/* Record Locking *** Progress manages locked records in a shared memory via a Lock Table 

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

FIND FIRST Cust EXCLUSIVE-LOCK.

/* This time there is no issue with the code... 

However if a SHARE-LOCK is obtained outside a transaction, then held when a transaction starts; we must wait for the 
end of the transaction or the record is released.... 
in the example below, an EXCLUSIVE-LOCK is only acquired during the transaction loop; it continues to be locked until 
the end of the transaction. 
** It is then converted to a SHARE-LOCK again if the record scope is larger than the transaction ( ..here it is NOT)

Connect two clients to the same database, in session 1 run the following code:
*/

FIND FIRST Cust.
DO TRANSACTION:

   /* Usually you would modify the record here */

    PAUSE.

END.

/* 2nd Pause */
PAUSE.

/*
When the first PAUSE statement is hit, in your other session, run this code 
*/
FIND FIRST Cust EXCLUSIVE-LOCK.

/* You will get the 2624 error... to say the record is locked.
Once you Press the Spacebar, in your 1st session... and get to the 2nd Pause. 
Run the FIND FIRST Cust EXCLUSIVE-LOCK code again.  
** The 2624 error will again appear...  as the SHARE-LOCK is still being held; the record has NOT been released yet and
it has NOT gone out of scope.
*/

/*

*** A record continues to remain locked, while the transaction remains active. *** 

The EXCLUSIVE-LOCK will be downgraded to a SHARE-LOCK even if the record was first read with a NO-LOCK. 
This is because when the NO-LOCK is upgraded to EXCLUSIVE-LOCK.  Note that the record must be reread 
from the database before the lock is applied.
*/

FIND FIRST Cust NO-LOCK.

DO TRANSACTION:
    
    /* Find the Current record and make modifications to it */
    FIND CURRENT Cust EXCLUSIVE-LOCK.
    /* .... mods */
    
END.

/* The record is still avail and has a Share-lock */
IF AVAILABLE Customer THEN 
    DISPLAY Cust.CustID Cust.LastName.
    
/*     
In the case where the transaction has ended but the record scope has not, to override the SHARE-LOCK 
use the RELEASE statement to release the record from the record buffer.  
If the record is still needed after the transaction has ended it will need to be re-found using a NO-LOCK.
*/

FIND FIRST Cust NO-LOCK.

DO TRANSACTION:
    
    FIND CURRENT Cust EXCLUSIVE-LOCK.
    /* do stuff... and then */
    RELEASE Cust.
    
END.

/* No Cust record is Now available... so find it again */
FIND FIRST Cust NO-LOCK.

IF AVAILABLE Cust THEN
    DISPLAY Cust.CustID Cust.LastName.
    
/* Progress stores each locked record in a Lock Table. The size of the lock table defaults to 8192 entries...
At startup it can be adjusted by using the -L database startup parameter.
     
    
*/
