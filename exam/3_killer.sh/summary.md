## 환경 설정

```bash
# vim .vimrc
set sw=2 ts=2 sts=2 et
```

```bash
export ns="default"
export do="--dry-run=client -o yaml"
export now="--force --grace-period 0"
export kcmd="kubectl run tmp --restart=Never --rm -i --image=nginx:alpine -- "

# Usage
# $kcmd -- curl -m 2 <svc>.<namespace>:<port>
# $kcmd -- wget -O- -T 2 <svc>.<namespace>:<port>
```

## Q 01 : Task weight: <code>1%</code>

The DevOps team would like to get the list of all Namespaces in the cluster.
Get the list and save it to /opt/course/1/namespaces.

```
k get ns > /opt/course/1/namespaces
```

---

## Q 02 : Task weight: <code>2%</code>

Create a single Pod of image <code>httpd:2.4.41-alpine</code> in Namespace default. The Pod should be named <code>pod1</code> and the container should be named <code>pod1-container</code>.

Your manager would like to run a command manually on occasion to output the status of that exact Pod. Please write a command that does this into <code>/opt/course/2/pod1-status-command.sh</code>. The command should use kubectl.

```bash
k run pod1 --image=httpd:2.4.41-alpine $do > pod1.yaml
vi pod1.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
spec:
  containers:
  - image: httpd:2.4.41-alpine
    name: pod1-container
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

```bash
k apply -f pod1.yaml
```

---

## Q 03 : Task weight: <code>2%</code>

Team Neptune needs a Job template located at <code>/opt/course/3/job.yaml</code>. This Job should run image <code>busybox:1.31.0</code> and execute <code>sleep 2 && echo done.</code> It should be in namespace <code>neptune**, run a total of 3 times and should execute 2 runs in parallel.

Start the Job and check its history. Each pod created by the Job should have the label <code>id: awesome-job</code>. The job should be named <code>neb-new-job</code> and the container <code>neb-new-job-container</code>.

```bash
k -n neptune create job neb-new-job --image=busybox:1.31.0 $do > job.yaml
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: neb-new-job
  namespace: neptune      # add
spec:
  completions: 3          # add
  parallelism: 2          # add
  template:
    metadata:
      creationTimestamp: null
      labels:             # add
        id: awesome-job   # add
    spec:
      containers:
      - command:
        - sh
        - -c
        - sleep 2 && echo done
        image: busybox:1.31.0
        name: neb-new-job-container # update
        resources: {}
      restartPolicy: Never
status: {}
```

---

## Q 04 : Task weight: <code>5%</code>

Team Mercury asked you to perform some operations using Helm, all in Namespace <code>mercury**:

Delete release <code>internal-issue-report-apiv1**
Upgrade release <code>internal-issue-report-apiv2</code> to any newer version of chart <code>bitnami/nginx</code> available
Install a new release <code>internal-issue-report-apache</code> of chart <code>bitnami/apache</code>. The Deployment should have two replicas, set these via Helm-values during install
There seems to be a broken release, stuck in pending-install state. Find it and delete it

```bash
# delete & upgrade
ns=mercury
helm -n $ns ls
helm -n $ns uninstall internal-issue-report-apiv1

helm repo update
helm -n $ns upgrade internal-issue-report-apiv2 bitnami/apache
```

```bash
# install with customizing
helm -n $ns pull --untar internal-issue-report-apache bitnami/apache
vi apache/values.yaml

## or

helm show values bitnami/apache | yq e # search variables

helm -n $ns install internal-issue-report-apache bitnami/apache --set replicaCount=2
helm -n $ns install internal-issue-report-apache bitnami/apache \
  --set replicaCount=2 \
  --set image.debug=true

```

```bash
# show pending-install & delete
helm -n $ns ls -a
helm -n $ns uninstall internal-issue-report-daniel
```

---

## Q 05 : Task weight: <code>3%</code>

Team Neptune has its own ServiceAccount named neptune-sa-v2 in Namespace <code>neptune</code>. A coworker needs the token from the Secret that belongs to that ServiceAccount. Write the base64 decoded token to file <code>/opt/course/5/token</code>.

```bash
ns=neptune
k -n $ns get sa # get overview
k -n $ns get secrets # shows all secrets of namespace
k -n $ns get secrets -o yaml | grep annotations -A 1 # shows secrets with first annotation
k -n $ns describe secret neptune-secret-1
```

```
# /opt/course/5/token
eyJhbGciOiJSUzI1NiIsImtpZCI6Im5aZFdqZDJ2aGNvQ3BqWHZOR1g1b3pIcm5JZ0hHNWxTZkwzQnFaaTFad2MifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJuZXB0dW5lIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im5lcHR1bmUtc2EtdjItdG9rZW4tZnE5MmoiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibmVwdHVuZS1zYS12MiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjY2YmRjNjM2LTJlYzMtNDJhZC04OGE1LWFhYzFlZjZlOTZlNSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpuZXB0dW5lOm5lcHR1bmUtc2EtdjIifQ.VYgboM4CTd0pdCJ78wjUwmtalh-2vsKjANyPsh-6guEwOtWEq5Fbw5ZHPtvAdrLlPzpOHEbAe4eUM95BRGWbYIdwjuN95J0D4RNFkVUt48twoakRV7h-aPuwsQXHhZZzy4yimFHG9Ufmsk5Yr4RVcG6n137y-FH08K8zZjIPAsKDqNBQtxg-lZvwVMi6viIhrrzAQs0MBOV82OJYGy2o-WQVc0UUanCf94Y3gT0YTiqQvczYMs6nz9ut-XgwitrBY6Tj9BgPprA9k_j5qEx_LUUZUpPAiEN7OzdkJsI8ctth10lypI1AeFr43t6ALyrQoBM39abDfq3FksR-oc_WMw
```

---

## Q 06 : Task weight: <code>7%</code>

Create a single Pod named <code>pod6</code> in Namespace default of image <code>busybox:1.31.0</code>. The Pod should have a readiness-probe executing <code>cat /tmp/ready</code>. It should initially wait <code>5</code> and periodically wait <code>10</code> seconds. This will set the container ready only if the file /tmp/ready exists.

The Pod should run the command touch /tmp/ready && sleep 1d, which will create the necessary file to be ready and then idles. Create the Pod and confirm it starts.

```bash
k run pod6 --image=busybox:1.31.0 $do --command -- sh -c "touch /tmp/ready && sleep 1d" > 6.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod6
  name: pod6
spec:
  containers:
  - command:
    - sh
    - -c
    - touch /tmp/ready && sleep 1d
    image: busybox:1.31.0
    name: pod6
    resources: {}
    readinessProbe:                             # add
      exec:                                     # add
        command:                                # add
        - sh                                    # add
        - -c                                    # add
        - cat /tmp/ready                        # add
      initialDelaySeconds: 5                    # add
      periodSeconds: 10                         # add
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

---

## Q 07 : Task weight: <code>4%</code>

The board of Team Neptune decided to take over control of one e-commerce webserver from Team Saturn. The administrator who once setup this webserver is not part of the organisation any longer. All information you could get was that the e-commerce system is called **my-happy-shop**.

Search for the correct Pod in Namespace **saturn** and move it to Namespace **neptune**. It doesn't matter if you shut it down and spin it up again, it probably hasn't any customers anyways.

```bash
ns=saturn
k -n $ns get pod
k -n $ns get pod -o yaml | grep my-happy-shop -A 10
k -n saturn get pod webserver-sat-003 -o yaml > my-happy-shop.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    description: this is the server for the E-Commerce System my-happy-shop
  labels:
    id: webserver-sat-003
  name: webserver-sat-003
  namespace: neptune # new namespace here
spec:
  containers:
  - image: nginx:1.16.1-alpine
    imagePullPolicy: IfNotPresent
    name: webserver-sat
  restartPolicy: Always
```

```bash
k -n $ns delete po -f my-happy-shop.yaml $now
k apply -f my-happy-shop.yaml
```

---

## Q 08 : Task weight: <code>4%</code>

There is an existing Deployment named **api-new-c32** in Namespace neptune. A developer did make an update to the Deployment but the updated version never came online. Check the Deployment history and find a revision that works, then rollback to it. Could you tell Team Neptune what the error was so it doesn't happen again?

```bash
ns=neptune
k -n $ns rollout history deploy api-new-c32
k -n $ns rollout undo deploy api-new-c32
k -n $ns get deploy api-new-c32
k -n $ns rollout status deploy api-new-c32
```

---

## Q 09 : Task weight: <code>5%</code>

In Namespace **pluto** there is single Pod named **holy-api**. It has been working okay for a while now but Team Pluto needs it to be more reliable. Convert the Pod into a Deployment with **3** replicas and name **holy-api**. The raw Pod template file is available at **/opt/course/9/holy-api-pod.yaml**.

