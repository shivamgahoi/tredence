# Connect-AzAccount
# The SubscriptionId in which to create these objects
$SubscriptionId = '4ecd28a4-cf3a-48a9-9731-3e41a5d56c9e'
# Set the resource group name and location for your server
$resourceGroupName = "shivamsqldbrg"
$location = "westus"
# Set an admin login and password for your server
$adminSqlLogin = "shivamgahoi"
$password = "monikagupta@1996"
# Set server name - the logical server name has to be unique in the system
$serverName = "shivamsqldbserver"
# The sample database name
$databaseName = "shivamdb"
# The ip address range that you want to allow to access your server
$startIp = "0.0.0.0"
$endIp = "0.0.0.0"

# Set subscription 
Set-AzContext -SubscriptionId $subscriptionId 

# Create a resource group
$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a server with a system wide unique server name
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

# Create a server firewall rule that allows access from the specified IP range
$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp

# Create a blank database with an S0 performance level
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -RequestedServiceObjectiveName "S0" `
    -SampleName "AdventureWorksLT"

# Clean up deployment 
# Remove-AzResourceGroup -ResourceGroupName $resourceGroupName