$resourceGroupName = "ADFQuickStartRG"
$ResGrp = New-AzResourceGroup $resourceGroupName -location 'East US'
$dataFactoryName = "shivamdatafactory"
$DataFactory = Set-AzDataFactoryV2 -ResourceGroupName $ResGrp.ResourceGroupName `
    -Location $ResGrp.Location -Name $dataFactoryName