In addition, the new Deployment should set **allowPrivilegeEscalation: false** and **privileged: false** for the security context on container level.

Please create the Deployment and save its yaml under **/opt/course/9/holy-api-deployment.yaml**.

```yaml
# holy-api pod
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: holy-api
  name: holy-api
spec:
  containers:
  - env:
    - name: CACHE_KEY_1
      value: b&MTCi0=[T66RXm!jO@
    - name: CACHE_KEY_2
      value: PCAILGej5Ld@Q%{Q1=#
    - name: CACHE_KEY_3
      value: 2qz-]2OJlWDSTn_;RFQ
    image: nginx:1.17.3-alpine
    name: holy-api-container
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
  volumes:
  - emptyDir: {}
    name: cache-volume1
  - emptyDir: {}
    name: cache-volume2
  - emptyDir: {}
    name: cache-volume3
status: {}
```

```bash
ns=pluto
k -n $ns create deploy holy-api --image=nginx:alpine $do > /opt/course/9/holy-api-deployment.yaml
```

```yaml
# edited
apiVersion: apps/v1
kind: Deployment
metadata:
  name: holy-api        # name stays the same
  namespace: pluto      # important
spec:
  replicas: 3           # 3 replicas
  selector:
    matchLabels:
      id: holy-api      # set the correct selector
  template:
    metadata:
      labels:
        id: holy-api
      name: holy-api
    spec:
      containers:
      - env:
        - name: CACHE_KEY_1
          value: b&MTCi0=[T66RXm!jO@
        - name: CACHE_KEY_2
          value: PCAILGej5Ld@Q%{Q1=#
        - name: CACHE_KEY_3
          value: 2qz-]2OJlWDSTn_;RFQ
        image: nginx:1.17.3-alpine
        name: holy-api-container
        securityContext:                   # add
          allowPrivilegeEscalation: false  # add
          privileged: false                # add
        volumeMounts:
        - mountPath: /cache1
          name: cache-volume1
        - mountPath: /cache2
          name: cache-volume2
        - mountPath: /cache3
          name: cache-volume3
      volumes:
      - emptyDir: {}
        name: cache-volume1
      - emptyDir: {}
        name: cache-volume2
      - emptyDir: {}
        name: cache-volume3
```

```bash
k -n $ns apply -f holy-api-deployment.yaml
```

---

## Q 10 - Task weight: <code>4%</code>

Team Pluto needs a new cluster internal Service. Create a ClusterIP Service named **project-plt-6cc-svc** in Namespace **pluto**. This Service should expose a single Pod named **project-plt-6cc-api** of image **nginx:1.17.3-alpine**, create that Pod as well. The Pod should be identified by label **project: plt-6cc-api**. The Service should use tcp port redirection of **3333:80**.

Finally use for example curl from a temporary **nginx:alpine** Pod to get the response from the Service. Write the response into **/opt/course/10/service_test.html**. Also check if the logs of Pod **project-plt-6cc-api** show the request and write those into **/opt/course/10/service_test.log**.

```bash
ns=pluto
k -n $ns run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    project: plt-6cc-api
  name: project-plt-6cc-api
spec:
  containers:
  - image: nginx:1.17.3-alpine
    name: project-plt-6cc-api
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

```bash
k -n $ns expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80
```

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    project: plt-6cc-api
  name: project-plt-6cc-svc   # good
  namespace: pluto            # great
spec:
  ports:
  - port: 3333                # awesome
    protocol: TCP
    targetPort: 80            # nice
  selector:
    project: plt-6cc-api      # beautiful
status:
  loadBalancer: {}
```

```bash
#k run tmp --restart=Never --rm --image=nginx:alpine -i -- curl http://project-plt-6cc-svc.pluto:3333
$kcmd -- curl -m 2 http://project-plt-6cc-svc.pluto:3333
$kcmd -- wget -O- -T2 http://project-plt-6cc-svc.pluto:3333 > /opt/course/10/service_test.html
## and delete unnecessary lines

k -n $ns logs project-plt-6cc-api > /opt/course/10/service_test.log
```

---

## Q 11 - Task weight: <code>7%</code>

During the last monthly meeting you mentioned your strong expertise in container technology. Now the Build&Release team of department Sun is in need of your insight knowledge. There are files to build a container image located at **/opt/course/11/image**. The container will run a Golang application which outputs information to stdout. You're asked to perform the following tasks:

