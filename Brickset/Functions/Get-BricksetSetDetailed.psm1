﻿function Get-BricksetSetDetailed {
<#
    .SYNOPSIS
    Get Brickset Set Detailed
    
    .DESCRIPTION
    Get Brickset Set with detailed info
    
    .PARAMETER APIKey
    API Key

    .PARAMETER SetId
    Brickset SetId (not the Lego Set Number)

    .INPUTS
    System.String.

    .OUTPUTS
    Brickset.sets

    .EXAMPLE
    Get-BricksetSetDetailed -APIKey 'Tk5C-KTA2-Gw2Q' -SetId 6905

    .EXAMPLE
    Get-BricksetSet -Theme 'Indiana Jones' | Get-BricksetSetDetailed
#>
[CmdletBinding()][OutputType('Brickset.sets')]

    Param
    (

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$APIKey,

    [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$SetId
    )

begin {

    # --- If $APIKey not supplied, try $Global:BricksetAPIKey

    if (!($PSBoundParameters.ContainsKey('APIKey'))){
            
        try {
    
            Get-Variable BricksetAPIKey | Out-Null
            $APIKey = $BricksetAPIKey
        }
        catch [Exception] {

            throw 'Brickset API Key not specified nor exists in $Global:BricksetAPIKey. Please set this to continue'
        }
    }

    # --- Make the Webservice Call
    if (!($Webservice)){

        $Global:Webservice = New-WebServiceProxy -Uri 'http://brickset.com/api/v2.asmx?WSDL' -Namespace 'Brickset' -Class 'Sets'
    }
}
process {
    
    try {
    
        $Webservice.getSet($APIKey,$null,$SetId)
    }
    catch [Exception]{
        
        throw "Unable to get Brickset Set"
    }
}
}