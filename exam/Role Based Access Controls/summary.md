# Role Based Access Controls 정리

```bash
# 모드 확인
$ kubectl describe pod kube-apiserver-controlplane -n kube-system
# --authorization-mode 을 확인한다.

# get roles exist in all namespaces
$ kubectl get roles --all-namespaces
$ k get roles -A

# get roles describe
kubectl describe role kube-proxy -n kube-system

# get role binding
kubectl describe rolebinding kube-proxy -n kube-system

# get check role permission
kubectl get pods --as dev-user

# create role
k create role developer --verb=list,create,delete --resource=pods --dry-run=client -o yaml > developer.yaml

# create rolebinding
k create rolebinding dev-user-binding --clusterrole=admin --user=developer --user=dev-user --dry-run=client -o yaml > rolebinding.yaml

# edit role
kubectl edit role developer -n blue
```


