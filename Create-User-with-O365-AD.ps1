#Imports the AD & O365 Modules (Module 1.02)
Import-Module activedirectory
Import-Module MSOnline

#Sets Variables (Module 1.03)
$fn #First Name
$ln #Last Name
$title
$dep #Department
$loc #Location
$man #Manager
$un #Username
$officePhone
$streetAdd
$city
$ZIP
$fi #First Name Initial, will be used to figure out Username

#Getting information (Module 1.04)
Write-Host "I need some information from you first. Answer the following questions to get started."
$fn = Read-host "First Name?"
$ln = Read-Host "Last Name?"
$title = Read-Host "Title?"
$dep = Read-Host "Department?"
$man = Read-Host "Manager (Username)?"
$loc = Read-Host "Loc1 or Loc2?"

#Finding out the Username (Module 1.05)
$fi = $fn.Substring(0,1)
$un = -join ($ln, $fi)

#Sets Location information (Module 1.06)
if ($loc -eq "Loc1") { #If the user is in Loc1 (Module 1.07)
    $officePhone = "(999) 999-9999";
    $streetAdd = "123 Anywhere Drive";
    $city = "YourTown";
    $ZIP = "12345";
}
Else { #If the user is in Loc2 (Module 1.08)
    $officePhone = "(987) 654-3210";
    $streetAdd = "987 Nothere Blvd";
    $city = "Somewhere Else";
    $ZIP = "98765";
}

#Sets Password (Module 1.09)
$passwd = (Read-Host -AsSecureString "Account Password")
$password = ConvertFrom-SecureString -SecureString $passwd

$userParams = @{ #(Module 1.10)
    'Name' = $un;
    'Enabled' = $true;
    'AccountPassword' = $passwd;
    'UserPrincipalName' = -join ($un, "@mycompany.com");
    'SamAccountName' = $un;
    'ChangePasswordAtLogon' = $false;
    'GivenName' = $fn;
    'Surname' = $ln;
    'DisplayName' = -join ($fn, " ", $ln);
    'Description' = $title;
    'OfficePhone' = $officePhone;
    'StreetAddress' =  $streetAdd;
    'City' = $city;
    'State' = "Texas";
    'PostalCode' = $ZIP;
    'Title' = $title;
    'Department' = $dep;
    'Company' = 'MyCompany';
    'Manager' = $man;
}

#Creates the user in AD (Module 1.11)
New-ADUser @userParams

#Wait for the account to be created before doing anything else (Module 1.12)
Start-Sleep -Seconds 10

#Makes the user's network drive and scan folder (Module 1.13)
if ($loc -eq "Loc1") { #If the user is in Loc1 (Module 1.14)
    New-Item -Name $un -ItemType directory -Path "\\server\folder" #Creates users network drive
    New-Item -Name scans -ItemType directory -Path "\\server\folder\$un" #Creates users scan folder
}
Else { #If the user is in Loc2 (Module 1.15)
    New-Item -Name $un -ItemType directory -Path "\\server\folder" #Creates users network drive
    New-Item -Name scans -ItemType directory -Path "\\server\folder\$un" #Creates users scan folder
}

