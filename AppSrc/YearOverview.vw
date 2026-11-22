Use cRDCView.pkg
Use FTConstants.h.pkg               // giFTThemeMode and the CI_FTTheme* modes (RDCFlexTron)
Use cFTGridHost.pkg                 // the host on a grid of 8 px columns - Used before the web controls
Use FTAllWebControlClasses.pkg      // cFTWebHtmlBox, cFTWebButton and the rest of the family
Use cFTHtmlPage.pkg                 // a whole page: its title (psLabel), its glyph (psTitleIcon), a body of HTML
Use FTMarkupBuilders.pkg            // CssLink, DivOpen, TagText, FTHtmlEscape ...
Use FTDashIcons.pkg                 // CS_GlyphCalendar

// The holiday function library: ghoCalendarHolidays.
Use oCalendarHolidays.pkg

/* THE YEAR OVERVIEW (2026-11-22, RDCFlexTron). One country's whole year as an HTML page in a FlexTron host: the
   twelve months, each day marked as a weekend day, a day off for an official holiday, a special day or a closure
   day, the working days of each month and of the year, and the list of the year's named days. A click on a
   country, on the year before or after, or on Refresh draws the page again.

   Everything comes from the library: HolidayName for a day's name and whether it is official, IsWorkingDay and
   IsClosedDay for whether it is worked, and psWeekendMask for the days off every week. Those settings are the
   ones the Working Days view sets on ghoCalendarHolidays, so a change there shows here after Refresh. */
