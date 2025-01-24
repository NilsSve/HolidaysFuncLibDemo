// Nations.sl
// Nations Lookup List

Use Windows.pkg
Use cRDCDbModalPanel.pkg
Use cRDCDbCJGridPromptList.pkg
Use cRDCDbCJGridColumn.pkg

Use cNationsDataDictionary.dd

Cd_Popup_Object Nations_sl is a cRDCDbModalPanel
    Set Location to 5 5
    Set Size to 184 494
    Set Label to "Nations Lookup List"
    Set Border_Style to Border_Thick
    Set Minimize_Icon to False
    Set Icon to "Nations.ico"
    Set Locate_Mode to CENTER_ON_PANEL

    Object oNations_DD is a cNationsDataDictionary
    End_Object

    Set Main_DD to oNations_DD
    Set Server  to oNations_DD

    Object oSelList is a cRDCDbCJGridPromptList
        Set Size to 155 486
        Set Location to 5 5
        Set Ordering to 1
        Set pbAutoServer to True

        Object oNations_Iso_Short is a cRDCDbCJGridColumn
            Entry_Item Nations.Iso_Short
            Set piWidth to 80
            Set psCaption to "ISO Short"
        End_Object

        Object oNations_Official_Short is a cRDCDbCJGridColumn
            Entry_Item Nations.Official_Short
            Set piWidth to 235
            Set psCaption to "Official Short"
        End_Object

        Object oNations_Iso_Long is a cRDCDbCJGridColumn
            Entry_Item Nations.Iso_Long
            Set piWidth to 62
            Set psCaption to "ISO Long"
        End_Object

        Object oNations_Capital_City is a cRDCDbCJGridColumn
            Entry_Item Nations.Capital_City
            Set piWidth to 190
            Set psCaption to "Capital City"
        End_Object

        Object oNations_Iso_Currency is a cRDCDbCJGridColumn
            Entry_Item Nations.Iso_Currency
            Set piWidth to 82
            Set psCaption to "ISO Currency"
        End_Object

        Object oNations_Internet_Tld is a cRDCDbCJGridColumn
            Entry_Item Nations.Internet_Tld
            Set piWidth to 97
            Set psCaption to "Internet Domain"
        End_Object

    End_Object

    Object oOk_bn is a Button
        Set Label to "&Ok"
        Set Location to 165 334
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send OK of oSelList
        End_Procedure

    End_Object

    Object oCancel_bn is a Button
        Set Label to "&Cancel"
        Set Location to 165 388
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Cancel of oSelList
        End_Procedure

    End_Object

    Object oSearch_bn is a Button
        Set Label to "&Search..."
        Set Location to 165 442
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Search of oSelList
        End_Procedure

    End_Object

    On_Key Key_Alt+Key_O Send KeyAction of oOk_bn
    On_Key Key_Alt+Key_C Send KeyAction of oCancel_bn
    On_Key Key_Alt+Key_S Send KeyAction of oSearch_bn
Cd_End_Object
