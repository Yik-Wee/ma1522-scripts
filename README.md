# MA1522 scripts
Just some matlab scripts, main one is symrref

# symrref
Find conditions when a symbolic matrix (containing unknown variables) is inconsistent, has unique solution or infinitely many solutions

## Copying
TODO

## Usage
```
symrref(A)
```

- takes in a symbolic matrix
- prints all possible RREFs of `A`, and their conditions

## Algorithm
The idea is:
1. Perform normal gaussian elimination on `A`
2. When our pivot has unknowns (symbolic variables, this is checked using `symvar(pivot)`) AND there are no other elements in the same column (from our current row + 1 to last row) that are non-zero and non-unknown, then
   1. solve `pivot == 0` for each unknown
   2. sub each solution (`rhs`) into the matrix (`subs(A, unknowns[i], rhs)`)
   3. `symrref` on that substituted matrix

## Example
```matlab
>> syms a; A = [1 -a 2-a -a-1 -a-1; 1 -a a -1 1; -1 -1 a-2 a+1 1; 1 a+2 1 a-1 3*a; 0 a+1 a-1 a 2*a+1]
>> symrref(A)
```
Output:
```
[debug solve0] solve(- a - 1 == 0, a)
When [a == -1]
[1, 1, 0, 0, 0]
[0, 0, 1, 0, 0]
[0, 0, 0, 1, 0]
[0, 0, 0, 0, 1]
[0, 0, 0, 0, 0]
 
Else (a ~= -1):
[debug solve0] solve(a - 1 == 0, a)
When [a == 1]
[1, 0, 1, 0, 0]
[0, 1, 0, 0, 0]
[0, 0, 0, 1, 0]
[0, 0, 0, 0, 1]
[0, 0, 0, 0, 0]
 
Else (a ~= 1):
[debug solve0] solve(-a == 0, a)
When [a == 0]
[1, 0, 0, -1,  1]
[0, 1, 0,  0,  0]
[0, 0, 1,  0, -1]
[0, 0, 0,  0,  0]
[0, 0, 0,  0,  0]
 
Else (a ~= 0):
[1, 0, 0, 0, -(- a^3 + a + 2)/(a^2 - 1)]
[0, 1, 0, 0,                  a/(a + 1)]
[0, 0, 1, 0,                  1/(a - 1)]
[0, 0, 0, 1,                          1]
[0, 0, 0, 0,                          0]
```
From above,
- when `a == -1` and `a == 1`, the system is inconsistent
- when `a == 0` the system has infinitely many solutions
- when `a != -1` and `a != 1` and `a != 0` the solution has a unique solution