Activate_View Activate_oYearOverview for oYearOverview
Object oYearOverview is a cRDCView
    Set Size to 342 640
    Set Location to 3 1
    Set Label to "Year Overview"
    Set Border_Style to Border_Thick
    Set Maximize_Icon to True
    Set pbAutoActivate to True
    Set Icon to "Calendar.ico"

    // The country and the year the page shows.
    Property String psCountry ""
    Property Integer piYear 0

    // ---- Text helpers ----

    Function TwoDigits Integer iValue Returns String
        If (iValue < 10) ;
            Function_Return ("0" + String(iValue))
        Function_Return (String(iValue))
    End_Function

    // A date as 2026-12-28, the same on every computer.
    Function IsoDate Date dDate Returns String
        Integer iYear iMonth iDay
        Move (DateGetYear(dDate))  to iYear
        Move (DateGetMonth(dDate)) to iMonth
        Move (DateGetDay(dDate))   to iDay
        Function_Return (String(iYear) + "-" + TwoDigits(Self, iMonth) + "-" + TwoDigits(Self, iDay))
    End_Function

    // In English, as the rest of the program: the library's month names follow the computer's language.
    Function MonthName Integer iMonth Returns String
        String sNames
        Move "January  February March    April    May      June     July     August   SeptemberOctober  November December " to sNames
        Function_Return (Trim(Mid(sNames, 9, ((iMonth - 1) * 9 + 1))))
    End_Function

    Function DayName Integer iIsoDay Returns String
        Function_Return (Mid("MonTueWedThuFriSatSun", 3, ((iIsoDay - 1) * 3 + 1)))
    End_Function

    Function CountryName String sISO_Short Returns String
        String sName
        Get ISO_ShortToOfficial_Short of ghoCalendarHolidays sISO_Short to sName
        If (Trim(sName) = "") ;
            Move sISO_Short to sName
        Function_Return (Trim(sName))
    End_Function

    // The countries with a holiday package, in the library's order.
    Function Countries Returns String[]
        Handle[] hoNationalHolidaysArray
        String[] asCountries
        String sISO_Short
        Integer i iLast
        Get phoNationalHolidaysArray of ghoCalendarHolidays to hoNationalHolidaysArray
        Move (SizeOfArray(hoNationalHolidaysArray) - 1) to iLast
        For i from 0 to iLast
            Get psISO_Short of hoNationalHolidaysArray[i] to sISO_Short
            Move sISO_Short to asCountries[SizeOfArray(asCountries)]
        Loop
        Function_Return asCountries
    End_Function

    Function ThisYear Returns Integer
        Date dToday
        Sysdate dToday
        Function_Return (DateGetYear(dToday))
    End_Function

    // The first time: this year, and the computer's own country when the library has a package for it - else GB.
    Procedure InitState
        String[] asCountries
        String sISO_Short
        If (piYear(Self) = 0) ;
            Set piYear to (ThisYear(Self))
        If (psCountry(Self) = "") Begin
            Get Countries to asCountries
            Get WindowsLocaleISO_Short of ghoCalendarHolidays to sISO_Short
            If (SearchArray(sISO_Short, asCountries) = -1) ;
                Move "GB" to sISO_Short
            Set psCountry to sISO_Short
        End
    End_Procedure

    // ---- What a day is ----

    // The class a day's cell takes, and the words its tooltip and the list give it.
    //   cls  a closure day (padClosedDays)          hol  a day off for an official holiday
    //   wkd  a day off every week (psWeekendMask)   spc  a named day that is not an official holiday
    // An official holiday or a special day on a weekend day takes both: "hol wkd", "spc wkd".
    Function DayClass Date dDate String sISO_Short String sName Boolean bOfficial String ByRef sWhat Returns String
        Boolean bWorking bClosed bWeekend
        String sMask
        Integer iIsoDay

        Get psWeekendMask of ghoCalendarHolidays to sMask
        Move (DateGetISODayOfWeek(ghoCalendarHolidays, dDate)) to iIsoDay
        Move (Mid(sMask, 1, iIsoDay) = "1") to bWeekend
        Get IsClosedDay of ghoCalendarHolidays dDate sISO_Short to bClosed
        Get IsWorkingDay of ghoCalendarHolidays dDate sISO_Short to bWorking

        If (bClosed) Begin
            Move "Closed" to sWhat
            Function_Return "cls"
        End
        If ((bWorking = False) and (bWeekend = False)) Begin
            Move "Holiday, day off" to sWhat
            Function_Return "hol"
        End
        If (bWeekend) Begin
            If ((sName <> "") and (bOfficial)) Begin
                Move "Holiday on a weekend" to sWhat
                Function_Return "hol wkd"
            End
            If (sName <> "") Begin
                Move "Special day, weekend" to sWhat
                Function_Return "spc wkd"
            End
            Move "Off every week" to sWhat
            Function_Return "wkd"
        End
        If (sName <> "") Begin
            Move "Special day, worked" to sWhat
            Function_Return "spc"
        End
        Move "Working day" to sWhat
        Function_Return ""
    End_Function

    // ---- The page ----

    Function BarHtml String sISO_Short Integer iYear Returns String
        String[] asCountries
        String sHtml sCls
        Integer i iLast

        Move (DivOpen("yo-bar")) to sHtml
        Append sHtml (DivOpen("yo-countries"))
        Get Countries to asCountries
        Move (SizeOfArray(asCountries) - 1) to iLast
        For i from 0 to iLast
            Move "yo-chip" to sCls
            If (asCountries[i] = sISO_Short) ;
                Move "yo-chip on" to sCls
            Append sHtml (SpanOpenClick(sCls, "country", asCountries[i], FTHtmlEscape(CountryName(Self, asCountries[i])))) ;
                asCountries[i] "</span>"
        Loop
        Append sHtml "</div>"

        Append sHtml (DivOpen("yo-years"))
        Append sHtml (SpanOpenClick("yo-btn", "year", "-1", "The year before")) "&lsaquo; " (String(iYear - 1)) "</span>"
        Append sHtml (TagText("span", "yo-year", String(iYear)))
        Append sHtml (SpanOpenClick("yo-btn", "year", "1", "The year after")) (String(iYear + 1)) " &rsaquo;</span>"
        If (iYear <> ThisYear(Self)) ;
            Append sHtml (SpanOpenClick("yo-btn", "today", "", "Back to this year")) "This year</span>"
        Append sHtml (SpanOpenClick("yo-btn", "refresh", "", "Draw the page again - after a change in the Working Days view")) "Refresh</span>"
        Append sHtml "</div></div>"
        Function_Return sHtml
    End_Function

    // One month: a table of its weeks, Monday first, the ISO week number on the left.
    // It counts the month's working days, its days off for a holiday on a weekday and its special days, and adds
    // its named days and closure days to the list.
    Function MonthHtml String sISO_Short Integer iYear Integer iMonth Date dToday Integer ByRef iWorking ;
                       Integer ByRef iHolidays Integer ByRef iSpecial String ByRef sListHtml Returns String
        String sHtml sCls sName sWhat sTip
        Integer iDays iDay iIsoDay iCol
        Boolean bOfficial bWorking
        Date dDate dFirst

        Move 0 to iWorking
        Get DateSetDate of ghoCalendarHolidays iYear iMonth 1 to dFirst
        Move (DateGetDaysInMonth(ghoCalendarHolidays, dFirst)) to iDays

        Move "" to sHtml
        Append sHtml '<table class="yo-t"><tr><th class="wn">Wk</th><th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th><th>Su</th></tr>'
        For iDay from 1 to iDays
            Move (dFirst + iDay - 1) to dDate
            Move (DateGetISODayOfWeek(ghoCalendarHolidays, dDate)) to iIsoDay
            If ((iDay = 1) or (iIsoDay = 1)) Begin
                If (iDay > 1) ;
                    Append sHtml "</tr>"
                Append sHtml '<tr><td class="wn">' (String(DateGetISOWeek(ghoCalendarHolidays, dDate))) "</td>"
                If (iDay = 1) Begin
                    For iCol from 1 to (iIsoDay - 1)
                        Append sHtml "<td></td>"
                    Loop
                End
            End

            Move False to bOfficial
            Get HolidayName of ghoCalendarHolidays dDate sISO_Short (&bOfficial) to sName
            Move (Trim(sName)) to sName
            Get DayClass dDate sISO_Short sName bOfficial (&sWhat) to sCls
            Get IsWorkingDay of ghoCalendarHolidays dDate sISO_Short to bWorking
            If (bWorking) ;
                Increment iWorking
            If ((sCls = "hol") or (sCls = "hol today")) ;
                Increment iHolidays
            If ((sCls = "spc") or (sCls = "spc today")) ;
                Increment iSpecial
            If (dDate = dToday) ;
                Move (Trim(sCls + " today")) to sCls

            Move (DayName(Self, iIsoDay) + " " + IsoDate(Self, dDate)) to sTip
            If (sName <> "") ;
                Move (sTip + " - " + sName) to sTip
            Move (sTip + " - " + sWhat) to sTip
            Append sHtml '<td class="d ' sCls '" title="' (FTHtmlEscape(sTip)) '">' (String(iDay)) "</td>"

            // A named day, or a closure day, goes in the list too.
            If ((sName <> "") or (Pos("cls", sCls) > 0)) Begin
                If (sName = "") ;
                    Move "Closure day" to sName
                Append sListHtml '<tr class="' sCls '"><td class="ld">' (IsoDate(Self, dDate)) '</td><td class="lw">' ;
                    (DayName(Self, iIsoDay)) '</td><td class="ln">' (FTHtmlEscape(sName)) '</td><td class="lk">' (FTHtmlEscape(sWhat)) "</td></tr>"
            End
        Loop
        Append sHtml "</tr></table>"
        Function_Return sHtml
    End_Function

    Function YearHtml Returns String
        String sHtml sMonths sList sISO_Short sMask sWeekend sTable
        Integer iYear iMonth iWorking iYearWorking iHolidays iSpecial i
        Date dToday

        Send InitState
        Get psCountry to sISO_Short
        Get piYear to iYear
        Sysdate dToday

        Move 0 to iYearWorking
        Move "" to sMonths
        Move "" to sList
        Move 0 to iHolidays
        Move 0 to iSpecial
        For iMonth from 1 to 12
            // The table first: the month's heading shows the working days it counted.
            Get MonthHtml sISO_Short iYear iMonth dToday (&iWorking) (&iHolidays) (&iSpecial) (&sList) to sTable
            Append sMonths (DivOpen("yo-m")) (DivOpen("yo-mh"))
            Append sMonths (TagText("span", "", MonthName(Self, iMonth)))
            Append sMonths (TagText("span", "yo-mw", (String(iWorking) + " working days"))) "</div>"
            Append sMonths sTable "</div>"
            Move (iYearWorking + iWorking) to iYearWorking
        Loop

        Get psWeekendMask of ghoCalendarHolidays to sMask
        Move "" to sWeekend
        For i from 1 to 7
            If (Mid(sMask, 1, i) = "1") Begin
                If (sWeekend <> "") ;
                    Move (sWeekend + ", ") to sWeekend
                Move (sWeekend + DayName(Self, i)) to sWeekend
            End
        Loop
        If (sWeekend = "") ;
            Move "none" to sWeekend

        Move (CS_PaletteCssLink + CssLink("yearoverview") + DivOpen("yo")) to sHtml
        Append sHtml (BarHtml(Self, sISO_Short, iYear))
        Append sHtml (DivOpen("yo-sum"))
        Append sHtml '<span class="yo-pill"><b>' (String(iYearWorking)) "</b> working days in " (String(iYear)) " in " (FTHtmlEscape(CountryName(Self, sISO_Short))) "</span>"
        Append sHtml '<span class="yo-pill hol"><b>' (String(iHolidays)) "</b> days off for official holidays on weekdays</span>"
        Append sHtml '<span class="yo-pill spc"><b>' (String(iSpecial)) "</b> special days that are worked</span>"
        Append sHtml '<span class="yo-pill wkd">Off every week: ' sWeekend "</span>"
        Append sHtml "</div>"
        Append sHtml (TagText("p", "yo-note", "The working days follow the settings of the Working Days view: the days off every week, the closure days and the UK region - click Refresh after a change there. Point at a day to see its name."))
        Append sHtml (DivOpen("yo-main")) (DivOpen("yo-months")) sMonths "</div>"
        Append sHtml (DivOpen("yo-list")) (TagText("h3", "", "Holidays and special days"))
        If (sList = "") ;
            Append sHtml (TagText("p", "yo-note", "No named days this year."))
        Else ;
            Append sHtml '<table class="yo-l">' sList "</table>"
        Append sHtml "</div></div>"
        Append sHtml (DivOpen("yo-legend"))
        Append sHtml '<span><i class="d hol"></i>Day off: official holiday</span><span><i class="d wkd"></i>Off every week</span>'
        Append sHtml '<span><i class="d spc"></i>Special day, worked</span><span><i class="d cls"></i>The company is closed</span><span><i class="d today"></i>Today</span>'
        Append sHtml "</div></div>"
        Function_Return sHtml
    End_Function

    Object oYear_host is a cFTGridHost
        Set Location to 0 0
        Set Size to 342 640
        Set peAnchors to anAll
        Set piColumnCount to 1
        Set psColumnWidths to "0/1fr"
        Set psRowHeights to "0/1fr"

        Object oYear_page is a cFTHtmlPage
            Set piRowIndex to 0
            Set piColumnIndex to 0
            Set piColumnSpan to 1
            Set pbFillHeight to True
            Set psLabel to "Year Overview"
            Set psTitleIcon to CS_GlyphCalendar

            Function BodyHtml Returns String
                Function_Return (YearHtml(oYearOverview))
            End_Function

            // The first drawing, kept for the page as it mounts.
            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Send RefreshBody
            End_Procedure

            // A click on a country, a year, This year or Refresh - after the web click has returned.
            Procedure OnHtmlClick String sId String sParam
                Integer iStep
                Send InitState of oYearOverview
                If (sId = "country") ;
                    Set psCountry of oYearOverview to sParam
                If (sId = "year") Begin
                    Move sParam to iStep
                    Set piYear of oYearOverview to (piYear(oYearOverview) + iStep)
                End
                If (sId = "today") ;
                    Set piYear of oYearOverview to (ThisYear(oYearOverview))
                Send RefreshBody
            End_Procedure
        End_Object
    End_Object

End_Object
