# Export Matching group for users

#### This script will check the users supplied are part of a specific group
#### The group comparision works on regex match, no need to supply the entire group name, you can also export list in file and provide multiple users

### Usage
``` PowerShell

usergroup.ps1 -users "userid" -group "groupname"
usergroup.ps1 -users "user1,user2,user3" -group "groupname"
usergroup.ps1 -users "user1,user2,user3" -group "groupname" -OutPutfile -filename filepath.csv

```
