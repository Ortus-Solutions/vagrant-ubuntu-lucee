#!/bin/sh

# Setup JDK + JRE Locations
JAVA_HOME="/usr/lib/jvm/current"
JRE_HOME="/usr/lib/jvm/current/jre"
export JAVA_HOME;
export JRE_HOME;

# Setup Java Options
JAVA_OPTS="$JAVA_OPTS -Xms64m -Xmx256m ";
export JAVA_OPTS;

# Setup Catalina Options
CATALINA_OPTS="$CATALINA_OPTS -Xms512m -Xmx512m -javaagent:/opt/lucee/tomcat/lib/lucee-inst.jar ";
export CATALINA_OPTS;