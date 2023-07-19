<#
  .NOTES
  ===========================================================================
   Created on:   	11.07.2023
   Created by:   	Simon Skotheimsvik
   Filename:     	Branding-Detection.ps1
   Info:          https://skotheimsvik.no
  ===========================================================================
  
  .DESCRIPTION
    This script sets the support information for Windows10 and Windows 11
    The information is found in "Settings - System - About - Support" and in "WinVer"
    The script can be assigned as Detection script in Microsoft Intune
    
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
    $ExistingValue = (Get-Item -Path $($Brand.RegKeyPath)).GetValue($($Brand.Key))
    if ($ExistingValue -ne $($Brand.Value)) {
      Write-Host $($Brand.Key) "Not Equal"
      Exit 1
      Exit #Remediation 
    }
    else {
#      Write-Host $($Brand.Key) "Equal"
    }
}
Exit 0