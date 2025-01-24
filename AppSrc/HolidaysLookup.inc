//****************************************************************************
// $Module type: Include File
// $Module name: HolidaysLookup.inc
// $Author     : Nils Svedmyr
// Created     : 2025-01-24 @ 16:23
//
// $Rev History:
//    2025-01-24 Module header created
//
//****************************************************************************
Use Windows.pkg
Use Dfspnfrm.pkg
Use cRDCModalPanel.pkg
Use cRDCCJGridPromptList.pkg
Use CountryPackages.pkg
Use LanguageText.pkg

// English
#IFSame Language$Current = Language$English
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Dutch
#IFSame Language$Current = Language$Nederlands
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Swedish
#IFSame Language$Current = Language$Svenska
    Define CS_LookupHeader for "Välj en eller flera helgdagar"
    Define CS_SpinFormLabel for "Visa helgdagar för år"
    Define CS_WeekDateCaption for "Datum"
    Define CS_NameCaption for "Namn"
    Define CS_WeekDayNameCaption for "Veckodag"
    Define CS_HolidayNameCaption for "Helgdag"
    Define CS_HolidayNameTooltip for "Nationell helgdag"
    Define CS_WeekNumberCaption for "Veckonr"
    Define CS_DayNumberCaption for "Dagnr"
    Define CS_SpinformInfoText     for "Spinn knapparna upp och ned för att byta till ett annat år"
    Define CS_ShortCutKeysInfoText for "Tryck på Ctrl+A för att markera alla datum - eller klicka med musen och Ctrl/Shift tangenterna."
    Define CS_OkButtonCaption for "Ok"
    Define CS_CancelButtonCaption for "Avbryt"
#ENDIF

// German
#IFSame Language$Current = Language$Deutsch
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Danish
#IFSame Language$Current = Language$Dansk
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Portugues
#IFSame Language$Current = Language$Portugues
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// French
#IFSame Language$Current = Language$Francais
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Italic
#IFSame Language$Current = Language$Italiano
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Spanish
#IFSame Language$Current = Language$Espanol
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Norwegian
#IFSame Language$Current = Language$Norsk
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Russian
#IFSame Language$Current = Language$Russian
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Polish
#IFSame Language$Current = Language$Polish
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF

// Hungarian
#IFSame Language$Current = Language$Hungarian
    Define CS_LookupHeader           for "Select one or more holiday date(s)"
    Define CS_WeekDateCaption        for "Date"
    Define CS_SpinFormLabel          for "Show holidays for year"
    Define CS_NameCaption            for "Name"
    Define CS_WeekDayNameCaption     for "Weekday"
    Define CS_HolidayNameCaption     for "Holiday"
    Define CS_HolidayNameTooltip     for "National holiday"
    Define CS_WeekNumberCaption      for "Week No"
    Define CS_DayNumberCaption       for "Day No"
    Define CS_SpinformInfoText       for "Spin the form to show holidays for a different year"
    Define CS_ShortCutKeysInfoText   for "Press Ctrl+A to mark all dates. Or use the mouse and Ctrl/Shift keys to select."
    Define CS_OkButtonCaption        for C_$OK
    Define CS_CancelButtonCaption    for C_$Cancel
#ENDIF
