// Currency.sl
// Currency Lookup List

Use Windows.pkg
Use cRDCDbModalPanel.pkg
Use cRDCDbCJGridPromptList.pkg
Use cRDCDbCJGridColumn.pkg

Use cNationsDataDictionary.dd

Cd_Popup_Object Currency_sl is a cRDCDbModalPanel
    Set Location to 5 5
    Set Size to 211 329
    Set Label to "Currency Lookup List"
    Set Border_Style to Border_Thick
    Set Minimize_Icon to False

    Object oNations_DD is a cNationsDataDictionary
    End_Object

    Set Main_DD to oNations_DD
    Set Server  to oNations_DD

    Object oSelList is a cRDCDbCJGridPromptList
        Set Size to 185 319
        Set Location to 5 5
        Set peAnchors to anAll
        Set psLayoutSection to "Currency_sl_oSelList"
        Set Ordering to 1
        Set pbAutoServer to True

        Object oNations_Iso_Currency is a cRDCDbCJGridColumn
            Entry_Item Nations.Iso_Currency
            Set piWidth to 96
            Set psCaption to "Currency Code"
            Set pbResizable to False
        End_Object

        Object oNations_Iso_Currtxt is a cRDCDbCJGridColumn
            Entry_Item Nations.Iso_Currtxt
            Set piWidth to 190
            Set psCaption to "Description"
        End_Object

        Object oNations_Official_Short is a cRDCDbCJGridColumn
            Entry_Item Nations.Official_Short
            Set piWidth to 192
            Set psCaption to "Country"
        End_Object

    End_Object

    Object oOk_bn is a Button
        Set Label to "&Ok"
        Set Location to 195 166
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send OK of oSelList
        End_Procedure

    End_Object

    Object oCancel_bn is a Button
        Set Label to "&Cancel"
        Set Location to 195 220
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Cancel of oSelList
        End_Procedure

    End_Object

    Object oSearch_bn is a Button
        Set Label to "&Search..."
        Set Location to 195 274
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Search of oSelList
        End_Procedure

    End_Object

    On_Key Key_Alt+Key_O Send KeyAction of oOk_bn
    On_Key Key_Alt+Key_C Send KeyAction of oCancel_bn
    On_Key Key_Alt+Key_S Send KeyAction of oSearch_bn
Cd_End_Object
