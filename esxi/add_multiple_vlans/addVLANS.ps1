# AddVLANS.ps1
# ksubhani@globeandmail.com
# 2024-12-09
# Adds multiple vlans to esxi host.
# Make sure that this script is executed in the same directory as vlans.csv
# If you are going to run this script again for another host, kill the
# current powershell prompt and start it again, else it will fail.

# ESXi host to connect to (make sure to change below with ip or host)
$esxihost = "10.230.34.169"

# vlans csv file location (make sure the file exists in the same directory as 
# this script)
$vlansfile="vlans.csv"

############### DO NOT EDIT BELOW ##############################################

# Prompt for credentials securely
Write-Host "Prompting for credentials..."
$credential = Get-Credential
 
Write-Host "Connecting to ESXi host..."
$connection = Connect-VIServer -Server $esxihost -Credential $credential

if ($connection) {
    Write-Host "Connected to ESXi host."
} else {
    Write-Host "Failed to connect to ESXi host."
    exit
}

# Import the VLANs from the CSV file
Write-Host "Importing VLANs from CSV file..."
$vlans = Import-Csv -Path $vlansfile

if ($vlans) {
    Write-Host "VLANs imported successfully."
} else {
    Write-Host "No VLANs found. Please check the CSV file path."
    exit
}

$virtualSwitchName = "vSwitch0"  # Replace with your actual virtual switch name

foreach ($vlan in $vlans) {
    Write-Host "Adding VLAN Name: $($vlan.VlanName) with ID: $($vlan.VlanId)"
    
    try {
        New-VirtualPortGroup -VirtualSwitch $virtualSwitchName -Name $vlan.VlanName -VlanId $vlan.VlanId -Confirm:$false
        Write-Host "Successfully added VLAN: $($vlan.VlanName) with ID: $($vlan.VlanId)"
    } catch {
        Write-Host "Failed to add VLAN: $($vlan.VlanName) with ID: $($vlan.VlanId). Error: $_"
    }
}

Disconnect-VIServer -Confirm:$false
Write-Host "Disconnected from ESXi host."

