// * Note: By default the year 1752 (Britain/US) has been selected as the first Gregorian year
// for the Easter algorithm.
// If you have the need to calculate Easter dates before the year 1928 (Egypt), you may
// need to replace the default first Gregorian year - depending on where in the world
// the calculation should take place - with a year from the list above.
Define C_FirstGregorianYear for 1752 

Struct tLunar
    Integer iYear
    Integer iMonth
    Integer iDay
    Boolean bLeap
End_Struct

Struct tHoliday
    Date    dDate
    Boolean bNationalHoliday
    String  sHolidayName
End_Struct  

Struct tHolidayFuncVar
    String sType
    String sVarName
End_Struct

Struct tHolidayFunc
    String sName
    String sHelp
    tHolidayFuncVar[] HolidayFuncVarArray
    String sReturnType
End_Struct

#IFNDEF _struct_tSystemTimeType
Struct tSystemTimeType
    Short wYear
    Short wMonth
    Short wDayOfWeek
    Short wDay
    Short wHour
    Short wMinute
    Short wSecond
    Short wMilliseconds
End_Struct
#ENDIF

#IFNDEF LOCALE_SYSTEM_DEFAULT
    Define LOCALE_SYSTEM_DEFAULT  for |CI$800
#ENDIF
#IFNDEF LOCALE_USER_DEFAULT
    Define LOCALE_USER_DEFAULT    for |CI$400    
#ENDIF

#IFNDEF get_WindowsAPI_GetDateFormat
    External_Function WindowsAPI_GetDateFormat "GetDateFormatA" Kernel32.dll ;
        Integer iLocale ;
        Integer idwFlags ;
        Pointer lpDate ; 
        String  sFormat ;
        Pointer psDateStr ;
        Integer iSizeBuffer ;
        Returns Integer
#ENDIF

#IFNDEF get_WindowsAPI_GetDateFormatW
    External_Function WindowsAPI_GetDateFormatW "GetDateFormatW" Kernel32.Dll ;
        UInteger LCID ;
        UInteger dwFlags ;
        Pointer lpsSystemTime ;
        Pointer lpFormat ;
        Pointer lpDateStr ;
        Integer cchDate ;
        Returns Integer
#ENDIF

#IFNDEF get_WindowsAPI_GetDateFormatEx
External_Function WindowsAPI_GetDateFormatEx "GetDateFormatEx" Kernel32.Dll ;
    Pointer lpLocaleName ;
    UInteger dwFlags ;
    Pointer lpsSystemTime ;
    Pointer lpFormat ;
    Pointer lpDateStr ;
    Integer cchDate ;
    Pointer lpCalendar ;
    Returns Integer
#ENDIF

#IFNDEF get_WindowsAPI_GetTimeFormat
    External_Function WindowsAPI_GetTimeFormat "GetTimeFormatA" Kernel32.dll ;
    	 Integer iLocale ;
    	 Integer idwFlags ;
    	 Pointer lpTime ;
    	 String  sFormat ;
    	 Pointer psTimeStr ;
    	 Integer iSizeBuffer ;
    	 Returns Integer 
#ENDIF

#IFNDEF get_WinAPI_GetLocaleInfoEx
External_Function WinAPI_GetLocaleInfoEx "GetLocaleInfoEx" Kernel32.dll ;
    Pointer lpLocaleName ;
    UInteger LCTYPE ;
    Pointer lpLCDATA ;
    Integer cchData ;
    Returns Integer
#ENDIF

#IFNDEF get_GetLocaleInfo
External_Function GetLocaleInfo "GetLocaleInfoA" Kernel32.dll ;
   DWord LCID DWord LCTYPE Pointer lpLCDATA Integer cchData Returns Integer
#ENDIF

#IFNDEF ghoNationalHolidayObject
    Global_Variable Integer ghoNationalHolidayObject
    Move 0 to ghoNationalHolidayObject
#ENDIF

// After the class (end of package) an object of the class cDateFunctions sets
// the ghoDateFunctions to Self.
#IFNDEF ghoCalendarHolidays
    Global_Variable Integer ghoCalendarHolidays
    Move 0 to ghoCalendarHolidays
