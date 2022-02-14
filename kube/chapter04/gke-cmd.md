# 쿠버네티스 생성

```bash
# zsh completion
$ echo 'source <(kubectl completion zsh)' >> ~/.zshrc

# 다음 로그인 시에도 zsh로 kubectl 자동 완성 기능을 활성화
$ source <(kubectl completion zsh)

# 쿠버네티스 버전 확인
gcloud container get-server-config --zone asia-northeast3-a

# 쿠버네티스 생성
gcloud container clusters create k8s \
# --cluster-version 1.21.5-gke.1802 \ #validMasterVersions에 있는 쿠버네티스 버전 지정
--zone asia-northeast3-a \ # 존 설정
--num-nodes 3 \ # 노드 수
--machine-type n2-standard-2 \ # 인스턴스 유형 지정
--enable-network-policy \ # 네트워크 정책 기능 활성화
--enable-vertical-pod-autoscaling # VerticalPodAutoscaler 활성화

# 알파 기능을 활성화한 클러스터 'k8s-alpha' 생성
gcloud container clusters create k8s-alpha \
--zone asia-northeast3-a \
--num-nodes 3 \
--machine-type n2-standard-2 \
--enable-network-policy \
--enable-vertical-pod-autoscaling
--enable-kubernetes-alpha \ # 쿠버네티스 알파 기능의 활성화
--no-enable-autorepair --no-enable-autoupgrade # 알파 기능을 활성화하기 때문에 일부 기능은 비활성화

# 사용자에게 모든 리소스의 접속 권한을 부여
kubectl create clusterrolebinding user-cluster-admin-binding \
--clusterrole=cluster-admin \
--user=6lueparr0t.2022@gmail.com

# 쿠버네티스 버전과 클라이언트 버전 확인
kubectl version

# 쿠버네티스 삭제
gcloud container clusters delete k8s --zone asia-northeast3-a

# 알파 기능을 활성화한 쿠버네티스 1.22.4-gke.1501 클러스터 구축
kind create cluster --name kind-alpha-cluster --config kind-alpha.yaml
```
