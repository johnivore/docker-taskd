FROM alpine:3

RUN set -x \
	&& apk add --no-cache taskd taskd-pki

ENV TASKDDATA /var/taskd
VOLUME /var/taskd
EXPOSE 53589

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
