#!/bin/bash

## Installing requested packages (need to be root)
if [ "${PACKAGES}" != "" ]; then
        echo "Packages to install: "${PACKAGES}
        yum -y install ${PACKAGES}
        yum -y clean all
else
  echo "Nothing to install."
fi

## Checking if BAMBOO_SERVER is defined
if [ -z "${BAMBOO_SERVER}" ]; then
	echo "Bamboo server URL undefined!" >&2
	echo "Please set BAMBOO_SERVER environment variable to URL of your Bamboo instance." >&2
	exit 1
fi

cd ~

BAMBOO_AGENT=atlassian-bamboo-agent-installer-${AGENT_VERSION}.jar


## Set BANBOO_AGENT_HOME
if [ -z "${BAMBOO_AGENT_HOME}" ]; then
	export BAMBOO_AGENT_HOME=~/bamboo-agent-home
fi


if [ ! -f ${BAMBOO_AGENT} ]; then
	echo "Downloading agent JAR..."
	wget "-O${BAMBOO_AGENT}" "http://${BAMBOO_SERVER}:${BAMBOO_SERVER_PORT}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-${AGENT_VERSION}.jar"
fi

if [ ! -f ${BAMBOO_AGENT_HOME}/bamboo-agent.cfg.xml -a "${BAMBOO_AGENT_UUID}" != "" ]; then
	echo "Creating agent configuration file..."

	mkdir -p ${BAMBOO_AGENT_HOME}
	echo 'agentUuid='${BAMBOO_AGENT_UUID} > ${BAMBOO_AGENT_HOME}/uuid-temp.properties
fi

if [ ! -d ${BAMBOO_AGENT_HOME}/bin ]; then
	mkdir -p ${BAMBOO_AGENT_HOME}/bin
	cp /bamboo-capabilities.properties ${BAMBOO_AGENT_HOME}/bin/
fi

if [ ! -f ${BAMBOO_AGENT_HOME}/bamboo-agent.cfg.xml -a "${BAMBOO_AGENT_CAPABILITY}" != "" ]; then
	echo ${BAMBOO_AGENT_CAPABILITY} >> ${BAMBOO_AGENT_HOME}/bin/bamboo-capabilities.properties
fi

if [ ! -f ${BAMBOO_AGENT_HOME}/bamboo-agent.cfg.xml -a "${BAMBOO_AGENT_UUID}" != "" ]; then
	echo 'agentUuid='${BAMBOO_AGENT_UUID} >> ${BAMBOO_AGENT_HOME}/bin/bamboo-capabilities.properties
fi

echo "Setting up the environment..."
export LANG=en_US.UTF-8
export JAVA_TOOL_OPTIONS="-Dfile.encoding=utf-8 -Dsun.jnu.encoding=utf-8"
export DISPLAY=:1

echo Starting Bamboo Agent...
java -jar "${BAMBOO_AGENT}" "http://${BAMBOO_SERVER}:${BAMBOO_SERVER_PORT}/agentServer/"
