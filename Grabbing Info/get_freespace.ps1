<#
.Synopsis
This script gets you the storage space on the localhost(your computer) or remote computer for the C: drive
 
.Description
This will make things easier to grab storage information

.Parameter ComputerName
This is for remote and local computer

.Example
.\get_freespace_cdrive.ps1 -computername "Some name here"
Shows how to do it on a remote computer

#> 

function Get-DiskinfoBRO{

#This turns on the ability to use parameter attributes , For here it will serve the purpose of making things mandatory
[cmdletBinding()]

#paramitize so then script wont get edited
param(
    #Line 12 ONLY EFFECTS THE NEXT parameter after it SO IT WONT EFFECT $BOGUS VARIABLE
    [Parameter(Mandatory=$true)]
    [String[]]$ComputerName
)
#Gets us the free space on the c: drive in Gbs !
Get-WmiObject -ComputerName $ComputerName -class win32_logicaldisk -Filter "DeviceID = 'c:' " 
}