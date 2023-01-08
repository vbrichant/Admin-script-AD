# Author : Vincent Brichant
# Version : 1.0
#
# Description : This script automatically create users based on the information present in the provided csv file
#
# Prerequisite : The following script should
#                   - Be run on a domain joined windows machine
#                   - Be run as a user with user creation privilegies over the domain
#
# Input : The script must be called with the path tho a CSV document containing the following collumn
#           - UserName  :   The AD username
#           - ID  :   The emplyee id of the person linked to the user
#           - Psw  :   The passowrd for the user
#           - FirstName :   The first name of the person linked to the user
#           - LastName  :   The last name of the person linked to the user
#           - Email  :   The email of the person linked to the userc
#           - Description  :   The description of the person linked to the user
#           - Departement  :   The departement of the person linked to the user
#           - OU        :   The Organisational Unit in which the user should be created

# Import Active Directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from your file in the $users variable
$users = Import-csv $args[0]

#Loop through each row containing user details in the CSV file
foreach ($user in $users) {
    #Read user data from each field in each row and assign the data to a variable as below
    $uname = $user.Username
    $id = $user.ID
    $password = $user.Psw
    $fname = $user.FirstName
    $lname = $user.LastName
    $email = $user.Email
    $description = $user.Description
    $departement = $user.Departement
    $OU = $user.OU

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

    #Check to see if the user already exists in the AD
    if (Get-ADUser -F { SamAccountName -eq $uname }) {
        Write-Warning "A user account with uname $uname already exists in Active Directory."
    }

    #Else, create the user
    else {
        New-ADUser `
            -SamAccountName $uname `
            -UserPrincipalName "$uname@L2-6.lab" `
            -EmployeeID $id `
            -Name "$fname $lname" `
            -GivenName $fname `
            -Surname $lname `
            -EmailAddress  $email `
            -Description  $description `
            -Department  $departement `
            -Enabled $enableUser `
            -DisplayName "$lname, $fname" `
            -Path $OU `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpire $True
    }
}