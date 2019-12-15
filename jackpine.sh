#!/bin/sh
# jackpine1.0
#
# Spatial benchmark 
# (c) 2011 University of Toronto. All rights reserved. 

#BHOME=`dirname $0`/..
BHOME=`pwd`

# Load all jars from the lib and lib-ext directories. 
for jar in $BHOME/lib/*.jar
do
  if [ -z $CP ]; then
    CP=$jar
  else
    CP=$CP:$jar
  fi
done
CP=$CP:$BHOME/config

BRISTLECONE_JVMDEBUG_PORT=54001
# uncomment to debug
# JVM_OPTIONS="${JVM_OPTIONS} -enableassertions -Xdebug -Xnoagent -Djava.compiler=none -
# Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=$BRISTLECONE_JVMDEBUG_PORT"
JVM_OPTIONS="${JVM_OPTIONS} -Xmx512m"

echo $SHELL
for scenario in $BHOME/config/*.properties
do
	Offset=`expr match $scenario '[0-9a-zA-Z./]*connection[a-zA-Z._]'`
	Ndex=`expr match $scenario '[0-9a-zA-Z./]*log4j[a-zA-Z.]*'`
	if [ "$Offset" = 0 ] && [ "$Ndex" = 0 ]; then
        	OutputFile=`echo $scenario | sed -e 's+^.*/++'`
		Offset=`expr index $OutputFile .`
		Offset=`expr $Offset - 1`
		OutputFile=`expr substr $OutputFile 1 $Offset`
 		echo "\nRunning scenario $scenario. Result is written in ./TestResults/${OutputFile}.html"
		if [ $# = 2 ] && [ $1 = "-i" ];  then
			java -cp $CP ${JVM_OPTIONS}  edu.toronto.cs.jackpine.benchmark.JackpineBenchmarkLauncher -props $scenario -html results/${OutputFile}.html -include $2
		else	
			java -cp $CP ${JVM_OPTIONS}  edu.toronto.cs.jackpine.benchmark.JackpineBenchmarkLauncher -props $scenario -html results/${OutputFile}.html
		fi
	fi
done
