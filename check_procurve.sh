#!/usr/bin/env bash

# check_procurve.sh v1.1
# (c) 2012-2015 - Martin Seener (martin.seener@barzahlen.de)

PROGNAME=$(basename $0)
VERSION="v1.1"
AUTHOR="2012-2015, Martin Seener (martin@seener.de)"

# Locations
# Uncomment next line if its in the same path as this script, or define manually
#SCRIPTPATH=`dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`
SCRIPTPATH="/usr/lib/nagios/plugins"
CHECKSNMP=$SCRIPTPATH"/check_snmp"

# Pre-defined OID's for several checks
OID_IFOPERSTATUS="1.3.6.1.2.1.2.2.1.8." # OID for Interface Operational Status

# Anything above CRITTRESH will result in a CRITICAL check state
CRITTRESH=1

# Internal vars
OVERALLSTATUS=0
PORTSDONE=""
CRITPORTS=""

# At first check that check_snmp is there
if [ ! -x $CHECKSNMP ]; then
  echo "UNKNOWN - Unable to find $CHECKSNMP!"
  echo ""
  print_help
  exit 3
fi

print_help() {
  echo ""
  echo "$PROGNAME is a nagios check for monitoring HP ProCurve switches using SNMP."
  echo ""
  echo "Usage: ./$PROGNAME <IP or Hostname> <Community name> <comma-separated list of ports to be checked>"
  echo "Example: ./$PROGNAME 10.10.10.2 public 1,2,4,8,23,49"
  echo ""
}

# Check if all parameters are set
if [ "$1" != "" ] && [ "$2" != "" ] && [ "$3" != "" ]; then
  # We have some so lets start to read the ports into an sorted array
  OIFS=$IFS
  # Internal Field Separator backupped and is now being changed to comma
  IFS=','
  CHECKPORTS=($3)
  # we have the ports sorted in an array, now change IFS back to original
  IFS=$OIFS
  # now we´ll check each port in the array
  CHECKPORTSLENGTH=${#CHECKPORTS[@]}
  for ((i=0; i<${CHECKPORTSLENGTH}; i++))
  do
    if [ "$OID_IFOPERSTATUS" != "" ]; then
      $CHECKSNMP -H $1 -C $2 -c $CRITTRESH -o $OID_IFOPERSTATUS${CHECKPORTS[$i]} > /dev/null 2>&1
    else
      $CHECKSNMP -H $1 -C $2 -c $CRITTRESH -o ${CHECKPORTS[$i]} > /dev/null 2>&1
		fi
		if [ $? -ne 0 ]; then
      if [ "$OID_IFOPERSTATUS" != "" ]; then
        # Ports Status os not "up" or "1" therefore we give out a CRITICAL Warning
        OVERALLSTATUS=2
        if [ ${CHECKPORTS[$i]} == 49 ]; then
          ACTUALPORT="LACP"
        else
          ACTUALPORT=${CHECKPORTS[$i]}
        fi
      else
        OVERALLSTATUS=2
        # Cut the OID_IFOPERSTATUS away so we only have the Port
        ACTUALPORT=`echo ${CHECKPORTS[$i]} | rev | cut -d'.' -f1`
        if [ $ACTUALPORT == 49 ]; then
          ACTUALPORT="LACP"
        fi
      fi
      CRITPORTS=$CRITPORTS$ACTUALPORT","
    else
      if [ "$OID_IFOPERSTATUS" != "" ]; then
        if [ ${CHECKPORTS[$i]} == 49 ]; then
          ACTUALPORT="LACP"
        else
          ACTUALPORT=${CHECKPORTS[$i]}
        fi
      else
        ACTUALPORT=`echo ${CHECKPORTS[$i]} | rev | cut -d'.' -f1`
        if [ $ACTUALPORT == 49 ]; then
          ACTUALPORT="LACP"
        fi
      fi
      PORTSDONE=$PORTSDONE$ACTUALPORT","
    fi
  done

  # remove trailing comma of PORTSDONE and CRITPORTS
  PORTSDONE=${PORTSDONE%?}
  CRITPORTS=${CRITPORTS%?}

  case "$OVERALLSTATUS" in
    0)  echo "OK - Checked Ports("$PORTSDONE")"
        exit 0;;
    2)  echo "CRITICAL - Ports Critical("$CRITPORTS") Ports OK("$PORTSDONE")"
        exit 2;;
  esac
else
  # At least one parameter is missing, aborting as warning
  echo "UNKNOWN - At least one Parameter is missing!"
  echo ""
  print_help
  exit 3
fi
