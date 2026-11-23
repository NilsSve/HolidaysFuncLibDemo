Use cRDCView.pkg
Use FTConstants.h.pkg               // giFTThemeMode and the CI_FTTheme* modes (RDCFlexTron)
Use cFTGridHost.pkg                 // the host on a grid of 8 px columns - Used before the web controls
Use FTAllWebControlClasses.pkg      // cFTWebHtmlBox, cFTMonthCalendar and the rest of the family
Use cFTHtmlPage.pkg                 // a whole page: its title (psLabel), its glyph (psTitleIcon), a body of HTML
Use FTMarkupBuilders.pkg            // CssLink, DivOpen, TagText, ScriptLink, FTHtmlEscape ...
Use FTDashIcons.pkg                 // CS_GlyphCalendar

// One month of a country's calendar (HolidaysFuncLib 1.0.7, on RDCFlexTron's cFTMonthCalendar), and with it the
// holiday function library: ghoCalendarHolidays.
Use cHolidayMonthCalendar.pkg

// The bar's click draws the year again (RefreshAll, below the objects it reaches).
Register_Procedure RefreshAll

/* THE YEAR OVERVIEW (2026-11-22; twelve calendar objects 2026-11-23). One country's whole year in a FlexTron host:
   the bar with the countries and the years, twelve cHolidayMonthCalendar objects - each one month, with its days
   marked from the library - and the list of the year's named days beside them, with the legend below.

   The months do the library's work themselves (cHolidayMonthCalendar.OnDefineDay); this view tells them the
   country and the year, sums what they counted, and draws the bar and the list from it (RefreshAll). Each month
   gets the working days of the months before it, so a day knows its place among the year's working days.

   A click on a day is the page's own business (ftcontrols.js marks it, yearoverview.js shows it in the list and
   describes it); a click on a country, a year or Refresh reaches the bar's OnHtmlClick and draws the year again.
   The working days follow the settings the Working Days view sets on ghoCalendarHolidays - after Refresh. */
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
    // The twelve month objects, January first (End_Construct_Object).
    Property Handle[] phoMonths

    // ---- Text helpers ----

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

    // ---- The bar and the list ----

    Function BarHtml String sISO_Short Integer iYear Integer iWorking Integer iHolidays Integer iSpecial Returns String
        String[] asCountries
        String sHtml sCls sMask sWeekend
        Integer i iLast

        Move (CS_PaletteCssLink + CssLink("yearoverview") + DivOpen("yo")) to sHtml
        Append sHtml (DivOpen("yo-bar")) (DivOpen("yo-countries"))
        Get Countries to asCountries
        Move (SizeOfArray(asCountries) - 1) to iLast
        For i from 0 to iLast
            Move "yo-chip" to sCls
            If (asCountries[i] = sISO_Short) ;
                Move "yo-chip on" to sCls
            Append sHtml (SpanOpenClick(sCls, "country", asCountries[i], FTHtmlEscape(CountryName(Self, asCountries[i])))) ;
                asCountries[i] "</span>"
        Loop
        Append sHtml "</div>" (DivOpen("yo-years"))
        Append sHtml (SpanOpenClick("yo-btn", "year", "-1", "The year before")) "&lsaquo; " (String(iYear - 1)) "</span>"
        Append sHtml (TagText("span", "yo-year", String(iYear)))
        Append sHtml (SpanOpenClick("yo-btn", "year", "1", "The year after")) (String(iYear + 1)) " &rsaquo;</span>"
        If (iYear <> ThisYear(Self)) ;
            Append sHtml (SpanOpenClick("yo-btn", "today", "", "Back to this year")) "This year</span>"
        Append sHtml (SpanOpenClick("yo-btn", "refresh", "", "Draw the page again - after a change in the Working Days view")) "Refresh</span>"
        Append sHtml "</div></div>"

        // The days off every week, in the country's language.
        Get psWeekendMask of ghoCalendarHolidays to sMask
        Move "" to sWeekend
        For i from 1 to 7
            If (Mid(sMask, 1, i) = "1") Begin
                If (sWeekend <> "") ;
                    Move (sWeekend + ", ") to sWeekend
                Move (sWeekend + DayNameOfCountry(ghoCalendarHolidays, i, False, True, sISO_Short)) to sWeekend
            End
        Loop
        If (sWeekend = "") ;
            Move "none" to sWeekend

        Append sHtml (DivOpen("yo-sum"))
        Append sHtml '<span class="yo-pill"><b>' (String(iWorking)) "</b> working days in " (String(iYear)) " in " (FTHtmlEscape(CountryName(Self, sISO_Short))) "</span>"
        Append sHtml '<span class="yo-pill hol"><b>' (String(iHolidays)) "</b> days off for official holidays on weekdays</span>"
        Append sHtml '<span class="yo-pill spc"><b>' (String(iSpecial)) "</b> special days that are worked</span>"
        Append sHtml '<span class="yo-pill wkd">Off every week: ' (FTHtmlEscape(sWeekend)) "</span>"
        Append sHtml "</div>"
        Append sHtml (TagText("p", "yo-note", "Click a day, or a row in the list, to see it in both places and read about it above the list. Click a colour in the legend to show only those days. The working days follow the settings of the Working Days view - click Refresh after a change there."))
        Function_Return (sHtml + "</div>")
    End_Function

    // The list of the year's named days, with the box that describes a clicked day above it. Its root carries the
    // year's working days, for the box's "left in the year"; yo-ready tells the page's script the year is drawn.
    Function ListHtml tHolidayCalendarDay[] aNamed String sISO_Short Integer iWorking Returns String
        String sHtml sIso
        Integer i iLast

        Move ('<div class="yo-list" data-total="' + String(iWorking) + '">') to sHtml
        Append sHtml '<div class="yo-detail"><span class="yo-hint">Click a day in the calendar, or a row in the list.</span></div>'
        Append sHtml (TagText("h3", "", "Holidays and special days"))
        Move (SizeOfArray(aNamed) - 1) to iLast
        If (iLast < 0) ;
            Append sHtml (TagText("p", "yo-note", "No named days this year."))
        Else Begin
            Append sHtml '<table class="yo-l">'
            For i from 0 to iLast
                Move (FTIsoDate(aNamed[i].dDate)) to sIso
                Append sHtml '<tr class="' aNamed[i].sClass '" data-d="' sIso '"><td class="ld">' sIso '</td><td class="lw">' ;
                    (FTHtmlEscape(DayNameOfCountry(ghoCalendarHolidays, FTIsoDayOfWeek(aNamed[i].dDate), False, True, sISO_Short))) ;
                    '</td><td class="ln">' (FTHtmlEscape(aNamed[i].sName)) '</td><td class="lk">' (FTHtmlEscape(aNamed[i].sWhat)) "</td></tr>"
            Loop
            Append sHtml "</table>"
        End
        Function_Return (sHtml + '<span class="yo-ready"></span></div>')
    End_Function

    // The legend: a click on a colour shows only those days (yearoverview.js); Today is no filter.
    Function LegendHtml Returns String
        String sHtml sTip
        Move "Show only these days - click again for all" to sTip
        Move (CssLink("yearoverview") + DivOpen("yo-legend")) to sHtml
        Append sHtml '<span class="yo-lg" data-kind="ftcal-off" title="' sTip '"><i class="ftcal-d ftcal-off"></i>Day off: official holiday</span>'
        Append sHtml '<span class="yo-lg" data-kind="ftcal-wkd" title="' sTip '"><i class="ftcal-d ftcal-wkd"></i>Off every week</span>'
        Append sHtml '<span class="yo-lg" data-kind="ftcal-spc" title="' sTip '"><i class="ftcal-d ftcal-spc"></i>Special day</span>'
        Append sHtml '<span class="yo-lg" data-kind="ftcal-cls" title="' sTip '"><i class="ftcal-d ftcal-cls"></i>The company is closed</span>'
        Append sHtml '<span><i class="ftcal-d ftcal-today"></i>Today</span>'
        Function_Return (sHtml + "</div>")
    End_Function

    Object oYear_host is a cFTGridHost
        Set Location to 0 0
        Set Size to 342 640
        Set peAnchors to anAll
        // Four months of 27 columns (216 px) side by side, and the list in the column after them, which takes the
        // rest of the width (108).
        Set piColumnCount to 109
        Set psColumnWidths to "108/1fr"

        // The page's script - a click on a list row or a legend colour; a day's click is ftcontrols.js's.
        Procedure OnDefineScriptIncludes String[] ByRef asScriptHtml
            Forward Send OnDefineScriptIncludes (&asScriptHtml)
            Move (ScriptLink("Js/yearoverview.js")) to asScriptHtml[SizeOfArray(asScriptHtml)]
        End_Procedure

        // ---- row 0: the title, the countries and the years, the year's sums ----
        Object oTop_page is a cFTHtmlPage
            Set piRowIndex to 0
            Set piColumnIndex to 0
            Set piColumnSpan to 109
            Set psLabel to "Year Overview"
            Set psTitleIcon to CS_GlyphCalendar
            Set psHtml to '<div class="ftph-cards"><b>US GB NL NO ES SE</b><b>2026</b></div>'

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
                // The whole year is built here - the wait cursor while it is (the page dims itself too).
                Send Cursor_Wait of Cursor_Control
                Send RefreshAll of oYearOverview
                Send Cursor_Ready of Cursor_Control
            End_Procedure
        End_Object

        // ---- rows 1 - 3: the twelve months, four to a row ----
        Object oJanuary is a cHolidayMonthCalendar
            Set piRowIndex to 1
            Set piColumnIndex to 0
            Set piColumnSpan to 27
            Set piMonth to 1
            Set pbDayClick to False             // a day's click is the page's own (yearoverview.js)
        End_Object
        Object oFebruary is a cHolidayMonthCalendar
            Set piRowIndex to 1
            Set piColumnIndex to 27
            Set piColumnSpan to 27
            Set piMonth to 2
            Set pbDayClick to False
        End_Object
        Object oMarch is a cHolidayMonthCalendar
            Set piRowIndex to 1
            Set piColumnIndex to 54
            Set piColumnSpan to 27
            Set piMonth to 3
            Set pbDayClick to False
        End_Object
        Object oApril is a cHolidayMonthCalendar
            Set piRowIndex to 1
            Set piColumnIndex to 81
            Set piColumnSpan to 27
            Set piMonth to 4
            Set pbDayClick to False
        End_Object
        Object oMay is a cHolidayMonthCalendar
            Set piRowIndex to 2
            Set piColumnIndex to 0
            Set piColumnSpan to 27
            Set piMonth to 5
            Set pbDayClick to False
        End_Object
        Object oJune is a cHolidayMonthCalendar
            Set piRowIndex to 2
            Set piColumnIndex to 27
            Set piColumnSpan to 27
            Set piMonth to 6
            Set pbDayClick to False
        End_Object
        Object oJuly is a cHolidayMonthCalendar
            Set piRowIndex to 2
            Set piColumnIndex to 54
            Set piColumnSpan to 27
            Set piMonth to 7
            Set pbDayClick to False
        End_Object
        Object oAugust is a cHolidayMonthCalendar
            Set piRowIndex to 2
            Set piColumnIndex to 81
            Set piColumnSpan to 27
            Set piMonth to 8
            Set pbDayClick to False
        End_Object
        Object oSeptember is a cHolidayMonthCalendar
            Set piRowIndex to 3
            Set piColumnIndex to 0
            Set piColumnSpan to 27
            Set piMonth to 9
            Set pbDayClick to False
        End_Object
        Object oOctober is a cHolidayMonthCalendar
            Set piRowIndex to 3
            Set piColumnIndex to 27
            Set piColumnSpan to 27
            Set piMonth to 10
            Set pbDayClick to False
        End_Object
        Object oNovember is a cHolidayMonthCalendar
            Set piRowIndex to 3
            Set piColumnIndex to 54
            Set piColumnSpan to 27
            Set piMonth to 11
            Set pbDayClick to False
        End_Object
        Object oDecember is a cHolidayMonthCalendar
            Set piRowIndex to 3
            Set piColumnIndex to 81
            Set piColumnSpan to 27
            Set piMonth to 12
            Set pbDayClick to False
        End_Object

        // ---- rows 1 - 3, at the right: the year's named days ----
        Object oList_box is a cFTWebHtmlBox
            Set piRowIndex to 1
            Set piRowSpan to 3
            Set piColumnIndex to 108
            Set piColumnSpan to 1
            Set pbFillHeight to True
            Set psHtml to '<div class="ftph-list" style="--rows:12"></div>'
        End_Object

        // ---- row 4: the legend ----
        Object oLegend_box is a cFTWebHtmlBox
            Set piRowIndex to 4
            Set piColumnIndex to 0
            Set piColumnSpan to 109
            Set psHtml to '<div class="ftph-cards"><b>Legend</b></div>'
        End_Object
    End_Object

    // The bar with the year's sums (row 0).
    Procedure RefreshTop Integer iYear Integer iWorking Integer iHolidays Integer iSpecial
        Send UpdateHtml of (oTop_page(oYear_host(Self))) (BarHtml(Self, psCountry(Self), iYear, iWorking, iHolidays, iSpecial))
    End_Procedure

    /* THE WHOLE YEAR: each month told the country, the year and the working days before it, and drawn; then the bar
       with the year's sums, and the list with the year's named days. */
    Procedure RefreshAll
        Handle[] hoMonths
        tHolidayCalendarDay[] aNamed aMonth
        String sISO_Short
        Integer iYear iMonth iWorking iHolidays iSpecial i

        Send InitState
        Get psCountry to sISO_Short
        Get piYear to iYear
        Get phoMonths to hoMonths
        Move 0 to iWorking
        Move 0 to iHolidays
        Move 0 to iSpecial
        For iMonth from 0 to (SizeOfArray(hoMonths) - 1)
            Set psISO_Short         of hoMonths[iMonth] to sISO_Short
            Set piYear              of hoMonths[iMonth] to iYear
            Set piWorkingDaysBefore of hoMonths[iMonth] to iWorking
            Send Refresh of hoMonths[iMonth]
            Move (iWorking  + piWorkingDays(hoMonths[iMonth])) to iWorking
            Move (iHolidays + piHolidays(hoMonths[iMonth]))    to iHolidays
            Move (iSpecial  + piSpecial(hoMonths[iMonth]))     to iSpecial
            Get paNamedDays of hoMonths[iMonth] to aMonth
            For i from 0 to (SizeOfArray(aMonth) - 1)
                Move aMonth[i] to aNamed[SizeOfArray(aNamed)]
            Loop
        Loop
        Send RefreshTop iYear iWorking iHolidays iSpecial
        Send UpdateHtml of (oList_box(oYear_host(Self))) (ListHtml(Self, aNamed, sISO_Short, iWorking))
    End_Procedure

    // The months in order, and the first drawing of the year.
    Procedure End_Construct_Object
        Handle[] hoMonths
        Handle hoHost
        Forward Send End_Construct_Object
        Move (oYear_host(Self)) to hoHost
        Move (oJanuary(hoHost))   to hoMonths[0]
        Move (oFebruary(hoHost))  to hoMonths[1]
        Move (oMarch(hoHost))     to hoMonths[2]
        Move (oApril(hoHost))     to hoMonths[3]
        Move (oMay(hoHost))       to hoMonths[4]
        Move (oJune(hoHost))      to hoMonths[5]
        Move (oJuly(hoHost))      to hoMonths[6]
        Move (oAugust(hoHost))    to hoMonths[7]
        Move (oSeptember(hoHost)) to hoMonths[8]
        Move (oOctober(hoHost))   to hoMonths[9]
        Move (oNovember(hoHost))  to hoMonths[10]
        Move (oDecember(hoHost))  to hoMonths[11]
        Set phoMonths to hoMonths
        Send UpdateHtml of (oLegend_box(hoHost)) (LegendHtml(Self))
        Send RefreshAll
    End_Procedure

End_Object
