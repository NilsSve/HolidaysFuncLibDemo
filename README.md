# Demo for 'Library-HolidaysFuncLib'

The `oCalendarHolidays.pkg` contains essential functions for managing holiday dates. For detailed information on how this function library operates, please refer to the documentation located at the top of `cCalendarHolidays.pkg`.

To see the 'Holiday Functions Library' in action, run the sample program `HolidaysFuncLibTest`. In the 'Dates Functions Test' tab, you will find a grid displaying built-in 'Holidays and Other Important Dates.' Enter a year in the lower section and click the 'Call Function' button to find out the date of a holiday or special day. You can also enter an ISO-2 character country code in the 'Enter Value 2:' field to view the name of the holiday or special day at the bottom of the screen. Please note that a limited number of 'National Holiday' packages are currently available, which are listed in the grid in the lower-left corner.

If your country is not included in the grid, creating a new one is quite simple! Just refer to the examples in `CountryPackages.pkg` for guidance on how to do this.

In the 'Calendar Test' tab, you can see an example of how to create your own calendar that includes the names of holidays and special days. Additionally, there is a sample of a generalized lookup list for holidays. Click the 'Test Holiday Lookup List' button to see how this feature can be used to retrieve any selection of holidays.

The 'Working Days Test' tab (View > Working Days) shows the working-day functions of HolidaysFuncLib 1.0.4: `IsWorkingDay`, `AddWorkingDays` and `WorkingDaysBetween`. On the left are the library's settings - the country, the UK region (`piHolidayRegion`), the days off every week (`psWeekendMask`) and the company's closure days (`padClosedDays`). On the right, each function has a group of its own, and the answer says why a day is not a working day: a weekend day, an official holiday (named), or a closure day. The grid at the bottom lists every day between the two dates and how it was counted. It opens on Christmas 2026 in the UK, where the Boxing Day bank holiday moves to Monday 28 December.

The 'Year Overview' tab (View > Year Overview) shows a country's whole year, month by month: each day marked as a weekend day, a day off for an official holiday, a special day or a closure day, the working days of each month and of the year, and the list of the year's holidays and special days. Click a country or a year to change it. It is a FlexTron page, built with the [RDCFlexTron](https://github.com/NilsSve/Library-RDCFlexTron) library, and it follows the settings of the Working Days view. The About dialog (Help > About) is RDCFlexTron's too.

The demo needs DataFlex 26: open `HolidaysFuncLibDemo.sws`. The library itself works with DataFlex 24, 25 and 26.

In addition to the `oCalendarHolidays` package, there are specific 'National Holidays Date Functions' tailored to individual countries. Each country package will at least return holiday names as strings.

You can find a collection of country-specific libraries in `CountryPackages.pkg`. Use these files as templates to develop your own holiday packages for specific countries.

The workspace also includes a database and a view displaying facts about nations around the world, which is independent of the calendar holiday packages mentioned above.

![The Year Overview of the United States in 2026, in the dark theme, with Independence Day clicked](Bitmaps/HolidaysFuncLibTest.png)

## Setup after cloning

The demo needs **DataFlex 26**. The libraries it uses - HolidaysFuncLib, RDCToolsLib, DFAbout, vWin32fh,
RDCFlexTron and Data Access's Web UI FlexTron - are **not** stored in this repository: `HolidaysFuncLibDemo.sws`
names them as dependencies, and DataFlex's package manager installs them into `DfPkg\` (and their web files into
`AppHtml\` and `Bitmaps\`). Run **`setup.bat`** once from the repository root: it runs `df-cli config` to install
them, and `skip-local-data.cmd`, so your local `Data\` database changes stay on your machine. Re-run it after a pull
that moves a library version.

Then open `HolidaysFuncLibDemo.sws` in DataFlex Studio 26, and compile and run `HolidaysFuncLibTest.src`.

