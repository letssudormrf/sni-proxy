FROM alpine:3.7

# Add local files to image
COPY files /
RUN chmod a+rwx /usr/local/bin/entrypoint.sh
    
RUN set -ex;\
    apk update;\
    apk upgrade;\
    apk add --no-cache sniproxy;\
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sniproxy", "-c /tmp/sniproxy.conf", "-f"]
