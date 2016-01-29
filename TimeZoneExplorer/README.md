# TIME ZONE EXPLORER PROJECT

**Author**: Michael L. Mehr, AzuResults, LLC

**For**: Training project

**Project Start Date**: January 11, 2016

**Project Due Date**: January 25, 2016

**Document Revision**: 1.0

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

* TimeZoneExplorer - iOS app for user front-end
* NOTE: Administrator can use Parse.com as interface for most raw data management
* TZEAdmin - Mac app for ease of use in various Admin tasks not provided by Parse.com website or Administrator app views

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
* Manager - able to view, add, and delete Users, can also view, add, and delete data on behalf of those users
* Administrator - able to view, add, and delete Managers or Users, setup and change their relationships, and can also view, add, and delete all system data

## Capabilities

### User Role Capabilities
* Log in
* View owned list of time zones
* View details of selected time zone from list
* Add time zone of interest from master list to owned list
* Delete entry from owned list
* Log out

### Manager Role Capabilities
* Log in
* View list of Users
* View details of selected User from list
* Reset User password
* Add new User to system
* Delete User from system
* Log out

### Administrator Role Capabilities
* Log in
* Perform any task of User or Manager roles
* View list of Managers
* Edit Manager information
* Add new Manager(s) to system
* Delete Manager(s) from system
* View, update, and delete any data in the system
* Update master list of time zones if needed (batch operation)
* Log out

## User Application Screens

### Log In
* The user sees two fields for text entry, User and Password.
* The User field allows normal text entry.
* The Password field follows Apple standards and allows text entry in hidden form.
* A Log In button is provided, which will attempt to log the user into the back end.
* Any errors are displayed in a popup window (dismissed by an OK button).
* Successful login of User transfers to the main __Time Zone List__ view for the User.
* Successful login of Manager transfers to the main __User List__ view for the Manager.
* Successful login of Administrator transfers to the main __Manager List__ view for the Administrator.

Screen shot TBD.

### Time Zone List
* Screen is only accessible after login.
* The user can see their list of time zones that they currently are interested in.
* The user sees each time zone displayed with all data in Requirement 4 visible:
  * Area Name (Continent, Ocean)
  * City Name (may include Country)
  * Standard Time Offset from UTC
* Each time zone in the list can be individually selected for detailed display (transfer to __Time Zone Details__ view).
* An Add button is provided (transfer to __Add Time Zone__ view).
* An Edit button is provided. This will enable individual swipe/deletion of entries as per Apple standard.

Screen shot TBD.

### Time Zone Details
* Screen is only accessible from __Time Zone List__ view.
* The user sees the selected time zone displayed with all data in Requirement 5 visible:
  * Area Name (Continent, Ocean)
  * City Name (may include Country)
  * Standard Time Offset from UTC
  * Current time localized to the specified time zone
* A back button will return to the __Time Zone List__ main view.

Screen shot TBD.

### Add Time Zone
* Screen is only accessible from __Time Zone List__ view.
* The user is shown the master list of all time zones to choose from.
* Contents of each list entry will consist of the full name of the zone (Area/City).
* Touching the entry will select the specified time zone.
* The current selection is also displayed onview.
* A Save button is provided to add the selected time zone to the user's list.
* The Save button will be disabled when the selection is already in the user's list.
* Multiple selections can be Saved as needed.
* A back button will return to the __Time Zone List__ main view.
* A Search box is provided for name filtering (Requirement 6). Operation is according to Apple standards.

Screen shot TBD.

## Manager Application Screens

### User List (Manager Role)
* Screen is only accessible after Manager login.
* The Manager can see their list of Users.
* Each User in the list can be individually selected for information display (transfer to __User Details__ view).
* An Add button is provided (transfer to __Add User__ view).
* An Edit button is provided. This will enable individual swipe/deletion of entries as per Apple standard.

### User Details (Manager Role)
* Screen is only accessible after Manager login.
* A Password Reset button is provided to reset the User's password.
* All other User information is available for display and editing.
* A back button will return to the __User List__ main view.
* A toolbar button (User) is provided (transfer to __Time Zone List__ view for selected User).

