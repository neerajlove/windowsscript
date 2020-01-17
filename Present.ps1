# Load WinSCP .NET assembly
Add-Type -Path "C:\Users\Ipacsadmin\Desktop\Scripts\WinSCPnet.dll"

$path = "C:\Users\Ipacsadmin\Desktop\nextiva"

Set-Location $path

# Extract year, month, day and the hour from the previously generated date
$years = Get-ChildItem $path | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name};

foreach ($year in $years) {
    $yearPath = $path;
    $path = $path + "\" + $year;
    #Write-Host $path;
    #Write-Host "";

    $months = Get-ChildItem $path | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name};

    foreach ($month in $months) {
        $monthPath = $path;
        $path = $path + "\" + $month;
        
        #Write-Host $path;
        #Write-Host "";

        $days = Get-ChildItem $path | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name};

        foreach ($day in $days) {
            $dayPath = $path;
            $path = $path + "\" + $day;

            #Write-Host $path;
            #Write-Host "";

            $hours = Get-ChildItem $path | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name};

            foreach ($hour in $hours) {
                $itemsPath = $path + "\" + $hour + "\*";
                Move-Item $itemsPath $path;
                
                # Delete blank hourly folders
                $DelPath = $path + "\" + $hour;
                Remove-Item $DelPath;
                Write-Host "Hourly for loop: $DelPath";
            }

            # Zip files
            $source = $path;
            $destination = $dayPath+"\$day-$month-$year.zip";
            
            Write-Host "Just outside hourly for loop: $destination";
            Write-Host "";

            If(Test-path $destination) {Remove-item $destination}
            Add-Type -assembly "system.io.compression.filesystem"
            [io.compression.zipfile]::CreateFromDirectory($source, $destination)
            $path = $dayPath;
        }
        $path = $monthPath;
    }
    $path = $yearPath;
}