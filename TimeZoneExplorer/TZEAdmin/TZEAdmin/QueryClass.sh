#!/bin/bash

#  QueryClass.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Convenience function to query a class or object's contents.
# (This is an unauthenticated query, so it should only work on the TimeZones class.)

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Name of class to query is placed in first argument
# You can also pass <classname>/<objectID> to query a particular object of the class.

# Output is pretty-printed with Python -m json.tool.

# echo curl -X GET
curl -X GET \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-REST-API-Key: $PARSE_RESTAPI_KEY" \
https://api.parse.com/1/classes/$1 | python -m json.tool
