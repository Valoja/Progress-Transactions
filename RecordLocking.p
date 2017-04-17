/* Record Locking

By default whenever a record is read with a SHARE-LOCK it is locked, this means that other users may read the record 
but may not update it until the SHARE-LOCK is released.  

If an attempt is made to update a record that is SHARE-LOCKED the program that attempted to update the 
record will receive a message that the requested record is in use.

To illustrate:

Connect two clients to the same database (I'm assuming there is a Cust table in it)

In session 1 run the following code:
*/

FIND FIRST Cust.   /* This automatically creates a SHARE-LOCK */
PAUSE.

/* After the code in session 1 is executed, run the below code in session 2 */

FIND FIRST Cust EXCLUSIVE-LOCK.  /* results in Error 2624 */

/* ***

Any attempt to acquire an EXCLUSIVE-LOCK on a record that currently has a SHARE-LOCK or 
an EXCLUSIVE-LOCK results in a message that the record is in use. 

** */

/* 

By default when a record is updated PROGRESS puts an EXCLUSIVE-LOCK on the record. 
Other users cannot read or update the record until the EXCLUSIVE-LOCK is removed.

This is why we define NO-LOCK when a record is being read... and lock it exclusively only when required.

You can use the RELEASE keyword to specifically let go of a record that is being locked or read.

A SHARE-LOCK from outside a transaction is held by Progress until the record is released.

eg:
Connect two clients to the same database. In session 1 run the following code: */

FIND FIRST Cust.   /* Cust record is locked as a SHARE-LOCK */

RELEASE Cust. /* We release Cust record from being Locked */
PAUSE.

/* After the code in session 1 is executed and gets to the Pause, run the below code in session 2 */

FIND FIRST Customer EXCLUSIVE-LOCK.

This time there is no issue with the code...




*/
