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
k get pod -o wide # 넓게 보기
k get node controlplane --show-labels # 노드의 라벨 확인하기

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
k rollout undo deployment [deployment-name] --to-revision=2

k scale deployment frontend --replicas=0
k scale deployment frontend-v2 --replicas=5

# Imperative Commands
k run nginx-pod --image=nginx:alpine
k run redis -l tier=db --image=redis:alpine
k run redis --image=redis:alpine --dry-run=client -o yaml > redis.yaml
k expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml > redis-service.yaml
k create deployment webapp --image=kodekloud/webapp-color --replicas=3
k run custom-nginx --image=nginx --port=8080
k create namespace dev-ns
k create ns dev-ns
k create deploy redis-deploy -n dev-ns --image=redis --replicas=2
k run httpd --image=httpd:alpine --port=80 --expose
k replace -f webapp-color-yaml --force
k create cm cm-3392845 --from-literal=DB_NAME=SQL3322 --from-literal=DB_HOST=sql322.mycompany.com --from-literal=DB_PORT=3306
k create secret generic db-secret-xxdf --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
k logs e-com-1123 -n e-commerce > /opt/outputs/e-com-1123.logs
k create deploy redis --image=redis:alpine --dry-run=client -o yaml > redis-deploy.yaml
k expose deploy redis --name=redis --port=6379 --target-port=6379 --dry-run=client -o yaml > redis-svc.yaml
k expose deploy redis --name=messaging-service --port=6379 -n marketing
k create deploy my-webapp --image=nginx --replicas=2 --dry-run=client -o yaml > my-webapp.yaml
k expose deployment my-webapp --name front-end-service --type NodePort --port 80 --dry-run=client -o yaml > front-end-service.yaml
k taint node node01 app_type=alpha:NoSchedule
k label node controlplane app_type=beta
k create ingress ingress --rule="ckad-mock-exam-solution.com/video*=my-video-service:8080" --dry-run=client -o yaml > ingress.yaml
k replace -f pod-with-rprobe.yaml --force
k create job --image=docker/whalesay whalesay --dry-run=client -o yaml

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

# Helm 설치 예제
chart=jenkinsci/jenkins
helm install jenkins -n jenkins -f jenkins-values.yaml $chart
```

# Condition Check
kubectl wait pods -l <label-key>=<label-name> --for condition=Ready --timeout=90s

## Reference
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://www.studytonight.com/post/how-to-list-all-resources-in-a-kubernetes-namespace
- https://github.com/bitnami/charts/tree/master/bitnami/apache/#installing-the-chart
- https://kubernetes.io/docs/tasks/configure-pod-container/security-context/