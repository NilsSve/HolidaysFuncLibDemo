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
