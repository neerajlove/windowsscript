# Get the exact date and time units at the client side
$date = Get-Date

# Extract year, month, day and the hour from the previously generated date
$year = $date.Year;
$month = $date.Month;
$day = $date.Day;

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\Users\Ipacsadmin\Desktop\Logs_Bursey\ScriptOutput$year-$month-$day.txt -append

$source = "C:\Users\Ipacsadmin\Desktop\BurseyData"

$destination = "C:\Users\Ipacsadmin\Desktop\Bursey_$year-$month-$day.zip"

If(Test-path $destination) {Remove-item $destination}

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory($source, $destination)

Stop-Transcript