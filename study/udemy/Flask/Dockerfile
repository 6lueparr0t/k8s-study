FROM ubuntu

RUN apt-get update
RUN apt-get install python
# Adding build tools to make yarn install work on Apple silicon / arm64 machines
RUN apt-get install python2 g++ make

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run

# github.com/kodekloudhub/webapp-color 참고
# 빌드
# docker build -t 6lueparr0t/udemy-python-app --platform linux/amd64 .

# 이미지 푸시
# docker push 6lueparr0t/udemy-python-app

# 이미지 기반 명령어 실행
# docker run 이미지 명령어
# ex) docker run python:3.6 cat /etc/*release*
# ex) docker run -d -p 8383:8080 webapp-color:lite

# 이미지 생성 시, alpine 이미지 사용 시, 용량을 줄일 수 있다.