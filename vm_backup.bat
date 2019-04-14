@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/: " %%a in ("%TIME%") do (if %%a LSS 10 (set mytime=0%%a%%b) else (set mytime=%%a%%b))
echo 'Backup VirtualBox VDI...'
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonemedium disk "C:\Virtual.Machines\CVM\CVM.vdi" "D:\VM_Backup\CVM-%mydate%_%mytime%.vdi" --format VDI
ForFiles /P "D:\VM_Backup" /S /D -3 /C "cmd /c del @file"
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\Users\Administrator\Documents\scripts\delete_inaccessible_vdis.ps1'"
echo Done.
