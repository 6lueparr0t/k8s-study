# Google Kubernetes Engine 명령어 정리

```bash
# gcloud 설치
curl https://sdk.cloud.google.com | bash

# shell 재실행
exec -l $SHELL

#gcloud CLI 인증
gcloud init

# GKE 에서 사용 가능한 쿠버네티스 버전 확인
gcloud container get-server-config --zone asia-northeast3-a | more

# gcloud container clusters create k8s
# --cluster-version 1.21.6-gke.1500 # validMasterVersions 에 있는 쿠버네티스 버전 지정
# --zone asia-northeast3-a # zone 지정
# --num-nodes 3 # 노드 수

# GKE 클러스터 'k8s' 생성
gcloud container clusters create k8s \
--cluster-version 1.21.6-gke.1500 \
--zone asia-northeast3-a \
--num-nodes 3

# GKE 클러스터 'k8s' 에 접속할 인증 정보를 다시 가져오는 방법
gcloud container clusters get-credentials k8s --zone asia-northeast3-a

# 현재 사용자의 이메일 주소를 가져옴
GCP_USER=`gcloud config get-value core/account`

# kubectl 을 사용할 GCP IAM 사용자에게 클러스터 관리자 권한 설정
kubectl create --save-config clusterrolebinding iam-cluster-admin-binding \
--clusterrole=cluster-admin \
--user=${GCP_USER}

# GKE 클러스터 'k8s' 삭제
gcloud container clusters delete k8s --zone asia-northeast3-a

```

## 참고

- GCP & GKE 클러스터 : <https://myjamong.tistory.com/246>
