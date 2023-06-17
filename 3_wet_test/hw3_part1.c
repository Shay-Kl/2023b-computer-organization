#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <signal.h>
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

/* symbol_name		- The symbol (maybe function) we need to search for.
 * exe_file_name	- The file where we search the symbol in.
 * error_val		- If  1: A global symbol was found, and defined in the given executable.
 * 			- If -1: Symbol not found.
 *			- If -2: Only a local symbol was found.
 * 			- If -3: File is not an executable.
 * 			- If -4: The symbol was found, it is global, but it is not defined in the executable.
 * return value		- The address which the symbol_name will be loaded to, if the symbol was found and is global.
 */
void offRead(int file, int offset, void* dest, int size, char* name)
{
	unsigned int off = syscall(SYS_LSEEK, file, offset, SEEK_SET);
    unsigned int read = syscall(SYS_READ, file, dest, size);
	//printf("Read %s at offset: %lu, Amount read is: %lu\n", name, off, read);
}

unsigned long find_symbol(char* symbol_name, char* exe_file_name, int* error_val)
{
	Elf64_Ehdr header;
    int file = syscall(SYS_open, exe_file_name, O_RDONLY);
	offRead(file, 0, &header, sizeof(header), "Elf Header");
	int sh_off = header.e_shoff;
	int sh_count = header.e_shnum;
	*error_val = -1;

	if(header.e_type!=ET_EXEC)
	{	
		*error_val = -3;
		syscall(SYS_CLOSE, file);
		return 0;
	}


	Elf64_Shdr section_header[sh_count];
	offRead(file, sh_off, &section_header, sizeof(section_header), "Section Header");
	int i = 0;
	for (i = 0; i < sh_count; i++)
	{
		//printf("Section type is %lu\n", section_header[i].sh_type);
		if (section_header[i].sh_type ==2)
		{
			break;
		}
	}

	int str_index = section_header[i].sh_link;
	int str_off = section_header[str_index].sh_offset;
	int str_size = section_header[str_index].sh_size;
	char str_table[str_size];
	offRead(file, str_off, str_table, str_size, "String Table");

	int sym_off = section_header[i].sh_offset;
	int sym_count = section_header[i].sh_size / section_header[i].sh_entsize;
	Elf64_Sym sym_table[sym_count];
	offRead(file, sym_off, sym_table, sizeof(sym_table), "Symbol Table");

	for (i = 0; i < sym_count; i++)
	{
		int str_index = sym_table[i].st_name;
		char buffer[BUFFER_SIZE];
		int j = -1;
		do
		{
			j++;
			buffer[j] = str_table[str_index+j];
		}
		while(buffer[j]!=0);
		
		//printf("%s\n", buffer);
		if (strcmp(buffer, symbol_name) == 0) //Correct symbol name
		{
			unsigned int bind = ELF64_ST_BIND(sym_table[i].st_info);
			if (bind == STB_GLOBAL) //Symbol is global
			{
				if(sym_table[i].st_shndx != SHN_UNDEF) //Symbol is defined here
				{
					syscall(SYS_CLOSE, file);
					*error_val = 1;
					return sym_table[i].st_value;
				}
				else //Symbol is not defined here
				{
					*error_val = -4; 
				}
			}
			else if (*error_val==-1) // Symbol is local
			{
				*error_val = -2;
			}
		}
	}
	

    syscall(SYS_CLOSE, file);
    return 0;
}



int main(int argc, char *const argv[]) {
	int err = 0;
	unsigned long addr = find_symbol(argv[1], argv[2], &err);

	if (addr > 0)
		printf("%s will be loaded to 0x%lx\n", argv[1], addr);
	else if (err == -2)
		printf("%s is not a global symbol! :(\n", argv[1]);
	else if (err == -1)
		printf("%s not found!\n", argv[1]);
	else if (err == -3)
		printf("%s not an executable! :(\n", argv[2]);
	else if (err == -4)
		printf("%s is a global symbol, but will come from a shared library\n", argv[1]);
	return 0;
}