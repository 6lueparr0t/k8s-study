## shell 설정

```bash
export ns=default
alias k='kubectl -n $ns' # Remember this must be single quote
alias kp='k get pods'
export do="--dry-run=client -o yaml"

# I would add the following alias when I need to do, not at the begining of the exam
# For debug pod's network
alias kcmd='k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5'
export now="--force --grace-period 0"
```

## vim 설정
```bash
vim ~/.vimrc
# input this
set sw=2 ts=2 sts=2 et
```