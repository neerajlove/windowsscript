$Trigger= New-ScheduledTaskTrigger -At 11:00am -Daily
$User= "Ipacsadmin"
$Action= New-ScheduledTaskAction -Execute "powershell.exe" -Argument "cd 'C:\Users\Ipacsadmin\Desktop\BurseyScripts' ; .\Bursey_Compilation.ps1"
Register-ScheduledTask -TaskName "BurseyTask" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force