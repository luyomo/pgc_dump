FROM debian AS builder

ENV http_proxy=http://10.136.0.60:8080 https_proxy=http://10.136.0.60:8080 PATH=/postgres/bin:$PATH

RUN apt-get update && apt-get remove -y libprotobuf-c-dev libprotobuf-dev && apt-get install -y build-essential pkg-config libreadline-dev zlib1g-dev libproj-dev liblwgeom-dev libprotobuf-c-dev rsync openssh-server libprotobuf-dev wget tar xz-utils zip

WORKDIR /opt

RUN wget https://ftp.postgresql.org/pub/source/v11.1/postgresql-11.1.tar.gz
RUN tar -xzvf postgresql-11.1.tar.gz

COPY pgc_dump /opt/postgresql-11.1/src/bin/pgc_dump

RUN sed -i '/pg_dump\ \\/a\pgc_dump\ \\' /opt/postgresql-11.1/src/bin/Makefile && mkdir -p /postgres/data && cd /opt/postgresql-11.1 && chmod 777 configure && ./configure --prefix=/postgres --enable-debug && make && make install

FROM debian

COPY --from=builder /postgres /postgres
COPY sh /postgres/sh
RUN chmod -R 777 /postgres/sh/*.sh

RUN groupadd postgres && useradd -s /bin/bash -g postgres postgres && mkdir /home/postgres && chown postgres:postgres /home/postgres && chown postgres:postgres /postgres/data

ENV http_proxy=http://10.136.0.60:8080 https_proxy=http://10.136.0.60:8080 PATH=/postgres/bin:$PATH

RUN apt-get update && apt-get install -y liblwgeom-2.3-0 openssh-server rsync libprotobuf-c-dev curl xxd sshpass

ENV LANG C.UTF-8
USER postgres
RUN /postgres/bin/initdb -D /postgres/data -E UTF-8 


RUN sh -c "/postgres/sh/create_database.sh >/dev/null 2>&1"


USER root

#EXPOSE 5432
ENTRYPOINT ["/postgres/sh/startdb.sh"]
