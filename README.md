How Do Progress Transactions Work

Firstly - Why this document has been written: - for two reasons: 

1 - to do something on GitHub that will not only allow me to learn more about GitHub, but also
2 - display expertise I have gained about using the Progress development language(s); it may even prove useful to dedicated programmers/testers/analysts who want a reference to these areas...


The most critical parts of writing good programs, for business applications, is ensuring data is retrievable in a timely fashion and  making sure records are not tied up due to poor locking issues. 
Locking issues can lead to increased waiting times, poor performance the overall system and at worst dreaded deadlocks.

There are complexities that need to be understood and they quickly spiral further... for example if a system error occurs while you are processing orders for a customer, you'd want the system to undo all the order processing work you have done for that customer, as well as any changes you made to the customer record itself. This is the likely scenario... so it's important you know how reord locking and scoping works so that you know what will happen in these scenarios.  

It is important for programmers to understand how record scope and locking is handled by the Progress Openedge database. So this document is to help all programmers using Progress 8, 9, 10, OpenEdge, ABL etc to write more effective code.

Transactions 

...are used to maintain data integrity. It's important to understand that a transaction is actually scoped to the
outer most block where the Database is updated. For example, using FIND or FOR with EXCLUSIVE-LOCK causes the transaction scope to be raised to the nearest block with a transaction.

Blocks with transaction properties include:
FOR, REPEAT, PROCEDURE and any block that has the TRANSACTION keyword specified or any block where EXCLUSIVE-LOCK is used.

Some statements that update the database are UPDATE, CREATE, ASSIGN and SET.

If there is no block that qualifies then the transaction's scope is raised to the Procedure.

Progress allows only one active transaction at a time, so the next transaction that you start in your procedure is 
actually a subtransation. If you start a transaction in one procedure and it has not ended when you call a sub-procedure, 
the new transactions in the sub-procedure will also be subtransactions.

The programs in this repository are actually examples explaining how transactions work.