#ENDIF

#IFNDEF LOCALE_SISO639LANGNAME
    Define LOCALE_SISO639LANGNAME    for |CI$00000059 // 2-character abbreviated country name
    Define LOCALE_SABBREVCTRYNAME    for |CI$00000007 // 3-character abbreviated country name
    Define LOCALE_SMONTHNAME1        for |CI$00000038 // Long name for January
    Define LOCALE_SMONTHNAME2        for |CI$00000039 // Long name for February
    Define LOCALE_SMONTHNAME3        for |CI$0000003A // Long name for March
    Define LOCALE_SMONTHNAME4        for |CI$0000003B // Long name for April
    Define LOCALE_SMONTHNAME5        for |CI$0000003C // Long name for May
    Define LOCALE_SMONTHNAME6        for |CI$0000003D // Long name for June
    Define LOCALE_SMONTHNAME7        for |CI$0000003E // Long name for July
    Define LOCALE_SMONTHNAME8        for |CI$0000003F // Long name for August
    Define LOCALE_SMONTHNAME9        for |CI$00000040 // Long name for September
    Define LOCALE_SMONTHNAME10       for |CI$00000041 // Long name for October
    Define LOCALE_SMONTHNAME11       for |CI$00000042 // Long name for November
    Define LOCALE_SMONTHNAME12       for |CI$00000043 // Long name for December
    Define LOCALE_SMONTHNAME13       for |CI$0000100E // Long name for 13th month (If exists)
    Define LOCALE_SABBREVMONTHNAME1  for |CI$00000044 // Abbreviated name for January
    Define LOCALE_SABBREVMONTHNAME2  for |CI$00000045 // Abbreviated name for February
    Define LOCALE_SABBREVMONTHNAME3  for |CI$00000046 // Abbreviated name for March
    Define LOCALE_SABBREVMONTHNAME4  for |CI$00000047 // Abbreviated name for April
    Define LOCALE_SABBREVMONTHNAME5  for |CI$00000048 // Abbreviated name for May
    Define LOCALE_SABBREVMONTHNAME6  for |CI$00000049 // Abbreviated name for June
    Define LOCALE_SABBREVMONTHNAME7  for |CI$0000004A // Abbreviated name for July
    Define LOCALE_SABBREVMONTHNAME8  for |CI$0000004B // Abbreviated name for August
    Define LOCALE_SABBREVMONTHNAME9  for |CI$0000004C // Abbreviated name for September
    Define LOCALE_SABBREVMONTHNAME10 for |CI$0000004D // Abbreviated name for October
    Define LOCALE_SABBREVMONTHNAME11 for |CI$0000004E // Abbreviated name for November
    Define LOCALE_SABBREVMONTHNAME12 for |CI$0000004F // Abbreviated name for December
    Define LOCALE_SABBREVMONTHNAME13 for |CI$0000100F // Abbreviated name for 13th month (If exists)
    
    Define LOCALE_IFIRSTDAYOFWEEK    for |CI$0000100C
    Define LOCALE_SDAYNAME1          for |CI$0000002A // Native long name for Monday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SDAYNAME2          for |CI$0000002B // Native long name for Tuesday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SDAYNAME3          for |CI$0000002C // Native long name for Wednesday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SDAYNAME4          for |CI$0000002D // Native long name for Thursday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SDAYNAME5          for |CI$0000002E // Native long name for Friday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SDAYNAME6          for |CI$0000002F // Native long name for Saturday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SDAYNAME7          for |CI$00000030 // Native long name for Sunday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME1    for |CI$00000031 // Native abbreviated name for Monday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME2    for |CI$00000032 // Native abbreviated name for Tuesday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME3    for |CI$00000033 // Native abbreviated name for Wednesday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME4    for |CI$00000034 // Native abbreviated name for Thursday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME5    for |CI$00000035 // Native abbreviated name for Friday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME6    for |CI$00000036 // Native abbreviated name for Saturday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
    Define LOCALE_SABBREVDAYNAME7    for |CI$00000037 // Native abbreviated name for Sunday. The maximum Number of characters allowed for this String is 80, including a terminating null character.
#ENDIF
