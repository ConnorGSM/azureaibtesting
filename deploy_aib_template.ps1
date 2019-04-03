# template path must be the RAW git path!

declare resourceGroupName="AIB_RG"
declare deploymentName="Test01"
declare templateFilePath="https://raw.githubusercontent.com/ConnorGSM/azureaibtesting/master/win_ser_aim_template.json"
declare parametersFilePath="/mnt/C/Users/cmccardle/OneDrive - Ensono/Azure JSON/My Work/Azure Image Builder/win_ser_aim_params.json"

az group deployment create --name $deploymentName --resource-group $resourceGroupName --template-uri $templateFilePath --parameters $parametersFilePath 