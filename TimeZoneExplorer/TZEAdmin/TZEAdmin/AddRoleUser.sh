#!/bin/bash

#  AddRoleUser.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Add user(s) to a _Role object's users: relation since Parse data browser cannot do this yet.

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Object ID of role to modify is placed in first argument
# Object ID of user to add is placed in second argument

# echo curl -X PUT
curl -X PUT \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-Master-Key: $PARSE_MASTER_KEY" \
-H "Content-Type: application/json" \
-d '{
"users": {
"__op": "AddRelation",
"objects": [
{
"__type": "Pointer",
"className": "_User",
"objectId": "'$2'"
}
]
}
}' \
https://api.parse.com/1/roles/$1
