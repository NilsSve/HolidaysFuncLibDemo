Use cRDCDbView.pkg
Use cCJGridColumnRowIndicator.pkg
Use cRDCCJGrid.pkg
Use cCJGridColumn.pkg
Use cRDCComboForm.pkg
Use cRDCForm.pkg
Use cRDCButton.pkg
Use cRDCSpinForm.pkg
Use cRDCCJGridPromptList.pkg
Use cRDCCheckbox.pkg
Use cRDCHeaderGroup.pkg

// Object with all Holiday date functions
Use oCalendarHolidays.pkg

Use cContinenDataDictionary.dd
Use cNationsDataDictionary.dd
Use cHolidaysDataDictionary.dd
Use Windows.pkg
Use cCJGrid.pkg
Use dfLine.pkg

Class cDateRDCForm is a Form
    Procedure Construct_Object
        Forward Send Construct_Object

        Set Label_Justification_mode to JMode_Right
        Set Label_Col_Offset to 2
        Set Label_Row_Offset to 0
    End_Procedure
    
    Procedure ClearData
        Set Value to ""
    End_Procedure
    
End_Class

Activate_View Activate_oDateFunctionsTest for oDateFunctionsTest
Object oDateFunctionsTest is a cRDCDbView
    Set Size to 322 633
    Set Location to 3 1
    Set Label to "Dates Functions Test"
    Set Border_Style to Border_Thick
    Set Maximize_Icon to True
    Set pbAutoActivate to True
    Set Icon to "Calendar.ico"
    Set Verify_Save_Msg to none
    
    Property Boolean pbUseRegisteredCountriesOnly True
    // Array of short country codes for all registered countries,
    // that can be found in CountryPackages.pkg.
    Property String[] pasISO_Short
    // Selected function name.
    Property String psFuncName ""
    
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
        
        // Fill the pasISO_Short string array w ISO_Short values,
        // for all registered language packages.
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

    Object oHeader_grp is a cRDCHeaderGroup
        Set Size to 126 618
        Set Location to 6 9
        Set Label to "Function List:"
        Set psNote to "'Holiday and Other Special Dates' Library Functions:"
        Set psImage to "FunctionLibrary.ico"
        Set peAnchors to anAll

        Object oDateFunctions_grd is a cRDCCJGridPromptList
            Set Size to 95 604
            Set Location to 25 6
            Set pbInitialSelectionEnable to True
            Set pbMultiSelectionMode to False
            Set peUpdateMode to umPromptNonInvoking
            Set pbGrayIfDisable to False
            Set pbShadeSortColumn to False
            Set pbShowFooter to True 
            Set piLayoutBuild to 2
            
            Object oCJGridColumnRowIndicator is a cCJGridColumnRowIndicator
            End_Object

            Object oNumber_col is a cCJGridColumn
                Set piWidth to 5
                Set psCaption to "#"
            End_Object
            
            Object oFunction_col is a cCJGridColumn
                Set piWidth to 30
                Set psCaption to "Function Name"
            End_Object

            Object oHeltText_col is a cCJGridColumn
                Set piWidth to 100
                Set psCaption to "Help Text"
                Set pbMultiLine to True
            End_Object

            Procedure LoadData 
                tHolidayFunc[] HolidayFuncArray
                tHolidayFunc HolidayFunc
                Integer iCount iSize
                tDataSourceRow[] TheData
                Boolean bFound
                Integer iItem iRow iNumber_col iFunction_col iHelp_col
                
                Move 0 to iRow
                Get piColumnId of oNumber_col   to iNumber_col
                Get piColumnId of oFunction_col to iFunction_col
                Get piColumnId of oHeltText_col to iHelp_col
                
                // *** Get the struct array with holiday functions data,
                //     created by the cCalendarHolidays class RegisterInterface procedure ***
                Get pHolidayFunctions of ghoCalendarHolidays to HolidayFuncArray
                Move (SizeOfArray(HolidayFuncArray)) to iSize
                Decrement iSize
                For iCount from 0 to iSize 
                    Move (iCount +1)                    to TheData[iRow].sValue[iNumber_col]
                    Move HolidayFuncArray[iCount].sName to TheData[iRow].sValue[iFunction_col]
                    Move HolidayFuncArray[iCount].sName to HolidayFunc.sName // the current selected item to struct member.
                    Move (SearchArray(HolidayFunc, HolidayFuncArray)) to iItem
                    If (iItem <> -1) Begin
                        Move HolidayFuncArray[iItem].sHelp to TheData[iRow].sValue[iHelp_col]
                    End
                    Increment iRow
                Loop

                Set psFooterText of oFunction_col  to ("# of Functions" * String(iSize + 1))

                // Initialize Grid with new data
                Send InitializeData TheData
                Send MovetoFirstRow
            End_Procedure
     
            Procedure OnRowChanged Integer iOldRow Integer iNewSelectedRow
                tDataSourceRow[] TheData
                Handle hoDataSource
                tHolidayFunc[] HolidayFuncArray
                tHolidayFunc HolidayFunc
                Integer iRow iFunction_Col iItem
                String sFunctionName
                                
                Get piColumnId of oFunction_col to iFunction_col
                Get phoDataSource to hoDataSource
                Get DataSource of hoDataSource to TheData
                Get SelectedRow of hoDataSource to iRow
                Move TheData[iRow].sValue[iFunction_Col] to sFunctionName
                Set psFuncName to sFunctionName
                Move sFunctionName to HolidayFunc.sName
                Get pHolidayFunctions of ghoCalendarHolidays to HolidayFuncArray
                Move (SearchArray(HolidayFunc, HolidayFuncArray)) to iItem
                If (iItem <> -1) Begin
                    Send SetParamValues of oParam_grp HolidayFuncArray[iItem]
                End
                Else Begin
                    Send SetParamValues of oParam_grp HolidayFuncArray[0]
                End
            End_Procedure
            
            Procedure Activating
                Forward Send Activating
                Send LoadData
            End_Procedure
                    
        End_Object
        
    End_Object

    Object oParam_grp is a cRDCHeaderGroup
        Set Location to 139 8
        Set Size to 179 618
        Set Label to "Test Function Call:"
        Set psNote to "Enter Function Parameters and click 'Call Function':"
        Set psImage to "CallFunction.ico"
        Set peAnchors to anBottomLeftRight

        Object oType1_fm is a cDateRDCForm
            Set Location to 30 37
            Set Size to 13 43
            Set Label to "Type 1:"
            Set Enabled_State to False
        End_Object

        Object oType2_fm is a cDateRDCForm
            Set Location to 46 37
            Set Size to 13 43
            Set Label to "Type 2:"
            Set Enabled_State to False
        End_Object

        Object oVarName1_fm is a cDateRDCForm
            Set Location to 30 116
            Set Size to 13 53
            Set Label to "Name 1:"
            Set Enabled_State to False
        End_Object

        Object oVarName2_fm is a cDateRDCForm
            Set Location to 46 116
            Set Size to 13 53
            Set Label to "Name 2:"
            Set Enabled_State to False
        End_Object

        Object oValue1_fm is a cRDCSpinForm
            Set Location to 30 218
            Set Size to 13 53
            Set Label to "Enter Value 1:"     
            
            Procedure End_Construct_Object
                Date dDate
                Integer iYear
                Forward Send End_Construct_Object
                Sysdate dDate
                Get DateGetISOYear of ghoCalendarHolidays dDate to iYear
                Set Value to iYear 
            End_Procedure
        End_Object

        Object oValue2_fm is a cDateRDCForm
            Set Location to 46 218
            Set Size to 13 53
            Set Label to "Enter Value 2:"
            Set Prompt_Button_Mode to PB_PromptOn
            Set Prompt_Object to Nations_sl
            Set Capslock_State to True
            // Set to zero to not trigger a Changed_State, when using prompt list.
            Set Server to 0
            
            Procedure ClearData
            End_Procedure

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
                
        End_Object

        Object oCallFunction_btn is a cRDCButton
            Set Location to 28 285
            Set Size to 31 57
            Set MultiLineState to True
            Set Label to "Call Function!" 
            Set psToolTip to "Calls the selected function from the grid with the entered values to the left."
            Set psImage to "Phone.ico"
            Set piImageSize to 24
            
            Procedure OnClick
                String sFuncName sType1 sValue1 sType2 sValue2 sISO_Short sToolTip
                String sType3 sValue3 sType4 sValue4 sRetval sHolidayName 
                Date dDate
                Boolean bOK bOfficialHoliday
                Integer iFuncID
                Handle ho
                
                Move False to bOK
                Move False to bOfficialHoliday 
                Move "" to sHolidayName
                Get Value of oType1_fm  to sType1
                Get Value of oValue1_fm to sValue1
                If (sType1 = "String") Begin
                    Move (Uppercase(sValue1)) to sValue1
                End
                Get CheckTypeValue sType1 sValue1 to bOK
                If (bOK = False) Begin
                    Procedure_Return
                End

                Move "" to sISO_Short
                Get Value of oType2_fm to sType2
                Get Value of oValue2_fm to sValue2    
                If (sType2 = "String") Begin
                    Move (Uppercase(sValue2)) to sValue2
                End
                If (sType2 <> "") Begin
                    Get CheckTypeValue sType2 sValue2 to bOK
                    If (bOK = False) Begin
                        Procedure_Return
                    End
                End
                Move sValue2 to sISO_Short
                
                Get psFuncName to sFuncName
                Set Value of oFunctionName_fm to sFuncName
                Move (Eval("get_" - (sFuncName))) to iFuncID
                If (sValue1 <> "") Begin
                    Get iFuncID of ghoCalendarHolidays sValue1 sValue2 to dDate
                End        
                Set Value of oResult_fm to dDate
                
                If (sISO_Short <> "" and dDate <> "") Begin
                    Get HolidayName of ghoCalendarHolidays dDate sISO_Short (&bOfficialHoliday) to sHolidayName
                    Set Checked_State of oIsHoliday_cg to bOfficialHoliday
                    If (sHolidayName = "") Begin
                        Move "Not Found" to sHolidayName
                    End
                    Set Value of oExtra6_fm to sHolidayName
                    Move ("Call to the 'HolidayName' function with the'" * String(sISO_Short) + "' ISO_Short code and date:" * String(dDate) * ", returned holiday name:" * String(sHolidayName)) to sToolTip
                    Set psToolTip of oExtra6_fm to sToolTip
                    Set psToolTip of (Label_Object(oExtra6_fm)) to sToolTip
                End
            End_Procedure 
            
            Function CheckTypeValue String sType String sValue Returns Boolean
                Boolean bOK
                Move True to bOK
                If (sType = "Integer") Begin
                    Get IsInteger of ghoCalendarHolidays sValue to bOK
                    If (bOK = True) Begin
                        Move (Length(sValue) = 4) to bOK
                    End
                    If (bOK = False) Begin
                        Send Info_Box "Not a valid 4-digit year value"
                    End
                End
                If (sType = "Date") Begin
                    Get IsValidDateString of ghoCalendarHolidays sValue to bOK
                    If (bOK = False) Begin
                        Send Info_Box "Not a valid Date value"
                    End
                End
                If (sType = "String") Begin
                    Get IsInteger of ghoCalendarHolidays sValue to bOK
                    If (bOK = False) Begin
                        Move (Length(sValue) <> 0) to bOK
                    End
                    If (bOK = False) Begin
                        Send Info_Box "Not a valid string value"
                    End
                End
                Function_Return bOK
            End_Function
        
        End_Object

        Object oInfo_tb is a TextBox
            Set Size to 10 177
            Set Location to 17 322
            Set Label to "Note: Results according your computer's local settings."
        End_Object

        Object oFunctionName_fm is a cDateRDCForm
            Set Location to 32 404
            Set Size to 13 68
            Set Label to "Function Name:"
            Set Enabled_State to False
            Set peAnchors to anNone
        End_Object

        Object oResult_fm is a cDateRDCForm
            Set Location to 47 404
            Set Size to 13 43
            Set Label to "Date:"
            
            Procedure OnChange
                String sValue sYear sMonth sDay sLastDayOfMonth sTextDate sISO_Long sFormat
                Integer iMonthDays iWeekNo 
                Boolean bOK
                
                Get Value to sValue
                If (sValue = "") Begin
                    Procedure_Return
                End
                Get IsValidDateString of ghoCalendarHolidays sValue to bOK
                If (bOK = False) Begin
                    Procedure_Return
                End
                
                Get DateGetISOYear       of ghoCalendarHolidays sValue to sYear
                Get DateGetMonthNameLong of ghoCalendarHolidays sValue to sMonth
                Get DateGetDayNameLong   of ghoCalendarHolidays sValue to sDay 
                Get DateGetDaysInMonth   of ghoCalendarHolidays sValue to iMonthDays
                Get DateGetISOWeek       of ghoCalendarHolidays sValue to iWeekNo
                Get WindowsLocaleValue   of ghoCalendarHolidays LOCALE_SABBREVCTRYNAME 3 to sISO_Long
                If (sISO_Long = "USA" or sISO_Long = "GBR") Begin
                    Move "dddd, dth MMMM yyyy" to sFormat
                End
                Else Begin
                    Move "dddd d MMMM yyyy" to sFormat
                End
                Get DateFormat          of ghoCalendarHolidays sValue sFormat to sTextDate
                Set Value of oExtra1_fm to sYear
                Set Value of oExtra2_fm to sMonth
                Set Value of oExtra3_fm to sDay
                Set Value of oExtra4_fm to iMonthDays
                Set Value of oExtra5_fm to iWeekNo
                Set Value of oExtra7_fm to sTextDate
            End_Procedure
            
        End_Object

        Object oExtra1_fm is a cDateRDCForm
            Set Location to 63 404
            Set Size to 13 43
            Set Label to "Year:"
            Set Enabled_State to False
        End_Object
        
        Object oExtra2_fm is a cDateRDCForm
            Set Location to 79 404
            Set Size to 13 43
            Set Label to "Month:"
            Set Enabled_State to False
        End_Object

        Object oExtra3_fm is a cDateRDCForm
            Set Location to 95 404
            Set Size to 13 43
            Set Label to "Week Day:"
            Set Enabled_State to False
        End_Object

        Object oExtra4_fm is a cDateRDCForm
            Set Location to 111 404
            Set Size to 13 19
            Set Label to "Days in Month:"
            Set Enabled_State to False
        End_Object
        
        Object oExtra5_fm is a cDateRDCForm
            Set Location to 111 456
            Set Size to 13 19
            Set Label to "Week #:"
            Set Enabled_State to False
        End_Object
        
        Object oExtra6_fm is a cDateRDCForm
            Set Location to 159 404
            Set Size to 13 68
            Set Label to "(From Country packages)  Day Name:"
