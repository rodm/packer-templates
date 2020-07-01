# Configure Windows

# Enable RDP
netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
# reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
New-ItemProperty -Path $registryPath -Name "fDenyTSConnections" -Value 0 -PropertyType DWORD -Force | Out-Null

# Enable UAC
# Invoke-Expression reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v EnableLUA /t REG_DWORD /d 1
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
New-ItemProperty -Path $registryPath -Name "EnableLUA" -Value 1 -PropertyType DWORD -Force | Out-Null
