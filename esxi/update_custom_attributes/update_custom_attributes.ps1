<#
# update_custom_attributes.ps1
# Khurram.Subhani@live.com
# 2023-02-22
# v3.0.2
# 
# A script to update multiple 'Custom Attributes' on multiple esxi virtual 
#  machines. You will need to populate file in the current location called
#  servers.txt; One server per line.
# 
# Should you need to remove the custom attributes from all of them, run
#  the script again but do not enter any value when prompted. Also, note to
#  make sure you uncomment line 37 before running it.
#>

# Use a list of servers in a file
vmNames = Get-Content .\servers.txt

$Attributes = @{}
$attributeNames = @("Build Date","Department Owner","Department Ownership","Initial BRD","Project Code","Project Description","Support Group")
foreach ($name in $attributeNames) {
    $value = Read-Host "[E]nter value for $name"
    $Attributes.Add($name, $value)
}

foreach ($vmName in $vmNames) {
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
        Set-Annotation -Entity $vmName -CustomAttribute "$key" -Value "$value"
    }

    # write an empty line
    Write-Output "`n"
}