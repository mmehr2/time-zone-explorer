#!/bin/bash

#  Logout.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Log out the currently logged in user.

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Valid session token (returned by login or signup) must be in $PARSE_SESSION_TOKEN.
# The token is removed once logout is completed (no check for failure).

# This also logs out the session token, which is no longer valid after the operation.

# echo curl -X POST
curl -X POST \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-REST-API-Key: $PARSE_RESTAPI_KEY" \
-H "X-Parse-Session-Token: $PARSE_SESSION_TOKEN" \
https://api.parse.com/1/logout
unset PARSE_SESSION_TOKEN
