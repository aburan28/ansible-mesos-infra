FROM centos:7
MAINTAINER "aburan28@gmail.com"


RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install epel-release
RUN yum -y install git sudo
RUN yum -y install python-pip python-setuptools python-crypto
RUN yum groupinstall -y "development tools"
RUN yum clean all
RUN pip install ansible
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers
RUN if [ ! -d "/etc/ansible" ]; then mkdir /etc/ansible; fi
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
