# script is to be run in User context. Intune win32 app should be deployed in same.
# copies reboot nag script.
# creates scheduled task for weekly reboot nag script. Uses 'whoami' so that task is created to run as the logged in user.


New-Item -Type dir C:\Scripts -ErrorAction SilentlyContinue
Copy-Item -Path ".\userReboot.ps1" -Destination "C:\Scripts\userReboot.ps1" -ErrorAction SilentlyContinue

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy bypass -WindowStyle Minimized -file C:\Scripts\userReboot.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 4pm
$principal = New-ScheduledTaskPrincipal -UserId (whoami) -RunLevel Limited -LogonType Interactive
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal

Register-ScheduledTask 'Weekly Reboot Prompt' -InputObject $task


# Intune detection rules: file exists
# 'C:\Windows\System32\Tasks\Weekly Reboot Prompt'