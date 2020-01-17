# Load WinSCP .NET assembly
Add-Type -Path "C:\Users\Ipacsadmin\Desktop\Scripts\WinSCPnet.dll"

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

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "uploads.callminer.net"
    UserName = "Velocityinternal_FTP"
    Password = "dD%q7`$fCpxnfAK57"
    SshHostKeyFingerprint = "ssh-rsa 2048 N7KAZnjEPKAMO27uITiWmPgY+FoXouJ80A6iN6XIs4c="
}

$session = New-Object WinSCP.Session

# Set up session log path
$session.SessionLogPath = "C:\Users\Ipacsadmin\Desktop\Logs\WinSCP$year-$month-$day.log";

try
{
    # Connect
    $session.Open($sessionOptions)

    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.ResumeSupport.State = [WinSCP.TransferResumeSupportState]::off;

    $localPath = "C:\Users\Ipacsadmin\Desktop\$year-$month-$day.zip";
    
    if(Test-Path $localPath) {
        # Transfer files if the zip files exist on the local system.
        $session.PutFiles($localPath, "/Velocityinternal/*", $false, $transferOptions).Check()
    } else {
        Write-Host "The local path for doesn't exist!"
    }
}
finally
{
    $session.Dispose()
}

# Delete the zip files from the middleman server
Remove-Item -path "C:\Users\Ipacsadmin\Desktop\$day" -Recurse -Force -Confirm:$false
Remove-Item -path "C:\Users\Ipacsadmin\Desktop\$year-$month-$day.zip" -Force -Confirm:$false

Stop-Transcript
