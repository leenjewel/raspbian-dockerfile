FROM leenjewel/raspbian:latest
MAINTAINER leenjewel <leenjewel@gmail.com>

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y perl --no-install-recommends && rm -fr /var/lib/apt/lists/*

ENV MYSQL_VERSION 5.5

RUN {\
    echo mysql-server mysql-server/data-dir select ''; \
    echo mysql-server mysql-server/root-pass password ''; \
    echo mysql-server mysql-server/re-root-pass password ''; \
    echo mysql-server mysql-server/remove-test-db select false; \
    } | debconf-set-selections \
    && apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}"* && rm -fr /var/lib/apt/lists/* \
    && rm -fr /var/lib/mysql && mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]