#Adds the user to the correct Security Group for permissions and other network drives
if ($dep -eq "Accounting"){ #(Module 1.16)
    Add-ADGroupMember -Identity 'Accounting' -Members $un #(Module 1.17)
} #Adds the user to the Accounting Group
Elseif ($dep -eq "Customer Service") { #(Module 1.18)
    Add-ADGroupMember -Identity 'Customer Service' -Members $un #(Module 1.19)
} #Adds the user to the Customer Service Group
Elseif ($dep -eq "Executives") { #(Module 1.20)
    Add-ADGroupMember -Identity 'Executives' -Members $un #(Module 1.21)
} #Adds the user to the Executives Group
Elseif ($dep -eq "HR") { #(Module 1.22)
    Add-ADGroupMember -Identity 'Human Resources' -Members $un #(Module 1.23)
} #Adds the user to the Human Resources Group
Elseif ($dep -eq "Human Resources") { #(Module 1.24)
    Add-ADGroupMember -Identity 'Human Resources' -Members $un #(Module 1.25)
} #Adds the user to the Human Resources Group
Elseif ($dep -eq "IT") { #(Module 1.26)
    Add-ADGroupMember -Identity 'Domain Admins' -Members $un #(Module 1.27)
} #Adds the user to the Domain Admins Group for IT
Elseif ($dep -eq "Maintenance") { #(Module 1.28)
    Add-ADGroupMember -Identity 'MaintGroup' -Members $un #(Module 1.29)
} #Adds the user to the Maintenance Group
Elseif ($dep -eq "Production") { #(Module 1.30)
    Add-ADGroupMember -Identity 'Production' -Members $un #(Module 1.31)
} #Adds the user to the Production GroupHR
Elseif ($dep -eq "QA") {  #(Module 1.32)
Elseif ($dep -eq "Shipping") {  #(Module 1.36)
    Add-ADGroupMember -Identity 'SHIP' -Members $un #(Module 1.37)
} #Adds the user to the Shipping Group
Else { #(Module 1.38)
    Add-ADGroupMember -Identity 'Domain Users' -Members $un #(Module 1.39)
} #Dumps the user to the Domain Users Group

$manfn = Get-ADUser $man -Properties Name | select Name #Gets the manager's name (Module 1.40)

#Creates a report of the User's information
$report = "Hello $fn $ln,

From the IT Department, welcome to <MyCompany>.   We are here to help you connect to the resources that you need for your job.
If you need assistance with technology, please feel free to contact us at either the help page, which is set as your
home page in Internet Explorer, email us at helpdesk@<MyCompany>.com, or call us at extension ####.

Below you will find your information so that you can login to the network and get started:

Your username is domain\$un
Your password is
Your email address is $fn$ln@<MyCompany>.com
Your phone number is $officePhone Ext.

It is suggested that you change your password to something that you can remember but difficult enough that somebody else cannot
figure out.   The requirement is only 6 characters, but we do advise on making it longer, throw some numbers and special
characters in there as well to make it stronger.   Best advice would be to use a pass-PHRASE instead of a pass-WORD.

The use of the equipment and resources provided are a privilege to you for use and should not be taken advantage of.   There are
measures set in place that allows us to manage the network.   Do not assume that there is any personal privacy on this network.  
The only privacy that you can assume is for the nature of your work.   All information (including emails, documents,
spreadsheets, pictures, etc.) contained on the equipment provided and on the network is the sole property of MyCompany.

If you have problems with your equipment or network resources, please feel free to ask.   We do not mind helping, but we cannot
help if we do not know, so please ask!

Sincerely,


Your IT Department"

if ($loc -eq "Loc1") { #(Module 1.43)
    Write-Output $report | Out-Printer
}
Else { #(Module 1.44)
    Write-Output $report | Out-Printer \\server\'Printer'
}

#Invoke a Sync (Module 1.45)
Invoke-Command -ComputerName <ADSync Server> {Start-ADSyncSyncCycle -PolicyType Delta}
Start-Sleep -Seconds 60

#Connect to O365 and licenses the user
Connect-MsolService #(Module 1.46)
Set-MsolUserLicense -UserPrincipalName (-join($un,'@<MyCompany>.com')) -AddLicenses #(Module 1.47)

#Connects to the Exchange box, creates the users email account, then disconnects from the Exchange box
$mail = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -AllowRedirection -Authentication Basic -Credential $cred #(Module 1.48-Part 1)
Import-PSSession $mail -WarningAction SilentlyContinue | Out-Null #(Module 1.48-Part 2)
enable-Mailbox -Identity $un -Alias $un -DisplayName (-join($fn,$ln)) #Creates the users mailbox (Module 1.49)
IF ($dep -eq "Executives") { #(Module 1.50)
    Set-Mailbox (-join($un,'@<MyCompany>.com')) -ProhibitSendQuota 19.5GB -ProhibitSendReceiveQuota 20GB -IssueWarningQuota 19GB #Sets the mailbox size in Exchange Online so that the user isn't using all 50 GB of storage (Module 1.51)
} #If they are an executive, then they get 20 GB of mailbox space
elseif ($dep -eq "IT") { #(Module 1.52)
    Set-Mailbox (-join($un,'@<MyCompany>.com')) #(Module 1.53)
} #IT gets the full mailbox, of course
else { #(Module 1.54)
    Set-Mailbox (-join($un,'@<MyCompany>.com')) -ProhibitSendQuota 9.5GB -ProhibitSendReceiveQuota 10GB -IssueWarningQuota 9GB #Sets the mailbox size in Exchange Online so that the user isn't using all 50 GB of storage (Module 1.55)
} #Otherwise, everybody else gets 10 GB of mailbox space
Remove-PSSession -Session $mail #Disconnects from the Exchange box (Module 1.56)
