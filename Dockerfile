FROM alpine:3

RUN set -x \
	&& apk add --no-cache taskd taskd-pki

COPY ./entrypoint.sh /entrypoint.sh

ENV TASKDDATA /var/taskd
VOLUME /var/taskd
EXPOSE 53589

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
