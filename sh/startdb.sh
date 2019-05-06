#!/bin/bash
echo "export PGHOME=/postgres" >> /etc/profile 
echo "export PGDATA=/postgres/data" >> /etc/profile 
echo "export PATH=$PATH:/postgres/bin:/sbin" >> /etc/profile
source /etc/profile
su - postgres -s /bin/bash -c "source /etc/profile"
su - postgres -s /bin/bash -c "echo export LD_LIBRARY_PATH=/postgres/lib >> ~/.bashrc"
su - postgres -s /bin/bash -c "source ~/.bashrc"
su - postgres -s /bin/bash -c "pg_ctl restart -D /postgres/data/"
echo "postgres db running............."

/bin/bash
