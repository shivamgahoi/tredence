$resourceGroupName = "ADFQuickStartRG"
$ResGrp = New-AzResourceGroup $resourceGroupName -location 'East US'
$dataFactoryName = "shivamdatafactory"
$DataFactory = Set-AzDataFactoryV2 -ResourceGroupName $ResGrp.ResourceGroupName `
    -Location $ResGrp.Location -Name $dataFactoryName

Set-AzDataFactoryV2LinkedService -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName -Name "AzureStorageLinkedService" `
    -DefinitionFile ".\AzureStorageLinkedService.json"

Set-AzDataFactoryV2LinkedService -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName -Name "AzureSqlDbLinkedService" `
    -DefinitionFile ".\AzureSqlDbLinkedService.json"

Set-AzDataFactoryV2Dataset -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName -Name "BlobDataset" `
    -DefinitionFile ".\BlobDataset.json"


Set-AzDataFactoryV2Dataset -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName -Name "SqlTableDataset" `
    -DefinitionFile ".\SqlTableDataset.json"

$DFPipeLine = Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName `
    -Name "Adfv2QuickStartPipeline" `
    -DefinitionFile ".\Adfv2QuickStartPipeline.json"

$RunId = Invoke-AzDataFactoryV2Pipeline `
    -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName `
    -PipelineName $DFPipeLine.Name `
    -ParameterFile .\PipelineParameters.json


while ($True) {
    $Run = Get-AzDataFactoryV2PipelineRun `
        -ResourceGroupName $ResGrp.ResourceGroupName `
        -DataFactoryName $DataFactory.DataFactoryName `
        -PipelineRunId $RunId

    if ($Run) {
        if ($run.Status -ne 'InProgress') {
            Write-Output ("Pipeline run finished. The status is: " +  $Run.Status)
            $Run
            break
        }
        Write-Output "Pipeline is running...status: InProgress"
    }

    Start-Sleep -Seconds 10
}