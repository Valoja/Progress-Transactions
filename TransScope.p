/*
Controlling the size of a transaction
Certain statements start a transaction automatically... these are:

*FOR EACH blocks that directly update the database

*REPEAT blocks that directly update the database
*Procedure blocks that directly update the database

*DO blocks with the ON ERROR or ON ENDKEY qualifiers (which you'll learn more about later) that contain statements that update the database

You can also control the size of a transaction by adding the TRANSACTION keyword to a DO, FOR EACH, or REPEAT block. This can force a transaction to be larger, but because of the statements that start a transaction automatically, you cannot use it to make a transaction smaller than ABL otherwise would make it.
The following example shows how transaction blocks are affected by changes to the procedure. As written, there is a DO TRANSACTION block around the whole update of both the Order and any modified OrderLines:
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
ince DO blocks do not have the block transaction property, any changes made in the DO block (Order update block) scope to the containing transaction block, in this case the DO TRANSACTION block. Any errors that occur within the DO block cause the entire transaction to be backed out.
FOR EACH OrderLine starts a new subtransaction for each iteration. If an error occurs within the FOR EACH block, only the change made for that iteration is backed out. Any changes for any previous iterations, as well as any changes made in the DO block, are committed to the database. To verify this, generate a listing file the same way you did previously:

*/

