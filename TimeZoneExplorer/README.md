# TIME ZONE EXPLORER PROJECT

**Author**: Michael L. Mehr, AzuResults, LLC

**For**: Toptal review

**Project Start Date**: January 11, 2016

**Project Due Date**: January 25, 2016

## Project Requirements
Write an application that shows time in different timezones

1. User must be able to create an account and log in
* When logged in, user can see, edit and delete timezones he entered
* Implement at least two roles with different permission levels (ie: a regular user would only be able to CRUD on his owned records, a user manager would be able to CRUD users, an admin would be able to CRUD on all records and users, etc.)
* When a timezone is entered, each entry has a Name, Name of city in timezone, difference to GMT time
* When displayed, each entry has also current time
* Filter by names
* REST API. Make it possible to perform all user actions via the API, including authentication (If a mobile application and you don’t know how to create your own backend you can use Parse.com, Firebase.com or similar services to create the API).
* All actions need to be done client side using AJAX, refreshing the page is not acceptable. (If a mobile app, disregard this)
* In any case you should be able to explain how a REST API works and demonstrate that by creating functional tests that use the REST Layer directly.
* Bonus: unit and e2e tests!
* You will not be marked on graphic design, however, do try to keep it as tidy as possible.

## Components

* TimeZoneExplorer - iOS app for User Role front-end
* TimeZoneUserManager - iOS app for Manager Role front-end
* NOTE: Administrator will use Parse.com as main interface for most data management
* (OPTIONAL) TimeZoneAdministrator - iOS app for Administrator Role front-end (almost same as UserManager app, maybe combine)
* TZEAdmin - Mac app for use in various Admin tasks not provided by Parse.com website or Administrator app

## Approach

I have evaluated several approaches to the problem, and given the short time frame and my skill set and lack of familiarity with the pure website approach using PHP or a framework such as Laravel, I've decided to use a mobile app as a front-end and implement the back-end using Parse.com as the server.

Since there is a requirement for a REST API, I propose to use the REST API provided by Parse, supplemented by anything needed on my end to make this easy for the client.
Since this is my first experience with using Parse, I will be familiarizing myself with their usage patterns and requirements as I proceed.

## Basic Design Trade-offs

### Standard vs. Daylight Savings time

Time zone data is fixed, a list of about 400 names standardized by IANA. Read up on it [here](https://en.wikipedia.org/wiki/Tz_database).
The requirements talk about only a single UTC offset value, however as stated on Wikipedia above, most zones define both standard and daylight savings time offsets. When each zone applies is a political artifact, and also based on the location hemisphere (January is in summer in Australia, but winter in the US.)

The initial version of the project will display only Standard time offsets, but the client can choose to have Daylight time added later as an option. The display of current time will take this hidden data into account, however.

(For some of the problems in interpreting this data and DST (and a good laugh), check out this [article](http://blog.jonudell.net/2009/10/23/a-literary-appreciation-of-the-olsonzoneinfotz-database/).)

### Use of Apple Data

One list of timezones is [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
However, this includes any entry that is valid on the TZ environment variable under Unix/Linux/OSX. It seems to be a superset, since it contains common abbreviations like CST and Etc/GMT as well.

Due to the current design using Apple technologies, we will start by using the data that comes from Apple. They list all of the continents and oceans, but only have one abbreviation ("GMT") and none of the Etc group. I have an Admin task in the TZEAdmin tool to generate this data. Later on, if the client wishes, the tool could be modified to generate the full set of IDs from the IANA database.

## Security Roles
* User - able to view, add, and delete TimeZones from their own managed list
* Manager - able to view, add, and delete Users
* Administrator - able to view, add, and delete Managers or Users, can also view, add, and delete all system data

## Processes and Tasks

### User Role Tasks
* Log in
* View owned list of time zones
* Add time zone of interest from master list to owned list
* Delete entry from owned list
* Log out

### Manager Role Tasks
* Log in
* View list of Users
* Reset User password
* Add new User to system
* Delete User from system
* Log out

### Administrator Role Tasks
* Log in
* View list of Managers
* Edit Manager information
* Add new Manager(s) to system
* Delete Manager(s) from system
* View, update, and delete any data in the system
* Update master list of time zones as needed
* Log out

## User Application Screens

### Log In
* The user sees two fields for text entry, User and Password.
* The User field allows normal text entry.
* The Password field follows Apple standards and allows text entry in hidden form (each character entered displays normally for a second and then is hidden behind a place-holder dot).
* A Log In button is provided, which will attempt to log the user into the back end.
* Any errors are displayed in a popup window (dismissed by an OK button).
* Successful login transfers to the main __Time Zone List__ screen for the user.

Screen shot TBD.

### Time Zone List
* Screen is only accessible after login.
* The user can see their list of time zones that they currently are interested in.
* The user sees each time zone displayed with all data in Requirement 4 visible:
  * Area Name (Continent, Ocean)
  * City Name (may include Country)
  * Standard Time Offset from UTC
* Each time zone in the list can be individually selected for detailed display (transfer to __Time Zone Details__ screen).
* An Add button is provided (transfer to __Add Time Zone__ screen).
* An Edit button is provided. This will enable individual swipe/deletion of entries as per Apple standard.

Screen shot TBD.

### Time Zone Details
* Screen is only accessible from __Time Zone List__ screen.
* The user sees the selected time zone displayed with all data in Requirement 5 visible:
  * Area Name (Continent, Ocean)
  * City Name (may include Country)
  * Standard Time Offset from UTC
  * Current time localized to the specified time zone
* A back button will return to the __Time Zone List__ main screen.

Screen shot TBD.

### Add Time Zone
* Screen is only accessible from __Time Zone List__ screen.
* The user is shown the master list of all time zones to choose from.
* Contents of each list entry will consist of the full name of the zone (Area/City).
* Touching the entry will select the specified time zone.
* The current selection is also displayed onscreen.
* A Save button is provided to add the selected time zone to the user's list.
* The Save button will be disabled when the selection is already in the user's list.
* Multiple selections can be Saved as needed.
* A back button will return to the __Time Zone List__ main screen.

Screen shot TBD.

## Manager Application Screens

### Log In (same as for User)

### User List (Manager Role)
* Screen is only accessible after Manager login.
* The Manager can see their list of Users.
* Each User in the list can be individually selected for information display (transfer to __User Details__ screen).
* An Add button is provided (transfer to __Add User__ screen).
* An Edit button is provided. This will enable individual swipe/deletion of entries as per Apple standard.

### User Details (Manager Role)
* Screen is only accessible after Manager login.
* A Password Reset button is provided to reset the User's password.
* All other User information is available for display and editing.
* A back button will return to the __User List__ main screen.

## Administrator Application Screens

### Log In (same as for User)

### Manager List (Administrator Role)
* Screen is only accessible after Administrator login.
* The Administrator can see their list of Managers.
* Each Manager in the list can be individually selected for information display (transfer to __Manager Details__ screen).
* An Add button is provided (transfer to __Add Manager__ screen).
* An Edit button is provided. This will enable individual swipe/deletion of entries as per Apple standard.

### Manager Details (Administrator Role)
* Screen is only accessible after Administrator login.
* A Password Reset button is provided to reset the Manager's password.
* All other Manager information is available for display and editing.
* A back button will return to the __Manager List__ main screen.


## REST API

## Requirements Testing

### User Interface Testing

### REST API Testing

