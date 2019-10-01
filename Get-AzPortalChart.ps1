#Set-StrictMode -Version 1.0

<#
ENUM's for Parameters
#>
[Flags()] enum metricAggregation {
    Sum = 1
    Min = 2
    Max = 3
    Avg = 4
    Count = 7
}

[Flags()] enum metricType {
    Percentage_CPU
    CPU_Credits_Consumed
    CPU_Credits_Remaining

    Used_Capacity
    Blob_Capacity
    Container_Count
    Blob_Count
    Index_Capacity
    Availability
    Egress
    Ingress
    SuccessE2ELatency
    SuccessServerLatency
    Transactions
}

<#
Helper Class
$v2Chart = [v2charts_TypeInformation]::New();
#>
class v2charts_TypeInformation {
    [string] $metrics_name
    [string] $metrics_namespace
    [string] $metricVisualization_displayName
    [string] $title
    [string] $providers
}

<#
Helper Functions
#>

function Get-TransposedStringFromMetricType {
    [OutputType([v2charts_TypeInformation])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [metricType] $metricType,
        [Parameter(Mandatory = $true, Position = 0)]
        [metricAggregation] $metricAggregation
    )
    
    #[string] $_MetricType = "";

    #$v2charts_TypeInformation = New-Object $v2charts_TypeInformation;
    $v2charts_TypeInformation = [v2charts_TypeInformation]::New();

    switch ($metricType) {
        <#
Virtual Machines - CPU
#>
        "Percentage_CPU" {
            $v2charts_TypeInformation.metrics_name = "Percentage CPU";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.compute/virtualmachines";
            $v2charts_TypeInformation.metricVisualization_displayName = "Percentage CPU";
            $v2charts_TypeInformation.title = "$($metricAggregation) Percentage CPU";
            $v2charts_TypeInformation.providers = "Microsoft.Compute/virtualMachines";
        }
        "CPU_Credits_Consumed" {
            $v2charts_TypeInformation.metrics_name = "CPU Credits Consumed";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.compute/virtualmachines";
            $v2charts_TypeInformation.metricVisualization_displayName = "CPU Credits Consumed";
            $v2charts_TypeInformation.title = "$($metricAggregation) CPU Credits Consumed";
            $v2charts_TypeInformation.providers = "Microsoft.Compute/virtualMachines";
        }
        "CPU_Credits_Remaining" {
            $v2charts_TypeInformation.metrics_name = "CPU Credits Remaining";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.compute/virtualmachines";
            $v2charts_TypeInformation.metricVisualization_displayName = "CPU Credits Remaining";
            $v2charts_TypeInformation.title = "$($metricAggregation) CPU Credits Remaining";
            $v2charts_TypeInformation.providers = "Microsoft.Compute/virtualMachines";
        }
        <#
Storage Account
#>

        <#
CAPACITY
#>
        
<#
    Available $metricAggregation = Avg
#>
"Used_Capacity" {
    $metricAggregation = "Avg";
    $v2charts_TypeInformation.metrics_name = "UsedCapacity";
    $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
    $v2charts_TypeInformation.metricVisualization_displayName = "Used Capacity";
    $v2charts_TypeInformation.title = "$($metricAggregation) Used Capacity";
    $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
}

        <#
Storage Account - Blob
#>

        <#
CAPACITY
ALl metrics in this category accept only a $metricAggregation of: Avg
#>
"Blob_Capacity" {
    $metricAggregation = "Avg";
    $v2charts_TypeInformation.metrics_name = "BlobCapacity";
    $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
    $v2charts_TypeInformation.metricVisualization_displayName = "Blob Capacity";
    $v2charts_TypeInformation.title = "$($metricAggregation) Blob Capacity";
    $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
}

        "Blob_Container_Count" {
            $metricAggregation = "Avg";
            $v2charts_TypeInformation.metrics_name = "ContainerCount";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Blob Container Count";
            $v2charts_TypeInformation.title = "$($metricAggregation) Success E2E Latency";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        "Blob_Count" {
            $metricAggregation = "Avg";
            $v2charts_TypeInformation.metrics_name = "BlobCount";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Blob Count";
            $v2charts_TypeInformation.title = "$($metricAggregation) Blob Count";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        "Index_Capacity" {
            $metricAggregation = "Avg";
            $v2charts_TypeInformation.metrics_name = "IndexCapacity";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Index Capacity";
            $v2charts_TypeInformation.title = "$($metricAggregation) Index Capacity";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        <#
TRANSACTION
ALl metrics in this category accept varying values for $metricAggregation.
#>

        <#
    Available $metricAggregation = Avg, Min, Max
#>
        "Availability" {
            $v2charts_TypeInformation.metrics_name = "Availability";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Availability";
            $v2charts_TypeInformation.title = "$($metricAggregation) Availability";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        <#
    Available $metricAggregation = Sum, Avg, Min, Max
#>
        "Egress" {
            $v2charts_TypeInformation.metrics_name = "Egress";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Egress";
            $v2charts_TypeInformation.title = "$($metricAggregation) Egress";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        <#
    Available $metricAggregation = Sum, Avg, Min, Max
#>
        "Ingress" {
            $v2charts_TypeInformation.metrics_name = "Ingress";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Ingress";
            $v2charts_TypeInformation.title = "$($metricAggregation) Ingress";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        <#
    Available $metricAggregation = Avg, Min, Max
#>
        "SuccessE2ELatency" {
            $v2charts_TypeInformation.metrics_name = "SuccessE2ELatency";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "SuccessE2ELatency";
            $v2charts_TypeInformation.title = "$($metricAggregation) SuccessE2ELatency";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        <#
    Available $metricAggregation = Avg, Min, Max
#>
        "SuccessServerLatency" {
            $v2charts_TypeInformation.metrics_name = "SuccessServerLatency";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "SuccessServerLatency";
            $v2charts_TypeInformation.title = "$($metricAggregation) SuccessServerLatency";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }

        <#
    Available $metricAggregation = Sum
#>
        "Transactions" {
            $v2charts_TypeInformation.metrics_name = "Transactions";
            $v2charts_TypeInformation.metrics_namespace = "microsoft.storage/storageaccounts";
            $v2charts_TypeInformation.metricVisualization_displayName = "Transactions";
            $v2charts_TypeInformation.title = "$($metricAggregation) Transactions";
            $v2charts_TypeInformation.providers = "Microsoft.Storage/storageAccounts";
        }



        default {
            write-host "I'm default for some reason"
            "$([string]$metricType)".Replace("_", " ")
        }
    }
    
    #return $_MetricType;
    return $v2charts_TypeInformation;
}

function Get-ResourceDefinition_MetricsBladeV3 {
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
        [string] $Color,
        [Parameter(Mandatory = $false, Position = 6)]
        [int] $NumberStartsAt = 1
    )

    <#
    Write-Host "subscriptionId: `t$($subscriptionId)";
    Write-Host "Computer Name: `t`t$($computerName)";
    Write-Host "Color: `t`t`t$($Color)";
    #>

    
    $v2charts_TypeInformation = $(Get-TransposedStringFromMetricType -metricType $metricType -metricAggregation $metricAggregation);

    
    return '{' `
        + '"id":{"resourceDefinition":{' `
        + '"id":"/subscriptions/' + $($subscriptionId) `
        + '/resourceGroups/' + $resourceGroup `
        + '/providers/' + $($v2charts_TypeInformation.providers) + '/' + $($computerName) + '"},' `
        + '"name":{"id":"' + $($v2charts_TypeInformation.metrics_name) + '",' `
        + '"displayName":"' + $($v2charts_TypeInformation.metricVisualization_displayName) + '"},' `
        + '"namespace":{"name":"' + $($v2charts_TypeInformation.metrics_namespace) + '"}},' `
        + '"metricAggregation":' + $([int]$metricAggregation) + ',' `
        + '"color":"' + $($Color) + `
        '"}'

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
        [string] $Color = '#47BDF5',
        [Parameter(Mandatory = $false, Position = 7)]
        [int] $NumberStartsAt = 1
    )

    [string]    $AzPortalChart = '';
    [string]    $AzPortalChart_Body = '';
    [string]    $AzPortalChart_Suffix = '';

    [string]    $computerName = '';

    $AzPortalChart_Prefix = '{"charts":[{"aggregation":1,"appliedISOGrain":"PT5M","metrics":[';

    for ($ResourceName_Number = $NumberStartsAt; $ResourceName_Number -le $ComputerCount; $ResourceName_Number++) {
        [string] $computerName = $computerNamePrefix + $ResourceName_Number.ToString("00");
        $AzPortalChart_Body += Get-ResourceDefinition_MetricsBladeV3 -subscriptionId $subscriptionId -computerName $computerName -resourceGroup $resourceGroup -metricAggregation $metricAggregation -metricType $metricType -Color $Color -NumberStartsAt $NumberStartsAt
        if ($ResourceName_Number -ne $ComputerCount) { $AzPortalChart_Body += ',' };
    }

    $v2charts_TypeInformation = $(Get-TransposedStringFromMetricType -metricType $metricType -metricAggregation $metricAggregation);
    

    $AzPortalChart_Suffix = '],"title":"' + $metricAggregation + ' ' + $($v2charts_TypeInformation.metricVisualization_displayName) + ' for ' + $computerNamePrefix + '","version":{"major":1,"minor":0,"build":0}}]}';

    $AzPortalChart = $AzPortalChart_Prefix;
    $AzPortalChart += $AzPortalChart_Body;
    $AzPortalChart += $AzPortalChart_Suffix;

    $AzPortalChart;

    Remove-Variable AzPortalChart;
    Remove-Variable AzPortalChart_Body;
    Remove-Variable AzPortalChart_Suffix;
    Remove-Variable computerName;
    Remove-Variable ResourceName_Number;
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
        [string] $Color = '#47BDF5',
        [Parameter(Mandatory = $false, Position = 7)]
        [int] $NumberStartsAt = 1
        
    )

    <#
    Write-Host "metricAggregation: $($metricAggregation)"
    Write-Host "metricAggregation: $([int]$metricAggregation)"
    #>

    $v2charts_TypeInformation = $(Get-TransposedStringFromMetricType -metricType $metricType -metricAggregation $metricAggregation);

    $ResourceDefinition = Get-ResourceDefinition -subscriptionId $subscriptionId -resourceGroup $resourceGroup -computerNamePrefix $computerNamePrefix -ComputerCount $ComputerCount -metricAggregation $metricAggregation -metricType $metricType -Color $Color -NumberStartsAt $NumberStartsAt;
    $ResourceDefinition_Escaped = [uri]::EscapeDataString($ResourceDefinition)

    $providers = ('/providers/' + $($v2charts_TypeInformation.providers) + '/');
    $providers_Escaped = [uri]::EscapeDataString($providers);

    return 'https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/MetricsBladeV3/Referer/MetricsExplorer/ResourceId/%2Fsubscriptions%2F' + $($subscriptionId) `
    + '%2FresourceGroups%2F' + $resourceGroup `
    + $providers_Escaped + $computerNamePrefix + '00' `
    + '/TimeContext/%7B%22options%22%3A%7B%22grain%22%3A1%7D%2C%22relative%22%3A%7B%22duration%22%3A86400000%7D%7D/ChartDefinition/' + $ResourceDefinition_Escaped
}
