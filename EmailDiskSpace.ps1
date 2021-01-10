$Server1C = Get-WmiObject Win32_LogicalDisk -Computer Server1 -Filter "DeviceID='C:'" | Select-Object FreeSpace
$Server2C = Get-WmiObject Win32_LogicalDisk -Computer Server2 -Filter "DeviceID='C:'" | Select-Object FreeSpace

$Server1D = Get-WmiObject Win32_LogicalDisk -Computer Server1 -Filter "DeviceID='D:'" | Select-Object FreeSpace
$Server2D = Get-WmiObject Win32_LogicalDisk -Computer Server2 -Filter "DeviceID='D:'" | Select-Object FreeSpace

$Server1E = Get-WmiObject Win32_LogicalDisk -Computer Server1 -Filter "DeviceID='E:'" | Select-Object FreeSpace
$Server2E = Get-WmiObject Win32_LogicalDisk -Computer Server2 -Filter "DeviceID='E:'" | Select-Object FreeSpace

$Diskspace1C = ([math]::Round($Server1C.FreeSpace /1GB,2))
$Diskspace2C = ([math]::Round($Server2C.FreeSpace /1GB,2))

$Diskspace1D = ([math]::Round($Server1D.FreeSpace /1GB,2))
$Diskspace2D = ([math]::Round($Server2D.FreeSpace /1GB,2))

$Diskspace1E = ([math]::Round($Server1E.FreeSpace /1GB,2))
$Diskspace2E = ([math]::Round($Server2E.FreeSpace /1GB,2))

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mailserver.domain/PowerShell/ -Authentication Kerberos
Import-PSSession $Session -DisableNameChecking -AllowClobber

$whitespace = (get-mailboxdatabase -identity MailboxDBName -status).AvailableNewMailboxSpace -replace "\(.*\)"," "

$body="
<table cellpadding='10'>
  <tr>
    <th></th>
    <th>Server1:</th>
    <th>Server2:</th>
  </tr>
  <tr>
<td>C:</td>
<td>$Diskspace1C GB</td>
<td>$Diskspace2C GB</td>
</tr>
<tr>
<td>D:</td>
<td>$Diskspace1D GB</td>
<td>$Diskspace2D GB</td><td>-</td>
</tr>
<tr>
<td>E:</td>
<td>$Diskspace1E GB</td>
<td>$Diskspace2E GB</td>
</tr>
<tr>
<td colspan='6'><b>Exchange DB whitespace:</b> $whitespace</td>
</tr>
</table>
"   

$body

Send-MailMessage -To “recipient@domain.com” -From “sender@domain.com” -Subject “Disk space report” -Body $body -BodyAsHtml -SmtpServer “mailserver.domain” -Port 587