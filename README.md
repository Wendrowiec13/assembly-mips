# Assembly-MIPS

Four MIPS-assembly projects completed during my one year stint at college(Wrocław University of Technology). Completed in 2022.

## Postfix.asm
A postfix expression evaluator that:
- Reads a postfix expression string from user input
- Implements a stack to process the expression
- Supports basic operations (+, -, *, /)
- Handles special operations ($ for triple addition, ^ for squaring)
- Displays the final calculated result

## Cipher.asm
A Caesar cipher implementation with three modes:
- Encryption mode (shifting characters by a key)
- Decryption mode (shifting characters back by a key)
- Modified mode (using the first letter of input as a dynamic key)

## Random.asm
A character generator that:
- Takes a user-provided seed value
- Generates 10 rows of 10 pseudo-random characters
- Filters characters to include only alphanumeric (0-9, a-z, A-Z) and special characters (#, $, !)
- Uses the MIPS random number generator syscalls

## Stack.asm
A simple stack implementation that provides:
- Push operations for adding floating-point numbers
- Pop operations for retrieving values 
- Empty stack detection
