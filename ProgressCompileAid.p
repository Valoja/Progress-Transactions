/* Checking on to see what the transaction scope is... 

Use the COMPILE statement with the LISTING option.


You can specify a file in the LISTING option... that will contain information at the bottom.
It shows each block within the program and displays whether the block is a transaction or not.

Checking whether a transaction is active

You can use the built-in TRANSACTION function in your procedures to determine whether a transaction 
is currently active. This LOGICAL function returns TRUE if a transaction is active and FALSE otherwise. 
You might use this, for example, in a subprocedure that is called from multiple places and which needs
to react differently depending on whether its caller started a transaction. 
(When you have a single procedure, you should not need this function to tell you if a transaction is active!)

ways to check on what is happening with Transactions in your code 

TRANSACTION 4GL function ...   tells you if you are currently in a transaction. eg */

MESSAGE TRANSACTION VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*
   PROMON (Transaction menu, or Lock Table).   
   
   Sample output for PROMON Record Locking Table option
The following shows an example of this option's output.
Record Locking Table:by user number
Usr:Ten  Name      Domain    Chain #    Row-id   Table:Part  Lock Flags  Tran State Tran ID
  5:2    tenant2   tenant2   REC  517    4229       -1:0     EXCL        None          0
  8:4    lobtenant lobtenant REC  655    4367       -1:0     EXCL        None          0
RETURN - repeat, U - continue uninterrupted, Q - quit 
The size of the record locking table is set with the Locking Table Entries (-L) startup parameter. See the chapter on locks in OpenEdge Getting Started: ABL Essentials for more information on locks and locking.
Usr:Ten
The user number and tenant ID.
Name
For client processes, the user name; for a lock from a JTA transaction, <JTA> is displayed.
Domain
The user's domain name.
Chain
The chain type should always be REC, the record lock chain.
#
The record lock chain number. The locking table is divided into chains anchored in a hash table. These chains provide for fast lookup of record locks by Rec-id.
Row-id
The row-id for the lock table entry.
Table:Part
The ID and Partition ID of the locked table.
Lock
One of five lock types: X (exclusive lock), S (share lock), IX (intent exclusive lock), IS (intent share lock), or SIX (shared lock on table with intent to set exclusive locks on records).
Flags
There are five possible types of flags. The table below lists the flags and their meanings.

Flag          Name             Description
------------- ---------------- ----------------------------------------------------------------------------
C             Create           The lock is in create mode.
D             Downgrade        The lock is downgraded.
E             Expired          The lock wait timeout has expired on this queued lock.
H             No hold          The "nohold" flag is set.
J             JTA              The lock is part of a JTA transaction
K             Keep             Keep the lock across transaction end boundary
L             Limbo lock       The client has released the record, but the transaction has not completed. 
                               The record lock is not released until the transaction ends.
P             Purged lock      The lock is no longer held.
              entry
Q             Queued lock      Represents a queued request for a lock already held by another process. 
              request
U             Upgrade request  The user has requested a lock upgrade from SHARE to EXCLUSIVE.


Trans State
The state of the transaction. The table below lists the possible states.

State             Description
----------------- --------------------------------------------------------------------------------------------
Begin             A transaction table entry was allocated, and a start record is being logged
Active            The transaction is doing forward processing
None              The lock was acquired outside of a transaction
Dead              The transaction is complete, but the lock has not been released
Prep              The transaction is preparing to enter phase 1 (ready to commit), but has not sent a 
                  ready-to-commit reply
Phase 1           In phase 1, ready to commit
Phase 2           In phase 2
C                 With two-phase commit, this user is logging for the coordinator for the transaction
R                 Ready to commit
L                 Limbo transaction
Active JTA        The transaction is currently executing
Idle JTA          The transaction is not currently executing
Prepared JTA      The transaction is prepared
RollbackOnly JTA  The transaction has encountered an error
Committed JTA     The transaction is in the commit process



Trans ID
Transaction ID of the lock.
   */
   
   
/*   
Virtual System Tables _Trans and _Lock
*/

