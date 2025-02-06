// C:\Users\Nils G. Svedmyr\Documents\My Dropbox\Visual DataFlex Projects 16\National Holidays\AppSrc\Holidays.vw
// Holidays
//
//----------------------------------------------------------------------------
//  Modifications:
//  ~~~~~~~~~~~~~
//  23/ 2/2011  PDC Escape key in grid cancels changes and exits edit mode.
//                  "For Country" combo default changed when country changed.
//                  Removed dependency on  VdfQuery library.
//                  Set psNoItemsText in grid.
//
//============================================================================
//
Use Batchdd.pkg
Use cRDCDbView.pkg
Use cRDCDbForm.pkg
Use cRDCDbGroup.pkg
Use cRDCDbCJGrid.pkg
Use cRDCDbCJGridColumn.pkg
Use cRDCForm.pkg
Use cRDCButton.pkg
#IFDEF Is$GraphicsLibrary
    Use cImageContainer.pkg
    Use cDbImageContainer.pkg
#ENDIF    
Use oCalendarHolidays.pkg
Use CountryPackages.pkg
Use HolidaysLookup.dg

Use cNationsDataDictionary.dd
Use cHolidaysDataDictionary.dd
Use cContinenDataDictionary.dd

Activate_View Activate_oHolidays For oHolidays
Object oHolidays is a cRDCDbView
    Set Location to -1 0
    Set Size to 272 522
    Set Label to "Calendar Test"
    Set Icon to "NationalHolidays.ico"
    Set Border_Style to Border_Thick
    Set Maximize_Icon to True
    Set pbAutoActivate to True   
    Set Auto_Clear_Deo_State to False
    
    { Visibility = Private }
    Property String private_psISO_Short
    
    Procedure Set psISO_Short String sISO_Short
        Set private_psISO_Short to sISO_Short
        Set Value of oNations_ISO_Short to sISO_Short
    End_Procedure
    
    { MethodType = Property }
    Function psISO_Short Returns String
        Function_Return (private_psISO_Short(Self))
    End_Function
    
    Property String[] pasISO_Short
    
    // Constraint function for oNations_DD
    Function IsCountry String sISO_Short Returns Boolean
        String[] asISO_Short
        Get pasISO_Short to asISO_Short
        Function_Return (SearchArray(sISO_Short, asISO_Short) <> -1)
    End_Function
        
    Object oContinen_DD is a cContinenDataDictionary
    End_Object

    Object oNations_DD is a cNationsDataDictionary
        Set DDO_Server to oContinen_DD
        
        // If the country changes we need to update the calendar display to show the holidays for the new country.
        Procedure Request_Find Integer eFindMode Integer iFile Integer iIndex
            Forward Send Request_Find eFindMode iFile iIndex
            If (iFile = Nations.File_Number) Begin
                Send broadcast_OnNationChange
            End
        End_Procedure 
        
        Procedure OnConstrain
            Constrain Nations as (IsCountry(Self, Nations.ISO_Short))
        End_Procedure
        
        // Fill the pasISO_Short string array with ISO_Short values,
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
        Set Constrain_File to Nations.File_Number

        Property Boolean pbHolidaysOnly False

        Procedure OnConstrain
            If (pbHolidaysOnly(Self)) Begin
                Constrain Holidays.HolidayName ne ""
            End
        End_Procedure

        // If the country changes we need to update the calendar display to show the holidays for the new country.
        Procedure Request_Find Integer eFindMode Integer iFile Integer iIndex
            Forward Send Request_Find eFindMode iFile iIndex
            If (iFile = Nations.File_Number) Begin
                Send broadcast_OnNationChange
            End
        End_Procedure

        Procedure FindByRowId Integer iFile RowID riRowId
            Forward Send FindByRowId iFile riRowId
            If (iFile = Nations.File_Number) Begin
                Send broadcast_OnNationChange
            End
        End_Procedure
    End_Object

    Set Main_DD to oHolidays_DD
    Set Server  to oHolidays_DD

    Procedure broadcast_OnNationChange
        Broadcast Recursive Send OnNationChange
    End_Procedure

    Object oIdle is a cIdleHandler
        Procedure OnIdle
            Delegate Send OnIdle
        End_Procedure
    End_Object

    Procedure OnIdle
        Send EnableObjects
    End_Function

    Procedure EnableObjects
        Boolean bRec
        Handle hoServer
        Get Server to hoServer
        Get HasRecord of hoServer to bRec
        Set Enabled_State of oHolidaysDetails_grd to (bRec)
    End_Function

    Procedure Activating
        Forward Send Activating
        Set pbEnabled of oIdle to True
    End_Procedure

    Procedure Deactivating
        Set pbEnabled of oIdle to False
        Forward Send Deactivating
    End_Procedure

    //-----------------------------------------------------------------------
    // Create custom confirmation messages for save and delete
    // We must create the new functions and assign verify messages
    // to them.
    //-----------------------------------------------------------------------
    Function ConfirmDeleteHeader Returns Boolean
        Function_Return False
    End_Function

    // Only confirm on the saving of new records
    Function ConfirmSaveHeader Returns Boolean
        Function_Return False
    End_Function

    Procedure Request_Clear
        Send Request_Clear_All
    End_Procedure

    // Define alternate confirmation Messages
    Set Verify_Save_MSG       to GET_ConfirmSaveHeader
    Set Verify_Delete_MSG     to GET_ConfirmDeleteHeader
    On_Key Key_Escape Send None

    Object oDateMaintenance_grp is a cRDCDbGroup
        Set Size to 208 508
        Set Location to 3 5
        Set Label to "Sample - Calendar Dates Including Holidays and Other Special Dates"
        Set peAnchors to anAll
        Set piMinSize to 204 457
        Set Bitmap_Style to Bitmap_Stretch

        Object oNations_ISO_Short is a cRDCDbForm
            Entry_Item Nations.ISO_Short
            Set Location to 13 75
            Set Size to 13 37
            Set Label to "ISO Short"
            Set psToolTip to "The two character long ISO code for the country"
            Set psToolTip to "Only Nations defined in the 'CountryPackes.pkg' appears here!"
        End_Object

        Object oToday_fm is a cRDCForm
            Set Size to 13 51
            Set Location to 13 164
            Set Label to "Todays Date"
            Set Form_Datatype to Mask_Date_Window
            Set Enabled_State to False
            Procedure OnStartup
                Date dToday
                Sysdate dToday
                Set Value to dToday
            End_Procedure
            Send OnStartup
        End_Object

        Object oSyncgrid_btn is a cRDCButton
            Set Size to 13 95
            Set Location to 13 222
            Set Label to "Jump to Today's Date"
            Set psToolTip to "Find Todays Date in the grid and center data around it."

            Procedure OnClick
                Send InitFromTodaysDate to oHolidaysDetails_grd
            End_Procedure

        End_Object

        Object oHolidays_sl is a cRDCButton
            Set Size to 14 86
            Set Location to 13 322
            Set Label to "Test Holiday Lookup List"
            Set peAnchors to anTopRight
        
            Procedure OnClick
                String sISO_Short
                tHoliday[] SelectedHolidays
                Get Field_Current_Value of oNations_DD Field Nations.ISO_Short to sISO_Short
                Get PopupHolidayLookup sISO_Short to SelectedHolidays
                Send Info_Box ("You selected:" * String(SizeOfArray(SelectedHolidays)) * "holidays from the popup.")
            End_Procedure
        
        End_Object

        Object oNations_Official_Long is a cRDCDbForm
            Entry_Item Nations.Official_Long
            Set Size to 13 244
            Set Location to 28 75
            Set Label to "Country"
        End_Object

        Object oInfo_tb is a TextBox
            Set Size to 10 48
            Set Location to 59 19
            Set Label to "Test Calendar:"
        End_Object

        Object oHolidaysDetails_grd is a cRDCDbCJGrid
            Set Size to 146 333
            Set Location to 43 75
            Set Server to oHolidays_DD
            Set Ordering to 1
            Set pbHeaderPrompts to False
            Set pbShowFooter to False
            Set piLayoutBuild to 4
            Set pbAutoSave to False
            Set pbEditOnTyping to False
            Set pbReadOnly to True 

            Object oHolidays_Dateno is a cRDCDbCJGridColumn
                Entry_Item Holidays.DateNo
                Set piWidth to 104
                Set psCaption to "Date"
                Set peHeaderAlignment to xtpAlignmentCenter
                Set peTextAlignment to xtpAlignmentCenter
            End_Object

            Object oHolidays_Holidayname is a cRDCDbCJGridColumn
                Entry_Item Holidays.HolidayName
                Set piWidth to 257
                Set psCaption to "Holiday Name"
                Set peHeaderAlignment to xtpAlignmentCenter
                Set peTextAlignment to xtpAlignmentCenter
            End_Object

            Object oHolidays_Isnatholiday is a cRDCDbCJGridColumn
                Entry_Item Holidays.IsNatHoliday
                Set piWidth to 122
                Set psCaption to "Holiday"
                Set pbCheckbox to True
                Set phoData_Col to Self
                Set peHeaderAlignment to xtpAlignmentCenter
                Set peTextAlignment to xtpAlignmentCenter
            End_Object

            Object oDbCJGridColumnDayOfWeek is a cRDCDbCJGridColumn
                Set piWidth to 109
                Set psCaption to "Day of Week (Local)"
                Set psToolTip to "Local computer date settings are used here."
                Set peHeaderAlignment to xtpAlignmentCenter
                Set peTextAlignment to xtpAlignmentCenter
                Procedure OnSetCalculatedValue String ByRef sValue
                    Get DateGetDayNameLong of ghoCalendarHolidays Holidays.DateNo to sValue
                    Forward Send OnSetCalculatedValue (&sValue)
                End_Procedure
            End_Object

            Object oDbCJGridColumnWeekNo is a cRDCDbCJGridColumn
                Set piWidth to 74
                Set psCaption to "Week No"
                Set peHeaderAlignment to xtpAlignmentCenter
                Set peTextAlignment to xtpAlignmentCenter
                Procedure OnSetCalculatedValue String ByRef sValue
                    Get DateGetISOWeek of ghoCalendarHolidays Holidays.DateNo to sValue
                    Forward Send OnSetCalculatedValue (&sValue)
                End_Procedure
            End_Object
            
            Procedure InitFromTodaysDate
                Date dToday
                String sID
                Sysdate dToday
                Get Field_Current_Value of oNations_DD Field Nations.ISO_Short to sID
                Clear Holidays
                Move sID to Holidays.ISO_Short
                Move dToday to Holidays.DateNo
                Find EQ Holidays.DateNo
                Send RefreshDataFromExternal 5
            End_Procedure

