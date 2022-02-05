# ----- Edit these variables ----- #
$PASSWORD_FOR_USERS   = "Password123!"
$USER_FIRST_LAST_LIST = Get-Content .\employees.txt
# ------------------------------------------------------ #

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

foreach ($n in $USER_FIRST_LAST_LIST) {
    $name = $n
    $first = $n.Split(" ")[0]
    $last = $n.Split(" ")[1]
    $username = "$($first.Substring(0,1))$($last)".ToLower()
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Green
    
    New-AdUser -GivenName $first `
               -Surname $last `
               -Name $name `
               -DisplayName $name `
               -userPrincipalName $username `
               -EmployeeID $username `
               -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true `
               -AccountPassword $password `
               -PasswordNeverExpires $true `
               -ChangePasswordAtLogon $false `
}
