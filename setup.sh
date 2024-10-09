#! /usr/bin/sh

# Create random string
guid=$(cat /proc/sys/kernel/random/uuid)
suffix=${guid//[-]/}
suffix=${suffix:0:18}

# Set the necessary variables
RESOURCE_GROUP="rg-dp100-l${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearning"
REGIONS=("eastus" "westus" "centralus" "northeurope" "westeurope")
RANDOM_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]}]}
WORKSPACE_NAME="mlw-dp100-l${suffix}"
COMPUTE_INSTANCE="ci${suffix}"
COMPUTE_CLUSTER="aml-cluster"

# Register the Azure Machine Learning resource provider in the subscription
echo "Register the Machine Learning resource provider:"
az provider register --namespace $RESOURCE_PROVIDER

# Create the resource group and workspace and set to default
echo "Create a resource group and set as default:"
az group create --name $RESOURCE_GROUP --location $RANDOM_REGION
az configure --defaults group=$RESOURCE_GROUP

echo "Create an Azure Machine Learning workspace:"
az ml workspace create --name $WORKSPACE_NAME 
az configure --defaults workspace=$WORKSPACE_NAME 

# Create compute instance
echo "Creating a compute instance with name: " $COMPUTE_INSTANCE
az ml compute create --name ${COMPUTE_INSTANCE} --size STANDARD_DS11_V2 --type ComputeInstance 

# Create compute cluster
echo "Creating a compute cluster with name: " $COMPUTE_CLUSTER
az ml compute create --name ${COMPUTE_CLUSTER} --size STANDARD_DS11_V2 --max-instances 2 --type AmlCompute 



# export MY_VM_NAME="my_VM_$RANDOM_ID"
# export MY_USERNAME=azureuser
# export MY_VM_IMAGE="Canonical:0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2:latest"
az vm create --resource-group rg-dp100-lc27d604846864aa694 --name "my_VM2" --image Canonical:0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2:latest  --admin-username azureuser --assign-identity --generate-ssh-keys --public-ip-sku Standard

az ml compute show --name my_VM2 --resource-group rg-dp100-lc27d604846864aa694 --workspace-name rg-dp100-lc27d604846864aa694

az ml compute list --resource-group rg-dp100-lc27d604846864aa694 --workspace-name mlw-dp100-lc27d604846864aa694

az ml compute attach \
    --name my_VM2 \
    --type virtualmachine \
    --resource-group rg-dp100-lc27d604846864aa694 \
    --workspace-name mlw-dp100-lc27d604846864aa694 \
    --vm-resource-id 41463841-d87e-4f36-8ea3-7b0294e63525

az vm show --name my_VM2 --resource-group rg-dp100-lc27d604846864aa694 --query "id" --output tsv