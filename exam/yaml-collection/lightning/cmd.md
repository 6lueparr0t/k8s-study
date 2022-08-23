# CMD

```bash
kubectl exec -it webapp-color -- sh

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
```