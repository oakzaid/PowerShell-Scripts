<#
.Synopsis
   Short Description 
   This function will gather basic computer information 
.DESCRIPTION
   Long description
   This function will gather basic information from 
   multiple computers and provide error logging information
.Parameter ComputerName
This parameter supports multiple computer names to gather
Data from. This parameter is mandatory
.EXAMPLE
Getting information from the local computer
Get-CompInfo -Computername
.EXAMPLE
Getting information from remote computers
Get-CompInfo -Computername comp1,comp2
.Example
Getting information from computers in a text file
Get-content c:\servers.txt | Get-CompInfo
.Example
Get-CompInfo -Hostname localhost

ComputerName  OS name                   OS Build FreeSpace
------------- --------                  -------- ---------
localhost     Microsoft Windows 10 Home 19044          118
#>
Function Get-CompInfo{
    [CmdletBinding()]
    Param(
        #want to support multiple computer so use []
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [String[]]$ComputerName,
        #Switch to turn on error logging
        [Switch]$ErrorLog,
        [String]$LogFile = 'C:\errorlog.txt'
    )
    Begin{
        if($ErrorLog){
            Write-Verbose 'Error logging turned on'
        }Else {
            Write-Verbose 'Error logging turned off'
        }
        foreach($Computer in $ComputerName){
            Write-Verbose "Computer: $Computer"
        }
    }
    Process{
        foreach($Computer in $ComputerName){
            $os = Get-WmiObject -ComputerName $Computer -Class Win32_operatingsystem
            $Disk = Get-WmiObject -ComputerName $Computer -Class win32_LogicalDisk -Filter "DeviceID = 'c:'"

        
            $Prop=[Ordered]@{
                'ComputerName ' = $Computer
                'OS name ' = $os.caption
                'OS Build' = $os.buildnumber
                'FreeSpace' = $Disk.freespace / 1gb -as [int]
                 
            }
            
        # Lets create an object that we can send down the pipleine then
        # that people can use select , where,  etc
        # we will assign methods and properties to it
        $obj = New-Object -TypeName PSObject -Property $Prop
        Write-Output $obj     
        }
    
    }
    End{}
    

}


Function Set-VolLabel{
                    #This lets you do whatif and confirm
    [CmdletBinding(SupportsShouldProcess=$true,
                    #now if $ConfirmPreference is set to medium then it will trigger the popup window
                    confirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [Parameter(Mandatory=$true)]
        [string]$Label
    )
    Process{
    
        if($PSCmdlet.ShouldProcess("$ComputerName - label change to $Label"))
        
        {
            $volname = Get-WmiObject -Class win32_logicalDisk -Filter "DeviceID = 'c:'" -ComputerName localhost
            $volname.volumeName = "$Label"
            $volname.Put() | Out-Null
        }
    }
}

Function Get-Fun1{
    Write-Output "Powershell is fun"
    }

Function Get-Fun2{
    Write-Output "Powershell is really really really cool"}