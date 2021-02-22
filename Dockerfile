#docker volume create minidlna_data
#docker run -d --name=minidlna --publish 8200:8200 --mount type=bind,src=/hdd,dst=/opt --mount type=volume,src=minidlna_data,dst=/var/cache/minidlna tomdyg/minidlna:latest
#docker service create --name minidlna --publish 8200:8200 --mount type=bind,src=/hdd,dst=/opt --mount type=volume,src=minidlna_data,dst=/var/cache/minidlna  --replicas=1 --constraint 'node.hostname == orangepipc2' tomdyg/minidlna:latest


FROM alpine:latest

EXPOSE 8200

RUN apk --no-cache update && apk --no-cache upgrade
RUN apk --no-cache add minidlna

ENV FRIENDLY_NAME "DLNA Server"
ENV MEDIA_DIR /opt
ENV DB_DIR /var/cache/minidlna
ENV LOG_DIR /var/log
ENV INOTIFY yes

COPY minidlna.conf /etc/minidlna.conf
COPY docker-run /usr/local/bin/docker-run
COPY docker-run-pre /usr/local/bin/docker-run-pre
RUN chmod +x /usr/local/bin/docker-run
RUN echo "/usr/sbin/minidlnad -f /etc/minidlna.conf -P /run/minidlna/minidlna.pid; exec tail -f /dev/null">> /usr/local/bin/docker-run-alt
RUN chmod +x /usr/local/bin/docker-run-alt
RUN chmod +x /usr/local/bin/docker-run-pre

WORKDIR /usr/local/bin
ENTRYPOINT ["docker-run"]

