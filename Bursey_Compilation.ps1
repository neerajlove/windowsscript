cd C:\Users\Ipacsadmin\Desktop\BurseyScripts

#$today = Get-Date

#$d = $today.Day
#$m = $today.Month
#$y = $today.Year

#$ErrorActionPreference="SilentlyContinue"
#Stop-Transcript | out-null
#$ErrorActionPreference = "Continue"
#Start-Transcript -path C:\Users\Ipacsadmin\Desktop\Logs_Bursey\ScriptOutput$y-$m-$d.txt -append

.\Bursey_download.ps1
.\Bursey_ZipFiles.ps1
.\Bursey_upload.ps1
.\Bursey_remove.ps1

#Stop-Transcript
