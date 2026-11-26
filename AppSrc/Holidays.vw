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
Use DemoTheme.pkg                   // the theme: DemoDarkView, DemoDarkGrid
Use cFTCheckBoxCaption.pkg          // a check box's caption as a TextBox (RDCFlexTron)
Use cFTRadioGroup.pkg               // cFTGroupCaption: a group box's caption as a TextBox (RDCFlexTron)
Use cRDCForm.pkg
Use cRDCButton.pkg
// The nation's flag as HTML (RDCFlexTron) - until 2026-11-23 a Graphics Library image, under Is$GraphicsLibrary.
Use cFTGridHost.pkg                 // the host - Used before the web controls
Use cRDCImageHtmlBox.pkg            // cRDCImageHtmlBox: the flag
Use cViewHtmlBox.pkg                // the note under the flag

// The flag is drawn again whenever the record changes (the ISO code form's Refresh), below the objects it reaches.
Register_Procedure ShowNationFlag
Use oCalendarHolidays.pkg
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
        Set peAnchors to anAll
        Set piMinSize to 204 457
        Set Bitmap_Style to Bitmap_Stretch

        // The caption, readable in both themes: a group box draws its own in the Windows colours.
        Object oDateMaintenance_grp_cap is a cFTGroupCaption
            Set Label to "Sample - Calendar Dates Including Holidays and Other Special Dates"
        End_Object

        Object oNations_ISO_Short is a cRDCDbForm
            Entry_Item Nations.ISO_Short
            Set Location to 13 75
            Set Size to 13 37
            Set Label to "ISO Short"
            Set psToolTip to "The two character long ISO code for the country"
            Set psToolTip to "Only Nations defined in the 'CountryPackes.pkg' appears here!"

            // A find, a clear or a relate: the flag follows.
            Procedure Refresh Integer notifyMode
                Forward Send Refresh notifyMode
                Send ShowNationFlag
            End_Procedure
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

            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                Set phoContextMenu to 0
                Send DemoDarkGrid Self      // the theme's colours in the dark theme (DemoTheme.pkg)
            End_Procedure

            On_Key kCancel Send None
        End_Object

        // THE FLAG, as HTML in a small FlexTron host - drawn again on every find, clear and relate (ShowNationFlag).
        Object oFlag_host is a cFTGridHost
            Set Size to 62 55
            Set Location to 40 430
            Set peAnchors to anTopRight
            Set piColumnCount to 1
            Set psColumnWidths to "0/1fr"
            Set psRowHeights to "0/1fr"

            Object oFlag_box is a cRDCImageHtmlBox
                Set piRowIndex to 0
                Set piColumnSpan to 1
                Set pbFillHeight to True
            End_Object
        End_Object

        // THE NOTE: the date records are not needed to use the library - this view is one more example of it.
        Object oNote_host is a cFTGridHost
            Set Size to 82 92
            Set Location to 106 414
            Set peAnchors to anTopRight
            Set piColumnCount to 1
            Set psColumnWidths to "0/1fr"
            Set psRowHeights to "0/1fr"

            Object oNote_box is a cViewHtmlBox
                Set piRowIndex to 0
                Set piColumnSpan to 1
                Set pbFillHeight to True
                Set psHtml to '<div style="font-size:11px;line-height:1.35;color:var(--dfr-ink,#d6d3cc);padding:2px 2px 0 4px"><b style="color:var(--dfr-amber,#e0a84a)">Note:</b> the library does not need these date records - it works out the holidays of any date on the fly. This table is just one more example of using it.</div>'
            End_Object
        End_Object

        Object oOnlyHolsCB is a CheckBox
            Set Size to 10 10
            Set Location to 194 75
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

        // The caption, readable in both themes: a check box draws its own in the Windows colours.
        Object oOnlyHols_cap is a cFTCheckBoxCaption
            Set Location to 195 86
            Set Label to "Only Show Holiday Dates"
            Set peAnchors to anBottomLeft
            Set phoCheckBox to (oOnlyHolsCB(Self))
        End_Object

    End_Object

    Object oAddDays_grp is a cRDCDbGroup
        Set Size to 52 404
        Set Location to 217 6
        Set peAnchors to anBottomLeft

        // The caption, readable in both themes: a group box draws its own in the Windows colours.
        Object oAddDays_grp_cap is a cFTGroupCaption
            Set Label to "Test - Generate Calendar Dates (including Holidays)"
        End_Object

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

            // This computer's country, when it has a holiday package: chosen in the list, and found through the DD
            // (with its continent) when the view has no nation yet.
            Procedure OnStartup
                Integer iItem
                String sISO_Short sOfficial_Short
                Get WindowsLocaleISO_Short of ghoCalendarHolidays to sISO_Short
                Move (Uppercase(Trim(sISO_Short))) to sISO_Short
                If (sISO_Short = "") ;
                    Procedure_Return
                If (HasRecord(oNations_DD(Self)) = False) ;
                    Send FindByISO_Short of oNations_DD sISO_Short
                If (Trim(Nations.ISO_Short) <> sISO_Short) ;
                    Procedure_Return
                Move (Trim(Nations.Official_Short)) to sOfficial_Short
                Get Combo_Item_Matching (sISO_Short * "-" * sOfficial_Short) to iItem
                If (iItem <> -1) Begin
                    Set Default_Combo_Item to iItem
                    Delegate Set psISO_Short to sISO_Short  // Panel property. Used by InitFromTodaysDate and DoProcess.
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

                Get psISO_Short to sISO_Short          // Panel property set by combobox above.
                If (sISO_Short = "") Begin
                    Send Stop_StatusPanel of ghoStatusPanel
                    Send Info_Box "You need to select the country for which dates should be created"
                    Procedure_Return
                End

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

                        Get HolidayName of ghoCalendarHolidays Holidays.DateNo sISO_Short (&bNationalHoliday) to sHolidayName

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
                Send FindByISO_Short of oNations_DD sISO_Short
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

    // The theme's ground and ink on the view and its controls, in the dark theme (DemoTheme.pkg).
    Procedure End_Construct_Object
        Forward Send End_Construct_Object
        Send DemoDarkView Self
        // the note on the view's colour - which DemoDarkView has just set
        Send ShowHtml of (oNote_box(oNote_host(oDateMaintenance_grp(Self)))) (psHtml(oNote_box(oNote_host(oDateMaintenance_grp(Self)))))
    End_Procedure

    // The nation's flag, from the Nations buffer the data dictionaries keep current.
    // The SVG flag by the ISO code - the picture Nations.Flag names when there is none.
    Procedure ShowNationFlag
        Send ShowCountryFlag of oFlag_box (Trim(Nations.ISO_Short)) (Trim(Nations.Flag)) (Trim(Nations.Official_Short))
    End_Procedure

End_Object
