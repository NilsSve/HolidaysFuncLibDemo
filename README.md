# Demo for 'Library-HolidaysFuncLib'

The `oCalendarHolidays.pkg` contains all the basic holiday date functions. See the documentation near the top of cCalendarHolidays.pkg for details on how the function library works.

Run the sample program `HolidaysFuncLibTest` to see the 'Holiday Functions Library' in action. The 'Dates Functions Test' tab-page shows a grid with build-in 'Holidays and Other Important Dates'. Enter a year in the lower part and press the 'Call Function' button to see the date the holiday/special day falls on. Enter an ISO-2 character country code in 'Enter Value 2:' to see the name of the holiday/special day at the bottom of the view. Note that only a few 'National Holiday' packages are available at current. Those countries can be seen in the grid at the lower-left of the view.

Note: If your country is missing from the lower-left grid, it is really simple to create one! Just see the examples in 'CountryPackages.pkg' on how to do it.

On the 'Calendar Test' tab-page is a sample on making your own calendar inclusive holiday/special day names. There is also a sample of a generalized lookup list for holidays. Click the 'Test Holiday Lookup List' button to see how it can be used to return any selection of holidays.

In addition to the `oCalendarHolidays` package, there are also specific 'National Holidays Date Functions' that is streamlined for each individual country. At a bare minimum such a country packge returns holiday names as a string.

See the collection of country-specific libraries in `CountryPackages.pkg`. Use these files as templates for developing your own country-specific holiday package.

The workspace also contains a database and a view for showing Nations of the World, providing all kinds of facts about all nations. This part is independent of the calendar holidays packages above.

![Sample of how the HolidaysFuncLib.src program looks like:](Bitmaps/HolidaysFuncLibTest.png)