//            Procedure InitBirthDate Date dBirthDayThisYear
//                String sID
//                Get Field_Current_Value of oNations_DD Field Nations.ISO_Short to sID
//                Clear Holidays
//                Move sID to Holidays.ISO_Short
//                Move dBirthDayThisYear to Holidays.DateNo
//                Find EQ Holidays.DateNo
//                Send RefreshDataFromExternal 5
//            End_Procedure

            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Set phoContextMenu to 0
            End_Procedure

            On_Key kCancel Send None
        End_Object

#IFDEF Is$GraphicsLibrary
        Object oFlagPole is a cImageContainer
            Set Size to 115 26
            Set Location to 43 433
            Set pbSelectImage to False
            Set psImage to "Flag Pole.png"
            Set pcBackColor to clBtnFace 
            Set Focus_Mode to NonFocusable
            Set peAnchors to anTopRight
            Set pbShowScrollBars to False

            // Needed because the flag had to be made smaller to
            // fit the calendar in.
            //
            Set peImageStyle to ifFitOneSide
            Set pbAutoTooltip to False
        End_Object

        Object oNationsFlag is a cDbImageContainer
            Entry_Item Nations.Flag
            Set Size to 48 47
            Set Location to 45 445
            Set psSelectImageCaption to ""
            Set pbSelectImage to True
            Set pcBackColor to clBtnFace 
            Set peImageStyle to ifFitOneSide
            Set peAnchors to anTopRight
            Set pbAutoTooltip to False
            Set pbShowScrollBars to False
        End_Object
