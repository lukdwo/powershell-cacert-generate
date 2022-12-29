if (Get-ChildItem -Path Cert:\CurrentUser\My\*) {
        
        # If user has cert, give a warning
        Write-Warning "User has some cert on this PC"
    }
    else {
        write-host $env:username
        write-host $args[0]
$cert_password = $args[0]
$CertName = $env:username
$CSRPath = "c:\certs\$($CertName).csr"
$INFPath = "c:\certs\$($CertName).inf"
$CERPath = "c:\certs\$($CertName).cer"
$PFXPath = "c:\certs\$($CertName).pfx"


Write-Host "Creating CertificateRequest(CSR) for $CertName `r "


$Signature = '$Windows NT$' 
$INF =
@"
[Version]
Signature= "$Signature" 
[NewRequest]
Subject = "CN=$CertName,OU=Users,OU=Users,OU=Own,DC=domain,DC=com"
Exportable = TRUE
[RequestAttributes]
CertificateTemplate=Temp_name
"@
write-Host "Certificate Request is being generated `r "
$INF | out-file -filepath $INFPath -force
certreq -new $INFPath $CSRPath 
certreq -attrib "CertificateTemplate:Temp_name" -submit -config "ca.domain.com\ca" $CSRPath $CERPath $PFXPath 
certreq -accept $CERPath


#Export Cer
$mycrtpwd = ConvertTo-SecureString -String $cert_password -Force -AsPlainText
Get-ChildItem -Path Cert:\CurrentUser\My\* | Export-PfxCertificate -FilePath $PFXPath -Password $mycrtpwd

          # If cert is created, show message.
        Write-Host "The user cert has been generated" -ForegroundColor Cyan
    }
 