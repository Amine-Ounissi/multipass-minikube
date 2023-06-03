# Create multipass vm for minikube

-Create the multipass VM:

Define file minikube-cloud-init.yaml

-Create the multipass VM:

```
multipass launch --name nom_VM --cpu 2 --mem 6G --disk 60G --cloud-init minikube-cloud-init.yaml
```
-Disable Hyper-v checkpoint:

```
Get-VMCheckpoint -VMName mpass-docker
Set-VM -Name <VMNAME> -CheckpointType Disabled
```

-Multipass execute commands:

-How to enter the VM:
```
winpty multipass exec nom_VM bash
```
-Script to deploy an app:

-Create values.yaml file for the ingress controller

-Install minikube, kubectl and helm as admin with Powershell:

```
choco install minikube
choco install kubernetes-cli
choco install kubernetes-helm
```

-Launch the script:
```
./mpass-minikube.sh nom_VM
```