#!/bin/bash
mkdir ~/.kube
mkdir ~/.minikube

#--------------------
multipass start minikube

#start minikube 
multipass exec minikube -- sudo minikube start --extra-config=apiserver.service-node-port-range=1-65535 --kubernetes-version=v1.20.0

# get dynamic IP of the VM
if (multipass start minikube); then
  IP=$(multipass ls  --format csv | grep minikube |  grep -v IPv4 | cut -f3 -d,)
else
  exit -1
fi


#copy files from VM to local machine
multipass exec minikube -- sudo cat //root//.minikube//profiles//minikube//client.crt > ~//.minikube//client.crt
multipass exec minikube -- sudo cat //root//.minikube//profiles//minikube//client.key > ~//.minikube//client.key
multipass exec minikube -- sudo cat //root//.minikube//ca.crt > ~//.minikube//ca.crt

export IP=$IP
echo $IP
multipass exec minikube -- sudo cat //root//.kube//config > ~//.kube//config

sed -i 's~server: https://*.*.*.*:*~server: https://'$IP':8443~g' ~//.kube//config
sed -i 's|certificate-authority: *.*|certificate-authority: ../.minikube/ca.crt|g' ~//.kube//config
sed -i 's|client-certificate: *.*|client-certificate: ../.minikube/client.crt|g' ~//.kube//config
sed -i 's|client-key: *.*|client-key: ../.minikube/client.key|g' ~//.kube//config



echo ""
echo "Test kubectl commmand:"
echo ""
kubectl get nodes

#create namespace ingress-nginx

#kubectl create namespace ingress-nginx

#add chart repo
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

#install ingress-controller from the file values.yaml
#multipass transfer values.yaml minikube:
#helm install -f values.yaml ingress-nginx --namespace ingress-nginx ingress-nginx/ingress-nginx

#Deploy an app
#kubectl create namespace web-test
#kubectl -n web-test create deployment web --image=gcr.io/google-samples/hello-app:1.0
#kubectl -n web-test expose deployment web --type=NodePort --port=8080

sleep 30s

#kubectl -n web-test apply -f example-ingress.yaml