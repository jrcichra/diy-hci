#!/bin/bash
set -x

# vagrant up
echo "Starting the VMs..."
export VAGRANT_EXPERIMENTAL="disks"
vagrant up
echo "VMs started"

echo "Installing k3s..."
if [ "$(uname)" == "Darwin" ]; then
    # MacOS
    wget https://github.com/alexellis/k3sup/releases/download/0.11.3/k3sup-darwin -O k3sup
else
    # Linux
    wget https://github.com/alexellis/k3sup/releases/download/0.11.3/k3sup -O k3sup
fi
chmod +x k3sup
./k3sup install --ip 192.168.55.11 --k3s-extra-args '--no-deploy traefik --no-deploy=local-storage' --user vagrant
./k3sup join --ip 192.168.55.12 --user vagrant --server-ip 192.168.55.11
./k3sup join --ip 192.168.55.13 --user vagrant --server-ip 192.168.55.11

export KUBECONFIG=kubeconfig

# deploy rook
echo "Deploying rook..."
kubectl apply -f yaml/rook/crds.yaml
kubectl apply -f yaml/rook/common.yaml
kubectl apply -f yaml/rook/operator.yaml
kubectl apply -f yaml/rook/cluster.yaml
kubectl apply -f yaml/rook/filesystem.yaml
kubectl apply -f yaml/rook/storageclass.yaml
echo "Rook deployed"

echo "Testing PVC..."
# apply a pvc and make sure it gets bound
kubectl apply -f yaml/rook/pvc.yaml

while [[ $(kubectl get pvc example-pvc -o 'jsonpath={..status.phase}') != "Bound" ]]; do
  echo "Waiting for PVC to be bound"
  sleep 1
done
echo "PVC bound"
kubectl delete -f yaml/rook/pvc.yaml

echo "Deploying KubeVirt..."
# deploy kubevirt
kubectl apply -f yaml/kubevirt/operator.yaml
kubectl apply -f yaml/kubevirt/cr.yaml
echo "KubeVirt deployed"

# deploy a vm
echo "Deploying a VM (w/ rook storage)..."
kubectl apply -f yaml/kubevirt/vm.yaml

# wait for the vm to be ready
while [[ $(kubectl get vm debian -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
  echo "Waiting for VM to be ready"
  sleep 1
done
echo "VM ready"

# delete the vm
echo "Deleting the VM..."
kubectl delete -f yaml/kubevirt/vm.yaml
echo "VM deleted"

echo "DIY-HCI is complete. You now have a fully functional K3S + Rook + KubeVirt cluster."
