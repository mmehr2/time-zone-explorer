#!/bin/bash

#  Login.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Log in the specified user.

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Username is placed in first argument, password in the 2nd.

# echo curl -X GET
curl -X GET \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-REST-API-Key: $PARSE_RESTAPI_KEY" \
-G \
--data-urlencode 'username='$1'' \
--data-urlencode 'password='$2'' \
https://api.parse.com/1/login | python -m json.tool
