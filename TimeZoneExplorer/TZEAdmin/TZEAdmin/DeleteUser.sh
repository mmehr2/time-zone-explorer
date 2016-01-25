#!/bin/bash

#  DeleteUser.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Delete authenticated user within a valid login session.

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Valid session token (returned by login or signup) must be in $PARSE_SESSION_TOKEN.
# Parameter is Object ID for the _User object to be deleted.

# Turns out that no _Role:users management is needed; the links are autodeleted.

# Output is pretty-printed with Python -m json.tool.

# echo curl -X DELETE
curl -X DELETE \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-REST-API-Key: $PARSE_RESTAPI_KEY" \
-H "X-Parse-Session-Token: $PARSE_SESSION_TOKEN" \
https://api.parse.com/1/users/$1 | python -m json.tool

# This also logs out the session token, which is no longer valid after the operation above.
unset PARSE_SESSION_TOKEN
