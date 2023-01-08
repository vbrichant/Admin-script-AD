# Author : Vincent Brichant
# Version : 1.0
#
# Description : This script automatically unlock the user given in args
#
# Prerequisite : The following script should
#                   - Be run on a domain joined windows machine
#                   - Be run as a user with user creation privilegies over the domain
#
# Input : The AD username of the user locked
# Import Active Directory module for running AD cmdlets
Import-Module activedirectory

# Store the username from args to a variable
$username = $args[0]

#Check if user not exist in the AD
if (!(Get-ADUser -Identity $username)){
    Write-Warning "Any user with the username '$username' exist in AD"
}
# If exist, unlock the user
else {
   Get-ADUser -Identity $username | Unlock-ADAccount
}