## Administrator Application Screens

### Log In (same as for User)

### Manager List (Administrator Role)
* Screen is only accessible after Administrator login.
* The Administrator can see their list of Managers.
* Each Manager in the list can be individually selected for information display (transfer to __Manager Details__ view).
* An Add button is provided (transfer to __Add Manager__ view).
* An Edit button is provided. This will enable individual swipe/deletion of entries as per Apple standard.

### Manager Details (Administrator Role)
* Screen is only accessible after Administrator login.
* A Password Reset button is provided to reset the Manager's password.
* All other Manager information is available for display and editing.
* A back button will return to the __Manager List__ main view.
* A toolbar button (Manager) is provided (transfer to __User List__ view for selected Manager).


## SECURITY MODEL IN USE
As I currently understand it, the Parse model allows each data object to have its access controlled by a PFACL object.
This grants read or write permissions directly to Users by ID, or Roles by Name.

I have implemented three Role objects: 

* Users
* Managers and 
* Administrators.

They are set up in a hierarchy: 

Users --> Managers --> Administrators 

(the arrows follow the 'roles' child relation in Parse).

This allows whatever Users can do to be available to Managers as well, and what both can do available to Admins.

The role objects will be set up using shell scripts (curl and the REST API), since there are only three needed, with fixed 'roles' relations between them.
Their 'users' role (lists of users in each group) need to be managed dynamically.

I setup the ACL on the three Role objects as follows:

* Users role object - This has no public permissions (CLPs) but grants specific Read and Write to both Managers and Admins (the Admins is probably redundant).
* Managers role object - This has no public permissions, but grants Read access only to the Managers (*), and Read and Write access to the Admins.
* Administrators role object - This has no public permissions, but grants Read and Write access only to the Admins.

(*) I believe this is needed so that Managers can consult the users list role relation even though they will not be changing them. If this is wrong, it can be removed.

This setup has the interesting property that a user can query the roles object class, and depending on how many can be found, privileges can be granted:

1. A current user who is an Admin will be able to see all 3 role objects (Adm, Mgr, Usr)
2. A current user who is a Manager will only be able to see 2 role objects (Mgr, Usr)
3. A current user who is at the User level will not be able to see any role objects.

Thus by querying the _Role class and consulting the return count, we know what role the current user has been authenticated at.
This has been tested using the shell scripts.

For this to work properly to allow proper CRUD access to User objects for Managers, I believe the ACL's have to be modified.

By default, Parse grants an ACL with Read/Write for the current (authenticated) user, and Public Read access for all users, to all data objects (including _User).

My modified access lists will be:

* For our basic data in MyTimeZones, this can be augmented with Read/Write access to Managers (and thus Admins). We do NOT grant access to other users via the Users role.
* For the _User class, we need to add role access (R/W) to Managers as well (and thus Admins) as they are created.
* ACLs for the _Role class have already been discussed.
* The TimeZones class (for the public master list) must be protected from changes, but readable by all, and writeable by the Admins.

