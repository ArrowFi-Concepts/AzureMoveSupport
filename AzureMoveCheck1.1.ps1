$uri = "https://raw.githubusercontent.com/tfitzmac/resource-capabilities/master/move-support-resources.csv"
Invoke-WebRequest -Uri $uri -OutFile .\moveSupported.csv

$moveSupported = Import-Csv -Path .\moveSupported.csv
$Azureresources = Import-Csv -Path .\Azureresources.csv
"Resource Name,Resource Type,Move Subscription" |Out-File -FilePath .\results.csv
foreach($resource in $Azureresources){
    foreach($support in $moveSupported){
        $test = $support.Resource.ToLower()
        if($resource."Resource Type" -like "*"+$test+"*") {
            write-host $resource.name "," $support."Move Subscription"
            $resource.name +","+$resource."Resource Type" +","+ $support."Move Subscription" | Out-File -FilePath .\results.csv -Append
            #if 0 write to issues.csv
            if(($support."Move Subscription") -eq 0){
                $resource.name +","+$resource."Resource Type" +","+ $support."Move Subscription" | Out-File -FilePath .\issues.csv -Append
            }
            #if virtualnetworkgateways write to issues.csv
            if($resource."Resource Type" -like "*virtualnetworkgateways*"){
                $resource.name +","+$resource."Resource Type" +","+ $support."Move Subscription" + " Yes except Basic SKU (https://learn.microsoft.com/fi-fi/azure/azure-resource-manager/management/move-limitations/networking-move-limitations)"| Out-File -FilePath .\issues.csv -Append
            }
            #if loadbalancers write to issues.csv
            if($resource."Resource Type" -like "*loadbalancers*"){
                $resource.name +","+$resource."Resource Type" +","+ $support."Move Subscription" + " Yes - Basic SKU, No - Standard SKU"| Out-File -FilePath .\issues.csv -Append
            }

        }

    }
}