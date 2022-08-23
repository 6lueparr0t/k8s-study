# 강좌를 통해 주로 썼던 명령어

## Common

```bash
# kubectl 은 k 의 축약형태로 사용할 수 있다.
k help
k version --short

# 리소스 보기
# pod, service, daemonset, deployment, replicaset, statefulset, job, cronjobs
k get all
k get all -n [namespace]

k get namespaces # 네임스페이스 리스트
k get all --all-namespaces # 모든 네임스페이스에서 조회

# 리소스 생성 (with yaml)
k create -f some.yaml
k apply -f some.yaml

# 리소스 삭제 (with yaml)
k delete -f some.yaml
k delete -f some.yaml --force --grace-period 0 # 즉시 삭제

# Deployment Control
k set image deployment/[deployment-name] [pods]=[image]
ex) k set image deployment/nginx-deployment nginx=nginx:1.17
k rollout history deployment [deployment-name]
k rollout undo deployment [deployment-name]
k rollout undo deployment [deployment-name]
k rollout undo deployment [deployment-name] --to-revision=2


k scale deployment frontend --replicas=0
k scale deployment frontend-v2 --replicas=5

# Helm 명령어
helm --help
helm list
helm search hub [helm-charts]
helm repo add [helm-charts] [repository-url]
helm search repo [added repository]
helm repo list

helm install [name] [helm-charts]
helm uninstall [name]

helm pull --untar [helm-charts] #다운로드 후 압축 풀기
helm install [name] . # value.yaml 설정 후 helm-charts 띄우기

```

## Reference
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://www.studytonight.com/post/how-to-list-all-resources-in-a-kubernetes-namespace
- https://github.com/bitnami/charts/tree/master/bitnami/apache/#installing-the-chart