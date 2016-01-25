#!/bin/sh

#  QuerySession.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Convenience function to query any object contents within a valid login session.

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Valid session token (returned by login or signup) must be in $PARSE_SESSION_TOKEN.
# Parameter is any parse REST API that uses the GET verb (starting after the '/1/').

# Output is pretty-printed with Python -m json.tool.

# echo curl -X GET
curl -X GET \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-REST-API-Key: $PARSE_RESTAPI_KEY" \
-H "X-Parse-Session-Token: $PARSE_SESSION_TOKEN" \
https://api.parse.com/1/$1 | python -m json.tool
