#!/bin/bash

NVIM_STD_DATA_DIR=$1
NVIM_STD_CACHE_DIR=$2
WORKSPACE_NAME=$3

# 新版本需要使用JDK17
export JAVA_HOME=$JAVA_HOME_17
export CLASSPATH=$JAVA_HOME_17/lib/dt.jar:$JAVA_HOME_17/lib/tools.jar

JDTLS_HOME="$NVIM_STD_DATA_DIR/mason/packages/jdtls"
JAVA="$JAVA_HOME/bin/java"
LOMBOK_JAR="$JDTLS_HOME/lombok.jar"
LAUNCHER_JAR=$(echo "$JDTLS_HOME/plugins/org.eclipse.equinox.launcher_*.jar")
CONFIG_DIR="$JDTLS_HOME/config_linux"
DATA_DIR="$NVIM_STD_CACHE_DIR/lsp/jdtls/$WORKSPACE_NAME"

# echo $JAVA
# echo $LOMBOK_JAR
# echo $LAUNCHER_JAR
# echo $CONFIG_DIR

# -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044
$JAVA \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xmx2G \
  -javaagent:$LOMBOK_JAR \
  -jar $LAUNCHER_JAR \
  -configuration $CONFIG_DIR \
  -data $DATA_DIR \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED