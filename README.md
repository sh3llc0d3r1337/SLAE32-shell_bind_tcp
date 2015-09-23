# SLAE32-shell_bind_tcp
SLAE32 Assignment #1 - Shell Bind TCP

shellcode.asm.original  -  The asm source of the shellcode which binds to the local port 4444.
shellcode.asm           -  Same as shellcode.asm, but the size is reduced and the NULL characters are removed.
test.c                  -  The test file which executes the shellcode
test.c.template         -  Same as the test.c, but the place of the shellcode contains a SHELLCODE string
string.py               -  Python script, used for generating hex values of /bin/sh for the shellcode
generate.py             -  Python script, generates shellcode for the given port number

shell-bind-tcp-c        -  The C equivalent of the bind shell
