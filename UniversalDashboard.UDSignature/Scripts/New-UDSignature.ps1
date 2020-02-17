<#
.SYNOPSIS
    Sample control for UniversalDashboard.
.DESCRIPTION
    Sample control function for UniversalDashboard. This function must have an ID and return a hash table.
.PARAMETER Id
    An id for the component default value will be generated by new-guid.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function New-UDSignature {
    param(
        [Parameter()]
        [string]$Id = (New-Guid).ToString(),
        [Parameter()]
        [string]$BackgroundColor = 'rgba(0,0,0,0)',
        [Parameter()]
        [string]$PenColor = 'black',
        [Parameter()]
        [int]$Width = 300,
        [Parameter()]
        [int]$Height = 150
    )

    End {

        @{
            # The AssetID of the main JS File
            assetId         = $AssetId
            # Tell UD this is a plugin
            isPlugin        = $true
            # This ID must be the same as the one used in the JavaScript to register the control with UD
            type            = "UD-Signature"
            # An ID is mandatory
            id              = $Id

            # This is where you can put any other properties. They are passed to the React control's props
            # The keys are case-sensitive in JS.
            backgroundColor = $BackgroundColor
            penColor        = $PenColor
            width           = $Width
            height          = $Height
        }

    }
}
