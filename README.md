How Do Progress Transactions Work

Why this document has been written?
What is a Transaction - scope and locks?
How to find Transaction scope?

Further Reference


The most critical parts of writing good programs, for business applications, is ensuring data is retrievable in a timely fashion and  making sure records are not tied up due to poor locking issues. Poor locking can lead to increased waiting times , poor performance the overall system and at worst dreaded deadlocks.

There are complexities that need to be understood and they quickly spiral further... for example if a system error occurs while you are processing orders for a customer, you'd want the system to undo all the order processing work you have done for that customer, as well as any changes you made to the customer record itself. This is the likely scenario... so it's important you know how reord locking and scoping works so that you know what will happen in these scenarios.  

It is important for programmers to understand how record scope and locking is handled by the Progress Openedge database. So this document is to help all programmers using Progress 8, 9, OpenEdge, ABL etc to write more effective code.

Transactions 

...are used to maintain data integrity. 
