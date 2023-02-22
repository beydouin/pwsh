# Connect to ESXi host
#Connect-VIServer -Server $ESXiHost

$vmNames = Read-Host "Enter virtual machine hostnames (separated by comma)"
$vmNames = $vmNames.Split(",")

$Attributes = @{}
$attributeNames = @("Build Date","Department Owner","Department Ownership","Initial BRD","Project Code","Project Description","Support Group")
foreach ($name in $attributeNames) {
    $value = Read-Host "Enter value for $name"
    $Attributes.Add($name, $value)
}

ForEach ($vmName in $vmNames) {
    $state = $vmName.Substring(5,1).ToLower()
    switch ($state) {
        {($_ -eq "t") -or ($_ -eq "a") -or ($_ -eq "e") -or ($_ -eq "o") -or ($_ -eq "h") -or ($_ -eq "j") -or ($_ -eq "l")} { $Attributes['State'] = 'TRANSITIONAL' }
        {($_ -eq "p") -or ($_ -eq "f") -or ($_ -eq "w") -or ($_ -eq "k") -or ($_ -eq "c")} { $Attributes['State'] = 'PRODUCTION' }
        {($_ -eq "d") -or ($_ -eq "u") -or ($_ -eq "s") -or ($_ -eq "y")} { $Attributes['State'] = 'DEVELOPMENT' }
        {($_ -eq "i") -or ($_ -eq "q")} { $Attributes['State'] = 'PRE-DEVELOPMENT' }
        'z' { $Attributes['State'] = 'LAB' }
        default { $Attributes['State'] = "INVALID OPTION: $servertype" }
    }

    foreach ($key in $Attributes.Keys) {
        $value = $Attributes[$key]
        Write-Host "Set-Annotation -Entity $vmName -CustomAttribute "$key" -Value "$value""
    }
}