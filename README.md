# diy-hci

DIY-HCI Solution using Rook + KubeVirt + easy-to-use GUIs. The goal is to have a simple way to build a highly available, horizontally scalable container, storage, and virtualization platform.

# NOTE

- Ideally the script can be run again to update software like k3s/rook/ceph/kubevirt/rancher. Doing so in a controlled manner might be challenging.
- Don't run any production workflows on this configuration unless you understand all the underlying components. There is no guaranteed upgrade path with DIY-HCI.

# Try it with Vagrant + libvirtd

- `vagrant plugin install vagrant-libvirt`
- `./start.sh`
