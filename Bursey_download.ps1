param (
    $localPath = "C:\Users\ipacsadmin\Desktop\BurseyData\*",
    $remotePath = "/Call Recordings/"
)

# Load WinSCP .NET assembly
Add-Type -Path "C:\Users\Ipacsadmin\Desktop\BurseyScripts\WinSCPnet.dll"

$x = Get-Date
    

$d = $x.Day
$m = $x.Month
$y = $x.Year

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\Users\Ipacsadmin\Desktop\Logs_Bursey\ScriptOutput$y-$m-$d.txt -append

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "70.88.172.169"
    UserName = "Provana"
    Password = "gJ98whA4dK"
    SshHostKeyFingerprint = "ssh-dss 1024 Lv0zua49dWj0qE3rxxpxrLZMiEA/uWAfSgzyxFWJ6Ck="
}

$session = New-Object WinSCP.Session
$session.SessionLogPath = "C:\Users\Ipacsadmin\Desktop\Logs_Bursey\WinSCP_Testing$y-$m-$d.log";

try
{
    # Connect
    $session.Open($sessionOptions)

    # Get today's date in MST timezone
    $today = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"Mountain Standard Time (Mexico)")
    
    # Subtract 1 day from the current day
    #$today = $today.AddDays(-1)

    Write-Host "Downloading files after $today"
    $remotePath = "/Call Recordings/"
    $directoryInfo = $session.ListDirectory($remotePath)

    Write-Host "Downloading files from $remotePath"

    $latest = $directoryInfo.Files | Where-Object { -Not $_.IsDirectory } | Sort-Object LastWriteTime -Descending | Where-Object {$_.LastWriteTime -ge $today}

    $N_Objects = ($latest | Measure-Object).Count
    Write-Host "Downloading $N_Objects Objects..."

    if ($Null -eq $latest)
    {
        Write-Host "No file found"
        exit 1
    }
    
    # Set up transfer options
    $transferOptions = New-Object WinSCP.TransferOptions -Property @{
        ResumeSupport = New-Object WinSCP.TransferResumeSupport -Property @{ State = [WinSCP.TransferResumeSupportState]::Off }
    }
    
    # # Transfer files
    foreach ($i in $latest) {
        Write-Host "Downloading $i.FullName"
        $session.GetFiles($i.FullName, $localPath, $False, $transferOptions).Check()
    }
}
finally
{
    $session.Dispose()
}
Stop-Transcript
