/* 
Transaction and Sub-Transactions

It is easy to get a little confused about Transactions and their scope; especially when the TRANSACTION keyword is used.
If you have already started a TRANSACTION block and then start another Transaction within the same block it is now a 
subtransaction (rather than a seperate transaction - it will NOT be handled as a seperate transaction).

Let's work through an example...
*/

/* an Update program for Orders of Customer - UpdateCustOrders.p */

FIND FIRST Cust EXCLUSIVE-LOCK WHERE
   CustID = InputCust.

ASSIGN Cust.LastActive = TodaysDateTime.  /* This assign is NOT even necessary to start a transaction, just being definite */

/* we now have a Transaction */

MESSAGE TRANSACTION VIEW-AS ALERT-BOX INFO BUTTONS OK. /* This will Output YES */

RUN UpdateOrders.p. /* Call Update program */

/* Right now we are calling a program from within a Transaction... */
 
 
/* Program UpdateOrders.p */

FOR EACH order OF Cust EXCLUSIVE-LOCK:  /* Updating more records */
        
    order.UpdateField = order.UpdateField + NewValue.
    
END.

/*
UpdateOrders.p will update each order in a separate sub-transaction, however
because a transaction was already active before running it, 
*** ALL the order records will be handled in one single big transaction. 

** This may overload the Lock Table and lead to error 915.

***

Trying to sort this out by specifying Transaction inside UpdateOrders... eg

FOR EACH order EXCLUSIVE-LOCK TRANSACTION: 

*** has NO effect because a FOR EACH: block already has an iterative transaction property.

It has to be sorted out at the source... the main program - UpdateCustOrders.p
*/


TRANSACTION 4GL function
PROMON (Transaction menu, or Lock Table)
Virtual System Tables _Trans and _Lock


/*  UpdateCustOrders.p - with Transaction handled more elegantly  */

 
DO TRANSACTION:    /* The transaction is started, */

   FIND FIRST Cust EXCLUSIVE-LOCK WHERE
      CustID = InputCust.

   ASSIGN Cust.LastActive = TodaysDateTime.  /* This assign is NOT even necessary to start a transaction, just being definite */

   /* we now have a Transaction */
   MESSAGE TRANSACTION VIEW-AS ALERT-BOX INFO BUTTONS OK. /* This will Output YES */

   /* The point of the RELEASE is to not keep an undesired SHARED-LOCK but
      alleviate unnecessary load on the system. 
      */
   RELEASE Cust. /* *** NOT having this means the scope of the Record is longer *** */          
   
END. /* Now the transaction is finished     */

MESSAGE TRANSACTION VIEW-AS ALERT-BOX INFO BUTTONS OK.      /* This will Output NO */

RUN UpdateOrders.p. /* Call Update program */

/* Program UpdateOrders.p */

FOR EACH order OF Cust EXCLUSIVE-LOCK:  /* Updating more records */
        
    order.UpdateField = order.UpdateField + NewValue.
    
END.

/* You now have a seperate transaction loop for Updating the Orders... now for some reason if UpdateOrders fails, you may need to 
   to update the Cust table to note that (depending on Business logic). 
   
*** The RELEASE command can be removed; The Scope of the MyTable buffer would need to be limited to the block with:
 
DO FOR Cust TRANSACTION: (This creates a strongly scoped block).

I hope you are now getting a good idea of the way Transactions work and the potential load on the system and the 
logic issues you need to be aware of when working with them... it's a bit of thinking... and that's the fun of 
good coding.

Enjoy!

*/
