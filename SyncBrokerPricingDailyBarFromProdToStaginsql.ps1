
$sql=@"
SELECT MAX(createdon) maxcreatedon FROM dbo.brokerpricingdailybar
"@

$data= Invoke-Sqlcmd -Query $sql -ServerInstance 'stagingsql.hedgecovest.local' -Database 'HCVClone' -username "dpa_m" -password "Fr3^kyFr1d^y"

write-host $data.maxcreatedon

$maxcreatedon = $data.maxcreatedon
$maxcreatedon = $maxcreatedon.addseconds(1)

$query = "SELECT * FROM [dbo].[BrokerPricingDailyBar] where createdon > '" +   $maxcreatedon  + "'"

write-host $query

$params = @{
SqlInstance = 'ag1-listener.hedgecovest.local' #source
Destination = 'stagingsql.hedgecovest.local'
Database = 'HCV'
DestinationDatabase = 'HCVCLone'
Table = '[dbo].[BrokerPricingDailyBar]'
BatchSize=10000
Query = $query
}


Copy-DbaDbTableData @params