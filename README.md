# Nagios Check for HP Procurve Switches

This is a nagios check for HP Procurve switch monitoring using check_snmp. It provides necessary OID-Base and logic on top of nagios default SNMP check.

With this tool you can check the operational status of each individual interface as well as LACP-Trunks.

# How to use?

Just get the check_procurve_ifoperstatus.sh and set the appropriate settings in the file like the patch to nagios check_snmp file
and the OID-Base if it differs for you, then execute it:

`./check_procurve_ifoperstatus.sh 10.10.10.2 public 1,2,4,8,23,49`

where you need to set the IP of the switch, the snmp community and the ports you want to check.

# Known issues and a bit of a roadmap

By now i only have tested the module on a HP Procurve 2510G-24 switch but i will add support for more models (2530-24G) too.
Send me one if you want me adding support for it.

Also this script was written quick and dirty for fast usage, so the roadmap will be:

* Adding support for more models
* Clean up the code and rewrite parts of it
* Add functionality what users want