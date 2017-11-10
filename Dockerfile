FROM centos:6.6
MAINTAINER L-A B <la.bergeron@hotmail.com>

# Update system & install dependencies
RUN yum -y update \
	&& yum -y install git java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel unzip wget which \
	&& yum -y clean all

COPY bamboo-agent-centos.sh /
COPY bamboo-capabilities.properties /

CMD ["/bamboo-agent-centos.sh"]
