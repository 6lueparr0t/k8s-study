# k8s 설치 (패키지 기반)
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"


# sudo apt-get remove kubeadm kubelet kubectl
sudo apt-get install kubeadm kubelet kubectl
# 업데이트를 멈춘다.
# 해제는 sudo apt-mark unhold kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl

# 별도로 cidr 범위 주지 않음
sudo kubeadm init
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# 메모리 스왑 해제
sudo swapoff -a

# CIDR 확인
kubeadm config print init-defaults

# 내려받고 확인 후 적용
curl https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O

watch kubectl get pods --all-namespaces

kubectl describe node sf-dev1 | grep Taints

# Taints 해제
k taint nodes --all node-role.kubernetes.io/control-plane-
k taint node sf-dev1 node-role.kubernetes.io/control-plane-

# Taints 설정
k taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule
k taint node sf-dev1 node-role.kubernetes.io/control-plane:NoSchedule

# 각 노드별 label 부여
k label nodes sf-dev1 name=master
k label nodes pe01wk01 name=worker1
k label nodes pe01wk02 name=worker2

kubeadm token create
# <token>
kubeadm token list

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
# <hash>

# CIDR 확인
kubeadm config print init-defaults
sudo kubeadm join <Master Node IP>:6443 --discovery-token <token> --discovery-token-ca-cert-hash sha256:<hash>

# helm 설치 방법
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm