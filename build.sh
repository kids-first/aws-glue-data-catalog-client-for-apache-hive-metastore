#!/bin/bash
set -e
hive_version=2.3.7

echo " ########## Downlaoding hive .... "
mkdir hive
curl -sL https://github.com/apache/hive/archive/rel/release-2.3.7.tar.gz | tar -xz --strip-components=1 -C hive

cd hive
echo " ########## Apply patch .... "
curl -sL https://issues.apache.org/jira/secure/attachment/12958418/HIVE-12679.branch-2.3.patch -o hive.patch
patch -p0 <hive.patch

echo " ########## Build hive .... "
mvn clean install -DskipTests

echo " ########## AWS Glue for hive metastore .... "
cd ..
mvn clean package -DskipTests -pl -aws-glue-datacatalog-hive2-client

mkdir -p dist/jars
find . -path ./hive -prune -false -o -name "*.jar" | grep -Ev "test|original" | xargs -I{} cp {} ./dist/jars

echo " ########## Success !!! "

