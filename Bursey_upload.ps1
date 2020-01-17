# Load WinSCP .NET assembly
Add-Type -Path "C:\Users\Ipacsadmin\Desktop\BurseyScripts\WinSCPnet.dll"

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "uploads.callminer.net"
    UserName = "Bursey_FTP"
    Password = "%7jCs#i4zOcoN2Gc"
    SshHostKeyFingerprint = "ssh-rsa 2048 N7KAZnjEPKAMO27uITiWmPgY+FoXouJ80A6iN6XIs4c="
}

$today = Get-Date

$d = $today.Day
$m = $today.Month
$y = $today.Year

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\Users\Ipacsadmin\Desktop\Logs_Bursey\ScriptOutput$y-$m-$d.txt -append

$session = New-Object WinSCP.Session

try
{
    # Connect
    $session.Open($sessionOptions)

    # Set up transfer options
    $transferOptions = New-Object WinSCP.TransferOptions -Property @{
        ResumeSupport = New-Object WinSCP.TransferResumeSupport -Property @{ State = [WinSCP.TransferResumeSupportState]::Off }
    }
    
    $transferOptions.AddRawSettings("IgnorePermErrors", "1")
    
    # Transfer files
    if(Test-Path C:\Users\Ipacsadmin\Desktop\Bursey_$y-$m-$d.zip) {
        write-host "Uploading..." 
        $session.PutFiles("C:\Users\Ipacsadmin\Desktop\Bursey_$y-$m-$d.zip", "/Bursey/*", $False, $transferOptions).Check()
    }
    else {
        Write-Host "No zip file found."
    }
    
}
finally
{
    $session.Dispose()
    Write-Host "Upload successful for $d-$m-$y"
}
Stop-Transcript
