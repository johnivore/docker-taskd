FROM alpine:3

# apk add --no-cache implies --update and packages are not locally cached
RUN set -x \
	&& apk add --no-cache taskd taskd-pki tzdata

COPY ./entrypoint.sh /entrypoint.sh

ENV TASKDDATA /var/taskd
VOLUME /var/taskd
EXPOSE 53589

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
