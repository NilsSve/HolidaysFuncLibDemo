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
// The exchange rate follows the nation the same way.
Register_Procedure ShowRate
Use cLinkLabel.pkg
Use cRDCForm.pkg
Use gFormatNumbers.pkg              // FormatNumber
Use cCurrencyRates.pkg              // today's rates from open.er-api.com

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

    Property String psFileType ".svg"

    // Today's exchange rates, fetched once (cCurrencyRates.pkg).
    Object oCurrencyRates is a cCurrencyRates
    End_Object

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

            // A find, a clear or a relate: the flag and the exchange rate follow.
            Procedure Refresh Integer notifyMode
                Forward Send Refresh notifyMode
                Send ShowNationFlag
                Send ShowRate
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
                Send Combo_Add_Item ".svg"
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
            Set Location to 150 194
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

        // THE EXCHANGE RATE: an amount of the nation's currency in another one, at today's rate from open.er-api.com.
        // The rates are fetched once, then every nation and currency is worked out from them (cCurrencyRates.pkg).
        Object oRates_grp is a cRDCDbGroup
            Set Size to 78 270
            Set Location to 134 230
            Set peAnchors to anTopRight

            Object oRates_grp_cap is a cFTGroupCaption
                Set Label to "Exchange Rate"
            End_Object

            Object oAmount_fm is a cRDCForm
                Set Size to 13 60
                Set Location to 14 45
                Set Label to "Amount"
                Set Label_Justification_Mode to JMode_Right
                Set Label_Col_Offset to 2
                Set Form_Datatype to 2
                Set Value to 100
                Set psToolTip to "How much of the nation's currency to convert."

                Procedure OnChange
                    Send ShowRate
                End_Procedure
            End_Object

            Object oFrom_tb is a TextBox
                Set Auto_Size_State to False
                Set Size to 10 30
                Set Location to 16 109
                Set FontWeight to fw_Bold
            End_Object

            Object oTo_fm is a cRDCForm
                Set Size to 13 30
                Set Location to 14 165
                Set Label to "in"
                Set Label_Justification_Mode to JMode_Right
                Set Label_Col_Offset to 2
                Set Capslock_State to True
                Set Value to "EUR"
                Set psToolTip to "The currency to convert to: its three-letter code, for example EUR, USD or GBP."

                Procedure OnChange
                    Send ShowRate
                End_Procedure
            End_Object

            Object oResult_tb is a TextBox
                Set Auto_Size_State to False
                Set Size to 10 240
                Set Location to 32 8
                Set FontWeight to fw_Bold
            End_Object

            Object oRate_tb is a TextBox
                Set Auto_Size_State to False
                Set Size to 10 240
                Set Location to 46 8
            End_Object

            // The service's terms ask for this credit where its rates are shown.
            Object oCredit_lnk is a cLinkLabel
                Set Size to 8 120
                Set Location to 61 8
                Set pbAutoSizeHeight to False
                Set Label to '<a href="https://www.exchangerate-api.com">Rates By Exchange Rate API</a>'
                Set psToolTip to "The exchange rates come from ExchangeRate-API's free open access (open.er-api.com), updated once a day."
            End_Object

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

    // This computer's country, when the view has no nation yet - found through the DD, with its continent.
    Procedure OnStartup
        String sISO_Short
        If (HasRecord(oNations_DD(Self))) ;
            Procedure_Return
        Get WindowsLocaleISO_Short of ghoCalendarHolidays to sISO_Short
        Send FindByISO_Short of oNations_DD sISO_Short
    End_Procedure

    Procedure Page Integer iMode
        Forward Send Page iMode
        Send OnStartup
    End_Procedure

    On_Key Key_Ctrl+Key_S Send Request_Save

    // The theme's ground and ink on the view and its controls, in the dark theme (DemoTheme.pkg).
    Procedure End_Construct_Object
        Forward Send End_Construct_Object
        Send DemoDarkView Self
    End_Procedure
    // The nation's flag, from the Nations buffer the data dictionaries keep current.
    // .svg: the flag-icons drawing named by the ISO code (se.svg), sharp at any size - the PNG when there is none.
    // .png and .gif: the picture Nations.Flag names ("Sweden.gif").
    Procedure ShowNationFlag
        String sFlag sFileType
        Get psFileType to sFileType
        Move (Trim(Nations.Flag)) to sFlag
        If ((sFlag <> "") and (sFileType <> ".gif")) Begin
            Move (Replace(".gif", sFlag, ".png")) to sFlag
        End
        If (sFileType = ".svg") ;
            Send ShowCountryFlag of oFlag_box (Trim(Nations.ISO_Short)) sFlag (Trim(Nations.Official_Short))
        Else ;
            Send ShowFlag of oFlag_box sFlag (Trim(Nations.Official_Short))
    End_Procedure

    // The amount in the nation's currency (Nations.ISO_Currency) shown in the other one, and the rate it is from.
    Procedure ShowRate
        Handle hoGrp
        String sFrom sTo sError
        Number nAmount nRate

        Move (oRates_grp(oNation_grp(Self))) to hoGrp
        Move (Uppercase(Trim(Nations.ISO_Currency))) to sFrom
        Get Value of (oTo_fm(hoGrp)) to sTo
        Move (Uppercase(Trim(sTo))) to sTo
        Get Value of (oAmount_fm(hoGrp)) to nAmount
        Set Label of (oFrom_tb(hoGrp)) to sFrom
        Set Label of (oRate_tb(hoGrp)) to ""
        If (sFrom = "") Begin
            Set Label of (oResult_tb(hoGrp)) to "This nation has no currency code."
            Procedure_Return
        End
        If (Length(sTo) <> 3) Begin
            Set Label of (oResult_tb(hoGrp)) to "Write the currency to convert to: EUR, USD, GBP ..."
            Procedure_Return
        End
        Get Rate of oCurrencyRates sFrom sTo to nRate
        If (nRate = 0) Begin
            Get psError of oCurrencyRates to sError
            If (sError = "") ;
                Move ("No rate for" * sFrom * "or" * sTo + ".") to sError
            Set Label of (oResult_tb(hoGrp)) to sError
            Procedure_Return
        End
        Set Label of (oResult_tb(hoGrp)) to (FormatNumber(nAmount, 2) * sFrom * "=" * FormatNumber(nAmount * nRate, 2) * sTo)
        Set Label of (oRate_tb(hoGrp)) to ("1" * sFrom * "=" * FormatNumber(nRate, 4) * sTo + ", the rate of" * RatesDay(oCurrencyRates))
    End_Procedure

End_Object
