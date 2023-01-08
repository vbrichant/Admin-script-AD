# Author : Vincent Brichant
# Version : 1.0
#
# Description : This script automatically update users based on the information present in the provided csv file
#
# Prerequisite : The following script should
#                   - Be run on a domain joined windows machine
#                   - Be run as a user with user creation privilegies over the domain
#
# Input : The script must be called with the path tho a CSV document containing the following collumn
#           - UserName  :   The AD username(String)
#           - Departement  : The name of the new departement(String)
#           - Description  :  The new description(String)

# Import Active Directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from your file in the $users variable
$users = Import-csv $args[0]

#Loop through each row containing user details in the CSV file
foreach ($user in $users) {
    Write-Output $user
    #Read user data from each field in each row and assign the data to a variable as below
    $uname = $user.Username
    $newDepartment = $user.Departement
    $newDescription = $user.Description

    #Check to see if the user already exists in the AD, if not raise warning
    if (!(Get-ADUser -F { SamAccountName -eq $uname })) {
        Write-Warning "Any user account with uname $uname exists in Active Directory."
    }
    #  if user exist, update the user
    else {
        $UserAD = Get-ADUser -Identity $uname -Properties department,description
        $UserAD.description = $newDescription
        $UserAD.department = $newDepartment
        Set-ADUser -Instance $UserAD
    }
}