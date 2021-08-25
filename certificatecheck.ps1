$urls = ''

#sets the callback to validate a server certificate.
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$minimumCertAgeDays = 60
$timeoutMilliseconds = 10000

foreach ($url in $urls){
    Write-Host Checking $url -f Green
    $req = [Net.HttpWebRequest]::Create($url)
    $req.Timeout = $timeoutMilliseconds
    $req.AllowAutoRedirect = $false

    try {
        $req.GetResponse() |Out-Null
    } catch {
        Write-Host Exception while checking URL $url`: $_ -f Red
    }

    $certExpiresOnString = $req.ServicePoint.Certificate.GetExpirationDateString()
    [datetime]$expiration = [System.DateTime]::Parse($req.ServicePoint.Certificate.GetExpirationDateString())
    [int]$certExpiresIn = ($expiration - $(get-date)).Days
    $certName = $req.ServicePoint.Certificate.GetName()

    if ($certExpiresIn -gt $minimumCertAgeDays){
        Write-Host Cert for site $url expires in $certExpiresIn days [on $expiration] -f Green
    } else{
        Write-Host WARNING: Cert for site $url expires in $certExpiresIn days [on $expiration] -f Red
    }
    Write-Host
    rv req
    rv expiration
    rv certExpiresIn
}