> NOTE: Make sure to run all commands as user **k8s**, for docker use **sudo docker**

1. Change the Dockerfile. The value of the environment variable SUN_CIPHER_ID should be set to the hardcoded value **5b9c1065-e39d-4a43-a04a-e59bcea3e03f**
2. Build the image using Docker, named **registry.killer.sh:5000/sun-cipher**, tagged as **latest** and **v1-docker**, push these to the registry
3. Build the image using Podman, named **registry.killer.sh:5000/sun-cipher**, tagged as **v1-podman**, push it to the registry
4. Run a container using Podman, which keeps running in the background, named **sun-cipher** using image **registry.killer.sh:5000/sun-cipher:v1-podman**. Run the container from k8s@terminal and not root@terminal
5. Write the logs your container sun-cipher produced into **/opt/course/11/logs**. Then write a list of all running Podman containers into **/opt/course/11/containers**

```Dockerfile
#1
## build container stage 1
#FROM docker.io/library/golang:1.15.15-alpine3.14
#WORKDIR /src
#COPY . .
#RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bin/app .
#
## app container stage 2
#FROM docker.io/library/alpine:3.12.4
#COPY --from=0 /src/bin/app app
## CHANGE NEXT LINE
#ENV SUN_CIPHER_ID=5b9c1065-e39d-4a43-a04a-e59bcea3e03f
#CMD ["./app"]

# test
FROM httpd:2.4
RUN echo "Hello, World!" > /usr/local/apache2/htdocs/index.html
```

```bash
#2
sudo docker build -t registry.killer.sh:5000/sun-cipher:latest -t registry.killer.sh:5000/sun-cipher:v1-docker .

sudo docker push registry.killer.sh:5000/sun-cipher:latest
sudo docker push registry.killer.sh:5000/sun-cipher:v1-docker

#3
podman build -t registry.killer.sh:5000/sun-cipher:v1-podman .
podman tag sun-cipher:v1-podman registry.killer.sh:5000/sun-cipher:v1-podman .
podman push registry.killer.sh:5000/sun-cipher:v1-podman

#4
podman run -d --name sun-cipher registry.killer.sh:5000/sun-cipher:v1-podman

#5
podman ps > /opt/course/11/containers
podman logs sun-cipher > /opt/course/11/logs
# podman exec -it sun-cipher cat /usr/local/apache2/htdocs/index.html
```

---

## Q 12 - Task weight: <code>8%</code>

Create a new PersistentVolume named **earth-project-earthflower-pv**. It should have a capacity of **2Gi**, accessMode **ReadWriteOnce**, hostPath **/Volumes/Data** and **no storageClassName** defined.

Next create a new PersistentVolumeClaim in Namespace **earth** named **earth-project-earthflower-pvc**. It should request **2Gi** storage, accessMode **ReadWriteOnce** and should not define a storageClassName. The PVC should bound to the PV correctly.

Finally create a new Deployment **project-earthflower** in Namespace **earth** which mounts that volume at **/tmp/project-data**. The Pods of that Deployment should be of image **httpd:2.4.41-alpine**.

```yaml
# 12_pv.yaml
kind: PersistentVolume
apiVersion: v1
metadata:
 name: earth-project-earthflower-pv
spec:
 capacity:
  storage: 2Gi
 accessModes:
  - ReadWriteOnce
 hostPath:
  path: "/Volumes/Data"
```

```yaml
# 12_pvc.yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: earth-project-earthflower-pvc
  namespace: earth
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
     storage: 2Gi
```

```yaml
# 12_dep.yaml
# k -n earth create deploy project-earthflower --image httpd:2.4.41-alpine $do > 12_dep.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: project-earthflower
  name: project-earthflower
  namespace: earth
spec:
  replicas: 1
  selector:
    matchLabels:
      app: project-earthflower
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: project-earthflower
    spec:
      volumes:                                      # add
      - name: data                                  # add
        persistentVolumeClaim:                      # add
          claimName: earth-project-earthflower-pvc  # add
      containers:
      - image: httpd:2.4.41-alpine
        name: container
        volumeMounts:                               # add
        - name: data                                # add
          mountPath: /tmp/project-data              # add
```

---

## Q 13 - Task weight: <code>6%</code>

