@echo off
echo Connecting to WIFI-NAME network...

:: Create WiFi profile
echo ^<?xml version="1.0"?^> > "WIFI-NAME.xml"
echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^> >> "WIFI-NAME.xml"
echo     ^<name^>WIFI-NAME^</name^> >> "WIFI-NAME.xml"
echo     ^<SSIDConfig^> >> "WIFI-NAME.xml"
echo         ^<SSID^> >> "WIFI-NAME.xml"
echo             ^<name^>WIFI-NAME^</name^> >> "WIFI-NAME.xml"
echo         ^</SSID^> >> "WIFI-NAME.xml"
echo     ^</SSIDConfig^> >> "WIFI-NAME.xml"
echo     ^<connectionType^>ESS^</connectionType^> >> "WIFI-NAME.xml"
echo     ^<connectionMode^>auto^</connectionMode^> >> "WIFI-NAME.xml"
echo     ^<MSM^> >> "WIFI-NAME.xml"
echo         ^<security^> >> "WIFI-NAME.xml"
echo             ^<authEncryption^> >> "WIFI-NAME.xml"
echo                 ^<authentication^>WPA2^</authentication^> >> "WIFI-NAME.xml"
echo                 ^<encryption^>AES^</encryption^> >> "WIFI-NAME.xml"
echo                 ^<useOneX^>true^</useOneX^> >> "WIFI-NAME.xml"
echo             ^</authEncryption^> >> "WIFI-NAME.xml"
echo             ^<OneX xmlns="http://www.microsoft.com/networking/OneX/v1"^> >> "WIFI-NAME.xml"
echo                 ^<authMode^>user^</authMode^> >> "WIFI-NAME.xml"
echo                 ^<EAPConfig^> >> "WIFI-NAME.xml"
echo                     ^<EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig"^> >> "WIFI-NAME.xml"
echo                         ^<EapMethod^> >> "WIFI-NAME.xml"
echo                             ^<Type xmlns="http://www.microsoft.com/provisioning/EapCommon"^>21^</Type^> >> "WIFI-NAME.xml"
echo                             ^<VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon"^>0^</VendorId^> >> "WIFI-NAME.xml"
echo                             ^<VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon"^>0^</VendorType^> >> "WIFI-NAME.xml"
echo                             ^<AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon"^>311^</AuthorId^> >> "WIFI-NAME.xml"
echo                         ^</EapMethod^> >> "WIFI-NAME.xml"
echo                         ^<Config xmlns="http://www.microsoft.com/provisioning/EapHostConfig"^> >> "WIFI-NAME.xml"
echo                             ^<EapTtls xmlns="http://www.microsoft.com/provisioning/EapTtlsConnectionPropertiesV1"^> >> "WIFI-NAME.xml"
echo                                 ^<ServerValidation^> >> "WIFI-NAME.xml"
echo                                     ^<ServerNames^>^</ServerNames^> >> "WIFI-NAME.xml"
echo                                     ^<TrustedRootCA^>^</TrustedRootCA^> >> "WIFI-NAME.xml"
echo                                 ^</ServerValidation^> >> "WIFI-NAME.xml"
echo                                 ^<Phase2Authentication^> >> "WIFI-NAME.xml"
echo                                     ^<PAPAuthentication /^> >> "WIFI-NAME.xml"
echo                                 ^</Phase2Authentication^> >> "WIFI-NAME.xml"
echo                                 ^<Phase1Identity^> >> "WIFI-NAME.xml"
echo                                     ^<IdentityPrivacy^>false^</IdentityPrivacy^> >> "WIFI-NAME.xml"
echo                                 ^</Phase1Identity^> >> "WIFI-NAME.xml"
echo                             ^</EapTtls^> >> "WIFI-NAME.xml"
echo                         ^</Config^> >> "WIFI-NAME.xml"
echo                     ^</EapHostConfig^> >> "WIFI-NAME.xml"
echo                 ^</EAPConfig^> >> "WIFI-NAME.xml"
echo             ^</OneX^> >> "WIFI-NAME.xml"
echo         ^</security^> >> "WIFI-NAME.xml"
echo     ^</MSM^> >> "WIFI-NAME.xml"
echo ^</WLANProfile^> >> "WIFI-NAME.xml"

:: Remove existing WiFi profile first (if any)
netsh wlan delete profile name="WIFI-NAME"

:: Add WiFi profile
netsh wlan add profile filename="WIFI-NAME.xml" user=all

:: Connect to WiFi network
netsh wlan connect name="WIFI-NAME"

:: Delete temporary profile file
del "WIFI-NAME.xml"

echo WiFi connection operation completed, attempting to connect to WIFI-NAME...
pause
