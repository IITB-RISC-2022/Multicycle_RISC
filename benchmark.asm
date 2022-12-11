; benchmark code to multiply two numbers stored in mem addresses 61, 62 and store result in 63
; we use r0 to store 0
lw r1,r0,61                 ; load in r1
lw r2,r0,62                 ; load in r2   
adi r6,r0,1                 ; load 1 in r6
ndu r5,r1,r1                ; store 1s complement of r1 in r5
add r5,r5,r6                ; store 2s complement of r1 in r5
adi r3,r0,0                 ; use r3 to store result
; start iterating from here
add r3,r2,r3                ; add the second number
add r5,r6,r5                ; increment loop variable r5
beq r5,r0,2                 ; terminate loop if r5 becomes 0
jri r0,6
sw r3,r0,63
; program completed so maintain the state
jri r0,11