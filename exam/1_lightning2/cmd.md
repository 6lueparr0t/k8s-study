# CMD

```bash

k get all --all-namespaces

k describe nginx1401 -n dev1401

k get nginx1401 -n dev1401 -o yaml > nginx1401.yaml

k delete po nginx1401 -n dev1401 --force --grace-period 0

...
readinessProbe:
  failureThreshold: 3
  httpGet:
    path: /
    port: 9080
    scheme: HTTP
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 1
livenessProbe:
  exec:
    command: ["ls", "/var/www/html/file_check"]
    # 혹은
    command:
    - "ls"
    - "/var/www/html/file_check"
  initialDelaySeconds: 10
  periodSeconds: 60
...

# ---

k create cronjob dice --image=kodekloud/throw-dice --schedule="*/1 * * * *" $do > dice.yaml

# ---

k run my-busybox --image=busybox --dry-run=client -o yaml > my-busybox.yaml

# ---


# Ingress 생성 시, 포트 확인
k get svc
k create ingress ingress-vh-routing --rule="watch.ecom-store.com/video*=video-service:8080" --rule="apparels.ecom-store.com/wear*=apparels-service:8080"
# nginx.ingress.kubernetes.io/rewrite-target: / 추가해주어야 인식함

# ---
k logs dev-pod-dind-878516 -c log-x
k logs dev-pod-dind-878516 -c log-x | grep WARNING > /opt/dind-878516_logs.txt

```