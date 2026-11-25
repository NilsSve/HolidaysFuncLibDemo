// C:\Visual DataFlex Projects 15\National Holidays\AppSrc\Nations.vw
// Nations View
//
Use cRDCDbView.pkg
Use cRDCDbCJGrid.pkg
Use cRDCDbForm.pkg
Use cRDCComboForm.pkg
Use cRDCDbGroup.pkg
Use DemoTheme.pkg                   // the theme: DemoDarkView
Use cFTRadioGroup.pkg               // cFTGroupCaption: a group box's caption as a TextBox (RDCFlexTron)
// The nation's flag as HTML (RDCFlexTron) - until 2026-11-23 a Graphics Library image, under Is$GraphicsLibrary.
Use cFTGridHost.pkg                 // the host - Used before the web controls
Use cFlagHtmlBox.pkg                // cFlagHtmlBox: the flag

// The flag is drawn again whenever the record changes (the ISO code form's Refresh), below the objects it reaches.
Register_Procedure ShowNationFlag
Use cLinkLabel.pkg
Use cWSCurrencyConvertor.pkg

Use cNationsDataDictionary.dd
Use cHolidaysDataDictionary.dd
Use cContinenDataDictionary.dd
Use Currency.sl

Activate_View Activate_oNations For oNations
Object oNations is a cRDCDbView
    Set Size to 239 520
    Set Label to "Nations Data"
    Set Border_Style to Border_Thick
    Set Auto_Clear_DEO_State to False
    Set pbAutoActivate to True   
    Set Icon to "Nations.ico"
    Set Verify_Save_Msg to none
    Set View_Latch_State to True

    Property String psFileType ".png"
    
    Object oContinen_DD is a cContinenDataDictionary
    End_Object

    Object oNations_DD is A cNationsDataDictionary
        Set DDO_Server to oContinen_DD
    End_Object

    Object oHolidays_DD is a cHolidaysDataDictionary
        Set Constrain_file to Nations.File_number
        Set DDO_Server to oNations_DD
    End_Object

    Set Main_DD to oNations_DD
    Set Server  to oNations_DD

    Object oNation_grp is a cRDCDbGroup
        Set Size to 231 507
        Set Location to 3 7
        Set peAnchors to anAll

        // The caption, readable in both themes: a group box draws its own in the Windows colours.
        Object oNation_grp_cap is a cFTGroupCaption
            Set Label to "National Characterestics"
        End_Object

        Object oNationsISO_Short is a cRDCDbForm
            Entry_Item Nations.ISO_Short
            Set Size to 13 37
            Set Location to 13 75
            Set Label to "ISO Code Short"
            Set piMinSize to 13 31

            // A find, a clear or a relate: the flag follows.
            Procedure Refresh Integer notifyMode
                Forward Send Refresh notifyMode
                Send ShowNationFlag
            End_Procedure
        End_Object

        Object oISOLink is a cLinkLabel
            Set Size to 8 76
            Set Location to 16 122
            Set Label to '<A HREF="https://www.iso.org/obp/ui/#search/code/">ISO - Country Codes</A>'
            Set psToolTip to "Link to ISO -  International Organization for Standardization - Country Codes and names"
        End_Object

        Object oNations_ISO_Long is a cRDCDbForm
            Entry_Item Nations.ISO_Long
            Set Location to 28 75
            Set Size to 13 37
            Set Label to "ISO Code Long"
        End_Object

        Object oNations_ISO_Code is a cRDCDbForm
            Entry_Item Nations.ISO_Code
            Set Location to 43 75
            Set Size to 13 37
            Set Label to "Numeric ISO Code"
        End_Object

        Object oNations_UN_Code is a cRDCDbForm
            Entry_Item Nations.UN_Code
            Set Location to 43 194
            Set Size to 13 25
            Set Label to "UN Code"
        End_Object

        Object oNationsOfficial_Short is a cRDCDbForm
            Entry_Item Nations.Official_Short
            Set Size to 13 332
            Set Location to 58 75
            Set Label to "Country"
            Set peAnchors to anTopLeftRight
        End_Object

        Object oNations_Official_Long is a cRDCDbForm
            Entry_Item Nations.Official_Long
            Set Location to 73 75
            Set Size to 13 332
            Set Label to "Country Long"
            Set peAnchors to anTopLeftRight
        End_Object

        Object oNations_Flag is a cRDCDbForm
            Entry_Item Nations.Flag
            Set Location to 89 75
            Set Size to 13 331
            Set Label to "Flag"
            Set peAnchors to anTopLeftRight
        End_Object

        Object oFiletype_cf is a cRDCComboForm
            Set Location to 112 416
            Set Size to 13 79  
            Set Label to "Select File Type"
            Set peAnchors to anTopRight

            Procedure Combo_Fill_List
                Send Combo_Add_Item ".png"
                Send Combo_Add_Item ".gif"
            End_Procedure
            
            Procedure OnChange
                String sVal
                Get Value to sVal
                Set psFileType to sVal
                Send ShowNationFlag
            End_Procedure
            
        End_Object
        
        Object oNations_Capital_City is a cRDCDbForm
            Entry_Item Nations.Capital_City
            Set Location to 105 75
            Set Size to 13 144
            Set Label to "Capital City"
        End_Object

        Object oNations_IntCallCode is a cRDCDbForm
            Entry_Item Nations.IntCallCode
            Set Location to 120 75
            Set Size to 13 39
            Set Label to "Int Calling Code"
        End_Object

        Object oNations_Internet_TLD is a cRDCDbForm
            Entry_Item Nations.Internet_TLD
            Set Location to 135 75
            Set Size to 13 37
            Set Label to "Internet TLD"
        End_Object

        Object oNations_ISO_Currency is a cRDCDbForm
            Entry_Item Nations.ISO_Currency
            Set Location to 150 75
            Set Size to 13 37
            Set Label to "ISO Currency Code"
        End_Object

        Object oNations_CurrNum is a cRDCDbForm
            Entry_Item Nations.ISO_CurrNum
            Set Location to 131 194
            Set Size to 13 25
            Set Label to "ISO Currency Number"
        End_Object

        Object oNations_ISO_CurrTxt is a cRDCDbForm
            Entry_Item Nations.ISO_CurrTxt
            Set Location to 165 75
            Set Size to 13 144
            Set Label to "Currency Text"
            Set peAnchors to anTopLeftRight

            Procedure Exiting Handle hoDestination Returns Integer
                Integer iRetVal
                Forward Get msg_Exiting hoDestination to iRetVal
                Send Request_Save
                Procedure_Return iRetVal
            End_Procedure
        End_Object

        Object oContinen_Name is a cRDCDbForm
            Entry_Item Continen.Name
            Set Location to 181 75
            Set Size to 13 145
            Set Label to "Continent Name"
        End_Object

        Object oNations_Area is a cRDCDbForm
            Entry_Item Nations.Area
            Set Label to "Area"
            Set Location to 197 75
            Set Size to 13 59
        End_Object

        Object oNations_Population is a cRDCDbForm
            Entry_Item Nations.Population
            Set Label to "Population"
            Set Location to 212 75
            Set Size to 13 59
        End_Object

        // THE FLAG, as HTML in a small FlexTron host - drawn again on every find, clear and relate (ShowNationFlag).
        Object oFlag_host is a cFTGridHost
            Set Size to 65 90
            Set Location to 48 410
            Set peAnchors to anTopRight
            Set piColumnCount to 1
            Set psColumnWidths to "0/1fr"
            Set psRowHeights to "0/1fr"

            Object oFlag_box is a cFlagHtmlBox
                Set piRowIndex to 0
                Set piColumnSpan to 1
                Set pbFillHeight to True 
                Set piHeight to 100
                Set piWidth  to 130
            End_Object

        End_Object

    End_Object

    // Do not allow to close panel:
    Procedure Request_Cancel
    End_Procedure

    Procedure OnStartup
        Integer iRecnum iRetval
        String sOfficial_Short sISO_Short sISO_Long

        Move Nations.Recnum to iRecnum
        Get WindowsLocaleValue of ghoCalendarHolidays LOCALE_SABBREVCTRYNAME 3 to sISO_Long
        // Change global record buffer and DDO to auto-find a country based on the current machine.
        Clear Nations
        Move sISO_Long to Nations.ISO_Long
        Find EQ Nations.ISO_Long
        If (Found) Begin
            Send Request_Assign of oNations_DD
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
        Send OnStartup
    End_Procedure

    //    On_Key Key_Ctrl+Key_C Send KeyAction of oCallWebService_btn
    //    On_Key Key_Alt+Key_C  Send KeyAction of oCallWebService_btn
    On_Key Key_Ctrl+Key_S Send Request_Save

    // The theme's ground and ink on the view and its controls, in the dark theme (DemoTheme.pkg).
    Procedure End_Construct_Object
        Forward Send End_Construct_Object
        Send DemoDarkView Self
    End_Procedure
    // The nation's flag, from the Nations buffer the data dictionaries keep current.
    Procedure ShowNationFlag
        String sFlag sFileType
        Get psFileType to sFileType
        Move (Trim(Nations.Flag)) to sFlag
        If (sFlag <> "" and sFileType <> ".gif") Begin
            Move (Replace(".gif", sFlag, ".png")) to sFlag
        End
        Send ShowFlag of oFlag_box sFlag (Trim(Nations.Official_Short))
    End_Procedure

End_Object
