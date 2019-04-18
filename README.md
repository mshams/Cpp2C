# Cpp2C
A high level C++ classes to c structs compiler.

This program converts C++ classes to C structs, and has some limitations.

Features and limitations:

1. Multiple variable declaretion is illegal

Ex:

Legal: int a; int b; int c; Illegal: int a,b,c;

2. IF and THEN forward is illegal:

Ex:

Legal: if (num2==6) Illegal: if (num2==6) printf(“Its true!”);

printf(“Its true!”);

3. Int, float, void, class and struct datatypes are supported

4. Refference variable not supported

5. Only one default parameter is supported, no more

6. This is a symbolic translator, so has bugs and limitations
