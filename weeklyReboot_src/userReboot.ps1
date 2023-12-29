# script is executed minimized in current logged-in user's context via scheduled task triggered on screen unlock
# checks if uptime > defined uptime limit
# alert user that the pc will be rebooted now, or cancel to be re-prompted
# reboots the PC with /g option which restarts most open apps upon logging back in

# Get times
$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime

# Define system uptime in days, that if passed a reboot will be prompted
$UptimeLimit = 6.9

if($uptime.TotalDays -gt $UptimeLimit) {
    Add-Type -AssemblyName PresentationFramework
    $msgBoxInput =  [System.Windows.MessageBox]::Show("Your PC has not yet been rebooted this week. To keep your machine running smoothly, it must be rebooted at least once per week. Please save your work and then choose OK to reboot now. If you click Cancel, you will be prompted again the next time you login.",'Alert from the IT Department','OKCancel','Asterisk')
}

switch ($msgBoxInput) {
    'OK' {
        shutdown.exe /g /t 10 /c "You will soon be signed out so that your computer may reboot."
    }
    
    'Cancel' {
        exit
    }
}