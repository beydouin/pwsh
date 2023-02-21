<#
# update_custom_attributes.ps1
# Khurram.Subhani@ssc-spc.gc.ca
# 2023-02-20
# v1.0
# 
# A script to update multiple 'Custom Attributes' on multiple esxi virtual 
#  machines. You will need to populate file in the current location called
#  servers.txt; One server per line.
# 
# Should you need to remove the custom attributes from all of them, run
#  the script again but do not enter any value when prompted. Also, note to
#  make sure you uncomment line 37 before running it.
#>

# Path to list of servers file
$servers= Get-Content .\servers.txt

# Ask users for value of annotation
$build_date=Read-Host -Prompt "[E]nter Build Date"
$department_owner=Read-Host -Prompt "[E]nter Department Owner"
$department_ownership=Read-Host -Prompt "[E]nter Department Ownership"
$inital_brd=Read-Host -Prompt "[E]nter Inital BRD"
$project_code=Read-Host -Prompt "[E]nter Project Code"
$project_description=Read-Host -Prompt "[E]nter Project Description"
#$srm_com=Read-Host -Prompt "[E]nter SRM-com.vmware.vcDr:::protected"
$support_group=Read-Host -Prompt "[E]nter Support Group"

# List thru each server and set annotation
foreach ($server in $servers) {
  $servertype=$server.substring(5,1)
  
  # Label 'state' based on substring character taken from $servertype
  if ( $servertype -eq "t" -or $servertype -eq "a" -or $servertype -eq "e" -or $servertype -eq "o" -or $servertype -eq "h" -or $servertype -eq "j" -or $servertype -eq "l") {
    $state="TRANSITIONAL"
  } elseif ( $servertype -eq "p" -or $servertype -eq "f" -or $servertype -eq "w" -or $servertype -eq "k" -or $servertype -eq "c") {
    $state="PRODUCTION"
  } elseif ( $servertype -eq "i" -or $servertype -eq "q") {
    $state="PRE-DEVELOPMENT"
  } elseif ($servertype -eq "d" -or $servertype -eq "u" -or $servertype -eq "s" -or $servertype -eq "y") {
    $state="DEVELOPMENT"
  } elseif ($servertype -eq "z") {
	$state="LAB"
  } else { $state="INVALID OPTION: $servertype" }
  
  # clear the below state if you need to clean out the attributes
  #$state=""
  
  # setting the attributes
  Set-Annotation -Entity $server -CustomAttribute "Build Date" -Value "$build_date"
  Set-Annotation -Entity $server -CustomAttribute "Department Owner" -Value "$department_owner"
  Set-Annotation -Entity $server -CustomAttribute "Department Ownership" -Value "$department_ownership"
  Set-Annotation -Entity $server -CustomAttribute "Initial BRD" -Value "$inital_brd"
  Set-Annotation -Entity $server -CustomAttribute "Project Code" -Value "$project_code"
  Set-Annotation -Entity $server -CustomAttribute "Project Description" -Value "$project_description"
  #Set-Annotation -Entity $server -CustomAttribute "SRM-com.vmware.vcDr:::protected" -Value "$srm_com"
  Set-Annotation -Entity $server -CustomAttribute "State" -Value "$state"
  Set-Annotation -Entity $server -CustomAttribute "Support Group" -Value "$support_group"
  
  # write an empty line
  write-output "`n"
}
