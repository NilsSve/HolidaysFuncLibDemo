//An_Calendar.sl//////////////////////////////////////////////////////////////
//
//  Defines an object oDatePrompt that can be used as a prompt object for
//  any Form, dbForm or grid cell that is used to enter dates.
//  The object is displayed below and right aligned with the object from
//  which it is invoked.
//
//----------------------------------------------------------------------------
//
//  Modifications:
//  ~~~~~~~~~~~~~
//  23/ 2/2011  Added peAlignment property.
//              Adjusted positioning to popup above parent if no room below.
//
//============================================================================
//

Use Windows.pkg
Use An_Calendar.pkg

#IFNDEF xtpAlignmentLeft
Define xtpAlignmentLeft   For 0
Define xtpAlignmentCenter For 1
Define xtpAlignmentRight  For 2
#ENDIF

Object oDatePrompt is a FloatingPanel
    Set Popup_State to True
    Set Scope_State to True
#IF (!@ < 170)
    Set Size to 95 116
#ELSE
    Set Size to 87 86
#ENDIF
    Set Label to "Calendar"
    Set Icon to "Application.ico"
    Set Maximize_Icon to False
    Set Border_Style to Border_Normal
    Set Caption_Bar to False
    Set Color to clWindow
    Set Column_Offset to -6
    Set Row_Offset    to 1

    Property Integer Invoking_Object_ID 0
    Property Integer peAlignment xtpAlignmentRight

    Object oCalendar is a cCalendarDisplay
#IF (!@ < 170)
        Set Size to 102 112
#ELSE
        Set Size to 87 86
#ENDIF
        Set pbPromptListBehavior to True // So that prompt is closed when it loses the focus.
        Set Floating_Menu_Object to 0       // 'Copy date' menu not appropriate for prompt list.
        Set Visible_State to True
        Procedure OnDateSelected Date dDate
            Send move_value_out
        End_Procedure
        Procedure OnDateClick Date dDate
            Send move_value_out
        End_Procedure
        On_Key kCancel Send Close_Panel
    End_Object

    Procedure Add_Focus Handle hoParent Returns Integer
        Integer iRetVal iLocation iSize iParentSize iScreenSize iVertPos
        Handle hoOldFocus
        String sInitialDate
        Register_Object oMain
        Move (focus(desktop)) to hoOldFocus
        Set invoking_object_id to hoOldFocus
        Get Absolute_GuiOrigin of hoOldFocus to iLocation
        Get GuiSize to iSize
        Get GuiSize of hoOldFocus to iParentSize
        Move (Hi(iLocation) + Hi(iParentSize) + 1) to iVertPos
        Get GUIScreen_Size to iScreenSize
        If (iVertPos + (Hi(iSize)) > Hi(iScreenSize)) Begin
            Move (Hi(iLocation) - Hi(iSize) -1) to iVertPos
        End
        If (peAlignment(Self) = xtpAlignmentLeft);
            Set GuiLocation  to iVertPos (Low(iLocation) + 1)
        If (peAlignment(Self) = xtpAlignmentCenter);
            Set GuiLocation to iVertPos (Low(iLocation) + ((Low(iParentSize) - Low(iSize))/2) - 1)
        Else Begin
            Set GuiLocation to iVertPos (Low(iLocation) + Low(iParentSize) - Low(iSize) - 1)
        End
        Send Adjust_Logicals
        Get Value of hoOldFocus Item current to sInitialDate
        If (IsValidDateString(sInitialDate)) Begin
            Set pdSeedDate of oCalendar to sInitialDate
        End
        Forward Get msg_Add_Focus hoParent to iRetVal
        Procedure_Return iRetVal
    End_Procedure

    Procedure move_value_out
        Handle  hoOldFocus
        Get invoking_object_id to hoOldFocus
        If (hoOldFocus <> Desktop) Begin
            Set Value of hoOldFocus Item current to (SelectedDate(oCalendar(Self)))
            Set item_changed_state of hoOldFocus Item current to DFTRUE
        End
        Send Close_Panel
        Send Stop_UI
    End_Procedure

    Procedure Popup
        Forward Send Popup
        Start_UI
    End_Procedure

End_Object

//End of file/////////////////////////////////////////////////////////////////