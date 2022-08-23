# Kubernetes(+ docker) Study

## Feature
- 쿠버네티스(와 도커) 공부
- ~~[쿠버네티스 완벽 가이드] 로 공부 중~~
  - 언젠간 다시 해야지..
- [소스 코드] URL
- [Udemy] 보며 CKAD 준비
  - [블로그 링크](https://github.com/6lueparr0t/k8s-study/blob/main/README.md) 정리

[쿠버네티스 완벽 가이드]: https://www.google.com/search?q=%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4+%EC%99%84%EB%B2%BD+%EA%B0%80%EC%9D%B4%EB%93%9C&oq=%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4+%EC%99%84%EB%B2%BD+%EA%B0%80%EC%9D%B4%EB%93%9C&aqs=chrome..69i57.4917j0j7&sourceid=chrome&ie=UTF-8

[소스 코드]: https://github.com/MasayaAoyama/kubernetes-perfect-guide
[Udemy]: https://www.udemy.com/course/certified-kubernetes-application-developer/

---

## Setting

### auto-completion

```bash
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

alias k=kubectl
complete -o default -F __start_kubectl k
```

### alias

```bash
export ns=default
alias k='kubectl -n $ns'
alias kp='k get pods'

export do="--dry-run=client -o yaml"

alias kcmd='k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5'
export now="--force --grace-period 0"
```

### vim

```bash
vim ~/.vimrc
// input this
set sw=2 ts=2 sts=2 et
```

### Config Reference
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/#bash
- https://itnext.io/how-i-prepare-ckad-certified-kubernetes-application-developer-ad911d5f1054