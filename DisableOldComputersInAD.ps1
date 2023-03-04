Import-Module ActiveDirectory
$smtpServer = "ex.lab.local"
$fromAdress  = "dc@lab.local"
$toAdress = "it@lab.local"
$limit = (Get-Date).AddDays(-90)
$warningLimit = (Get-Date).AddDays(-70)
$logfileForOldComputers = "C:\Temp\" + (get-date -Format yyyy-MM-dd) + "-DisabledComputers.txt"
$logfileForComputersThatWillBeDeactivatedSoon = "C:\Temp\" + (get-date -Format yyyy-MM-dd) + "-ComputersThatWillBeDeactivatedSoon.txt"
$OldComputers = Get-ADComputer -Properties LastLogonDate -Filter { LastLogonDate -lt $limit -and Enabled -eq $true }
$SoonOldComputers = Get-ADComputer -Properties LastLogonDate -Filter { LastLogonDate -lt $warningLimit -and Enabled -eq $true }

if ($OldComputers.count -gt 0) {
    New-Item -ItemType File -Path $logfileForOldComputers -Force
}
if ($SoonOldComputers.count -gt 0) {
    New-Item -ItemType File -Path $logfileForComputersThatWillBeDeactivatedSoon -Force
}
foreach ($item in $OldComputers) {
    Disable-ADAccount -Identity $item.SamAccountName
    "The Computer " + $item.SamAccountName + " is now disabled." | Out-File $logfileForOldComputers -Append
}
foreach ($item in $SoonOldComputers) {
    $diff = NEW-TIMESPAN –Start $limit –End $item.LastLogonDate
    "The Computer " + $item.SamAccountName +  " will be disbaled in " + $diff.Days + " Days" | Out-File $logfileForComputersThatWillBeDeactivatedSoon -Append
}
if ($OldComputers.count -gt 0 -or $SoonOldComputers.count -gt 0) {
    Send-MailMessage -SmtpServer $smtpServer -Subject "Disbale old Cupmters in AD" -Attachments $logfileForOldComputers,$logfileForComputersThatWillBeDeactivatedSoon -To $toAdress -From $fromAdress -body "Please be sure to check!" -Encoding UTF8
}
elseif ($OldComputers.count -gt 0) {
    Send-MailMessage -SmtpServer $smtpServer -Subject "Disbale old Cupmters in AD" -Attachments $logfileForOldComputers -To $toAdress -From $fromAdress -body "Please be sure to check!" -Encoding UTF8
}
elseif ($SoonOldComputers.count -gt 0) {
    Send-MailMessage -SmtpServer $smtpServer -Subject "Disbale old Cupmters in AD" -Attachments $logfileForComputersThatWillBeDeactivatedSoon -To $toAdress -From $fromAdress -body "Please be sure to check!" -Encoding UTF8
}