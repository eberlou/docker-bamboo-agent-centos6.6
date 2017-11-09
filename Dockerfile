FROM centos:6.6
MAINTAINER L-A B <la.bergeron@hotmail.com>

# Update system & install dependencies
RUN yum -y update \
	&& yum -y install git java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel unzip wget which \
	&& yum -y clean all

# Create user and group for Bamboo
RUN groupadd -r -g 900 bamboo-agent \
	&& useradd -r -m -u 900 -g 900 bamboo-agent

COPY bamboo-agent-centos.sh /
COPY bamboo-capabilities.properties /

USER bamboo-agent
CMD ["/bamboo-agent-centos.sh"]
