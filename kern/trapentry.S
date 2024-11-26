/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not...

TRAPHANDLER_NOEC(t_divide, T_DIVIDE)
TRAPHANDLER_NOEC(t_debug, T_DEBUG)
TRAPHANDLER_NOEC(t_nmi, T_NMI)
TRAPHANDLER_NOEC(t_brkpt, T_BRKPT)
TRAPHANDLER_NOEC(t_oflow, T_OFLOW)
TRAPHANDLER_NOEC(t_bound, T_BOUND)
TRAPHANDLER_NOEC(t_illop, T_ILLOP)
TRAPHANDLER_NOEC(t_device, T_DEVICE)
TRAPHANDLER(t_dblflt, T_DBLFLT)
TRAPHANDLER(t_tss, T_TSS)
TRAPHANDLER(t_segnp, T_SEGNP)
TRAPHANDLER(t_stack, T_STACK)
TRAPHANDLER(t_gpflt, T_GPFLT)
TRAPHANDLER(t_pgflt, T_PGFLT)
TRAPHANDLER_NOEC(t_fperr, T_FPERR)
TRAPHANDLER(t_align, T_ALIGN)
TRAPHANDLER_NOEC(t_mchk, T_MCHK)
TRAPHANDLER_NOEC(t_simderr, T_SIMDERR)
TRAPHANDLER_NOEC(t_syscall, T_SYSCALL)

/*
 * Lab 3: Your code here for _alltraps
 */

.globl vectors
vectors:
    .long t_divide
    .long t_debug 
    .long t_nmi
    .long t_brkpt
    .long t_oflow
    .long t_bound
    .long t_illop
    .long t_device
    .long t_dblflt
    .long 0
    .long t_tss
    .long t_segnp
    .long t_stack
    .long t_gpflt
    .long t_pgflt
    .long 0
    .long t_fperr
    .long t_align
    .long t_mchk
    .long t_simderr
    .space (T_SYSCALL - T_SIMDERR - 1) * 4
    .long t_syscall

_alltraps:
    pushl %ds
    pushl %es
    pushal
    
    movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es
    
    pushl %esp
    call trap

.align 4
.globl sysenter_handler
sysenter_handler:

    pushl %ebp
    movl %esp, %ebp
    
    movl $KSTACKTOP, %esp

    pushl %edi 
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %eax
    
    call syscall
    
    movl %ebp, %esp  
    popl %ebp
    
    movl %esi, %edx
    movl %ebp, %ecx  
    sysexit



















; /* See COPYRIGHT for copyright information. */

; #include <inc/mmu.h>
; #include <inc/memlayout.h>
; #include <inc/trap.h>

; #include <kern/picirq.h>

; ###################################################################
; # exceptions/interrupts
; ###################################################################

; /* TRAPHANDLER defines a globally-visible function for handling a trap.
;  * It pushes a trap number onto the stack, then jumps to _alltraps.
;  * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
;  *
;  * You shouldn't call a TRAPHANDLER function from C, but you may
;  * need to _declare_ one in C (for instance, to get a function pointer
;  * during IDT setup).  You can declare the function with
;  *   void NAME();
;  * where NAME is the argument passed to TRAPHANDLER.
;  */
; #define TRAPHANDLER(name, num)						\
; 	.globl name;		/* define global symbol for 'name' */	\
; 	.type name, @function;	/* symbol type is function */		\
; 	.align 2;		/* align function definition */		\
; 	name:			/* function starts here */		\
; 	pushl $(num);							\
; 	jmp _alltraps

; /* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
;  * It pushes a 0 in place of the error code, so the trap frame has the same
;  * format in either case.
;  */
; #define TRAPHANDLER_NOEC(name, num)					\
; 	.globl name;							\
; 	.type name, @function;						\
; 	.align 2;							\
; 	name:								\
; 	pushl $0;							\
; 	pushl $(num);							\
; 	jmp _alltraps

; .text

; /*
;  * Lab 4: Generating entry points for the different traps.
;  */
; TRAPHANDLER_NOEC(t_divide, T_DIVIDE)
; TRAPHANDLER_NOEC(t_debug, T_DEBUG)
; TRAPHANDLER_NOEC(t_nmi, T_NMI)
; TRAPHANDLER_NOEC(t_brkpt, T_BRKPT)
; TRAPHANDLER_NOEC(t_oflow, T_OFLOW)
; TRAPHANDLER_NOEC(t_bound, T_BOUND)
; TRAPHANDLER_NOEC(t_illop, T_ILLOP)
; TRAPHANDLER_NOEC(t_device, T_DEVICE)
; TRAPHANDLER(t_dblflt, T_DBLFLT)
; TRAPHANDLER(t_tss, T_TSS)
; TRAPHANDLER(t_segnp, T_SEGNP)
; TRAPHANDLER(t_stack, T_STACK)
; TRAPHANDLER(t_gpflt, T_GPFLT)
; TRAPHANDLER(t_pgflt, T_PGFLT)
; TRAPHANDLER_NOEC(t_fperr, T_FPERR)
; TRAPHANDLER(t_align, T_ALIGN)
; TRAPHANDLER_NOEC(t_mchk, T_MCHK)
; TRAPHANDLER_NOEC(t_simderr, T_SIMDERR)
; TRAPHANDLER_NOEC(t_syscall, T_SYSCALL)

; /*
;  * Vector table for traps
;  */
; .globl vectors
; vectors:
;     .long t_divide
;     .long t_debug 
;     .long t_nmi
;     .long t_brkpt
;     .long t_oflow
;     .long t_bound
;     .long t_illop
;     .long t_device
;     .long t_dblflt
;     .long 0
;     .long t_tss
;     .long t_segnp
;     .long t_stack
;     .long t_gpflt
;     .long t_pgflt
;     .long 0
;     .long t_fperr
;     .long t_align
;     .long t_mchk
;     .long t_simderr
;     .space (T_SYSCALL - T_SIMDERR - 1) * 4
;     .long t_syscall

; ###################################################################
; # _alltraps: Main trap entry handler
; ###################################################################

; _alltraps:
;     # Save general-purpose registers and segment registers
;     pushl %ds
;     pushl %es
;     pushal

;     # Load kernel data segment descriptor
;     movw $GD_KD, %ax
;     movw %ax, %ds
;     movw %ax, %es

;     # Save trap frame pointer
;     pushl %esp

;     # Call trap() function in C (kern/trap.c)
;     call trap

;     # Restore registers and segment registers
;     addl $4, %esp          # Remove trap frame pointer from stack
;     popal
;     popl %es
;     popl %ds

;     # Return from interrupt
;     iret

; ###################################################################
; # sysenter_handler: Fast system call entry point for sysenter
; ###################################################################

; .align 4
; .globl sysenter_handler
; sysenter_handler:
;     # Save caller's base pointer and set up new frame
;     pushl %ebp
;     movl %esp, %ebp

;     # Switch to kernel stack
;     movl $KSTACKTOP, %esp

;     # Save general-purpose registers for the syscall handler
;     pushl %edi 
;     pushl %ebx
;     pushl %ecx
;     pushl %edx
;     pushl %eax

;     # Call the syscall handler in C (kern/syscall.c)
;     call syscall

;     # Restore base pointer and pop general-purpose registers
;     movl %ebp, %esp  
;     popl %ebp

;     # Load return address and sysexit
;     movl %esi, %edx        # Load new %eip
;     movl %ebp, %ecx        # Load new %esp
;     sysexit
