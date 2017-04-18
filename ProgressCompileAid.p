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

TRANSACTION 4GL function ... eg    */

MESSAGE TRANSACTION VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*
   PROMON (Transaction menu, or Lock Table).   */
   
/*   
Virtual System Tables _Trans and _Lock
*/

