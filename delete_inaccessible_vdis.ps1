# This program finds inaccessible VDI medium and close them
# Author: Hong Yan
# Email: contact@yanhong.ca

Write-Host "Listing hdds..."
# List all VirtualBox HDDs and save it to a temp file
& "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list hdds > $env:TEMP\backup_vdi_files.txt

# Split VDI medium information into an array
$vdiDescFileString = gc $env:TEMP\backup_vdi_files.txt | Out-String
$nl = [System.Environment]::NewLine
$vdiDescriptions = ($vdiDescFileString -split "$nl$nl")
Remove-Item -path $env:TEMP\backup_vdi_files.txt

# Traverse the array to find out inaccessible VDI mediums and close them
foreach ($vdiDescription in $vdiDescriptions) {
  if ($vdiDescription -match "inaccessible") {
    $regexStr = "[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}"
    if ($vdiDescription -match $regexStr) {
      $uuid = [regex]::Matches($vdiDescription, $regexStr).Groups[0].Value
      Write-Host "closemedium $uuid"
      & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" closemedium disk $uuid
    }
  }
}
