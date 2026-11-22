Use cRDCView.pkg
Use cRDCHeaderGroup.pkg
Use cRDCForm.pkg
Use cRDCSpinForm.pkg
Use cRDCComboForm.pkg
Use cRDCButton.pkg
Use cRDCCJGrid.pkg
Use cCJGridColumn.pkg
Use DemoTheme.pkg                   // the theme: DemoDarkView, DemoDarkGrid
Use cFTCheckBoxCaption.pkg          // a check box's caption as a TextBox (RDCFlexTron)
Use cFTRadioGroup.pkg               // cFTGroupCaption: a group box's caption as a TextBox (RDCFlexTron)

// The holiday function library: ghoCalendarHolidays, and the UK region constants (BrittishHolidays.pkg).
Use oCalendarHolidays.pkg

// THE WORKING DAYS TEST (2026-11-21, HolidaysFuncLib 1.0.4). The settings on the left are the library's own:
// the country code, piHolidayRegion (the UK's regions), psWeekendMask and padClosedDays - set on ghoCalendarHolidays
// exactly as a program would set them. The three groups on the right call IsWorkingDay, AddWorkingDays and
// WorkingDaysBetween, and say why a day is not a working day. The library answers only True or False; the reason
// is worked out here, from the same settings.
Activate_View Activate_oWorkingDays for oWorkingDays
Object oWorkingDays is a cRDCView
    Set Size to 342 640
    Set Location to 3 1
    Set Label to "Working Days Test"
    Set Border_Style to Border_Thick
    Set Maximize_Icon to True
    Set pbAutoActivate to True
    Set Icon to "Calendar.ico"

    // True once every control of the view exists: the forms report a change while they are built.
    Property Boolean pbReady False
    // The country codes in the country list, in the list's order; "" is the last entry, no country.
    Property String[] pasCountries

    // ---- Text helpers ----

    Function DayName Date dDate Returns String
        Integer iDay
        Move (DateGetISODayOfWeek(ghoCalendarHolidays, dDate)) to iDay
        Function_Return (Mid("MonTueWedThuFriSatSun", 3, ((iDay - 1) * 3 + 1)))
    End_Function

    Function LongDayName Date dDate Returns String
        String[] asNames
        Integer iDay
        Move (StrSplitToArray("Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday", ",")) to asNames
        Move (DateGetISODayOfWeek(ghoCalendarHolidays, dDate)) to iDay
        Function_Return asNames[iDay - 1]
    End_Function

    // A date as "Mon 2026-12-28", whatever the date format of the machine.
    Function DateText Date dDate Returns String
        Integer iMonth iDay
        Move (DateGetMonth(dDate)) to iMonth
        Move (DateGetDay(dDate))   to iDay
        Function_Return (DayName(Self, dDate) * String(DateGetYear(dDate)) + "-" + Right(("0" + String(iMonth)), 2) + "-" + Right(("0" + String(iDay)), 2))
    End_Function

    // ---- The settings ----

    // The country chosen in the list: a two-letter code, or "" for no country. Read from the text - "GB - United
    // Kingdom" - which is there from construction on; the combo's current item is known only once it has a window.
    Function CountryCode Returns String
        String sValue
        Get Value of oCountry_cf to sValue
        Move (Trim(sValue)) to sValue
        If (sValue = "" or Left(sValue, 10) = "No country") Begin
            Function_Return ""
        End
        Function_Return (Left(sValue, 2))
    End_Function

    // The settings as the library takes them: the weekend days, the UK region, the closure days are already there.
    Procedure ApplySettings
        String sMask sISO_Short sRegion
        Integer iRegion
        Boolean bChecked

        // A value set while the view is built reports a change before the weekend boxes exist.
        If (pbReady(Self) = False) Begin
            Procedure_Return
        End
        Move "" to sMask
        Get Checked_State of oDay1_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Get Checked_State of oDay2_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Get Checked_State of oDay3_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Get Checked_State of oDay4_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Get Checked_State of oDay5_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Get Checked_State of oDay6_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Get Checked_State of oDay7_cb to bChecked
        Move (sMask + If(bChecked, "1", "0")) to sMask
        Set psWeekendMask of ghoCalendarHolidays to sMask
        Set Label of oMask_tb to ('psWeekendMask = "' + sMask + '"')

        Get CountryCode to sISO_Short
        Set Enabled_State of oRegion_cf to (sISO_Short = "GB")
        Get Value of oRegion_cf to sRegion
        Case Begin
            Case (sRegion = "Scotland")
                Move CI_UKRegionScotland to iRegion
                Case Break
            Case (sRegion = "Northern Ireland")
                Move CI_UKRegionNorthernIreland to iRegion
                Case Break
            Case (sRegion = "Any part of the UK")
                Move CI_UKRegionAny to iRegion
                Case Break
            Case Else
                Move CI_UKRegionEnglandWales to iRegion
        Case End
        Set piHolidayRegion of ghoCalendarHolidays to iRegion
        Send ShowAll
    End_Procedure

    // ---- The answers ----

    // What kind of day it is - "Working day", "Weekend", "Holiday" or "Closed" - and why, in sWhy.
    Function DayKind Date dDate String sISO_Short String ByRef sWhy Returns String
        Handle hoCountry
        String sMask sName
        Integer iDay
        Boolean bWorking bOff bOfficial

        Move "" to sWhy
        Get IsWorkingDay of ghoCalendarHolidays dDate sISO_Short to bWorking
        If (bWorking = True) Begin
            Function_Return "Working day"
        End
        Get psWeekendMask of ghoCalendarHolidays to sMask
        Move (DateGetISODayOfWeek(ghoCalendarHolidays, dDate)) to iDay
        If (Mid(sMask, 1, iDay) = "1") Begin
            Move (LongDayName(Self, dDate) + " is a day off every week") to sWhy
            Function_Return "Weekend"
        End
        If (sISO_Short <> "") Begin
            Get NationalHolidaysObject of ghoCalendarHolidays sISO_Short to hoCountry
            If (hoCountry <> 0) Begin
                Get IsOfficialDayOff of hoCountry dDate (piHolidayRegion(ghoCalendarHolidays)) to bOff
                If (bOff = True) Begin
                    Move False to bOfficial
                    Get HolidayName of ghoCalendarHolidays dDate sISO_Short (&bOfficial) to sName
                    Move sName to sWhy
                    Function_Return "Holiday"
                End
            End
        End
        Move "The company is closed (padClosedDays)" to sWhy
        Function_Return "Closed"
    End_Function

    Procedure ShowIsWorkingDay String sISO_Short
        Date dDate
        String sKind sWhy

        Get Value of oDate1_fm to dDate
        If (dDate < 1) Begin
            Set Label of oAnswer1_tb to "Enter a date"
            Set Label of oWhy1_tb to ""
            Procedure_Return
        End
        Get DayKind dDate sISO_Short (&sWhy) to sKind
        If (sKind = "Working day") Begin
            Set Label of oAnswer1_tb to (DateText(Self, dDate) * "is a working day")
            Set Label of oWhy1_tb to "It is not a weekend day, an official holiday or a closure day."
        End
        Else Begin
            Set Label of oAnswer1_tb to (DateText(Self, dDate) * "is not a working day")
            Set Label of oWhy1_tb to ("Because:" * sWhy + ".")
        End
    End_Procedure

    Procedure ShowAddWorkingDays String sISO_Short
        Date dDate dResult
        Integer iDays

        Get Value of oDate2_fm to dDate
        Get Value of oDays2_sf to iDays
        If (dDate < 1) Begin
            Set Label of oAnswer2_tb to "Enter a date"
            Procedure_Return
        End
        Get AddWorkingDays of ghoCalendarHolidays dDate iDays sISO_Short to dResult
        Set Label of oAnswer2_tb to (DateText(Self, dDate) * (If(iDays < 0, "-", "+")) * String(Abs(iDays)) * "working days =" * DateText(Self, dResult))
    End_Procedure

    Procedure ShowWorkingDaysBetween String sISO_Short
        tDataSourceRow[] TheData
        Date dFrom dTo dDate dLast
        String sKind sWhy
        Integer iDays iRow iDate_col iDay_col iKind_col iWhy_col
        Boolean bGrid

        Get piColumnId of oDate_col to iDate_col
        Get piColumnId of oDay_col  to iDay_col
        Get piColumnId of oKind_col to iKind_col
        Get piColumnId of oWhy_col  to iWhy_col
        Get Value of oFrom3_fm to dFrom
        Get Value of oTo3_fm   to dTo
        Get IsComObjectCreated of oDays_grd to bGrid
        If (dFrom < 1 or dTo < 1) Begin
            Set Label of oAnswer3_tb to "Enter both dates"
            If (bGrid = True) Begin
                Send ReInitializeData of oDays_grd TheData False
            End
            Procedure_Return
        End
        Get WorkingDaysBetween of ghoCalendarHolidays dFrom dTo sISO_Short to iDays
        Set Label of oAnswer3_tb to (String(iDays) * "working days")
        // The grid is filled once its control exists - it is created when the view is shown (its Activating).
        If (bGrid = False) Begin
            Procedure_Return
        End

        // The days counted, in date order whichever way round the two dates are - at most a year of them.
        Move (If(dFrom <= dTo, dFrom, dTo)) to dDate
        Move (If(dFrom <= dTo, dTo, dFrom)) to dLast
        Move 0 to iRow
        While (dDate <= dLast and iRow < 366)
            Get DayKind dDate sISO_Short (&sWhy) to sKind
            Move (DateText(Self, dDate)) to TheData[iRow].sValue[iDate_col]
            Move (LongDayName(Self, dDate))  to TheData[iRow].sValue[iDay_col]
            Move sKind to TheData[iRow].sValue[iKind_col]
            Move sWhy  to TheData[iRow].sValue[iWhy_col]
            Increment iRow
            Move (dDate + 1) to dDate
        Loop
        Send ReInitializeData of oDays_grd TheData False
        Set psFooterText of oDate_col to (String(iRow) * "days" + (If(dDate <= dLast, " - the first year only", "")))
    End_Procedure

    Procedure ShowAll
        String sISO_Short
        If (pbReady(Self) = False) Begin
            Procedure_Return
        End
        Get CountryCode to sISO_Short
        Send ShowIsWorkingDay sISO_Short
        Send ShowAddWorkingDays sISO_Short
        Send ShowWorkingDaysBetween sISO_Short
    End_Procedure

    // ---- Settings ----
    Object oSettings_grp is a cRDCHeaderGroup
        Set Size to 334 194
        Set Location to 4 4
        Set Label to "Settings"
        Set peAnchors to anTopBottomLeft

        Object oCountry_cf is a cRDCComboForm
            Set Size to 13 132
            Set Location to 28 54
            Set Label to "Country:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Entry_State to False
            Set psToolTip to "The country whose official holidays are days off. The library has holiday packages for these countries."

            // The countries with a holiday package, then "no country".
            Procedure Combo_Fill_List
                Handle[] hoNationalHolidaysArray
                String[] asCountries
                String sISO_Short sName
                Integer i iLast

                Get phoNationalHolidaysArray of ghoCalendarHolidays to hoNationalHolidaysArray
                Move (SizeOfArray(hoNationalHolidaysArray) - 1) to iLast
                For i from 0 to iLast
                    Get psISO_Short of hoNationalHolidaysArray[i] to sISO_Short
                    Get ISO_ShortToOfficial_Short of ghoCalendarHolidays sISO_Short to sName
                    Move sISO_Short to asCountries[SizeOfArray(asCountries)]
                    Send Combo_Add_Item (sISO_Short * "-" * sName)
                Loop
                Move "" to asCountries[SizeOfArray(asCountries)]
                Send Combo_Add_Item "No country - weekends and closure days only"
                Set pasCountries to asCountries
            End_Procedure

            // Filled here, not when the view activates (ComboForm's own moment): the view's first answers need the
            // list. A filled list is left alone at activation. GB first: its Christmas 2026 shows a moved bank
            // holiday, and its regions differ.
            Procedure End_Construct_Object
                String[] asCountries
                Integer iItem
                Forward Send End_Construct_Object
                Send Combo_Fill_List
                Get pasCountries to asCountries
                Move (SearchArray("GB", asCountries)) to iItem
                If (iItem >= 0) Begin
                    Set Value to (Combo_Value(Self, iItem))
                End
            End_Procedure

            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oRegion_cf is a cRDCComboForm
            Set Size to 13 132
            Set Location to 46 54
            Set Label to "UK region:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Entry_State to False
            Set psToolTip to "piHolidayRegion: whose bank holidays are days off. Only the United Kingdom has regions in the library."

            Procedure Combo_Fill_List
                Send Combo_Add_Item "England and Wales"
                Send Combo_Add_Item "Scotland"
                Send Combo_Add_Item "Northern Ireland"
                Send Combo_Add_Item "Any part of the UK"
            End_Procedure

            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Send Combo_Fill_List
                Set Value to "England and Wales"
            End_Procedure

            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oWeekend_tb is a TextBox
            Set Size to 10 120
            Set Location to 70 8
            Set Label to "Days off every week:"
        End_Object

        Object oDay1_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 8
            Set Checked_State to False
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        // The caption, readable in both themes: a check box draws its own in the Windows colours.
        Object oDay1_cap is a cFTCheckBoxCaption
            Set Location to 83 18
            Set Label to "Mon"
            Set phoCheckBox to (oDay1_cb(Self))
        End_Object

        Object oDay2_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 34
            Set Checked_State to False
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oDay2_cap is a cFTCheckBoxCaption
            Set Location to 83 44
            Set Label to "Tue"
            Set phoCheckBox to (oDay2_cb(Self))
        End_Object

        Object oDay3_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 60
            Set Checked_State to False
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oDay3_cap is a cFTCheckBoxCaption
            Set Location to 83 70
            Set Label to "Wed"
            Set phoCheckBox to (oDay3_cb(Self))
        End_Object

        Object oDay4_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 86
            Set Checked_State to False
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oDay4_cap is a cFTCheckBoxCaption
            Set Location to 83 96
            Set Label to "Thu"
            Set phoCheckBox to (oDay4_cb(Self))
        End_Object

        Object oDay5_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 112
            Set Checked_State to False
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oDay5_cap is a cFTCheckBoxCaption
            Set Location to 83 122
            Set Label to "Fri"
            Set phoCheckBox to (oDay5_cb(Self))
        End_Object

        Object oDay6_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 138
            Set Checked_State to True
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oDay6_cap is a cFTCheckBoxCaption
            Set Location to 83 148
            Set Label to "Sat"
            Set phoCheckBox to (oDay6_cb(Self))
        End_Object

        Object oDay7_cb is a CheckBox
            Set Size to 10 10
            Set Location to 82 164
            Set Checked_State to True
            Procedure OnChange
                Send ApplySettings
            End_Procedure
        End_Object

        Object oDay7_cap is a cFTCheckBoxCaption
            Set Location to 83 174
            Set Label to "Sun"
            Set phoCheckBox to (oDay7_cb(Self))
        End_Object

        Object oMask_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 178
            Set Location to 96 8
            Set Label to 'psWeekendMask = "0000011"'
        End_Object

        Object oClosed_tb is a TextBox
            Set Size to 10 160
            Set Location to 116 8
            Set Label to "The company is closed on (padClosedDays):"
        End_Object

        Object oClosedDate_fm is a cRDCForm
            Set Size to 13 66
            Set Location to 128 8
            Set Form_Datatype to Mask_Date_Window
            Set psToolTip to "A date to add to the closure days - a Christmas week, a bridge day."
        End_Object

        Object oAddClosed_btn is a cRDCButton
            Set Size to 13 50
            Set Location to 128 78
            Set Label to "Add"

            Procedure OnClick
                Date[] adClosed
                Date dDate
                Get Value of oClosedDate_fm to dDate
                If (dDate < 1) Begin
                    Send Info_Box "Enter the date the company is closed."
                    Procedure_Return
                End
                Get padClosedDays of ghoCalendarHolidays to adClosed
                If (SearchArray(dDate, adClosed) = -1) Begin
                    Move dDate to adClosed[SizeOfArray(adClosed)]
                    Move (SortArray(adClosed)) to adClosed
                    Set padClosedDays of ghoCalendarHolidays to adClosed
                End
                Send LoadClosedDays of oClosed_grd
                Send ShowAll
            End_Procedure
        End_Object

        Object oRemoveClosed_btn is a cRDCButton
            Set Size to 13 50
            Set Location to 128 132
            Set Label to "Remove"

            Procedure OnClick
                Date[] adClosed adKept
                String sText
                Integer i iLast
                Get SelectedRowValue of oClosedDate_col to sText
                If (sText = "") Begin
                    Procedure_Return
                End
                Get padClosedDays of ghoCalendarHolidays to adClosed
                Move (SizeOfArray(adClosed) - 1) to iLast
                For i from 0 to iLast
                    If (DateText(Self, adClosed[i]) <> sText) Begin
                        Move adClosed[i] to adKept[SizeOfArray(adKept)]
                    End
                Loop
                Set padClosedDays of ghoCalendarHolidays to adKept
                Send LoadClosedDays of oClosed_grd
                Send ShowAll
            End_Procedure
        End_Object

        Object oClosed_grd is a cRDCCJGrid
            // The theme's colours in the dark theme (DemoTheme.pkg).
            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Send DemoDarkGrid Self
            End_Procedure

            Set Size to 186 178
            Set Location to 146 8
            Set pbReadOnly to True
            Set pbShowFooter to False
            Set peAnchors to anTopBottomLeft

            Object oClosedDate_col is a cCJGridColumn
                Set piWidth to 170
                Set psCaption to "Closed on"
            End_Object

            Procedure LoadClosedDays
                tDataSourceRow[] TheData
                Date[] adClosed
                Integer i iLast iCol
                Boolean bGrid
                Get IsComObjectCreated to bGrid
                If (bGrid = False) Begin
                    Procedure_Return
                End
                Get piColumnId of oClosedDate_col to iCol
                Get padClosedDays of ghoCalendarHolidays to adClosed
                Move (SizeOfArray(adClosed) - 1) to iLast
                For i from 0 to iLast
                    Move (DateText(Self, adClosed[i])) to TheData[i].sValue[iCol]
                Loop
                Send ReInitializeData TheData False
            End_Procedure

            Procedure Activating
                Forward Send Activating
                Send LoadClosedDays
            End_Procedure
        End_Object
    End_Object

    // ---- 1. IsWorkingDay ----
    Object oIsWorking_grp is a cRDCHeaderGroup
        Set Size to 58 432
        Set Location to 4 202
        Set Label to "1. Is it a working day?  (IsWorkingDay)"
        Set peAnchors to anTopLeftRight

        Object oDate1_fm is a cRDCForm
            Set Size to 13 66
            Set Location to 24 34
            Set Label to "Date:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Form_Datatype to Mask_Date_Window
            Procedure OnChange
                Send ShowAll
            End_Procedure
        End_Object

        Object oAnswer1_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 310
            Set Location to 26 112
            Set FontWeight to fw_Bold
            Set peAnchors to anTopLeftRight
        End_Object

        Object oWhy1_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 310
            Set Location to 40 112
            Set peAnchors to anTopLeftRight
        End_Object
    End_Object

    // ---- 2. AddWorkingDays ----
    Object oAdd_grp is a cRDCHeaderGroup
        Set Size to 58 432
        Set Location to 66 202
        Set Label to "2. Add working days  (AddWorkingDays)"
        Set peAnchors to anTopLeftRight

        Object oDate2_fm is a cRDCForm
            Set Size to 13 66
            Set Location to 24 34
            Set Label to "Date:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Form_Datatype to Mask_Date_Window
            Procedure OnChange
                Send ShowAll
            End_Procedure
        End_Object

        Object oDays2_sf is a cRDCSpinForm
            Set Size to 13 40
            Set Location to 24 160
            Set Label to "Working days:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Minimum_Position to -999
            Set Maximum_Position to 999
            Set psToolTip to "How many working days to add - a negative number goes back."
            Procedure OnChange
                Send ShowAll
            End_Procedure
        End_Object

        Object oAnswer2_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 210
            Set Location to 26 212
            Set FontWeight to fw_Bold
            Set peAnchors to anTopLeftRight
        End_Object

        Object oNote2_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 310
            Set Location to 42 34
            Set Label to "The start date is not counted, as Excel's WORKDAY does not count it: Friday + 1 is Monday."
            Set peAnchors to anTopLeftRight
        End_Object
    End_Object

    // ---- 3. WorkingDaysBetween ----
    Object oBetween_grp is a cRDCHeaderGroup
        Set Size to 210 432
        Set Location to 128 202
        Set Label to "3. Working days between  (WorkingDaysBetween)"
        Set peAnchors to anAll

        Object oFrom3_fm is a cRDCForm
            Set Size to 13 66
            Set Location to 24 34
            Set Label to "From:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Form_Datatype to Mask_Date_Window
            Procedure OnChange
                Send ShowAll
            End_Procedure
        End_Object

        Object oTo3_fm is a cRDCForm
            Set Size to 13 66
            Set Location to 24 134
            Set Label to "To:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Form_Datatype to Mask_Date_Window
            Procedure OnChange
                Send ShowAll
            End_Procedure
        End_Object

        Object oAnswer3_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 210
            Set Location to 26 212
            Set FontWeight to fw_Bold
            Set peAnchors to anTopLeftRight
        End_Object

        Object oNote3_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 410
            Set Location to 42 8
            Set Label to "Both dates are counted, as Excel's NETWORKDAYS counts them. The days, and why each one is or is not counted:"
            Set peAnchors to anTopLeftRight
        End_Object

        Object oDays_grd is a cRDCCJGrid
            // The theme's colours in the dark theme (DemoTheme.pkg).
            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Send DemoDarkGrid Self
            End_Procedure

            Set Size to 150 416
            Set Location to 54 8
            Set pbReadOnly to True
            Set pbShowFooter to True
            Set peAnchors to anAll

            Object oDate_col is a cCJGridColumn
                Set piWidth to 90
                Set psCaption to "Date"
            End_Object

            Object oDay_col is a cCJGridColumn
                Set piWidth to 80
                Set psCaption to "Day"
            End_Object

            Object oKind_col is a cCJGridColumn
                Set piWidth to 80
                Set psCaption to "Counted as"
            End_Object

            Object oWhy_col is a cCJGridColumn
                Set piWidth to 220
                Set psCaption to "Why"
            End_Object

            // Its control exists from here on, so the days can be listed.
            Procedure Activating
                Forward Send Activating
                Send ShowAll
            End_Procedure
        End_Object
    End_Object

    // The library's settings as this view shows them, and the Christmas 2026 dates the description in the
    // README uses: the moved Boxing Day bank holiday is Monday 28 December.
    Procedure End_Construct_Object
        Date[] adNone
        Forward Send End_Construct_Object
        Set padClosedDays of ghoCalendarHolidays to adNone
        Set Value of oDate1_fm  to (DateSetDate(ghoCalendarHolidays, 2026, 12, 28))
        Set Value of oDate2_fm  to (DateSetDate(ghoCalendarHolidays, 2026, 12, 24))
        Set Value of oDays2_sf  to 1
        Set Value of oFrom3_fm  to (DateSetDate(ghoCalendarHolidays, 2026, 12, 21))
        Set Value of oTo3_fm    to (DateSetDate(ghoCalendarHolidays, 2027, 1, 1))
        Set pbReady to True
        Send ApplySettings
        Send DemoDarkView Self
    End_Procedure

End_Object
