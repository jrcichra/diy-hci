# diy-hci

DIY-HCI Solution using Rook + KubeVirt + easy-to-use GUIs. The goal is to have a simple way to build a highly available, horizontally scalable container, storage, and virtualization platform.

# NOTE

- This is not currently functional. Ideally this will be managed by an ansible playbook or setup script to install everything required.
- Ideally the playbook can be run again to update software like k3s/rook/ceph/kubevirt/rancher. Doing so in a controlled manner might be challenging.
- Don't run any production workflows on this configuration unless you understand all the underlying components. There is no guaranteed upgrade path with DIY-HCI.

# Try it with Vagrant + libvirtd

- `vagrant plugin install vagrant-libvirt`
- `vagrant up`
- `wget https://github.com/alexellis/k3sup/releases/download/0.11.3/k3sup && chmod +x k3sup`
- `./k3sup install --ip 192.168.55.11 --user vagrant --cluster`
- `./k3sup join --ip 192.168.55.12 --user vagrant --server-user vagrant --server-ip=192.168.55.11 --server`
- `./k3sup join --ip 192.168.55.13 --user vagrant --server-user vagrant --server-ip=192.168.55.11 --server`
- `git clone --single-branch --branch v1.9.2 https://github.com/rook/rook.git`
- `kubectl apply -f crds.yaml -f common.yaml -f operator.yaml cluster.yaml`
- `wait a few minutes`
- `kubectl apply -f filesystem.yaml storageclass.yaml`
