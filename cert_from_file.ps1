# Store the data from MOCK.csv in the $ADUsers variable
$ADUsers = Import-Csv C:\certs\MOCK.csv -Delimiter ","

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.username
    $ad_username = "domain\$username"
    $firstname = $User.firstname
    $lastname = $User.lastname
    $ad_password = $User.ad_password
	$cert_password = $User.cert_password
    Write-Host $ad_username
    Write-Host $ad_password

      $securePassword = ConvertTo-SecureString -String $ad_password -Force -AsPlainText
      $credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $ad_username, $securePassword
      $args="-noprofile -file c:\certs\cert_generate.ps1 $cert_password"
      Write-Host $args
      Start-Process powershell.exe -Credential $credential -ArgumentList $args
}

Read-Host -Prompt "Press Enter to exit"
   
   
    