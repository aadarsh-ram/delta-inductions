FROM ubuntu

RUN apt-get -y update && \
    apt-get -y install sudo
RUN apt-get -y install datamash
RUN apt-get -y install cron
RUN apt-get -y install acl
RUN apt-get -y install python3-pip
RUN pip3 install markupsafe==2.0.1
RUN pip3 install Flask==1.1.4
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

COPY ./scripts ./code/scripts

WORKDIR /code/scripts
RUN chmod +x ./genUser.sh
RUN chmod +x ./aliasgen.sh 
RUN chmod +x ./permit.sh
RUN chmod +x ./app.py 

RUN ./aliasgen.sh

CMD bash -c "./genUser.sh ; ./permit.sh ; python3 -u app.py"
EXPOSE 1000