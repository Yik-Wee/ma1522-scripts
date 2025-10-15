# MA1522 scripts
Just some matlab scripts, main one is symrref

# symrref
Find conditions when a symbolic matrix (containing unknown variables) is inconsistent, has unique solution or infinitely many solutions

## Copying
Either copy paste the code into a `*.m` file in your MATLAB workspace, or clone the repo:
1. cd into your matlab workspace
```
cd YOUR_MATLAB_WORKSPACE_PATH
```

2. clone the repo
```
git clone https://github.com/Yik-Wee/ma1522-scripts.git
```

## Usage
```
symrref(A, show_rowops=true)
```

- takes in a symbolic matrix
- prints all possible RREFs of `A`, and their conditions
Optional parameters:
- show_rowops - true to print row operations, false otherwise

## Algorithm
The idea is:
1. Perform normal gaussian elimination on `A`
2. When our pivot has unknowns (symbolic variables, this is checked using `symvar(pivot)`) AND there are no other elements in the same column (from our current row + 1 to last row) that are non-zero and non-unknown, then
   1. solve `pivot == 0` for each unknown
   2. sub each solution (`rhs`) into the matrix (`subs(A, unknowns[i], rhs)`)
   3. `symrref` on that substituted matrix

## Examples
Example 1:
```matlab
>> syms a; A = [1 -a 2-a -a-1 -a-1; 1 -a a -1 1; -1 -1 a-2 a+1 1; 1 a+2 1 a-1 3*a; 0 a+1 a-1 a 2*a+1]
>> symrref(A)
```
Output:
```
=> (1)*R_1
=> R_2 - 1*R_1
=> R_3 - -1*R_1
=> R_4 - 1*R_1
=> R_2 <-> R_3
When [a == -1]
    => (1)*R_1
    => R_2 <-> R_3
    => (-1/4)*R_2
    => R_1 - 3*R_2
    => R_4 - -2*R_2
    => R_5 - -2*R_2
    => R_3 <-> R_4
    => (-2/3)*R_3
    => R_1 - -3/4*R_3
    => R_2 - 1/4*R_3
    => R_5 - -1/2*R_3
    => (1)*R_4
    => R_1 - 5/2*R_4
    => R_2 - -5/6*R_4
    => R_3 - 7/3*R_4
    => R_5 - -1/3*R_4
[1, 1, 0, 0, 0]
[0, 0, 1, 0, 0]
[0, 0, 0, 1, 0]
[0, 0, 0, 0, 1]
[0, 0, 0, 0, 0]
 
^^^ a == -1
====
Else (a ~= -1):
    => (-1/(a + 1))*R_2
    => R_1 - -a*R_2
    => R_4 - 2*a + 2*R_2
    => R_5 - a + 1*R_2
    => R_3 <-> R_4
    When [a == 1]
        => (1)*R_1
        => (1)*R_2
        => (1/2)*R_3
        => R_1 - -2*R_3
        => R_4 - 1*R_3
        => R_5 - 1*R_3
        => (2/3)*R_4
        => R_1 - 3/2*R_4
        => R_2 - 1/2*R_4
        => R_3 - 3/2*R_4
        => R_5 - 1/2*R_4
[1, 0, 1, 0, 0]
[0, 1, 0, 0, 0]
[0, 0, 0, 1, 0]
[0, 0, 0, 0, 1]
[0, 0, 0, 0, 0]
 
^^^ a ~= -1 AND a == 1
====
    Else (a ~= 1):
        => (1/(a - 1))*R_3
        => R_1 - 2 - a*R_3
        => R_4 - 2*a - 2*R_3
        => R_5 - a - 1*R_3
        => R_4 <-> R_5
        When [a == 0]
            => (1)*R_1
            => (1)*R_2
            => (1)*R_3
[1, 0, 0, -1,  1]
[0, 1, 0,  0,  0]
[0, 0, 1,  0, -1]
[0, 0, 0,  0,  0]
[0, 0, 0,  0,  0]
 
^^^ a ~= -1 AND a ~= 1 AND a == 0
====
        Else (a ~= 0):
            => (-1/a)*R_4
            => R_1 - (a^2 - 4*a + 1)/(a - 1)*R_4
            => R_3 - (2*a)/(a - 1)*R_4
            => R_5 - -3*a*R_4
[1, 0, 0, 0, -(- a^3 + a + 2)/(a^2 - 1)]
[0, 1, 0, 0,                  a/(a + 1)]
[0, 0, 1, 0,                  1/(a - 1)]
[0, 0, 0, 1,                          1]
[0, 0, 0, 0,                          0]
 
^^^ a ~= -1 AND a ~= 1 AND a ~= 0
====
```
From above,
- when `a == -1` and `a == 1`, the system is inconsistent
- when `a == 0` the system has infinitely many solutions
- when `a != -1` and `a != 1` and `a != 0` the solution has a unique solution

Example 2:
```matlab
>> syms a b; A = [1 1-a  0 b-3 b-1; 1 2 a+b -1 2; 1 a+3 a+b 1-b 4-b; 1 a -(b+a) b-3 b-2; 0 a+1 a+b 2-b 3-b]
>> symrref(A)
```
Very long output with some redundant cases