[ This could be granted by adding the Admins role R/W to the objects as they are uploaded by the admin script (to >400 objects).
But I believe it's easier to add a CLP for Write to the Admins. I have done this manually, and it needs to be tested. For deployment, I need to look at this a bit further (probably another script).]

For marking individual entries and filtering if not owned by a Manager or Admin (for data access), we can consult the individual ACL's and check if there is Write access to the current Role.

Objects won't even appear in the list unless they have Read access, and editing is prevented if Write access is denied. But still, for systemwide management, further functions would be useful.

### UPDATED NOTE ON SECURITY:

I have discovered entries on the Parse blog that indicate that Parse has specifically disallowed any manipulation of User object permissions (such as making them editable by Managers) in the
app API interface. They say that the Master Key allows permissions (via the Browser or REST API). So my plans for an app User Management screen probably need to be adjusted or scrapped.

[Here](http://blog.parse.com/learn/engineering/parse-security-iii-are-you-on-the-list/) is the link with relevant description of the problem. 

## REST API

The folllowing functions have been identified as being important for the REST API.
They have been designed (and documented) as functions executed by the TZEAdmin tool.
However, they can also be implemented by shell scripts, and this may prove to be more expedient for the time frame. The admin tool can be expanded later, especially for batch operations.

SESSIONS (for all)

* SIGNUP - Create a new user (takes -n Name -p Password, returns SessionID,UserID)
* LOGIN - Login specified user (takes -n Name -p Password, returns SessionID,UserID)
* LOGOUT - Logout current user session (takes -i SessionID)

DATA (for all)

* GETZONELIST - Get specified user's time zone list (takes -u UserID, returns List[ZoneName])
* ADDTOZONELIST - Adds an entry to specified user's time zone list (takes -u UserID -n ZoneName)
* DELETEFROMZONELIST - Deletes an entry from specified user's time zone list (takes -u UserID -n ZoneName)
* GETMASTERTZLIST - Get the master list of time zone names (returns List[ZoneName])

USERS (for MgrID,AdminID only)

* GETUSERLIST - Get specified mgr's user list (takes -m MgrID, returns List[UserName])
* GETUSERDATA - Get specified user's object data (takes -m MgrID, returns Obj[UserData])
* CREATEUSER - Create a new user w/o login (takes -m MgrID -n Name -p Password [-e email][-P phone], returns UserID)
* UPDATEUSER - Update user data (takes -m MgrID -u UserID [-n Name][-p Password][-e email][-P phone])
* DELETEUSER - Delete user from system (takes -m MgrID -n Name)

ROLES (for AdminID only)

* GETROLELIST - Get security role list (takes -a AdminID, returns List[RoleName])
* CREATEROLE - Create a new security role (takes -a AdminID -n RoleName, returns RoleID)
* DELETEROLE - Delete role from system (takes -a AdminID -n RoleName)
* GETUSERROLE - Get RoleName of specified user (takes -a AdminID [-u UserID | -U UserName], returns RoleName)
* SETUSERROLE - Sets RoleName of specified user (takes -a AdminID [-u UserID | -U UserName] -n RoleName)
* GETROLEUSERS - Get list of user names with given role (takes -a AdminID -n RoleName, returns List[UserName])

MISC

* GENMASTERTZLIST - Generate the master time zone list data in CSV format (takes -a AdminID)
* SETMASTERTZLIST - Set the master list of time zone names (takes -a AdminID -D CSV-Data-File-Path)


## Requirements Testing

I have implemented various shell scripts to supplement the command line tool. These turn out will be invaluable in getting things up and running in time.

  __NOTE:__ Currently the Parse.com data browser does NOT have the ability to change relations, just view them. This seems to have been an anticipated feature for over 3 years now.

* ```Login.sh username password``` - Implements logging in a single user, returning a session token
* ```Logout.sh``` - Logs out the current user session, specified in the $PARSE_SESSION_TOKEN environment variable (manually set for now).
* ```AddRoleRelations.sh targetRoleID addedRoleID``` - Adds an object to the 'roles' relation on the Parse _Role object whose ID is given (cannot be done on Parse.com data browser currently).
* ```AddRoleUser.sh targetRoleID addedUserID``` - Adds an object to the 'users' relation on the Parse _Role object whose ID is given (cannot be done on Parse.com data browser currently).
* ```RemoveRoleUser.sh targetRoleID removedUserID``` - Removes an object from the 'users' relation on the Parse _Role object whose ID is given (cannot be done on Parse.com data browser currently).
* ```QuerySession.sh ...``` - Allows the user to query the REST API for class object lists (all GET-accessible objects). This is the preferred, authenticated version, using $PARSE_SESSION_TOKEN.
* ```QueryClass.sh``` (deprecated) - Allows the user to query the REST API for class object lists. This is the unauthenticated version and differs slightly from the above in usage.

Further documentation can be found in the script source code.
If this is an incomplete list, it at least shows how the rest should be done, as documented by Parse's own REST API.


