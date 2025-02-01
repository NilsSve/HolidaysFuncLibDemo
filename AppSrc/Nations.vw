// C:\Visual DataFlex Projects 15\National Holidays\AppSrc\Nations.vw
// Nations View
//
Use cRDCDbView.pkg
Use cRDCDbCJGrid.pkg
Use cRDCDbForm.pkg
Use cRDCDbGroup.pkg
#IFDEF Is$GraphicsLibrary
    Use cDbImageContainer.pkg
#ENDIF    
Use cLinkLabel.pkg
Use cWSCurrencyConvertor.pkg

Use cNationsDataDictionary.dd
Use cHolidaysDataDictionary.dd
Use cContinenDataDictionary.dd
Use Currency.sl

Activate_View Activate_oNations For oNations
Object oNations is a cRDCDbView
    Set Size to 227 520
    Set Label to "Nations Data"
    Set Border_Style to Border_Thick
    Set Auto_Clear_DEO_State to False
    Set pbAutoActivate to True   
    Set Icon to "Nations.ico"
    Set Verify_Save_Msg to none
    Set View_Latch_State to True

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
        Set Size to 219 507
        Set Location to 3 7
        Set Label to "National Characterestics"
        Set peAnchors to anAll

        Object oNationsISO_Short is a cRDCDbForm
            Entry_Item Nations.ISO_Short
            Set Size to 13 37
            Set Location to 13 75
            Set Label to "ISO Code Short"
            Set piMinSize to 13 31
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

        Object oNations_Capital_City is a cRDCDbForm
            Entry_Item Nations.Capital_City
            Set Location to 88 75
            Set Size to 13 144
            Set Label to "Capital City"
        End_Object

        Object oNations_IntCallCode is a cRDCDbForm
            Entry_Item Nations.IntCallCode
            Set Location to 103 75
            Set Size to 13 39
            Set Label to "Int Calling Code"
        End_Object

        Object oNations_Internet_TLD is a cRDCDbForm
            Entry_Item Nations.Internet_TLD
            Set Location to 118 75
            Set Size to 13 37
            Set Label to "Internet TLD"
        End_Object

        Object oNations_ISO_Currency is a cRDCDbForm
            Entry_Item Nations.ISO_Currency
            Set Location to 133 75
            Set Size to 13 37
            Set Label to "ISO Currency Code"
        End_Object

        Object oNations_CurrNum is a cRDCDbForm
            Entry_Item Nations.ISO_CurrNum
            Set Location to 133 194
            Set Size to 13 25
            Set Label to "ISO Currency Number"
        End_Object

        Object oNations_ISO_CurrTxt is a cRDCDbForm
            Entry_Item Nations.ISO_CurrTxt
            Set Location to 148 75
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

#IFDEF Is$GraphicsLibrary
        Object oFlagPole1 is a cImageContainer
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

        Object oNationsFlag1 is a cDbImageContainer
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
        Object oContinen_Name is a cRDCDbForm
            Entry_Item Continen.Name
            Set Location to 164 75
            Set Size to 13 145
            Set Label to "Continent Name"
        End_Object

        Object oNations_Area is a cRDCDbForm
            Entry_Item Nations.Area
            Set Label to "Area"
            Set Location to 180 75
            Set Size to 13 59
        End_Object

        Object oNations_Population is a cRDCDbForm
            Entry_Item Nations.Population
            Set Label to "Population"
            Set Location to 195 75
            Set Size to 13 59
        End_Object

    End_Object

    // Do not allow to close panel:
    Procedure Request_Cancel
    End_Procedure

    //    On_Key Key_Ctrl+Key_C Send KeyAction of oCallWebService_btn
    //    On_Key Key_Alt+Key_C  Send KeyAction of oCallWebService_btn
    On_Key Key_Ctrl+Key_S Send Request_Save
End_Object
