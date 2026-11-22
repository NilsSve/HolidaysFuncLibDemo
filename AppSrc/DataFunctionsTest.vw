Use cRDCDbView.pkg
Use DemoTheme.pkg                   // the theme: DemoDarkView, DemoDarkGrid
Use cCJGridColumnRowIndicator.pkg
Use cRDCCJGrid.pkg
Use cCJGridColumn.pkg
Use cRDCForm.pkg
Use cRDCSpinForm.pkg
Use cRDCCJGridPromptList.pkg
Use cRDCHeaderGroup.pkg

// Object with all Holiday date functions
Use oCalendarHolidays.pkg

Use cContinenDataDictionary.dd
Use cNationsDataDictionary.dd
Use cHolidaysDataDictionary.dd
Use Windows.pkg
Use cCJGrid.pkg

// THE DATES FUNCTIONS TEST, in three steps (2026-11-20, Nils: "a bit confusing"). Pick a function from the list,
// set the year and the country, and the answer is there: no button to press, no parameter types to read. The year
// strip shows the same function for five years, which is how a rule such as "the Saturday between 20 and 26 June"
// is checked at a glance. The reverse question - is this date a holiday? - has a row of its own at the bottom.
Activate_View Activate_oDateFunctionsTest for oDateFunctionsTest
Object oDateFunctionsTest is a cRDCDbView
    Set Size to 342 633
    Set Location to 3 1
    Set Label to "Dates Functions Test"
    Set Border_Style to Border_Thick
    Set Maximize_Icon to True
    Set pbAutoActivate to True
    Set Icon to "Calendar.ico"
    Set Verify_Save_Msg to none

    Property Boolean pbUseRegisteredCountriesOnly False
    // The short country codes of the country packages (CountryPackages.pkg).
    Property String[] pasISO_Short
    // The selected function.
    Property String psFuncName ""
    // True once every control of the view exists: the year and the country report a change while they are built.
    Property Boolean pbReady False

    // Constraint function:
    Function IsCountry String sISO_Short Returns Boolean
        String[] asISO_Short
        Get pasISO_Short to asISO_Short
        Function_Return (SearchArray(sISO_Short, asISO_Short) <> -1)
    End_Function

    Object oContinen_DD is a cContinenDataDictionary
    End_Object

    Object oNations_DD is a cNationsDataDictionary
        Set DDO_Server to oContinen_DD

        Procedure OnConstrain
            If (pbUseRegisteredCountriesOnly(Self) = True) Begin
                Constrain Nations as (IsCountry(Self, Nations.ISO_Short))
            End
        End_Procedure

        // Fill the pasISO_Short string array with the ISO_Short value of every country package.
        Procedure End_Construct_Object
            Handle[] hoNationalHolidaysArray
            String[] asISO_Short
            Handle ho
            Integer iSize iCount

            Forward Send End_Construct_Object

            Get phoNationalHolidaysArray of ghoCalendarHolidays to hoNationalHolidaysArray
            Move (SizeOfArray(hoNationalHolidaysArray)) to iSize
            Decrement iSize
            For iCount from 0 to iSize
                Move hoNationalHolidaysArray[iCount] to ho
                Get psISO_Short of ho to asISO_Short[-1]
            Loop
            Set pasISO_Short to asISO_Short
        End_Procedure

    End_Object

    Object oHolidays_DD is a cHolidaysDataDictionary
        Set DDO_Server to oNations_DD
    End_Object

    Set Main_DD to oHolidays_DD
    Set Server to oHolidays_DD

    // The library's description of a function, by name. False when there is no such function.
    Function FunctionByName String sName tHolidayFunc ByRef HolidayFunc Returns Boolean
        tHolidayFunc[] HolidayFuncArray
        Integer i iLast

        Get pHolidayFunctions of ghoCalendarHolidays to HolidayFuncArray
        Move (SizeOfArray(HolidayFuncArray) - 1) to iLast
        For i from 0 to iLast
            If (HolidayFuncArray[i].sName = sName) Begin
                Move HolidayFuncArray[i] to HolidayFunc
                Function_Return True
            End
        Loop
        Function_Return False
    End_Function

    // True when the function's second parameter is the country code.
    Function TakesCountry tHolidayFunc HolidayFunc Returns Boolean
        Function_Return (SizeOfArray(HolidayFunc.HolidayFuncVarArray) > 1)
    End_Function

    // The country a code names, with a note when the library has a language holiday package for it: "Sweden - holiday package".
    Function CountryText String sISO_Short Returns String
        String sName
        Boolean bPackage

        If (Trim(sISO_Short) = "") Begin
            Function_Return "Choose a country"
        End
        Get ISO_ShortToOfficial_Short of ghoCalendarHolidays sISO_Short to sName
        Move (IsCountry(Self, sISO_Short)) to bPackage
        If (Trim(sName) = "") Begin
            Function_Return "Not a country code that has a corresponding language library"
        End
        If (bPackage = True) Begin
            Function_Return (Trim(sName) + " - has a language holiday package")
        End
        Function_Return (Trim(sName) + " - a holiday language package is missing, so no holiday names")
    End_Function

    // A date written out: "Saturday 21 June 2025", or "Saturday, 21st June 2025" in the US and the UK.
    Function LongDateText Date dDate Returns String
        String sISO_Long sFormat sText
        Get WindowsLocaleValue of ghoCalendarHolidays LOCALE_SABBREVCTRYNAME 3 to sISO_Long
        If (sISO_Long = "USA" or sISO_Long = "GBR") Begin
            Move "dddd, dth MMMM yyyy" to sFormat
        End
        Else Begin
            Move "dddd d MMMM yyyy" to sFormat
        End
        Get DateFormat of ghoCalendarHolidays dDate sFormat to sText
        Function_Return sText
    End_Function

    // The selected function called for one year and country; "" when it gives no date.
    Function CallFunction String sFuncName Integer iYear String sISO_Short Returns Date
        Integer iFuncID
        Date dDate

        Move (Eval("get_" - (sFuncName))) to iFuncID
        If (iFuncID = 0) Begin
            Function_Return dDate
        End
        Get iFuncID of ghoCalendarHolidays iYear sISO_Short to dDate
        Function_Return dDate
    End_Function

    // EVERYTHING the right-hand side shows, from the selected function, the year and the country. Sent by the list,
    // the year and the country whenever one of them changes - there is no button to press.
    Procedure ShowAnswer
        Handle hoIn hoAns
        tHolidayFunc HolidayFunc
        String sFuncName sISO_Short sYear sHolidayName sCall sStrip sMonth
        Date dDate dOther
        Integer iYear i
        Boolean bFound bTakesCountry bOfficial bOK

        If (pbReady(Self) = False) Begin
            Procedure_Return
        End
        Move (oInput_grp(Self))  to hoIn
        Move (oAnswer_grp(Self)) to hoAns
        Get psFuncName to sFuncName
        Get FunctionByName sFuncName (&HolidayFunc) to bFound
        Set Label of (oFunctionName_tb(hoIn)) to (If(bFound, sFuncName, ""))
        Set Value of (oFunctionHelp_ed(hoIn)) to (If(bFound, HolidayFunc.sHelp, ""))
        Get Value of (oCountry_fm(hoIn)) to sISO_Short
        Move (Uppercase(Trim(sISO_Short))) to sISO_Short
        Set Label of (oCountryName_tb(hoIn)) to (CountryText(Self, sISO_Short))
        Move (TakesCountry(Self, HolidayFunc)) to bTakesCountry
        Set Label of (oCountryUse_tb(hoIn)) to (If(bTakesCountry, "The function takes a country as param, and the holiday name comes from its language package.", "This function's country param is optional."))

        Send ClearAnswer
        If (bFound = False) Begin
            Procedure_Return
        End
        Get Value of (oYear_sf(hoIn)) to sYear
        Get IsInteger of ghoCalendarHolidays sYear to bOK
        If (bOK = True) Begin
            Move sYear to iYear
            Move (iYear >= 1753 and iYear <= 2500) to bOK
        End
        If (bOK = False) Begin
            Set Label of (oLongDate_tb(hoAns)) to "Enter a year from 1753 to 2500"
            Procedure_Return
        End

        Get CallFunction sFuncName iYear sISO_Short to dDate
        If (dDate = 0) Begin
            Set Label of (oLongDate_tb(hoAns)) to ("No date for" * String(iYear) + (If(bTakesCountry, " in " + sISO_Short, "")))
            Set Label of (oHolidayName_tb(hoAns)) to "The function returns no date for this year and country."
            Procedure_Return
        End

        Set Label of (oLongDate_tb(hoAns)) to (LongDateText(Self, dDate))
        Move "" to sHolidayName
        Move False to bOfficial
        If (sISO_Short <> "") Begin
            Get HolidayName of ghoCalendarHolidays dDate sISO_Short (&bOfficial) to sHolidayName
        End
        If (sHolidayName = "") Begin
            Set Label of (oHolidayName_tb(hoAns)) to ("No holiday name for this date in the" * sISO_Short * "language package")
            Set Label of (oOfficial_tb(hoAns)) to ""
        End
        Else Begin
            Set Label of (oHolidayName_tb(hoAns)) to (sHolidayName + " - the name from the" * sISO_Short * "language package for this date")
            Set Label of (oOfficial_tb(hoAns)) to (If(bOfficial, "Official holiday", "Not an official holiday"))
        End

        Get DateGetMonthNameLong of ghoCalendarHolidays dDate to sMonth
        Set Value of (oWeek_fm(hoAns))        to (DateGetISOWeek(ghoCalendarHolidays, dDate))
        Set Label of (oDaysInMonth_fm(hoAns)) to ("Days in" * Trim(sMonth) + ":")
        Set Value of (oDaysInMonth_fm(hoAns)) to (DateGetDaysInMonth(ghoCalendarHolidays, dDate))
        Set Value of (oDateFormat_fm(hoAns))  to dDate
        Move ("Get" * String(sFuncName) * "of ghoCalendarHolidays" * String(iYear)) to sCall
        If (bTakesCountry = True) Begin
            Move (sCall * '"' + sISO_Short + '"') to sCall
        End
        Set Value of (oCall_fm(hoAns)) to (String(sCall) * "to sRetval")

        // The same function for the two years before and after: a rule shows itself in five dates.
        For i from -2 to 2
            Get CallFunction sFuncName (iYear + i) sISO_Short to dOther
            Move (String(iYear + i)) to sStrip
            If (dOther <> 0) Begin
                Move (sStrip + ":" * Left(DateGetDayNameLong(ghoCalendarHolidays, dOther), 3) * String(DateGetDay(dOther)) * Left(DateGetMonthNameLong(ghoCalendarHolidays, dOther), 3)) to sStrip
            End
            Else Begin
                Move (sStrip + ": -") to sStrip
            End
            Send SetYearStrip (i + 2) sStrip (i = 0)
        Loop
    End_Procedure

    Procedure ClearAnswer
        Handle hoAns
        Integer i
        Move (oAnswer_grp(Self)) to hoAns
        Set Label of (oLongDate_tb(hoAns))    to ""
        Set Label of (oHolidayName_tb(hoAns)) to ""
        Set Label of (oOfficial_tb(hoAns))    to ""
        Set Value of (oWeek_fm(hoAns))        to ""
        Set Label of (oDaysInMonth_fm(hoAns)) to "Days in month:"
        Set Value of (oDaysInMonth_fm(hoAns)) to ""
        Set Value of (oDateFormat_fm(hoAns))  to ""
        Set Value of (oCall_fm(hoAns))        to ""
        For i from 0 to 4
            Send SetYearStrip i "" False
        Loop
    End_Procedure

    // One box of the year strip; the year asked for in bold.
    Procedure SetYearStrip Integer iBox String sText Boolean bThisYear
        Handle ho hoAns
        Move (oAnswer_grp(Self)) to hoAns
        Case Begin
            Case (iBox = 0)
                Move (oYear1_tb(hoAns)) to ho
                Case Break
            Case (iBox = 1)
                Move (oYear2_tb(hoAns)) to ho
                Case Break
            Case (iBox = 2)
                Move (oYear3_tb(hoAns)) to ho
                Case Break
            Case (iBox = 3)
                Move (oYear4_tb(hoAns)) to ho
                Case Break
            Case Else
                Move (oYear5_tb(hoAns)) to ho
        Case End
        Set Label of ho to sText
        Set FontWeight of ho to (If(bThisYear, fw_Bold, fw_Normal))
    End_Procedure

    // ---- 1. The function list, with a search box ----
    Object oFunctions_grp is a cRDCHeaderGroup
        Set Size to 334 190
        Set Location to 4 4
        Set Label to "1. Pick a function"
        Set psNote to "Type to search the names and descriptions."
        Set psImage to "FunctionLibrary.ico"
        Set peAnchors to anTopBottomLeft

        Object oSearch_fm is a cRDCForm
            Set Size to 13 178
            Set Location to 26 6
            Set peAnchors to anTopLeftRight
            Set psToolTip to "Part of a function name or description, for example midsummer or bank holiday."

            Procedure OnChange
                Send LoadData of oDateFunctions_grd
            End_Procedure
        End_Object

        Object oDateFunctions_grd is a cRDCCJGridPromptList
            // The theme's colours in the dark theme (DemoTheme.pkg).
            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Send DemoDarkGrid Self
            End_Procedure

            Set Size to 286 178
            Set Location to 43 6
            Set pbInitialSelectionEnable to True
            Set pbMultiSelectionMode to False
            Set peUpdateMode to umPromptNonInvoking
            Set pbGrayIfDisable to False
            Set pbShadeSortColumn to False
            Set pbShowFooter to True
            Set piLayoutBuild to 3
            Set peAnchors to anAll

            Object oFunction_col is a cCJGridColumn
                Set piWidth to 120
                Set psCaption to "Function"
            End_Object

            Object oAsks_col is a cCJGridColumn
                Set piWidth to 70
                Set psCaption to "Asks for"
            End_Object

            // The functions whose name or description holds the search text, in the library's order.
            Procedure LoadData
                tHolidayFunc[] HolidayFuncArray
                tDataSourceRow[] TheData
                String sSearch
                Integer iCount iLast iRow iFunction_col iAsks_col

                Get piColumnId of oFunction_col to iFunction_col
                Get piColumnId of oAsks_col     to iAsks_col
                Get Value of oSearch_fm to sSearch
                Move (Lowercase(Trim(sSearch))) to sSearch
                Get pHolidayFunctions of ghoCalendarHolidays to HolidayFuncArray
                Move 0 to iRow
                Move (SizeOfArray(HolidayFuncArray) - 1) to iLast
                For iCount from 0 to iLast
                    If (sSearch = "" or Lowercase(HolidayFuncArray[iCount].sName) contains sSearch or Lowercase(HolidayFuncArray[iCount].sHelp) contains sSearch) Begin
                        Move HolidayFuncArray[iCount].sName to TheData[iRow].sValue[iFunction_col]  
