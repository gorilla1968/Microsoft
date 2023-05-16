###################################################
# Create a root certificate authority and specify the IP Address and DNS Hostname
# The certificate is valid for 20 years

$rootCert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "Root CA For Windows Admin Center" -TextExtension @("2.5.29.19={text}CA=true","2.5.29.17={text}IPAddress=172.16.0.200&DNS=Schulserver.schule.intern") -KeyUsage CertSign,CrlSign,DigitalSignature -NotAfter (Get-Date).AddYears(20)

# Password protect and export the root certificate authority to be imported on the target machine (client)
[System.Security.SecureString]$rootCertPassword = ConvertTo-SecureString -String "password" -Force -AsPlainText
[String]$rootCertPath = Join-Path -Path 'cert:\CurrentUser\My\' -ChildPath "$($rootCert.Thumbprint)"
Export-Certificate -Cert $rootCertPath -FilePath 'RootCA.crt' ###C:\Windows\system32

# Create a self signed client certificate and specify the IP Address and DNS Hostname
# Certificate is valid for 10 years
$testCert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -Subject "Windows Admin Center (Self-Signed)" -TextExtension @("2.5.29.17={text}IPAddress=172.16.0.200&DNS=Schulserver.schule.intern") -KeyExportPolicy Exportable -KeyLength 2048 -NotAfter (Get-Date).AddYears(10) -KeyUsage DigitalSignature,KeyEncipherment -Signer $rootCert

# Add the certificate to the certificate store and export it
[String]$testCertPath = Join-Path -Path 'cert:\LocalMachine\My\' -ChildPath "$($testCert.Thumbprint)"
 Export-PfxCertificate -Cert $testCertPath -FilePath testcert.pfx -Password $rootCertPassword
#Export-Certificate -Cert $testCertPath -FilePath testcert.crt #####C:\Windows\System32


