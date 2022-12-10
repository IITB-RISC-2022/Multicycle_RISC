; benchmark code to multiply two numbers stored in mem addresses 61, 62 and store result in 63
; we use r0 to store 0
lw r1,r0,61
lw r2,r0,62
; use r6 to store 1
lw r6,r0,1
; store 2s complement of r1 in r5
ndu r5,r4,1
add r5,r0,1
; use r3 to store result
lw r3,r0,0
; start iterating
add r3,r2,r0
; increment loop variable
add r5,r6,r0
; terminate loop if r5 becomes 0
beq r5,r0,2
jri r0,7
sw r3,r0,63

