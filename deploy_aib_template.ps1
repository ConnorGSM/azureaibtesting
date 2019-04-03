#Delete existing template
az resource delete \
    --resource-group AIB_RG \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n wintestaib01

# Create new template - template path must be the RAW git path!
declare resourceGroupName="AIB_RG"
declare deploymentName="Test02"
declare templateFilePath="https://raw.githubusercontent.com/ConnorGSM/azureaibtesting/master/win_ser_aim_template.json"
declare parametersFilePath="/mnt/c/Scripting/win_ser_aim_params.json"

az group deployment create --name $deploymentName --resource-group $resourceGroupName --template-uri $templateFilePath --parameters $parametersFilePath 

#create new image from template
az resource invoke-action \
     --resource-group AIB_RG \
     --resource-type  Microsoft.VirtualMachineImages/imageTemplates \
     -n wintestaib01 \
     --action Run 


#Create VM from Image
az vm create \
  --resource-group AIB_RG \
  --name testaibvm01 \
  --location westcentralus \
  --admin-username connor \
  --admin-password Password01234! \
  --image wintestaib01
  --size Standard_DS1_v2
  --data-disk-sizes-gb 60