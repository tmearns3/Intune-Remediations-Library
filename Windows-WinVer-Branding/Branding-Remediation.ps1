<#
  .NOTES
  ===========================================================================
   Created on:   	11.07.2023
   Created by:   	Simon Skotheimsvik
   Filename:     	Branding-Remediation.ps1
   Info:          https://skotheimsvik.no
  ===========================================================================
  
  .DESCRIPTION
    This script sets the support information for Windows10 and Windows 11
    The information is found in Settings - System - About - Support
    The script can be assigned as a Remediation script in Microsoft Intune
    
#>

$BrandingContent = @"
RegKeyPath,Key,Value
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","SupportURL","https://support.rastcloud.com/"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","Manufacturer","RastCloud"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","SupportHours","Standard: 24-7-365"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","SupportPhone","+49 123456789"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion","RegisteredOwner","RastCloud"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion","RegisteredOrganization","RastCloud"
"@

$Branding = $BrandingContent | ConvertFrom-Csv -delimiter ","

foreach ($Brand in $Branding) {

    IF (!(Test-Path ($Brand.RegKeyPath))) {
        Write-Host ($Brand.RegKeyPath) " does not exist. Will be created."
        New-Item -Path $RegKeyPath -Force | Out-Null
    }
    IF (!(Get-Item -Path $($Brand.Key))) {
        Write Host $($Brand.Key) " does not exist. Will be created."
        New-ItemProperty -Path $($Brand.RegKeyPath) -Name $($Brand.Key) -Value $($Brand.Value) -PropertyType STRING -Force
    }
    
    $ExistingValue = (Get-Item -Path $($Brand.RegKeyPath)).GetValue($($Brand.Key))
    if ($ExistingValue -ne $($Brand.Value)) {
        Write-Host $($Brand.Key) " not correct value. Will be set."
        Set-ItemProperty -Path $($Brand.RegKeyPath) -Name $($Brand.Key) -Value $($Brand.Value) -Force
    }
    else {
        Write-Host $($Brand.Key) " is correct"
    }
}

Exit 0