Team Moonpie, which has the Namespace **moon**, needs more storage. Create a new PersistentVolumeClaim named **moon-pvc-126** in that namespace. This claim should use a new StorageClass **moon-retain** with the provisioner set to **moon-retainer** and the reclaimPolicy set to Retain. The claim should request storage of **3Gi**, an accessMode of **ReadWriteOnce** and should use the new StorageClass.

The provisioner **moon-retainer** will be created by another team, so it's expected that the PVC will not boot yet. Confirm this by writing the log message from the PVC into file **/opt/course/13/pvc-126-reason**.

```yaml
# 13_sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: moon-retain
provisioner: moon-retainer
reclaimPolicy: Retain
```

```yaml
# 13_pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: moon-pvc-126            # name as requested
  namespace: moon               # important
spec:
  accessModes:
    - ReadWriteOnce             # RWO
  resources:
    requests:
      storage: 3Gi              # size
  storageClassName: moon-retain # uses our new storage class
```

```bash
# /opt/course/13/pvc-126-reason
k -n moon describe pvc moon-pvc-126
# waiting for a volume to be created, either by external provisioner "moon-retainer" or manually created by system administrator
```

---

## Q 14 - Task weight: <code>4%</code>

You need to make changes on an existing Pod in Namespace **moon** called **secret-handler**. Create a new Secret secret1 which contains **user=test** and **pass=pwd**. The Secret's content should be available in Pod **secret-handler** as environment variables **SECRET1_USER** and **SECRET1_PASS**. The yaml for Pod **secret-handler** is available at **/opt/course/14/secret-handler.yaml**.

There is existing yaml for another Secret at **/opt/course/14/secret2.yaml**, create this Secret and mount it inside the same Pod at **/tmp/secret2**. Your changes should be saved under **/opt/course/14/secret-handler-new.yaml**. Both Secrets should only be available in Namespace **moon**.

```yaml
# /opt/course/14/secret-handler-new.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: secret-handler
    uuid: 1428721e-8d1c-4c09-b5d6-afd79200c56a
    red_ident: 9cf7a7c0-fdb2-4c35-9c13-c2a0bb52b4a9
    type: automatic
  name: secret-handler
  namespace: moon
spec:
  volumes:
  - name: cache-volume1
    emptyDir: {}
  - name: cache-volume2
    emptyDir: {}
  - name: cache-volume3
    emptyDir: {}
  - name: secret2-volume              # add
    secret:                           # add
      secretName: secret2             # add
  containers:
  - name: secret-handler
    image: bash:5.0.11
    args: ['bash', '-c', 'sleep 2d']
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
    - name: secret2-volume            # add
      mountPath: /tmp/secret2         # add
    env:
    - name: SECRET_KEY_1
      value: ">8$kH#kj..i8}HImQd{"
    - name: SECRET_KEY_2
      value: "IO=a4L/XkRdvN8jM=Y+"
    - name: SECRET_KEY_3
      value: "-7PA0_Z]>{pwa43r)__"
    - name: SECRET1_USER              # add
      valueFrom:                      # add
        secretKeyRef:                 # add
          name: secret1               # add
          key: user                   # add
    - name: SECRET1_PASS              # add
      valueFrom:                      # add
        secretKeyRef:                 # add
          name: secret1               # add
          key: pass                   # add
```

```bash
ns=moon
k -n $ns exec secret-handler -- env | grep SECRET1
k -n $ns exec secret-handler -- find /tmp/secret2 

k -f /opt/course/14/secret-handler-new.yaml replace $now
```

---

## Q 15 - Task weight: <code>5%</code>

Team Moonpie has a nginx server Deployment called **web-moon** in Namespace **moon**. Someone started configuring it but it was never completed. To complete please create a ConfigMap called **configmap-web-moon-html** containing the content of file **/opt/course/15/web-moon.html** under the data key-name **index.html**.

The Deployment **web-moon** is already configured to work with this ConfigMap and serve its content. Test the nginx configuration for example using **curl** from a temporary **nginx:alpine** Pod.

```bash
ns=moon
k -n $ns create configmap configmap-web-moon-html --from-file=index.html=/opt/course/15/web-moon.html
```

```yaml
apiVersion: v1
data:
  index.html: |     # notice the key index.html, this will be the filename when mounted
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Web Moon Webpage</title>
    </head>
    <body>
    This is some great content.
    </body>
    </html>
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: configmap-web-moon-html
  namespace: moon
```

```bash
k -n ns get pod -o wide
$kcmd -n $ns -- curl 10.44.0.78
```

---

## Q 16 - Task weight: <code>6%</code>

