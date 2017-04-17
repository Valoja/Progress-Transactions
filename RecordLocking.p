/* Record Locking

By default whenever a record is read with a SHARE-LOCK, this means that other users may read the record 
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

FIND FIRST Cust EXCLUSIVE-LOCK.

/ ****

Any attempt to acquire an EXCLUSIVE-LOCK on a record that currently has a SHARE-LOCK or 
an EXCLUSIVE-LOCK results in a message that the record is in use. 

***/


By default when a record is updated PROGRESS puts an EXCLUSIVE-LOCK on the record. 
Other users cannot read or update the record until the EXCLUSIVE-LOCK is removed. 
