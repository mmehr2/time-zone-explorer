#!/bin/bash

#  AddRoleRelations.sh
#  TZEAdmin
#
#  Created by Michael L Mehr on 1/24/16.
#  Copyright © 2016 Michael L. Mehr. All rights reserved.

# Add relations among the three role objects (class _Role) since Parse data browser cannot do this yet.

# App ID is placed in $PARSE_APP_ID
# Access key is placed in $PARSE_MASTER_KEY
# Object ID of role to modify is placed in first argument
# Object ID of role to add is placed in second argument

# echo curl -X PUT
curl -X PUT \
-H "X-Parse-Application-Id: $PARSE_APP_ID" \
-H "X-Parse-Master-Key: $PARSE_MASTER_KEY" \
-H "Content-Type: application/json" \
-d '{
"roles": {
"__op": "AddRelation",
"objects": [
{
"__type": "Pointer",
"className": "_Role",
"objectId": "'$2'"
}
]
}
}' \
https://api.parse.com/1/roles/$1