#ENDIF
        Object oOnlyHolsCB is a CheckBox
            Set Size to 10 120
            Set Location to 194 75
            Set Label to "Only Show Holiday Dates"
            Set psToolTip to "Check this to hide dates that are not holidays"
            Set peAnchors to anBottomLeft

            Procedure OnChange
                Boolean bChecked
                Get Checked_State to bChecked
                Set pbHolidaysOnly of oHolidays_DD to bChecked
                Send Rebuild_Constraints to oHolidays_DD
                Send Refind_Records to oHolidays_DD
                Send Find of oHolidays_DD GE (Ordering(oHolidaysDetails_grd(Self)))    // to refresh grid
            End_Procedure

        End_Object

    End_Object

    Object oAddDays_grp is a cRDCDbGroup
        Set Size to 52 404
        Set Location to 217 6
        Set Label to "Test - Generate Calendar Dates (including Holidays)"
        Set peAnchors to anBottomLeft

        Object oStartDate_fm is a Form
            Set Size to 13 45
            Set Location to 13 75
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Label to "Start Date"
            Set psToolTip to "Start date for the interval that date records is to be generated for. (Push-button to the right.)"
            Set Form_Datatype to Mask_Date_Window

            Procedure End_Construct_Object
                String sDate
                Forward Send End_Construct_Object
                Get DateGetFirstDayOfYear of ghoCalendarHolidays (CurrentDateTime()) to sDate
                Set Value to sDate
            End_Procedure

        End_Object

        Object oEndDate_fm is a Form
            Set Size to 13 45
            Set Location to 14 160
            Set Label_Justification_Mode to JMode_Right
            Set Label_Col_Offset to 2
            Set Label to "End Date"
            Set psToolTip to "End date for the interval that date records is to be generated for. (Push-button to the right.)"
            Set Form_Datatype to Mask_Date_Window

            Procedure End_Construct_Object
                String sDate
                Forward Send End_Construct_Object
                Get DateGetLastDayOfYear of ghoCalendarHolidays (CurrentDateTime()) to sDate //(DateChangeYear(CurrentDateTime(),1)) to sDate
                Set Value to sDate
            End_Procedure

        End_Object

        Object oCountry_cf is a ComboForm
            Set Size to 13 208
            Set Location to 30 75
            Set Label_Col_Offset to 2
            Set Label_Justification_Mode to JMode_Right
            Set Label to "For Country"
            Set Entry_State Item 0 to False
            Set psToolTip to "Complete Holiday function packages has been put together for the countries in the list. See: 'CountryPackages.pkg'. You can easily add your own country by looking at the examples in that file."

            Procedure Combo_Fill_List
                Handle[] ahoNationalHolidaysArray
                Integer iCount iSize
                Handle hoNationalHolidays
                Get phoNationalHolidaysArray of ghoCalendarHolidays to ahoNationalHolidaysArray
                Move (SizeOfArray(ahoNationalHolidaysArray)) to iSize
                Decrement iSize
                For iCount from 0 to iSize
                    Move ahoNationalHolidaysArray[iCount] to hoNationalHolidays
                    Send Combo_Add_Item (psISO_Short(hoNationalHolidays) * "-" * psOfficial_Short(hoNationalHolidays))
                Loop
            End_Procedure

            Procedure OnChange
                Integer iItem
                String sVal
                Get Wincombo_Current_Item to iItem       // We need this because at startup the Value property is = ""
                Get WinCombo_Value Item iItem to sVal
                Move (Left(sVal, 2)) to sVal             // Short country code.
                Delegate Set psISO_Short to sVal         // Panel property. Used by InitFromTodaysDate and DoProcess.
            End_Procedure

            Procedure OnStartup
                Integer iRecnum iRetval
                String sOfficial_Short sISO_Short sISO_Long

                Move Nations.Recnum to iRecnum
                Get WindowsLocaleValue of ghoCalendarHolidays LOCALE_SABBREVCTRYNAME 3 to sISO_Long
                // Change global record buffer to auto-find todays date record (if any)
                Clear Nations
                Move sISO_Long to Nations.ISO_Long
                Find EQ Nations.ISO_Long
                If (Found) Begin
                    Move (Trim(Nations.ISO_Short))      to sISO_Short
                    Move (Trim(Nations.Official_Short)) to sOfficial_Short
                    Get Combo_Item_Matching (sISO_Short * "-" * sOfficial_Short) to iRetval
                    If (iRetval <> -1) Begin
                        Set Default_Combo_Item to iRetval
                        Delegate Set psISO_Short to sISO_Short  // Panel property. Used by InitFromTodaysDate and DoProcess.
                        Send Request_Assign of oNations_DD
                    End
                End

                // Reset record-buffer
                If (iRecnum > 0) Begin
                    Clear Nations
                    Move iRecnum to Nations.Recnum
                    Find EQ Nations by 0
                End
            End_Procedure

            Procedure Page Integer iMode
                Forward Send Page iMode
                Send OnStartup // This will set the psISO_Short property on startup.
            End_Procedure

            // Update value displayed to that for the current country
            Procedure OnNationChange
                Integer iRetVal
                String  sISO_Short sISO_Long sValue

                Get Field_Current_Value of oNations_DD Field Nations.ISO_Short     to sISO_Short
                Get Field_Current_Value of oNations_DD Field Nations.Official_Long to sISO_Long
                Move (sISO_Short * "-" * sISO_Long) to sValue
                Get Combo_Item_Matching sValue to iRetval
                If (iRetval <> -1) Begin
                    Set Value to sValue
                End
            End_Procedure

        End_Object

        Object oCreateDates_bp is a BusinessProcess
            Set Allow_Cancel_State to True

            // This will generate Holiday records for the given date interval and a
            // selected country.
            Procedure OnProcess
                Integer iRetval iRecnum
                Date dStartDate dEndDate dDate
                Boolean bNationalHoliday
                String  sHolidayName sISO_Short
                Handle hoNationalHolidays

                Get psISO_Short to sISO_Short          // Panel property set by combobox above.
                If (sISO_Short = "") Begin
                    Send Stop_StatusPanel of ghoStatusPanel
                    Send Info_Box "You need to select the country for which dates should be created"
                    Procedure_Return
                End

                Get NationalHolidaysObject of ghoCalendarHolidays sISO_Short to hoNationalHolidays
                Get Value of oStartDate_fm to dStartDate
                Get Value of oEndDate_fm   to dEndDate
                Move Holidays.Recnum to iRecnum

                Send Initialize_StatusPanel of ghoStatusPanel "Creating calendar date records" "" "" "dbwork.avi"
                Send Start_StatusPanel of ghoStatusPanel
                Move (dStartDate -1) to dStartDate            // We start by adding 1 below.

                Lock
                    Repeat
                        Clear Holidays
                        Move sISO_Short  to Holidays.ISO_Short
                        Move (dStartDate + 1) to Holidays.DateNo
                        Find Eq Holidays.DateNo
    
                        Get IsHoliday of hoNationalHolidays Holidays.DateNo (&bNationalHoliday) to sHolidayName
    
                        Move sHolidayName     to Holidays.HolidayName
                        Move bNationalHoliday to Holidays.IsNatHoliday
                        SaveRecord Holidays
    
                        Move Holidays.DateNo to dDate
                        Send Update_StatusPanel of ghoStatusPanel ("Date created:" * String(Holidays.DateNo) * sHolidayName)
                        Increment dStartDate
    
                        Get Check_StatusPanel of ghoStatusPanel to iRetval
                        If (iRetval <> 0) Begin
                            Get YesNo_Box "Do you want to stop the generation of records?" to iRetval
                            Move (iRetval = MBR_Yes) to iRetval
                        End
    
                    Until (dDate = dEndDate or iRetval <> 0)
                Unlock

                If (iRecnum > 0) Begin
                    Move Holidays.Recnum to iRecnum
                    Find EQ Holidays by Recnum
                End
                Send Stop_StatusPanel of ghoStatusPanel
            End_Procedure

        End_Object

        Object oGenerate_btn is a cRDCButton
            Set Size to 13 103
            Set Location to 14 289
            Set Label to "Generate Date Records"
            Set psToolTip to "Select a country from the 'For Country' combo-box to the left. Only those countries can be used to create/update holiday records. If your country is not in the list You will need to create a similar package for your country."
            Set peAnchors to anNone
    
            // Generates Holiday records for the given date interval and selected country.
            Procedure OnClick
                Integer iRetval
                Date dStart dEnd
                String sISO_Short
    
                Get Value of oStartDate_fm to dStart
                Get Value of oEndDate_fm   to dEnd
                Get psISO_Short to sISO_Short          // Panel property.
                Get YesNo_Box ("Do you want to create/update date records for country code:" * sISO_Short * "\nFor the interval" * String(dStart) * "to" * String(dEnd) * "now?") to iRetval
                If (iRetval = MBR_No) Begin
                    Procedure_Return
                End
    
                Send DoProcess to oCreateDates_bp
                Send Request_Find of oNations_DD EQ False
                Send InitFromTodaysDate of oHolidaysDetails_grd
                Send Info_Box "The generation/update of date records is complete."
            End_Procedure
    
        End_Object

        Object oZeroFile_bnt is a cRDCButton
            Set Size to 13 103
            Set Location to 30 289
            Set Label to "Delete All Date Records"
            Set psToolTip to "Delete all records from the Holidays table (zerofile)"
            Set peAnchors to anNone
    
            // Removes all Holiday records (for all countries)
            Procedure OnClick
                Integer iRetval
                Get YesNo_Box "Are you sure You want to delete all records from the Holidays table (zerofile)?" to iRetval
                If (iRetval = MBR_No) Begin
                    Procedure_Return
                End
    
                Send Request_Clear_All of oNations_DD
                Open Holidays Mode DF_EXCLUSIVE
                ZeroFile Holidays
                Open Holidays Mode DF_SHARE
                Send Info_Box "Ready. All Holidays table records removed."
    
            End_Procedure
    
        End_Object

    End_Object

    // Do not allow to close panel:
    Procedure Request_Cancel
    End_Procedure

End_Object
