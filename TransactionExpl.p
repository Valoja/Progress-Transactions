/*
   Transactions :  in Progress a transaction is used to scope how records in the database will be changed.

   A transaction can be as small as changing one record or big enough to cover changes made to several tables and many records, all at once.

  *** Basically - the transaction scoping allows you to back out the changes made if something goes awry. ie an unexpected error, program or system crash ***

  When an error does occur, Progress naturally backs out whatever it was doing during the transaction.

  Any changes that were made inside the transaction are completely restored to orginal values. Let's discuss more about how transactions can be started (sometimes by choice, other times automatically); it's important to know how it works so that you can control it. 

   
  ** a transaction can be defined :
  the outer most loop that contains a direct update to the database - it can be any 
  FOR EACH, REPEAT, DO loops */

/*
  The following will start a transaction: any block using the TRANSACTION keyword on the block statement (DO, FOR EACH, or REPEAT).

  can be any [DO | FOR EACH | REPEAT] */ DO TRANSACTION:

    /* <----
    --
    
    program code ** Transaction scope ** covers this entire loop
    --
    ---> */

  END.

/*
but if you do not specify using the transaction keyword then it is:

  Any procedure block and each loop ( DO ON ERROR, FOR EACH, or REPEAT block ) that directly updates the database 
** Directly updating the database means that the block contains at least one statement that can change the database. CREATE, DELETE, and UPDATE for examples. 

** transaction is also caused by directly reading records with an EXCLUSIVE-LOCK.
*/

PROCEDURE changeTableCust:

    FIND FIRST Cust WHERE CustNum = InputCustID EXCLUSIVE-LOCK.

    /* --- *** do stuff ** */

END PROCEDURE.


/* UpdateCust.p */
FIND FIRST Cust  WHERE 
   CustNum = InputCustID EXCLUSIVE-LOCK.

/* Any 
[DO | FOR | REPEAT] */  ON ERROR UNDO, LEAVE:
    
    FIND FIRST Cust WHERE 
       CustNum = InputCustID EXCLUSIVE-LOCK.

    /* --- *** do stuff *** */

END.

/*
The important thing to remember is that if a transaction has been activated before calling another program, the scope of the transaction is defined by the calling program. eg...
*/
  /* Program A  */
  FOR EACH Cust:
    FIND Orders OF Cust EXCLUSIVE-LOCK.

    RUN CallProgramB.

  END. 

  /* Program B */
  DO:
      /*

        what ever happens in here falls inside the scope of Program A (the calling program)

      */

  END.


/**** Tke KEY takeaway is.... it is possible to control the size of the transaction. 
* You do that by using the TRANSACTION keyword 
* this way you can make it smaller or larger, to meet the demands of the system you are writing in...

** when records are being Updated... it's important to keep these factors in mind. 

*****/

*/
