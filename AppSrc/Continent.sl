// Continent.sl
// Continent Lookup List

Use Windows.pkg
Use cRDCDbModalPanel.pkg
Use cRDCDbCJGridPromptList.pkg
Use cRDCDbCJGridColumn.pkg

Use cContinenDataDictionary.dd

Cd_Popup_Object Continent_sl is a cRDCDbModalPanel
    Set Location to 5 5
    Set Size to 134 187
    Set Label to "Continent Lookup List"
    Set Border_Style to Border_Thick
    Set Minimize_Icon to False

    Object oContinen_DD is a cContinenDataDictionary
    End_Object

    Set Main_DD to oContinen_DD
    Set Server  to oContinen_DD

    Object oSelList is a cRDCDbCJGridPromptList
        Set Size to 105 177
        Set Location to 5 5
        Set Ordering to 1
        Set pbAutoServer to True

        Object oContinent_ID is a cRDCDbCJGridColumn
            Entry_Item Continen.ID
            Set piWidth to 25
            Set psCaption to "ID"
        End_Object

        Object oContinent_Name is a cRDCDbCJGridColumn
            Entry_Item Continen.Name
            Set piWidth to 225
            Set psCaption to "Continent Name"
        End_Object

    End_Object

    Object oOk_bn is a Button
        Set Label to "&Ok"
        Set Location to 115 24
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send OK of oSelList
        End_Procedure

    End_Object

    Object oCancel_bn is a Button
        Set Label to "&Cancel"
        Set Location to 115 78
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Cancel of oSelList
        End_Procedure

    End_Object

    Object oSearch_bn is a Button
        Set Label to "&Search..."
        Set Location to 115 132
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Search of oSelList
        End_Procedure

    End_Object

    On_Key Key_Alt+Key_O Send KeyAction of oOk_bn
    On_Key Key_Alt+Key_C Send KeyAction of oCancel_bn
    On_Key Key_Alt+Key_S Send KeyAction of oSearch_bn
Cd_End_Object