//                        Set psToolTip of TheData[iRow].sValue[iFunction_col] to HolidayFuncArray[iCount].sHelp
                        Move (If(SizeOfArray(HolidayFuncArray[iCount].HolidayFuncVarArray) > 1, "year, country", "year")) to TheData[iRow].sValue[iAsks_col]
                        Increment iRow
                    End
                Loop
                Set psFooterText of oFunction_col to (String(iRow) * "of" * String(iLast + 1) * "functions")
                Send ReInitializeData TheData False
                // The first function is the selected one; its answer shows whether or not the grid reports a row change.
                If (iRow > 0) Begin
                    Send MovetoFirstRow
                    Set psFuncName to TheData[0].sValue[iFunction_col]
                    Send ShowAnswer
                End
                Else Begin
                    Set psFuncName to ""
                    Send ShowAnswer
                End
            End_Procedure

            Procedure OnRowChanged Integer iOldRow Integer iNewSelectedRow
                String sFunctionName
                Forward Send OnRowChanged iOldRow iNewSelectedRow
                Get SelectedRowValue of oFunction_col to sFunctionName
                Set psFuncName to sFunctionName
                Send ShowAnswer
            End_Procedure

            Procedure Activating
                Forward Send Activating
                Send LoadData
            End_Procedure

        End_Object

    End_Object

    // ---- 2. The function, the year and the country ----
    Object oInput_grp is a cRDCHeaderGroup
        Set Size to 109 432
        Set Location to 4 198
        Set Label to "2. Year and country"
        Set psNote to "The answer below changes as soon as you change one of them."
        Set psImage to "CallFunction.ico"
        Set peAnchors to anTopLeftRight

        Object oFunctionName_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 88
            Set Location to 40 8
            Set Label to "Function:"
            Set FontWeight to fw_Bold
        End_Object

        Object oFunctionHelp_ed is a cTextEdit
            Set Size to 26 313
            Set Location to 40 110
            Set Enabled_State to False
            Set peAnchors to anTopLeftRight
            Set Label to " -- "
            Set Label_Justification_Mode to JMode_Right
        End_Object

        Object oYear_sf is a cRDCSpinForm
            Set Size to 13 44
            Set Location to 71 34
            Set Label to "Year:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Minimum_Position to 1753
            Set Maximum_Position to 2500

            Procedure End_Construct_Object
                Date dDate
                Forward Send End_Construct_Object
                Sysdate dDate
                Set Value to (DateGetYear(dDate))
            End_Procedure

            Procedure OnChange
                Send ShowAnswer
            End_Procedure
        End_Object

        Object oCountry_fm is a cRDCForm
            Set Size to 13 30
            Set Location to 71 110
            Set Label to "Country:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Prompt_Button_Mode to PB_PromptOn
            Set Prompt_Object to Nations_sl
            Set Capslock_State to True
            Set psToolTip to "The two-letter ISO code. The prompt lists every country."
            // Zero, so a pick from the prompt list does not change a record.
            Set Server to 0

            Procedure Prompt_Callback Handle hPrompt
                Set pbAutoServer   of hPrompt to False
                Set Server         of hPrompt to (oNations_DD(Self))
                Set peUpdateMode   of hPrompt to umPromptValue
                Set piUpdateColumn of hPrompt to 0
            End_Procedure

            Procedure End_Construct_Object
                String sISO_Short
                Forward Send End_Construct_Object
                Get WindowsLocaleISO_Short of ghoCalendarHolidays to sISO_Short
                Set Value to sISO_Short
            End_Procedure

            Procedure OnChange
                Send ShowAnswer
            End_Procedure
        End_Object

        Object oCountryName_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 13 136
            Set Location to 71 147
        End_Object

        Object oCountryUse_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 13 136
            Set Location to 71 289
            Set peAnchors to anTopLeftRight
        End_Object

    End_Object

    // ---- 3. The answer ----
    Object oAnswer_grp is a cRDCHeaderGroup
        Set Size to 128 432
        Set Location to 117 198
        Set Label to "3. The answer"
        Set psNote to "Dates are shown according to your computer's settings."
        Set psImage to "Calendar.ico"
        Set peAnchors to anTopLeftRight

        Object oLongDate_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 14 188
            Set Location to 24 8
            Set FontWeight to fw_Bold
            Set FontPointHeight to 14
        End_Object

        Object oOfficial_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 109
            Set Location to 32 235
            Set Justification_Mode to JMode_Right
            Set FontWeight to fw_Bold
        End_Object

        Object oHolidayName_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 279
            Set Location to 46 8
        End_Object

        Object oWeek_fm is a cRDCForm
            Set Size to 13 24
            Set Location to 62 34
            Set Label to "Week:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Enabled_State to False
        End_Object

        Object oDaysInMonth_fm is a cRDCForm
            Set Size to 13 24
            Set Location to 62 128
            Set Label to "Days in month:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Enabled_State to False
        End_Object

        Object oDateFormat_fm is a cRDCForm
            Set Size to 13 56
            Set Location to 62 236
            Set Label to "Your date format:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Enabled_State to False
        End_Object

        Object oCall_fm is a cRDCForm
            Set Size to 13 258
            Set Location to 79 34
            Set Label to "The call:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Enabled_State to False
            Set psToolTip to "What to write to get this date from the library."
        End_Object

        Object oAround_tb is a TextBox
            Set Size to 10 118
            Set Location to 97 8
            Set Label to "The same function, around that year:"
        End_Object

        Object oYear1_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 80
            Set Location to 111 8
        End_Object

        Object oYear2_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 80
            Set Location to 111 92
        End_Object

        Object oYear3_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 80
            Set Location to 111 176
        End_Object

        Object oYear4_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 80
            Set Location to 111 260
        End_Object

        Object oYear5_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 80
            Set Location to 111 344
        End_Object

    End_Object

    // ---- The reverse question: which holiday is this date? ----
    Object oReverse_grp is a cRDCHeaderGroup
        Set Size to 89 432
        Set Location to 249 198
        Set Label to "Is this date a holiday?"
        Set psNote to "IsDateAHoliday: a date and a country give the holiday and the function that finds it."
        Set psImage to "Calendar.ico"
        Set peAnchors to anTopLeftRight

        Object oReverseDate_fm is a cRDCForm
            Set Size to 13 60
            Set Location to 32 30
            Set Label to "Date:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set psToolTip to "A date, written the way your computer writes dates."

            Procedure OnChange
                Send ShowReverse
            End_Procedure
        End_Object

        Object oReverseCountry_fm is a cRDCForm
            Set Size to 13 30
            Set Location to 32 140
            Set Label to "Country:"
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Prompt_Button_Mode to PB_PromptOn
            Set Prompt_Object to Nations_sl
            Set Capslock_State to True
            Set Server to 0

            Procedure Prompt_Callback Handle hPrompt
                Set pbAutoServer   of hPrompt to False
                Set Server         of hPrompt to (oNations_DD(Self))
                Set peUpdateMode   of hPrompt to umPromptValue
                Set piUpdateColumn of hPrompt to 0
            End_Procedure

            Procedure End_Construct_Object
                String sISO_Short
                Forward Send End_Construct_Object
                Get WindowsLocaleISO_Short of ghoCalendarHolidays to sISO_Short
                Set Value to sISO_Short
            End_Procedure

            Procedure OnChange  
                If (Active_State(Self)) Begin
                    Send ShowReverse
                End
            End_Procedure
        End_Object

        Object oReverseAnswer_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 390
            Set Location to 52 34
            Set FontWeight to fw_Bold
        End_Object

        Object oReverseFunction_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 390
            Set Location to 67 34
        End_Object

        // The answer to the reverse question, as soon as the date is a whole date.
        Procedure ShowReverse
            Date dDate
            String sDate sISO_Short sHolidayName sFunctionName
            Boolean bOK bFound bIsHoliday

            If (pbReady(Self) = False) Begin
                Procedure_Return
            End
            Set Label of oReverseAnswer_tb   to ""
            Set Label of oReverseFunction_tb to ""
            Get Value of oReverseDate_fm to sDate
            If (Trim(sDate) = "") Begin
                Set Label of oReverseAnswer_tb to "Enter a date"
                Procedure_Return
            End
            Get IsValidDateString of ghoCalendarHolidays sDate to bOK
            If (bOK = False) Begin
                Set Label of oReverseAnswer_tb to "Not a whole date yet"
                Procedure_Return
            End
            Move sDate to dDate
            Get Value of oReverseCountry_fm to sISO_Short
            Move (Uppercase(Trim(sISO_Short))) to sISO_Short
            Get IsDateAHoliday of ghoCalendarHolidays dDate sISO_Short (&bIsHoliday) (&sHolidayName) (&sFunctionName) to bFound
            If (bFound = False or sHolidayName = "") Begin
                Set Label of oReverseAnswer_tb to (LongDateText(Self, dDate) + ": no holiday in the" * sISO_Short * "language package")
                If (bFound = True) Begin
                    Set Label of oReverseFunction_tb to ("Found by the function" * sFunctionName + ", but the package returns no name.")
                End
                Procedure_Return
            End
            Set Label of oReverseAnswer_tb   to (LongDateText(Self, dDate) + ":" * sHolidayName * (If(bIsHoliday, "- official holiday", "- not an official holiday")))
            Set Label of oReverseFunction_tb to ("Found by the function" * sFunctionName + ".")
        End_Procedure

    End_Object

    Procedure End_Construct_Object
        Forward Send End_Construct_Object
        Set pbReady to True
        Send DemoDarkView Self
    End_Procedure

End_Object
