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
k -n dvl1987 create configmap time-config --from-literal=TIME_FREQ=10

k run time-check --image=busybox --dry-run -o yaml > pod.yaml

k create ns dvl1987

k rollout history deployment [deployment-name]
k rollout undo deployment [deployment-name]
k rollout undo deployment [deployment-name] --to-revision=2
```