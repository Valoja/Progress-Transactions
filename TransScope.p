/*
Controlling the size of a transaction
Certain statements start a transaction automatically... these are:

*FOR EACH blocks that directly update the database

*REPEAT blocks that directly update the database
*Procedure blocks that directly update the database

*DO blocks with the ON ERROR or ON ENDKEY qualifiers (which you'll learn more about later) that contain statements 
that update the database

You can also control the size of a transaction by adding the TRANSACTION keyword to a DO, FOR EACH, or REPEAT block. 
This can force a transaction to be larger, but because of the statements that start a transaction automatically, 
you cannot use it to make a transaction smaller than ABL otherwise would make it.
The following example shows how transaction blocks are affected by changes to the procedure. As written, there is a 
DO TRANSACTION block around the whole update of both the Order and any modified OrderLines:
 */

DO TRANSACTION ON ERROR UNDO, LEAVE:
  DO:
    /* Order update block */
  END.
  FOR EACH OrderLine:
    /* OrderLine update block */
  END.
END. /* TRANSACTION block. */

/* 
Since DO blocks do not have the block transaction property, any changes made in the DO block (Order update block) scope to
the containing transaction block, in this case the DO TRANSACTION block. Any errors that occur within the DO block cause 
the entire transaction to be backed out.
FOR EACH OrderLine starts a new subtransaction for each iteration. If an error occurs within the FOR EACH block, only the
change made for that iteration is backed out. Any changes for any previous iterations, as well as any changes made in the 
DO block, are committed to the database. To verify this, generate a listing file.

***

Making a transaction larger

In this section, you experiment with increasing the size of a transaction. To see the effect of removing the DO TRANSACTION block from saveOrder:

1. Comment out the DO TRANSACTION statement and the matching END statement at the end of the procedure.
2. Recompile and generate a new listing file.
3. Take a look at the final section. You can see that, without the DO TRANSACTION block, the entire saveOrder procedure become a transaction block:

File Name       Line Blk.    Type Tran       Blk. Label 
-------------------- ---- --------- ---- ------------------------------
...ter8\orderlogic.p   82 Procedure No    Procedure fetchOrder 
...ter8\orderlogic.p  111 For       No 
...ter8\orderlogic.p  124 Procedure Yes   Procedure saveOrder 
    Buffers: bUpdateOrder
             sports2000.Order

...ter8\orderlogic.p  146 Do        No 
...ter8\orderlogic.p  151 Do        No 
...ter8\orderlogic.p  156 Do        No 
...ter8\orderlogic.p  164 For       Yes 
    Buffers: sports2000.OrderLine
             bUpdateOline
             
Why did this happen? A DO block by itself, without a TRANSACTION or ON ERROR qualifier, does not start a transaction. 
Therefore, the AVM has to fall back on the rule that the entire procedure becomes the transaction block. In this 
particular case, this does not really make a big difference because the update code for Order and OrderLine is 
essentially the only thing in the procedure. 

But, as emphasized before, this is a very dangerous practice and you should always avoid it. If you generate a listing 
file and see that a procedure is a transaction block, you need an explicit transaction within your code. In fact, you
should always have explicit transaction blocks in your code and then verify that statements outside that block are not
forcing the transaction to be larger than you intend.



Transaction mechanics
It's important to have at least a basic understanding of how ABL handles transactions and subtransactions... 

During a transaction, information on all database activity occurring during that transaction is written to a 
before-image (or BI) file that is associated with the database and located on the server with the other database files. 

The information written to the before-image file is coordinated with the timing of the data written to the actual 
database files. That way, if an error occurs during the transaction, the AVM uses the before-image file to restore 
the database to the condition it was in before the transaction started. Information written to the before-image file 
is not buffered. 

It is written to disk immediately, so that there is minimal loss of information in the event of a system crash.
Space in the before-image file is allocated in units called clusters. The AVM automatically allocates new clusters 
as needed. After all changes associated with a cluster are committed and written to the database itself, the AVM can 
reuse the cluster. Therefore, the disk space used by the before-image file depends on several factors including the 
cluster size, the scope of your transactions, and when physical writes are made to the database files. 

An action such as creating a huge number of database records in a batch procedure within a single transaction creates 
an enormous before-image file. You should avoid such actions.
When the AVM encounters a transaction block nested within another transaction block, it starts a subtransaction. 
All database activity occurring during that subtransaction is written to a local-before-image (or LBI) file. 
Unlike the database BI file, the AVM maintains one LBI file for each user. If an error occurs during the subtransaction, 
the AVM uses this local-before-image file to restore the database to the condition it was in before the subtransaction 
started. In any case where a full transaction is not being backed out, the AVM uses the local-before-image file to 
back out, not only subtransactions, but also changes to variables not defined as NO-UNDO.
Because the LBI file is not needed for crash recovery, it does not have to be written to disk in the same carefully 
synchronized fashion as does the before-image information. This minimizes the overhead associated with subtransactions. 
The LBI file is written using normal buffered I/O. The amount of disk space required for each user's LBI file depends 
on the number and size of subtransactions started that are subject to being done. 

It is advisable that you minimize the use of subtransactions, as well as the scope of your overall transactions, 
not just to simplify the handling of these files but also to minimize record contention with other users.

*/


