	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 15, 0	sdk_version 15, 1
	.globl	_day1asm                        ; -- Begin function day1asm
	.p2align	2
_day1asm:                               ; @day1asm
	.cfi_startproc
; %bb.0:
    ;x0 = list1, x1 = list2, x2 = size
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
    mov x3, x1  ; x3=list2
    mov x1, x2  ; x1=size
    bl  _sortlst ; x0=list1, x1=size

    mov x2, x0   ; x2=list1
    mov x0, x3   ; x0=list2
    bl  _sortlst ; x0=list2, x1=size

    mov x3, x0 ; x3=list2
    mov x0, x2 ; x0=list1
    mov x2, x1 ; x2=size
    mov x1, x3 ; x1=list2
    ;bl _difflsts ; x0=list1, x1=list2, x2=size, x3=return
    bl _similarity ; x0=list1, x1=list2, x2=size, x3=return
    mov x0, x3 ; mov result into x0 for return

	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
    .globl _difflsts
    .p2align    2
_difflsts:
	.cfi_startproc
    ; x0 list1
    ; x1 list2
    ; x2 size
    ; x3 return
    mov x9, #0 ; x9=pos
    mov x3, #0 ; x12=sum
Ldiffwhile:
    cmp x9, x2  ; while pos < size
    bge Ldiffend
    ldr x10, [x0, x9, LSL#3]
    ldr x11, [x1, x9, LSL#3]
    subs x11, x11, x10
    bmi Ldiffinvert
Ldiffsum:
    add x3, x3, x11
    add x9, x9, #1
    b   Ldiffwhile
Ldiffinvert:
    neg x11, x11
    b Ldiffsum
Ldiffend:
    ret
	.cfi_endproc


    .globl _sortlst
    .p2align    2
_sortlst:
	.cfi_startproc
    
;procedure gnomeSort(a[]):
    ; x0 is ptr
    ; x1 is size
;   pos := 0
    mov x9, #0 ; pos
;   while pos < length(a):
Lsortwhile:
    cmp x9, x1
    bge Lsortend 
;       if (pos == 0 or a[pos] >= a[pos-1]):
    cmp x9, #0
    beq Lsortmovpos
;       x10 <- a[pos]
    ldr x10, [x0, x9, LSL#3]
;       x11 <- a[pos-1]; x12 = pos-1 (x9-1)
    sub x12, x9, #1
    ldr x11, [x0, x12, LSL#3]
    cmp x10, x11
    bge Lsortmovpos
    b   Lsortswap
Lsortmovpos:
;           pos := pos + 1
    add x9, x9, #1
    b   Lsortwhile
Lsortswap:
;           swap a[pos] and a[pos-1]
    str x10, [x0, x12, LSL#3]
    str x11, [x0, x9, LSL#3]
;           pos := pos - 1
    sub x9, x9, #1
    b   Lsortwhile
Lsortend:
    ret

;procedure gnomeSort(a[]):
;   pos := 0
;   while pos < length(a):
;       if (pos == 0 or a[pos] >= a[pos-1]):
;           pos := pos + 1
;       else:
;           swap a[pos] and a[pos-1]
;           pos := pos - 1
	.cfi_endproc

    .globl _similarity
    .p2align    2
_similarity:
	.cfi_startproc
    ; x0 list1
    ; x1 list2
    ; x2 size
    ; x3 return
    mov x3, #0                  ; x3 = sum
    mov x9, #0                  ; x9 = idx1
    mov x10, #0                 ; x10 = idx2
;     while lst1[idx1] != lst2[idx2] {
;         if lst1[idx1] > list2[idx2] {
;             idx2++;
;         } else if lst2[idx2] > lst1[idx1] {
;             idx1++;
;         } 
;     }
Lsimwhileout:                   ; while (idx1 < SIZE) {
    mov x11, #0                 ;     int num = 0;                  (( x11 = num ))
    ldr x12, [x0, x9, LSL#3]    ;     int item1 = lst1[idx1];       (( x12 = item1 )) 
    ldr x13, [x1, x10, LSL#3]   ;     int item2 = lst2[idx2];       (( x13 = item2 )) 
    cmp x12, x13
    bgt Lsimidx2 ;if item1 > item2 
    blt Lsimidx1
    beq Lsimwhile

Lsimidx2:
    add x10, x10, #1 ; idx2++;
    cmp x10, x2
    bge Lsimret
    b   Lsimwhileout

Lsimidx1:
    add x9, x9, #1
    cmp x9, x2
    bge Lsimret
    b   Lsimwhileout

Lsimwhile:                      
    add x11, x11, x12           
    add x10, x10, #1            ;         idx2++;
    cmp x10, x2                 ;         if (idx2 >= SIZE) break;
    bge Lsimwhileend            
    
    ldr x13, [x1, x10, LSL#3]    
    cmp x12, x13
    beq Lsimwhile
    
Lsimwhileend:
    add x3, x3, x11             ;         sum += num;
    add x9, x9, #1              ;         idx1++;
    cmp x9, x2                  ;         if (idx1 >= SIZE) break;
    bge Lsimret           ;    

    ldr x14, [x0, x9, LSL#3]    
    cmp x14, x12
    beq Lsimwhileend

    b   Lsimwhileout            ; }
    
Lsimret:
    ret
	.cfi_endproc

.subsections_via_symbols
