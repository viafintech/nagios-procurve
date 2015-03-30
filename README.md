# Nagios Check for HP ProCurve Switches

This is a nagios check for HP ProCurve switches. It provides the necessary OID's and logic on top of nagios default SNMP check to get information about the monitored ProCurve switches.

This check will be enhanced from time to time but by now it only support monitoring of interface ports and LACP Trunks.

## Available versions

If you want the latest stable version you can easily stick with the master branch. If you want a specific version, checkout the respective branch.
The latest stuff is always available on the Development branch.

## How to use?

Just get the check_procurve.sh and set the correct path to the check_snmp nagios check if its not already the correct default.
Next versions will try to find that file itself and may get a fallback to different SNMP clients.

You can use the check like this...

`./check_procurve.sh 10.10.10.2 public 1,2,4,8,23,49`

...where you need to set the IP of the switch, the snmp community and the ports you want to check separated by commas.
LACP Trunks start with a higher port number 49 and following.

## Contributing and License

Feel free to contribute by forking the check and creating feature branches which i can merge back. Please sign-off your commits. Every contribution is welcome, even just issues if you can't fix them yourself!

Released under the MIT License
