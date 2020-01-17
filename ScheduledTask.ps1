$Trigger= New-ScheduledTaskTrigger -At 09:30am -Daily
$User= "Ipacsadmin"
$Action= New-ScheduledTaskAction -Execute "powershell.exe" -Argument "cd 'C:\Users\Ipacsadmin\Desktop\Scripts' ; .\WinSCP.ps1"
Register-ScheduledTask -TaskName "Velocity-Callminer-Task" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force