# Mount and install VMware Tools

if ($env:PACKER_BUILDER_TYPE -eq "vmware-iso") {
    Write-Host "Installing VMware Tools"

    $imagePath = "C:\Users\vagrant\windows.iso"
    $driveLetter = (Mount-DiskImage -ImagePath $imagePath | Get-Volume).DriveLetter

    Start-Process -FilePath "${driveLetter}:\setup64.exe" -ArgumentList "/S /V /qn REBOOT=R ADDLOCAL=ALL" -Wait

    Dismount-DiskImage -ImagePath $imagePath | Out-Null
}
