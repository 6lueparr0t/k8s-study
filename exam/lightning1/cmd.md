# CMD

```bash
kubectl exec -it webapp-color -- sh

# -z : 포트스캔
# -v : verbose
# -w : timeout [sec]
nc -z -v secure-service 80

nc -z -v -w 1 secure-service 80

kubectl get netpol

k get netpol default-deny -o yaml > netpol.yaml

k get pods --show-labels

k edit netpol default-deny

spec:
  podSelector:
    matchLabels:
      run: secure-pod
  polichTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: webapp-color
```


```bash
k create ns dvl1987

k -n dvl1987 create configmap time-config --from-literal=TIME_FREQ=10

k run time-check --image=busybox --dry-run=client -o yaml > pod.yaml


k rollout history deployment [deployment-name]
k set image deploy [deployment-name] [name]=[image]:[version]
k rollout undo deployment [deployment-name]
k rollout undo deployment [deployment-name] --to-revision=1
```