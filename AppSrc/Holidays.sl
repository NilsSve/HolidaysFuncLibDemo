// Holidays.sl
// Holidays Lookup List

Use DFClient.pkg
Use cDbCJGridPromptList.pkg
Use cDbCJGridColumn.pkg
Use cRDCDbModalPanel.pkg
Use cRDCDbCJGridPromptList.pkg
Use cRDCDbCJGridColumn.pkg
Use cCalendarHolidays.pkg

Use cNationsDataDictionary.dd
Use cHolidaysDataDictionary.dd

Object Holidays_sl is a cRDCDbModalPanel
    Set Location to 5 5
    Set Size to 204 377
    Set Label to "Holidays Lookup List"
    Set Border_Style to Border_Thick
    Set Minimize_Icon to False 
    Set Icon to "NationalHolidays.ico"

    Object oNations_DD is a cNationsDataDictionary
    End_Object

    Object oHolidays_DD is a cHolidaysDataDictionary
        Set DDO_Server to oNations_DD
    End_Object

    Set Main_DD to oHolidays_DD
    Set Server  to oHolidays_DD

    Object oSelList is a cRDCDbCJGridPromptList
        Set Size to 175 367
        Set Location to 5 5
        Set Ordering to 1
        Set pbAutoServer to True 
        Set pbHeaderPrompts to False

        Object oHolidays_Dateno is a cRDCDbCJGridColumn
            Entry_Item Holidays.DateNo
            Set piWidth to 65
            Set psCaption to "Date"
        End_Object

        Object oHolidays_Holidayname is a cRDCDbCJGridColumn
            Entry_Item Holidays.Holidayname
            Set piWidth to 195
            Set psCaption to "Description"
        End_Object

        Object oHolidays_Isnatholiday is a cRDCDbCJGridColumn
            Entry_Item Holidays.IsNatHoliday
            Set pbCheckbox to True
            Set piWidth to 52
            Set psCaption to "Holiday"
        End_Object

        Object oDateWeekNumber is a cRDCDbCJGridColumn
            Set piWidth to 66
            Set psCaption to "Week No"

            Procedure OnSetCalculatedValue String ByRef sValue
                Move (DateGetISOWeek(Holidays.DateNo)) to sValue
            End_Procedure
        
        End_Object

        Object oDateDayName is a cRDCDbCJGridColumn
            Set piWidth to 85
            Set psCaption to "Week Day"

            Procedure OnSetCalculatedValue String ByRef sValue
                Move (DateGetDayName(Holidays.DateNo)) to sValue
            End_Procedure 
            
        End_Object

        Object oDateDayNumber is a cRDCDbCJGridColumn
            Set piWidth to 87
            Set psCaption to "Day no"

            Procedure OnSetCalculatedValue String ByRef sValue
                DateTime dtVar
                Move Holidays.DateNo to dtVar
                Move (DateGetDayOfYear(dtVar)) to sValue
            End_Procedure 
            
        End_Object
        
    End_Object

    Object oOk_bn is a Button
        Set Label to "&Ok"
        Set Location to 185 214
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send OK of oSelList
        End_Procedure

    End_Object

    Object oCancel_bn is a Button
        Set Label to "&Cancel"
        Set Location to 185 268
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Cancel of oSelList
        End_Procedure

    End_Object

    Object oSearch_bn is a Button
        Set Label to "&Search..."
        Set Location to 185 322
        Set peAnchors to anBottomRight

        Procedure OnClick
            Send Search of oSelList
        End_Procedure

    End_Object

    On_Key Key_Alt+Key_O Send KeyAction of oOk_bn
    On_Key Key_Alt+Key_C Send KeyAction of oCancel_bn
    On_Key Key_Alt+Key_S Send KeyAction of oSearch_bn
End_Object
