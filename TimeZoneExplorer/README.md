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

* TimeZoneExplorer - iOS app for User front-end
* TZEAdmin - Mac app for use in various Admin tasks

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

