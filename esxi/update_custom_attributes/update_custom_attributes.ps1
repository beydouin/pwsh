<#
# update_custom_attributes.ps1
# Khurram.Subhani@live.com
# 2023-02-20
# v2.0.0
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

# Specify an array of keys
$keys=@("Build Date","Department Owner","Department Ownership","Initial BRD","Project Code","Project Description","Support Group")

# Array of values will get populated via for loop
$values=@()

# Ask users for value of each key specified
for ($i=0;$i -le $keys.Length-1;$i++) {
	$thekey=$keys[$i]
	if ($thekey -ne "State") {
		$values += Read-Host -Prompt "[E]nter $thekey"
	}
}

# List thru each server and set annotation
foreach ($server in $servers) {
  $servertype=$server.substring(5,1)
  $state=""
  
  # Label 'state' based on substring character taken from $servertype
  switch ($servertype) {
	  {($_ -eq "t") -or ($_ -eq "a") -or ($_ -eq "e") -or ($_ -eq "o") -or ($_ -eq "h") -or ($_ -eq "j") -or ($_ -eq "l")} {$state="TRANSITIONAL"; break}
	  {($_ -eq "p") -or ($_ -eq "f") -or ($_ -eq "w") -or ($_ -eq "k") -or ($_ -eq "c")} {$state="PRODUCTION"; break}
	  {($_ -eq "d") -or ($_ -eq "u") -or ($_ -eq "s") -or ($_ -eq "y")} {$state="DEVELOPMENT"; break}
	  {($_ -eq "i") -or ($_ -eq "q")} {$state="PRE-DEVELOPMENT"; break}
	  "z" {$state="LAB"; break}
	  default {$state="INVALID OPTION: $servertype" }
  }
  
  # setting the attributes
  for ($i=0;$i -le $keys.Length-1;$i++){
	  for ($j=0;$j -le $values.Length-1;$j++) {
		  $thekey=$keys[$i]
		  $thevalue=$values[$j]
		  
		  if ($i -eq $j) {
			  Set-Annotation -Entity $server -CustomAttribute "$thekey" -Value "$thevalue"
		  }
		  
	  }
  }
  Set-Annotation -Entity $server -CustomAttribute "State" -Value "$state"
  
  # write an empty line
  write-output "`n"
}
