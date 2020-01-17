# Get the exact date and time units at the client side
$date = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'Eastern Standard Time');

# Extract year, month, day and the hour from the previously generated date
$year = $date.Year;
$month = $date.Month;
$day = $date.Day;

#$day = $day - 1;
$a = $day / 10;
if ($a -lt 1) {
    $day = "0" + $day;
}

$a = $month / 10;
if ($a -lt 1) {
    $month = "0" + $month;
}

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\Users\Ipacsadmin\Desktop\Logs\ScriptOutput$year-$month-$day.txt -append

$path = "C:\Users\Ipacsadmin\Desktop\$day\"

$hours = Get-ChildItem $path | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name};

foreach ($hour in $hours) {
    $hoursPath = $path;
    $path = $path + $hour + "\*";

    Move-Item $path $hoursPath;
    $removePath = $hoursPath + $hour;
    Remove-Item $removePath;
    $path = $hoursPath;
}

$source = "C:\Users\Ipacsadmin\Desktop\$day"

$destination = "C:\Users\Ipacsadmin\Desktop\$year-$month-$day.zip"

If(Test-path $destination) {Remove-item $destination}

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory($Source, $destination)

Stop-Transcript