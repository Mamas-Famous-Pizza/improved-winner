<#
    .SYNOPSIS
    The purpose of this script is to enable a GitHub Action workflow to run the functional tests for one product.
    .EXAMPLE
    To run this script, call it from the root of the repo, like so: ./Testing/Functional/Products/Tests/CallProductTests.ps1 <params> <thumbprint>
#>

param(
    # The hashtable with the params.
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [boolean]$ReportErrors=$true,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]$Params,


    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$Filter="*",

    # The thumbprint of the cert used to access the product.
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Thumbprint
)

$TestScriptDir = 'Testing/Functional/Products'

# Add thumbprint to hashtable
$Params["Thumbprint"] = $Thumbprint

# Create an array of test containers
$TestContainers = @()
$TestContainers += New-PesterContainer -Path $TestScriptDir -Data $Params

$PesterConfig = @{
    Run = @{
        Container = $TestContainers
    }
    Filter = @{
        Tag = @($Filter)
    }
    Output = @{
        Verbosity = 'Detailed'
    }
    Debug = @{
        ShowFullErrors = $ReportErrors
        WriteDebugMessages = $ReportErrors
    }
}

$Config = New-PesterConfiguration -Hashtable $PesterConfig
Invoke-Pester -Configuration $Config
