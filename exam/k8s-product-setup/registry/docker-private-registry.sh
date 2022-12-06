# 인증서 생성
openssl req \
-newkey rsa:4096 -nodes -keyout /data/certs/<도메인주소>.key \
-x509 -days 3650 -out /data/certs/<도메인주소>.crt

sudo mkdir -p /etc/docker/certs.d/<도메인주소>:5000

k create configmap configmap-registry --from-literal REGISTRY_HTTP_ADDR=0.0.0.0:5000 --from-literal REGISTRY_HTTP_TLS_CERTIFICATE=/certs/<도메인주소>.crt --from-literal REGISTRY_HTTP_TLS_KEY=/certs/<도메인주소>.key  $do > cm.yaml
k create secret tls <도메인>-registry-com --key <도메인주소>.key --cert <도메인주소>.crt $do > secret.yaml