# IBMMQ-passwd-auth
**Tools to demonstrate the behavior of various combinations of CHLAUTH mapping rules in IBM MQ v8.0 and higher with password-based authentication enabled, and the results of those tests.**

As of IBM MQ v8.0 the ability to natively validate a user ID and password has been delivered, and integrated into the existing CHLAUTH functionality.  The many possible CHLAUTH rule combinations interacting with the new ADOPTCTX parameter present a steep learning curve to MQ administrators in the best case.  As of MQ v8.0.0.5 the behavior of these controls has changed several times which presents something less than the best case to the MQ administrator.  Based on the nature of the changes and that the current version as of this writing (v8.0.0.5) appears to be broken, additional changes to the behavior are anticipated in future releases. 

The intent of this project is to provide the means for an MQ Administrator to quickly and reliably ascertain the behavior of IBM MQ client authentication under a specific Fix Pack and queue manager configuration.

**UPDATE 29NOV16**

Word has just been received on the List Server that a possible MQ Explorer bug was not properly toggling Compatibility Mode in some early releases of v8.0.  Because Explorer was the tool used to test, some of the results may be affected.  There is a separate Explorer bug that as of 8.0.0.5 it overwrites the Plugins and Dropins directories and forces the user to run from a different workspace.  Although this does not affect the results directly, it means using a version other than the one that is native to the MQ Server installation (i.e. reverting back to Explorer v8.0.0.0).

Rather than requiring specific versions of Explorer or maintaining various versions, the connection tests will be delegatged to a new Java program that will be added shortly.  Code has already been donated and it's just a matter of vetting and posting it.  That will cascade into new scripts that perform automated testing at the command line rather than using the GUI.  The intent is to maintain both sets.  The scripts for automated testing and post-patch regression testing, and the MQ Explorer and menu scripts for interactive "what-if" type testing.