The Tech Lead of Mercury2D decided it's time for more logging, to finally fight all these missing data incidents. There is an existing container named **cleaner-con** in Deployment **cleaner** in Namespace **mercury**. This container mounts a volume and writes logs into a file called **cleaner.log**.

The yaml for the existing Deployment is available at **/opt/course/16/cleaner.yaml**. Persist your changes at **/opt/course/16/cleaner-new.yaml** but also make sure the Deployment is running.

Create a sidecar container named **logger-con**, image **busybox:1.31.0** , which mounts the same volume and writes the content of **cleaner.log** to stdout, you can use the **tail -f** command for this. This way it can be picked up by **kubectl logs**.

Check if the logs of the new container reveal something about the missing data incidents.

```bash
cp /opt/course/16/cleaner.yaml /opt/course/16/cleaner-new.yaml
vim /opt/course/16/cleaner-new.yaml
```

```yaml
# /opt/course/16/cleaner-new.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  name: cleaner
  namespace: mercury
spec:
  replicas: 2
  selector:
    matchLabels:
      id: cleaner
  template:
    metadata:
      labels:
        id: cleaner
    spec:
      volumes:
      - name: logs
        emptyDir: {}
      initContainers:
      - name: init
        image: bash:5.0.11
        command: ['bash', '-c', 'echo init > /var/log/cleaner/cleaner.log']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
      containers:
      - name: cleaner-con
        image: bash:5.0.11
        args: ['bash', '-c', 'while true; do echo `date`: "remove random file" >> /var/log/cleaner/cleaner.log; sleep 1; done']
        volumeMounts:
        - name: logs
          mountPath: /var/log/cleaner
      - name: logger-con                                                # add
        image: busybox:1.31.0                                           # add
        command: ["sh", "-c", "tail -f /var/log/cleaner/cleaner.log"]   # add
        volumeMounts:                                                   # add
        - name: logs                                                    # add
          mountPath: /var/log/cleaner                                   # add
```

```bash
k -f /opt/course/16/cleaner-new.yaml apply
k -n mercury logs <cleaner-pod> -c logger-con
```

---

## Q 17 - Task weight: <code>4%</code>

Last lunch you told your coworker from department Mars Inc how amazing InitContainers are. Now he would like to see one in action. There is a Deployment yaml at **/opt/course/17/test-init-container.yaml**. This Deployment spins up a single Pod of image **nginx:1.17.3-alpine** and serves files from a mounted volume, which is empty right now.

Create an InitContainer named **init-con** which also mounts that volume and creates a file **index.html** with content **check this out!** in the root of the mounted volume. For this test we ignore that it doesn't contain valid html.

The InitContainer should be using image **busybox:1.31.0**. Test your implementation for example using **curl** from a temporary **nginx:alpine** Pod.

```yaml
# 17_test-init-container.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      initContainers:                 # initContainer start
      - name: init-con
        image: busybox:1.31.0
        command: ['sh', '-c', 'echo "check this out!" > /tmp/web-content/index.html']
        volumeMounts:
        - name: web-content
          mountPath: /tmp/web-content # initContainer end
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
```

```bash
17_test-init-container.yaml
k -n mars get pod -o wide # to get the cluster IP
$kcmd -- curl 10.0.0.67
```

---

## Q 18 - Task weight: <code>4%</code>

There seems to be an issue in Namespace **mars** where the ClusterIP service **manager-api-svc** should make the Pods of Deployment **manager-api-deployment** available inside the cluster.

You can test this with **curl manager-api-svc.mars:4444** from a temporary **nginx:alpine** Pod. Check for the misconfiguration and apply a fix.

```bash
ns=mars
$kcmd -n $mars -- curl -m 5 manager-api-svc:4444 # not working
k -n mars get pod -o wide # get cluster IP
$kcmd -n $mars -- curl -m 5 10.0.1.14 # but it works
```

```yaml
# k -n mars edit service manager-api-svc
apiVersion: v1
kind: Service
metadata:
...
  labels:
    app: manager-api-svc
  name: manager-api-svc
  namespace: mars
...
spec:
  clusterIP: 10.3.244.121
  ports:
  - name: 4444-80
    port: 4444
    protocol: TCP
    targetPort: 80
  selector:
    #id: manager-api-deployment # wrong selector, needs to point to pod!
    id: manager-api-pod
  sessionAffinity: None
  type: ClusterIP
```

```bash
$kcmd -n $mars -- curl -m 5 manager-api-svc:4444 # check again
```

