# azure-metricsmonitordash

Scripts to automatically create urls for Azure's Metrics Monitor Dashboard

Example usage:

```powershell
cls;
.\Get-AzPortalChart.ps1;

Get-UrlForChart `
    -subscriptionId 'your-subscription-guid-goes-here' `
    -resourceGroup 'resourcegroupname' `
    -computerNamePrefix 'prefix-of-storageaccounts' `
    -ComputerCount 14 `
    -metricAggregation Sum  `
    -metricType Transactions  `
    -NumberStartsAt 0;
```

This assumes your virtual machines are in a numbered order, ie:

* prefix-of-webservers01
* prefix-of-webservers02
* prefix-of-webservers03

..

* prefix-of-webservers13
* prefix-of-webservers14
