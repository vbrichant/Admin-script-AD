# Author : Vincent Brichant
# Version : 1.0
#
# Description : This script automatically enable or disable users based on the information present in the provided csv file
#
# Prerequisite : The following script should
#                   - Be run on a domain joined windows machine
#                   - Be run as a user with user creation privilegies over the domain
#
# Input : The script must be called with the path tho a CSV document containing the following collumn
#           - UserName  :   The AD username(String)
#           - Enable  :   'True' or 'False(String)

# Import Active Directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from your file in the $users variable
$users = Import-csv $args[0]

#Loop through each row containing user details in the CSV file
foreach ($user in $users) {

    #Read user data from each field in each row and assign the data to a variable as below
    $uname = $user.Username

    #Check if data is correct in CSV for parameter Enable. If data is correct assign value to the variable enable
    if ($user.Enable -eq "True"){
        $enable = $True
    }

    elseif ($user.Enable -eq "False"){
        $enable = $false
    }

    # If data is not correct, raise warning
    else {
        Write-Warning "Data 'enable' incorect for user $uname, use 'True' or 'False' insted"
    }

    #Check to see if the user already exists in the AD, if not raise warning
    if (!(Get-ADUser -F { SamAccountName -eq $uname })) {
        Write-Warning "Any user account with uname $uname exists in Active Directory."
    }

    #Else, change the state of the user in the AD
    else {
        $UserAD = Get-ADUser -Identity $uname -Properties enabled
        $UserAD.enabled  = $enable
        Set-ADUser -Instance $UserAD
        Write-Output "The user account with uname $uname has now Enable=$enable."
    }
}