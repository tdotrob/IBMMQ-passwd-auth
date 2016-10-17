# IBMMQ-passwd-auth
**Tools to demonstrate the behavior of various combinations of CHLAUTH mapping rules in IBM MQ v8.0 and higher with password-based authentication enabled, and the results of those tests.**

As of IBM MQ v8.0 the ability to natively validate a user ID and password has been delivered, and integrated into the existing CHLAUTH functionality.  The many possible CHLAUTH rule combinations interacting with the new ADOPTCTX parammeter present a steep learning curve to MQ administrators in the best case.  As of MQ v8.0.0.5 the behavior of of these controls has changed several times which presents something less than the best case to the MQ administrator.  Based on the nature of the changes and that the current version as of this writing (v8.0.0.5) appears to be broken, additional changes to the behavior are anticipated in future releases. 

The intent of this project is to provide the means for an MQ Administrator to quickly and reliably ascertain the behavior of IBM MQ client authentication under a specific Fix Pack and queue manager configuration.
