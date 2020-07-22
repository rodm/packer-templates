# Mount and install VirtualBox Guest Additions

if ($env:PACKER_BUILDER_TYPE -eq "virtualbox-iso") {
    Write-Host "Installing VirtualBox Guest Additions"

    $imagePath = "${env:USERPROFILE}\VBoxGuestAdditions.iso"
    $driveLetter = (Mount-DiskImage -ImagePath $imagePath | Get-Volume).DriveLetter
    $certUtil = "${driveLetter}:\cert\VBoxCertUtil.exe"

    Get-ChildItem "${driveLetter}:\cert\" -Filter vbox*.cer | ForEach-Object {
        $certPath = $_.FullName
        Write-Host "Add trusted publisher ${certPath}"
        Invoke-Expression "$certUtil add-trusted-publisher $certPath --root $certPath"
    }

    New-Item -Path "C:\Windows\Temp\virtualbox" -ItemType "directory" | Out-Null
    Start-Process -FilePath "${driveLetter}:\VBoxWindowsAdditions.exe" -ArgumentList "/S" -WorkingDirectory "C:\Windows\Temp\virtualbox" -Wait

    Remove-Item "C:\Windows\Temp\virtualbox" -Recurse -Force
    Dismount-DiskImage -ImagePath $imagePath | Out-Null
}
