# set your environment variables here!!!!

# Create SIG  resource group
sigResourceGroup=AIB_SIG_RG

# location of SIG (see possible locations in main docs)
location=westus

# additional region to replication image to
additionalregion=eastus

# your subscription
# get the current subID : 'az account show | grep id'
subscriptionID=a553d124-d24b-4a78-a75d-37281a6ada80

# name of the shared image gallery, e.g. myCorpGallery
sigName=AIBSIG01

# name of the image definition to be created, e.g. ProdImages
imageDefName=UbuntuImages

# create resource group
az group create -n $sigResourceGroup -l $location

# assign permissions for that resource group
az role assignment create \
    --assignee cf32a0cc-373c-47c9-9156-0db11f6a6dfc \
    --role Contributor \
    --scope /subscriptions/$subscriptionID/resourceGroups/$sigResourceGroup

# create SIG
az sig create \
    -g $sigResourceGroup \
    --gallery-name $sigName

# create SIG image definition

az sig image-definition create \
   -g $sigResourceGroup \
   --gallery-name $sigName \
   --gallery-image-definition $imageDefName \
   --publisher Canonical \
   --offer UbuntuServer \
   --sku 19.04-DAILY \
   --os-type Linux