---

## Q 19 - Task weight: <code>3%</code>

In Namespace **jupiter** you'll find an apache Deployment (with one replica) named **jupiter-crew-deploy** and a ClusterIP Service called **jupiter-crew-svc** which exposes it. Change this service to a NodePort one to make it available on all nodes on port **30100**.

Test the NodePort Service using the internal IP of all available nodes and the port 30100 using **curl**, you can reach the internal node IPs directly from your main terminal. On which nodes is the Service reachable? On which node is the Pod running?

```bash
ns=jupiter
k -n jupiter get all
$kcmd -- curl -m 5 jupiter-crew-svc:8080
k -n jupiter edit service jupiter-crew-svc
```

```yaml
# k -n jupiter edit service jupiter-crew-svc
apiVersion: v1
kind: Service
metadata:
  name: jupiter-crew-svc
  namespace: jupiter
...
spec:
  clusterIP: 10.3.245.70
  ports:
  - name: 8080-80
    port: 8080
    protocol: TCP
    targetPort: 80
    nodePort: 30100 # add the nodePort
  selector:
    id: jupiter-crew
  sessionAffinity: None
  #type: ClusterIP
  type: NodePort    # change type
status:
  loadBalancer: {}
```

```bash
curl 192.168.100.11:30100
curl 192.168.100.12:30100
```

---

## Q 20 - Task weight: <code>9%</code>

In Namespace **venus** you'll find two Deployments named **api** and **frontend**. Both Deployments are exposed inside the cluster using Services. Create a NetworkPolicy named np1 which restricts outgoing tcp connections from Deployment **frontend** and only allows those going to Deployment **api**. Make sure the NetworkPolicy still allows outgoing traffic on UDP/TCP ports 53 for DNS resolution.

Test using: **wget www.google.com** and **wget api:2222** from a Pod of Deployment frontend.

```bash
ns=venus
k -n $ns get all
$kcmd -n $ns -- wget -O- frontend:80
$kcmd -n $ns -- wget -O- api:2222
$kcmd -n $ns -- wget -O- www.google.com
```

```yaml
# 20_np1.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np1
  namespace: venus
spec:
  podSelector:
    matchLabels:
      id: frontend          # label of the pods this policy should be applied on
  policyTypes:
  - Egress                  # we only want to control egress
  egress:
  - to:                     # 1st egress rule
    - podSelector:            # allow egress only to pods with api label
        matchLabels:
          id: api
  - ports:                  # 2nd egress rule
    - port: 53                # allow DNS UDP
      protocol: UDP
    - port: 53                # allow DNS TCP
      protocol: TCP
```

```bash
# test again
k -n $ns get all
$kcmd -n $ns -- wget -O- frontend:80
$kcmd -n $ns -- wget -O- api:2222
$kcmd -n $ns -- wget -O- www.google.com
```

---

## Q 21 - Task weight: <code>4%</code>

Team Neptune needs 3 Pods of image **httpd:2.4-alpine**, create a Deployment named **neptune-10ab** for this. The containers should be named **neptune-pod-10ab**. Each container should have a memory request of **20Mi** and a memory limit of **50Mi**.

Team Neptune has it's own ServiceAccount **neptune-sa-v2** under which the Pods should run. The Deployment should be in Namespace **neptune**.

```bash
ns=neptune
k -n $ns create deploy neptune-10ab --image=httpd:2.4-alpine $do > 21.yaml
```

```yaml
# 21.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: neptune-10ab
  name: neptune-10ab
  namespace: neptune
spec:
  replicas: 3                   # change
  selector:
    matchLabels:
      app: neptune-10ab
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: neptune-10ab
    spec:
      serviceAccountName: neptune-sa-v2 # add
      containers:
      - image: httpd:2.4-alpine
        name: neptune-pod-10ab  # change
        resources:              # add
          limits:               # add
            memory: 50Mi        # add
          requests:             # add
            memory: 20Mi        # add
status: {}
```

---

## Q 22 - Task weight: <code>3%</code>

Team Sunny needs to identify some of their Pods in namespace **sun**. They ask you to add a new label **protected: true** to all Pods with an existing label **type: worker** or **type: runner**. Also add an annotation **protected: do not delete this pod** to all Pods having the new label **protected: true**.

