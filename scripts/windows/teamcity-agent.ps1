# Install TeamCity Build Agent

mkdir C:\opt -ErrorAction Silently | Out-Null

# Install Java
Write-Host "Downloading JDK"
# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$JDK_FILE=(Split-Path -Path $env:JDK_URL -Leaf)
$JAVA_HOME="C:\opt\" + $JDK_FILE.Split("_")[0].Replace("open", "")
(New-Object System.Net.WebClient).DownloadFile($env:JDK_URL, "$env:TEMP\$JDK_FILE")
Expand-Archive -Path "$env:TEMP\$JDK_FILE" -DestinationPath C:\opt -Force

# Install and configure TeamCity Build Agent
Write-Host "Downloading TeamCity Build Agent"
$AGENT_FILE=(Split-Path -Path $env:AGENT_URL -Leaf)
$AGENT_HOME="C:\opt\teamcity-agent"
mkdir $AGENT_HOME -ErrorAction Silently | Out-Null
(New-Object System.Net.WebClient).DownloadFile($env:AGENT_URL, "$env:TEMP\$AGENT_FILE")
Expand-Archive -Path "$env:TEMP\$AGENT_FILE" -DestinationPath "$AGENT_HOME" -Force

# Configure TeamCity Build Agent
$configPath = "${AGENT_HOME}\conf"
(Get-Content "$configPath\buildAgent.dist.properties") -replace "name=.*", "name=buildagent" | Set-Content "$configPath\buildAgent.properties"
$wrapperPath = "${AGENT_HOME}\launcher\conf\wrapper.conf"
(Get-Content "$wrapperPath") -replace "wrapper.java.command=.*", "wrapper.java.command=$JAVA_HOME\bin\java" | Set-Content "$wrapperPath"
Start-Process -FilePath "${AGENT_HOME}\bin\service.install.bat" -WorkingDirectory "${AGENT_HOME}\bin" -Wait
