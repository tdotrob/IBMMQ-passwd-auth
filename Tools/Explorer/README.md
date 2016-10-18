# Instructions for use
The testing methodology (as of this writing) uses MQ Explorer to exercise the SVRCONN channels.  Enclosed is an XML file that can be imported into MQ Explorer to generate six remote connections matching the channels created by the MQSC scripts.

The file contains handles for channels that correspond to PEERMAP, USERMAP, and ADDRESSMAP rules, both in Compatibility Mode and MQCSP Mode, for a total of six channels.

The user IDs have been removed from the connection definitions.  The initial tests were performed with Explorer running as mqm and t.rob as the MQCSP account name.  These can be changed by editing the file prior to importing or dynamically in the Connection Details dialog.

It is not possible to transfer passwords in the import file so these will need to be entered on all six channels after importing.  This is the same screen that has the User ID so if it is not changed prior to the import you can change it here as well.

At the moment the tools all look for a queue manager named ASH listening on localhost at port 1416.  These values are immutable once defined so any required alterations must be made by editing the file prior to importing it.   