```bash
k -n sun get pod --show-labels
k -n sun get pod -l type=runner # only pods with label runner

# labeling
k -n sun label pod -l type=runner protected=true # run for label runner
k -n sun label pod -l type=worker protected=true # run for label worker

## or
k -n sun label pod -l "type in (worker,runner)" protected=true

k -n sun get pod --show-labels # check label in pod

# annotating
k -n sun annotate pod -l protected=true protected="do not delete this pod"

# last check
k -n sun get pod -l protected=true -o yaml | grep -A 8 metadata:

```

---

## Preview Question 1

In Namespace **pluto** there is a Deployment named **project-23-api**. It has been working okay for a while but Team Pluto needs it to be more reliable. Implement a liveness-probe which checks the container to be reachable on port 80. Initially the probe should wait 10, periodically 15 seconds.

The original Deployment yaml is available at **/opt/course/p1/project-23-api.yaml**. Save your changes at **/opt/course/p1/project-23-api-new.yaml** and apply the changes.

```yaml
# /opt/course/p1/project-23-api-new.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: project-23-api
  namespace: pluto
spec:
  replicas: 3
  selector:
    matchLabels:
      app: project-23-api
  template:
    metadata:
      labels:
        app: project-23-api
    spec:
      volumes:
      - name: cache-volume1
        emptyDir: {}
      - name: cache-volume2
        emptyDir: {}
      - name: cache-volume3
        emptyDir: {}
      containers:
      - image: httpd:2.4-alpine
        name: httpd
        volumeMounts:
        - mountPath: /cache1
          name: cache-volume1
        - mountPath: /cache2
          name: cache-volume2
        - mountPath: /cache3
          name: cache-volume3
        env:
        - name: APP_ENV
          value: "prod"
        - name: APP_SECRET_N1
          value: "IO=a4L/XkRdvN8jM=Y+"
        - name: APP_SECRET_P1
          value: "-7PA0_Z]>{pwa43r)__"
        livenessProbe:                  # add
          tcpSocket:                    # add
            port: 80                    # add
          initialDelaySeconds: 10       # add
          periodSeconds: 15             # add
```

---

## Preview Question 2

Team Sun needs a new Deployment named **sunny** with 4 replicas of image **nginx:1.17.3-alpine** in Namespace **sun**. The Deployment and its Pods should use the existing ServiceAccount **sa-sun-deploy**.

Expose the Deployment internally using a ClusterIP Service named **sun-srv** on port 9999. The nginx containers should run as default on port 80. The management of Team Sun would like to execute a command to check that all Pods are running on occasion. Write that command into file **/opt/course/p2/sunny_status_command.sh**. The command should use **kubectl**.

```yaml
# p2_sunny.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: sunny
  name: sunny
  namespace: sun
spec:
  replicas: 4                               # change
  selector:
    matchLabels:
      app: sunny
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: sunny
    spec:
      serviceAccountName: sa-sun-deploy     # add
      containers:
      - image: nginx:1.17.3-alpine
        name: nginx
        resources: {}
status: {}
```

```yaml
#k -n sun expose deployment sunny --name sun-srv --port 9999 --target-port 80
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: sunny
  name: sun-srv         # required by task
spec:
  ports:
  - port: 9999          # service port
    protocol: TCP
    targetPort: 80      # target port
  selector:
    app: sunny          # selector is important
status:
  loadBalancer: {}
```

---

## Preview Question 3

Management of EarthAG recorded that one of their Services stopped working. Dirk, the administrator, left already for the long weekend. All the information they could give you is that it was located in Namespace **earth** and that it stopped working after the latest rollout. All Services of EarthAG should be reachable from inside the cluster.

Find the Service, fix any issues and confirm it's working again. Write the reason of the error into file **/opt/course/p3/ticket-654.txt** so Dirk knows what the issue was.

```yaml
# k -n earth edit deploy earth-3cc-web
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
...
  generation: 3                     # there have been rollouts
  name: earth-3cc-web
  namespace: earth
...
spec:
...
  template:
    metadata:
      creationTimestamp: null
      labels:
        id: earth-3cc-web
    spec:
      containers:
      - image: nginx:1.16.1-alpine
        imagePullPolicy: IfNotPresent
        name: nginx
        readinessProbe:
          failureThreshold: 3
          initialDelaySeconds: 10
          periodSeconds: 20
          successThreshold: 1
          tcpSocket:
            port: 82                # this port doesn't seem to be right, should be 80
          timeoutSeconds: 1
```

```bash
# /opt/course/p3/ticket-654.txt
wrong port for readinessProbe defined!
```