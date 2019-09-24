#Set-StrictMode -Version 1.0

[Flags()] enum metricAggregation {
    Sum   = 1
    Min   = 2
    Max   = 3
    Avg   = 4
    Count = 7
}

[Flags()] enum metricType {
    Percentage_CPU
    CPU_Credits_Consumed
    CPU_Credits_Remaining
}

function Get-TransposedStringFromMetricType {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [metricType] $metricType
    )
    return "$([string]$metricType)".Replace("_"," ");
}

function Get-ResourceDefinition_virtualMachine {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $subscriptionId,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $resourceGroup,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $computerName,
        [Parameter(Mandatory = $true, Position = 3)]
        [metricAggregation] $metricAggregation,
        [Parameter(Mandatory = $true, Position = 4)]
        [metricType] $metricType,
        [Parameter(Mandatory = $true, Position = 5)]
        [string] $Color
    )

    <#
    Write-Host "subscriptionId: `t$($subscriptionId)";
    Write-Host "Computer Name: `t`t$($computerName)";
    Write-Host "Color: `t`t`t$($Color)";
    #>

    
    #return '{"id":{"resourceDefinition":{"id":"/subscriptions/' + $($subscriptionId) + '/resourceGroups/' + $resourceGroup + '/providers/Microsoft.Compute/virtualMachines/' + $($computerName) + '"},"name":{"id":"CPU Credits Consumed","displayName":"CPU Credits Consumed"},"namespace":{"name":"microsoft.compute/virtualmachines"}},"metricAggregation":' + $([int]$metricAggregation) + ',"color":"' + $($Color) + '"}'
    $metricType_String = $(Get-TransposedStringFromMetricType -metricType $metricType).Replace("_"," ");
    return '{"id":{"resourceDefinition":{"id":"/subscriptions/' + $($subscriptionId) + '/resourceGroups/' + $resourceGroup + '/providers/Microsoft.Compute/virtualMachines/' + $($computerName) + '"},"name":{"id":"' + $($metricType_String) + '","displayName":"' + $($metricType_String) + '"},"namespace":{"name":"microsoft.compute/virtualmachines"}},"metricAggregation":' + $([int]$metricAggregation) + ',"color":"' + $($Color) + '"}'
}

function Get-ResourceDefinition {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $subscriptionId,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $resourceGroup,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $computerNamePrefix,
        [Parameter(Mandatory = $true, Position = 3)]
        [int] $ComputerCount,
        [Parameter(Mandatory = $true, Position = 4)]
        [metricAggregation] $metricAggregation,
        [Parameter(Mandatory = $true, Position = 5)]
        [metricType] $metricType,
        [Parameter(Mandatory = $false, Position = 6)]
        [string] $Color = '#47BDF5'
    )

    [string]    $AzPortalChart = '';
    [string]    $AzPortalChart_Body = '';
    [string]    $AzPortalChart_Suffix = '';

    [string]    $computerName = '';

    $AzPortalChart_Prefix = '{"charts":[{"aggregation":1,"appliedISOGrain":"PT5M","metrics":[';

    for ($ComputerNumber = 1; $ComputerNumber -le $ComputerCount; $ComputerNumber++) {
        [string] $computerName = $computerNamePrefix + $ComputerNumber.ToString("00");
        $AzPortalChart_Body += Get-ResourceDefinition_virtualMachine -subscriptionId $subscriptionId -computerName $computerName -resourceGroup $resourceGroup -metricAggregation $metricAggregation -metricType $metricType -Color $Color
        if ($ComputerNumber -ne $ComputerCount) { $AzPortalChart_Body += ',' };
    }

    $metricType_String = $(Get-TransposedStringFromMetricType -metricType $metricType).Replace("_"," ");
    $AzPortalChart_Suffix = '],"title":"' + $metricAggregation + ' ' + $($metricType_String) + ' for ' + $computerNamePrefix + '","version":{"major":1,"minor":0,"build":0}}]}';

    $AzPortalChart = $AzPortalChart_Prefix;
    $AzPortalChart += $AzPortalChart_Body;
    $AzPortalChart += $AzPortalChart_Suffix;

    $AzPortalChart;

    Remove-Variable AzPortalChart;
    Remove-Variable AzPortalChart_Body;
    Remove-Variable AzPortalChart_Suffix;
    Remove-Variable computerName;
    Remove-Variable ComputerNumber;
    Remove-Variable ComputerCount;
}

function Get-UrlForChart {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $subscriptionId,
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $resourceGroup,
        [Parameter(Mandatory = $true, Position = 2)]
        [string] $computerNamePrefix,
        [Parameter(Mandatory = $true, Position = 3)]
        [int] $ComputerCount,
        [Parameter(Mandatory = $false, Position = 4)]
        [metricAggregation]
        [metricAggregation] $metricAggregation,
        [Parameter(Mandatory = $false, Position = 5)]
        [metricType]
        [metricType] $metricType,
        [Parameter(Mandatory = $false, Position = 6)]
        [string] $Color = '#47BDF5'
    )

    <#
    Write-Host "metricAggregation: $($metricAggregation)"
    Write-Host "metricAggregation: $([int]$metricAggregation)"
    #>

    $ResourceDefinition             = Get-ResourceDefinition -subscriptionId $subscriptionId -resourceGroup $resourceGroup -computerNamePrefix $computerNamePrefix -ComputerCount $ComputerCount -metricAggregation $metricAggregation -metricType $metricType -Color $Color;
    $ResourceDefinition_Escaped     = [uri]::EscapeDataString($ResourceDefinition)
    return 'https://portal.azure.com#blade/Microsoft_Azure_Monitoring/MetricsBladeV3/Referer/MetricsExplorer/ResourceId/%2Fsubscriptions%2' + $($subscriptionId) + '%2FresourceGroups%2F' + $resourceGroup +'%2Fproviders%2FMicrosoft.Compute%2FvirtualMachines%2F' + $computerNamePrefix + '/TimeContext/%7B%22options%22%3A%7B%22grain%22%3A1%7D%2C%22relative%22%3A%7B%22duration%22%3A86400000%7D%7D/ChartDefinition/' + $ResourceDefinition_Escaped
}
