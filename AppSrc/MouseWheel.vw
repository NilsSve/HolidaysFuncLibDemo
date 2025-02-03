Use Windows.pkg
Use DFClient.pkg
Use cCJGrid.pkg
Use cCJGridColumn.pkg
Use cTextEdit.pkg
Use cRDCDbView.pkg  
Use cRDCCJGrid.pkg 
Use cRDCDbGroup.pkg

Activate_View Activate_oMouseWheel for oMouseWheel
Object oMouseWheel is a cRDCDbView //dbView
    Set Border_Style to Border_Thick
    Set Size to 200 300
    Set Location to 2 2
    Set Label to "OnWmMouseWheel"
    Set pbAutoActivate to True
    
       // low level event sent from windows.
//    Procedure OnWmMouseWheel Integer wParam Integer lParam
//        Integer iWheelDelta iKeys iDelta iClicks
//        Forward Send OnWmMouseWheel wParam lParam
//        Move (low(abs(wParam))) to iKeys           // any keys down when pressed
//        Move (hi(abs(wParam))) to iDelta           // number of click units
//        If (wParam<0) Begin
//            Move (-iDelta) to iDelta     // can be up or down
//        End
//
//        // tell windows that we've handled the event.    
//        Set Windows_Override_State to True    
//    End_Procedure 

    Object oDateMaintenance_grp is a cRDCDbGroup
        Set Location to 20 17
        Set Size to 144 256
        Set Label to 'oGroup1'

        Object oForm1 is a Form
            Set Location to 27 89
            Set Size to 12 108
            Set Value to "Testing moursewheel"
        
            // OnChange is called on every changed character
        //    Procedure OnChange
        //        String sValue
        //    
        //        Get Value to sValue
        //    End_Procedure
        
        End_Object
    
        Object oCJGrid1 is a cRDCCJGrid //cCJGrid
            Set Location to 46 96
            Set Size to 100 100
    
            Object oCJGridColumn1 is a cCJGridColumn
                Set piWidth to 100
                Set psCaption to "column"
                
            End_Object
    
            Object oCJGridColumn2 is a cCJGridColumn
                Set piWidth to 100
                Set psCaption to "column"
            End_Object
        End_Object

    End_Object

End_Object
