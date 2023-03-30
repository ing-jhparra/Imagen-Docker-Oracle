FROM centos:latest
MAINTAINER "Jesus Parra" <parra.jesus@gmail.com>
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y update
RUN yum -y install sudo
RUN mkdir /oracle
WORKDIR /oracle
ADD oracle-database-*.rpm /oracle
RUN yum -y localinstall oracle-database-preinstall-19c-1.0-2.el8.x86_64.rpm
USER root 
RUN export ORACLE_DOCKER_INSTALL=true && \ 
    yum -y localinstall oracle-database-ee-19c-1.0-1.x86_64.rpm
USER oracle
RUN echo "PATH=$ORACLE_HOME/bin:$PATH" >> ~/.bash_profile && \
    echo "export PATH" >> ~/.bash_profile && \
    source  ~/.bash_profile
RUN rm *.rpm
#RUN /etc/init.d/oracledb_ORCLCDB-19c configure
CMD ["/bin/bash"]