//            Set Enabled_State to False 
            Set Entry_State to False
            Set Skip_State to True
            Set peAnchors to anNone
        End_Object

        Object oExtra7_fm is a cDateRDCForm
            Set Location to 128 404
            Set Size to 13 68
            Set Label to "DateFormat:" 
            Set psToolTip to "Note that the date is spelled according to your computer's local date settings."
            Set psToolTip of (Label_Object(Self)) to "Note that the date is spelled according to your computer's local date settings."
            Set Enabled_State to False
            Set peAnchors to anNone
        End_Object

        Object oIsHoliday_cg is a CheckBox
            Set Size to 13 46
            Set Location to 147 404
            Set Label to "Is Holiday"  
            Set Checked_State to False
            Set Entry_State to False
        End_Object

        Object oGridInfo_tb is a TextBox
            Set Size to 10 157
            Set Location to 72 35
            Set Label to "Existing Country packages (CountryPackages.pkg):"
        End_Object

        Object oNationHolidays_grd is a cRDCCJGrid
            Set Size to 85 237
            Set Location to 82 34
            Set pbReadOnly to True 
            Set pbShowFooter to False
            Set peAnchors to anNone

            Object oISO_Short_col is a cCJGridColumn
                Set piWidth to 40
                Set psCaption to "ISO Short"
            End_Object

            Object oOfficial_Short_col is a cCJGridColumn
                Set piWidth to 160
                Set psCaption to "Official_Short"
            End_Object 
            
            Procedure LoadData
                Handle hoDataSource
                tDataSourceRow[] TheData     
                tISO_Codes[] ISO_CodesArray
                Handle[] ahoNationalHolidaysArray
                Integer iCount iSize iFirst_col iSecond_col iItem
                Handle hoNationalHolidays 
                String sISO_Short
                
                Get phoDataSource to hoDataSource
                // Get the datasource indexes of the various columns
                Get piColumnId of oISO_Short_col      to iFirst_col
                Get piColumnId of oOfficial_Short_col to iSecond_col
                
                Get phoNationalHolidaysArray of ghoCalendarHolidays to ahoNationalHolidaysArray
                Move (SizeOfArray(ahoNationalHolidaysArray)) to iSize
                Decrement iSize
                Move 0 to iItem
                For iCount from 0 to iSize
                    Move ahoNationalHolidaysArray[iCount] to hoNationalHolidays
                    Get psISO_Short      of hoNationalHolidays to ISO_CodesArray[iItem].sIso_Short
                    Get psOfficial_Short of hoNationalHolidays to ISO_CodesArray[iItem].sOffical_Short
                    Increment iItem
                Loop

                Move (SortArray(ISO_CodesArray)) to ISO_CodesArray
                Move (SizeOfArray(ISO_CodesArray)) to iSize
                Decrement iSize
                For iCount from 0 to iSize
                    Move ISO_CodesArray[iCount].sIso_Short     to TheData[iCount].sValue[iFirst_col]
                    Move ISO_CodesArray[iCount].sOffical_Short to TheData[iCount].sValue[iSecond_col]
                Loop
                
                Send ReInitializeData TheData True
                Send MovetoFirstRow 
            End_Procedure 
            
            Procedure OnRowDoubleClick Integer iRow Integer iColumn
                String sISO_Short 
                Forward Send OnRowDoubleClick iRow iColumn
                Get SelectedRowValue of oISO_Short_col to sISO_Short
                Set Value of oValue2_fm to sISO_Short
            End_Procedure

            Procedure OnCreate
                Forward Send OnCreate
                Send LoadData
            End_Procedure

        End_Object

        Procedure SetParamValues tHolidayFunc HolidayFunc
            tHolidayFuncVar[] FuncVarArray
            Integer iCount iSize
            
            Move HolidayFunc.HolidayFuncVarArray to FuncVarArray
            Send ClearData 
            Send DisableValueForms

            If (SizeOfArray(FuncVarArray) > 0) Begin
                Set Value of oType1_fm    to FuncVarArray[0].sType
                Set Value of oVarName1_fm to FuncVarArray[0].sVarName
                Set Enabled_State of oValue1_fm to True
            End
            If (SizeOfArray(FuncVarArray) > 1) Begin
                Set Value of oType2_fm    to FuncVarArray[1].sType
                Set Value of oVarName2_fm to FuncVarArray[1].sVarName
            End
            Set Enabled_State of oValue2_fm to True
        End_Procedure

        Procedure DisableValueForms
            Set Enabled_State of oValue1_fm to False
            Set Enabled_State of oValue2_fm to False
        End_Procedure

        Procedure ClearData
            Broadcast Send ClearData 
            Set Checked_State of oIsHoliday_cg to False
        End_Procedure 

        Object oRightArrow_tb is a TextBox
            Set Size to 10 6
            Set Location to 49 448
            Set Label to ">>"
        End_Object

        Object oTopHorizontalLine is a LineControl
            Set Size to 2 52
            Set Location to 53 453
        End_Object

        Object oVerticalLine is a LineControl
            Set Size to 113 3
            Set Location to 53 505
            Set Horizontal_State to False
        End_Object

        Object oLowerHorizontalLine is a LineControl
            Set Size to 2 29
            Set Location to 166 476
        End_Object

        Object oLeftArrow_tb is a TextBox
            Set Size to 10 11
            Set Location to 161 472
            Set Label to "<<"
        End_Object

        Object oReciprocalVerticalLine is a LineControl
            Set Size to 170 3
            Set Location to 4 520
            Set Horizontal_State to False
        End_Object

        Object oReciprocalInfo_tb is a TextBox
            Set Auto_Size_State to False
            Set Size to 19 85
            Set Location to 17 530
            Set Label to "Reciprocal Function 'IsDateAHoliday' Test:"
            Set FontWeight to fw_Bold
            Set Justification_Mode to JMode_Left
        End_Object

        Object oReciprocalDate_fm is a cDateRDCForm
            Set Location to 47 530
            Set Size to 13 78
            Set Label to "Enter a Date:"
            Set Label_Justification_Mode to JMode_Top
            Set Label_Col_Offset to 0
            Set Label_Row_Offset to 1
            Procedure ClearData
            End_Procedure
        End_Object

        Object oISO_Short_fm is a cDateRDCForm
            Set Location to 73 530
            Set Size to 13 78
            Set Label to "ISO Short:"
            Set Prompt_Button_Mode to PB_PromptOn
            Set Prompt_Object to Nations_sl
            Set Capslock_State to True
            // Set to zero to not trigger a Changed_State, when using prompt list.
            Set Server to 0
            Set Label_Justification_Mode to JMode_Top
            Set Label_Row_Offset to 1
            Set Label_Col_Offset to 0
            
            Procedure ClearData
            End_Procedure

            Procedure Prompt_Callback Handle hPrompt
                Set pbAutoServer   of hPrompt to False 
                Set Server         of hPrompt to (oNations_DD(Self))
                Set peUpdateMode   of hPrompt to umPromptValue
                Set piUpdateColumn of hPrompt to 0
            End_Procedure
            
            Procedure End_Construct_Object
                String sISO_Long sISO_Short
                Forward Send End_Construct_Object             
                Get WindowsLocaleValue of ghoCalendarHolidays LOCALE_SABBREVCTRYNAME to sISO_Long
                Get ISO_LongToISO_Short of ghoCalendarHolidays sISO_Long to sISO_Short
                Set Value to sISO_Short
            End_Procedure
                
        End_Object

        Object oReciprocalCall_btn is a Button
            Set Size to 26 78
            Set Location to 91 530
            Set Label to "Call 'IsDateAHoliday' Function"
            Set MultiLineState to True
        
            Procedure OnClick
                Date dDate
                String sDate sISO_Short sHolidayName sFunctionName sFoundText
                Boolean bOK bFound bIsHoliday
                
                Get Value of oReciprocalDate_fm to sDate
                Get IsValidDateString of ghoCalendarHolidays sDate to bOK
                If (bOK = False) Begin
                    Send Info_Box "Not a valid Date value"
                    Procedure_Return
                End
                Move sDate to dDate
                Get Value of oISO_Short_fm to sISO_Short 
                Get IsDateAHoliday of ghoCalendarHolidays dDate sISO_Short (&bIsHoliday) (&sHolidayName) (&sFunctionName) to bFound
                If (bFound = True) Begin
                    Move sFunctionName to sFoundText
                End
                Else Begin                       
                    Move "Not Found!" to sFoundText
                End
                If (sHolidayName = "") Begin
                    Move "Not Found!" to sHolidayName
                End
                Set Value of oCallReply_fm to sFoundText
                Set Checked_State of oIsHoliday2_cg to bIsHoliday
                Set Value of oHolidayName_fm to sHolidayName
            End_Procedure
        
        End_Object

        Object oCallReply_fm is a cDateRDCForm
            Set Location to 121 530
            Set Size to 13 78
        End_Object

        Object oIsHoliday2_cg is a CheckBox
            Set Size to 10 78
            Set Location to 137 530
            Set Label to "Is Holiday"  
            Set Checked_State to False
            Set Entry_State to False
        End_Object

        Object oHolidayName_fm is a cDateRDCForm
            Set Location to 159 530
            Set Size to 13 78
            Set Label to "Holiday Name:"
            Set Entry_State to False
            Set Skip_State to True
            Set peAnchors to anNone
            Set Label_Justification_Mode to JMode_Top
            Set Label_Row_Offset to 1
            Set Label_Col_Offset to 0
        End_Object

    End_Object

End_Object
