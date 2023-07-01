#ifndef __HW3_H__
#define __HW3_H__


#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/syscall.h>
#include <syscall.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/reg.h>
#include <sys/user.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdbool.h>

#include "elf64.h"

#define	ET_NONE	0	//No file type 
#define	ET_REL	1	//Relocatable file 
#define	ET_EXEC	2	//Executable file 
#define	ET_DYN	3	//Shared object file 
#define	ET_CORE	4	//Core file 

#define SYS_OPEN 2
#define SYS_READ 0
#define SYS_CLOSE 3
#define SYS_LSEEK 8
	
#define O_RDONLY 0

#define BUFFER_SIZE 512

#define STB_LOCAL 0
#define STB_GLOBAL 1
#define STB_WEAK 2

#define SHN_UNDEF 0



void offRead(int file, int offset, void* dest, int size, char* name);

unsigned long find_symbol(char* symbol_name, char* exe_file_name, int* error_val);
#endif // __HW3_H__