FROM python:3.8.3-slim-buster

RUN apt-get update && apt-get install sshpass vim -y

COPY ./requirements.txt /local/requirements.txt
COPY ./requirements.yml /local/requirements.yml
WORKDIR /local

RUN pip install -r requirements.txt \
 && ansible-galaxy install -r requirements.yml

CMD ["/bin/bash"]
