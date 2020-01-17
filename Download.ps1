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

Write-Host $day.length;
Write-Host $day;

# Write the Year Month Day Hour to the console
Write-Host "$year $month $day $hour";

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "velocity.brickftp.com"
    UserName = "anurag.chaudhuri@provana.com"
    Password = "Provana123"
    SshHostKeyFingerprint = "ssh-rsa 4096 JvS7SrgY9QfsC2otdG0TGo0aWcvvieGg1R2Vx8/5VSw="
}

$session = New-Object WinSCP.Session

# Set up session log path
$session.SessionLogPath = "C:\Users\Ipacsadmin\Desktop\Logs\WinSCP$year-$month-$day.log";

try
{
    # Connect
    $session.Open($sessionOptions)

	# Check if folder exists
    $remotePath = "/nextiva/$($year)/$($month)/$($day)";
    if ($session.FileExists($remotePath)) {
        # Transfer files
        Write-Host "File $remotePath exists, downloading...";
        $session.GetFiles($remotePath, "C:\Users\Ipacsadmin\Desktop\*").Check()
    }
    else {
        Write-Host "Remote path does not exist!";
    }
}
finally
{
    $session.Dispose()
}

Stop-Transcript
