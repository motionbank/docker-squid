FROM debian:12-slim

ENV SQUID_VERSION=5.7-2+deb12u1 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=proxy

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

RUN usermod -a -G tty proxy
RUN echo "\nlogfile_rotate 0 \
    \ncache_log stdio:/dev/tty \
    \naccess_log stdio:/dev/tty \
    \ncache_store_log stdio:/dev/tty\n" >> /etc/squid/squid.conf

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
