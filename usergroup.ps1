
Param
(
    [Parameter(Mandatory = $true)]
    [String]$group,

    [Parameter()]
    [String[]]$users = $env:USERNAME,
    
    [Parameter()]
    [switch]$OutPutfile,

    [Parameter()]
    [String]$filename='output.csv'

)

#check the VPN is connected on not, intead of range 10* you can put your VPN ip address, and also if you are running this on remote server you can remove this check.

$checkconn = Get-NetIPAddress -IPAddress 10*
if ( ! $checkconn ){
    Write-Host "Please connect to VPN to proceed" -ForegroundColor red
    Write-Host "Exiting the current execution..." -ForegroundColor red
    exit;
}

# Split the parameter value array into strings
$user = ($users -split ',').Trim()

if($OutPutfile.IsPresent){
    foreach($itr in $user){
        Write-Host `r
        Write-Host "++++++++++++"
        Write-Host "Fetching groups details for User : "$itr -ForegroundColor yellow
        $grp= (Get-ADUser $itr -Properties memberof | Select-Object MemberOf).memberof
        foreach($itr1 in $grp.split([Environment]::NewLine)){
            if($itr1 -match $group){
                $userdetails = [pscustomobject]@{
                    UserID = $itr
                    GroupName = ($itr1.split(',')[0]).split('=')[1]
                }
                $userdetails | Export-Csv -Path $filename -NoTypeInformation -Append
            }
        }
    }
    Write-Host `r
    $msg="Content added to file "+$(pwd)+'\'+$filename
    Write-Host $msg -ForegroundColor blue -BackgroundColor white
}
else{
    foreach($itr in $user){
        Write-Host `r
        Write-Host "++++++++++++"
        Write-Host "User Name: "$itr -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "Applicable group names: "
        $grp= (Get-ADUser $itr -Properties memberof | Select-Object MemberOf).memberof
        foreach($itr1 in $grp.split([Environment]::NewLine)){
            if($itr1 -match $group){
                Write-Host ($itr1.split(',')[0]).split('=')[1] -ForegroundColor Blue -BackgroundColor Black
            }
        }
    }
}
