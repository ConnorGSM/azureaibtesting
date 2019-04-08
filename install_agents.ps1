function config-commString ($commstring) {

    write-host "setting community string to : $commstring"
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v $commstring /t REG_DWORD /d 4 /f
}

function config-Manager ($line,$permittedmanager) {

 write-host "Adding $permittedmanager in SNMP Service"
 reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v $line /t REG_SZ /d $permittedmanager /f

}

function Install-SNMP  {

    $checkinstall= Get-WindowsFeature -name SNMP-Service


    if ($checkinstall.installed -eq $True ) {
            return 0
    }

    else {
        $installSNMP = Install-WindowsFeature SNMP-Service -IncludeManagementTools
        return 0

    }
}



#install SNMP
function install-SNMPModule {
    
    $install= Install-SNMP
    if ($install -eq 0 ) {
        $commString = config-commString 'gbr7361v'
        $permPM1    = config-Manager 1 "${ip_1}"
        $permPM2    = config-Manager 2 "${ip_2}"
        $permPM3    = config-Manager 3 "${ip_3}"
        $permPM4    = config-Manager 4 "${ip_4}"
    }
    else {
        write-host "Error installing SNMP please install manually and run the script again for configuration"
    }
}

function install-epo {
        mkdir C:\Server_Agents\EPO_Installer
        (New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/mcafeeagent-windows.zip?sv=2018-03-28&ss=b&srt=sco&sp=rl&se=2020-01-11T20:20:39Z&st=2019-04-08T11:20:39Z&spr=https&sig=3xY%2BF0S5yZdpGzXdTj7vQhsZchOdhabNo2Vix562V0U%3D", "C:\Server_Agents\EPO_Installer\mcafeeagent-windows.zip")
        Write-Output "Downloading EPO installer zip"
        Start-Sleep -Seconds 5
        
        Write-Output "Extracting"
        Expand-Archive C:\Server_Agents\EPO_Installer\mcafeeagent-windows.zip -DestinationPath C:\Server_Agents\EPO_Installer\
        Start-Sleep -Seconds 15
        
        
        Write-Output "Running EPO Installer"
        $EPOcommand="C:\Server_Agents\EPO_Installer\0409\FramePkg.exe /Install=Agent /Silent"
        Invoke-Expression $EPOcommand
        Start-Sleep -Seconds 45
        cd "C:\Program Files\McAfee\Agent\"
        .\cmdagent.exe -i
        Start-Sleep -Seconds 5
    
}


#install SCOM 

function install-scom {
    if ("${install_scom}" -eq 'yes') {
        mkdir C:\Server_Agents\SCOM_Installer
        (New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/SCOM_Installer.zip?sv=2018-03-28&ss=b&srt=sco&sp=rl&se=2020-01-11T20:20:39Z&st=2019-04-08T11:20:39Z&spr=https&sig=3xY%2BF0S5yZdpGzXdTj7vQhsZchOdhabNo2Vix562V0U%3D", "C:\Server_Agents\SCOM_installer\SCOM_Installer.zip")
        
        Write-Output "Extracting 5"
        Expand-Archive c:\Server_Agents\SCOM_installer\SCOM_Installer.zip -DestinationPath c:\Server_Agents\SCOM_installer
        Write-Output "Unzipped"
        Start-Sleep -Seconds 10
        
        $installer_folder = Get-ChildItem C:\Server_Agents\SCOM_Installer | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
        Set-Content -Path C:\Server_Agents\SCOM_Installer\SCOM_Installer\SCOM1801_agent\agent_install.bat -Value "msiexec.exe /i  c:\Server_agents\SCOM_installer\SCOM_Installer\SCOM1801_agent\MOMAgent.msi /qn /l*v %temp%\MOMAgent_install.log USE_SETTINGS_FROM_AD=0 USE_MANUALLY_SPECIFIED_SETTINGS=1 MANAGEMENT_GROUP=UKOMPROD MANAGEMENT_SERVER_DNS=AWS001UK02003.ukawscloud.com ACTIONS_USE_COMPUTER_ACCOUNT=1 NOAPM=1 AcceptEndUserLicenseAgreement=1"
      
        Write-Output "Running SCOM Installer"
        $command = "C:\Server_Agents\SCOM_Installer\$installer_folder\SCOM1801_agent\agent_install.bat"
	    Invoke-Expression $command
        Start-Sleep -Seconds 60
    }
}



# installing Qualys Agent 
function install-Qualys {
       
        Write-Output "Downloading Qualys installer zip"
        (New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/QualysCloudAgent.exe?sv=2018-03-28&ss=b&srt=sco&sp=rl&se=2020-01-11T20:20:39Z&st=2019-04-08T11:20:39Z&spr=https&sig=3xY%2BF0S5yZdpGzXdTj7vQhsZchOdhabNo2Vix562V0U%3D", "C:\Server_Agents\QualysCloudAgent.exe")
        cmd /c "C:\Server_Agents\QualysCloudAgent.exe  CustomerId={9c0e25d3-3ca2-5af6-e040-10ac13043f6a} ActivationId={909fdd58-aad6-480b-a8c0-e233057e6f55}" 
        Start-Sleep -Seconds 10  
}

# end of Qualys installation

function enable_PSRemoting {

    if ("${install_PSRemote}" -eq "Yes") {

    # Windows Remoting 
   
    Enable-PSRemoting -force
    Set-Service WinRM -StartMode Automatic
    Set-Item WSMan:localhost\client\trustedhosts -value * -force
    winrm set winrm/config/client/auth '@{Basic="true"}'
    winrm set winrm/config/client '@{AllowUnencrypted="true"}'
    }
}

#install-cylance

function install-cylance {

		$cylance= get-service -Name CylanceSvc
		
		if(!$cylance) {
			(New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/CylanceProtect_x64.msi?sv=2018-03-28&ss=b&srt=sco&sp=rl&se=2020-01-11T20:20:39Z&st=2019-04-08T11:20:39Z&spr=https&sig=3xY%2BF0S5yZdpGzXdTj7vQhsZchOdhabNo2Vix562V0U%3D", "C:\Server_Agents\CylanceProtect_x64.msi")
			c:\Server_Agents\CylanceProtect_x64.msi /q /l*v c:\Server_Agents\CylanceInstall.log PIDKEY=s8PnX13jItikQYLnaX1FesvdE LAUNCHAPP=1
            Start-Sleep -Seconds 60     
        } 
}



#install-cylanceoptics

function install-cylanceoptics {

       $cylance= get-service -Name CyOptics
		
		if(!$cylance) {
			(New-Object System.Net.WebClient).DownloadFile("https://aibmedia.blob.core.windows.net/media/CylanceOPTICSSetup.exe?sv=2018-03-28&ss=b&srt=sco&sp=rl&se=2020-01-11T20:20:39Z&st=2019-04-08T11:20:39Z&spr=https&sig=3xY%2BF0S5yZdpGzXdTj7vQhsZchOdhabNo2Vix562V0U%3D", "C:\Server_Agents\CylanceOPTICSSetup.exe")
            $command = "C:\Server_Agents\CylanceOPTICSSetup.exe -s"
            Invoke-Expression $command
            Start-Sleep -Seconds 20
			        }
}


# MAIN 

config-Manager
config-commString
install-epo
install-Qualys
install-SNMPModule
install-scom
enable_PSRemoting
install-cylance
install-cylanceoptics