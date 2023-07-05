#include "elfReader.h"
pid_t run_target(char * const* args);
void run_debugger(pid_t child_pid, unsigned long address, bool isDynamic);
unsigned long find_dynamic_symbol(char* symbol_name, char* exe_file_name);

int main(int argc, char *const argv[])
{
    if (argc < 3)
    {
        printf("PRF:: Not enough arguments\n");
        return 0;
    }
    int error = 0;
    char* function = argv[1];
    char* prog = argv[2];
	char * const* args = &(argv[2]);
	bool isDynamic = false;
	
    unsigned long address = find_symbol(function, prog, &error); //Use Hw3 function
	switch(error)
	{
		case -3:
			printf("PRF:: <prog name> not an executable!\n");
			return 0;
		case -1:
			printf("PRF:: %s not found! :(\n", function);
			return 0;
		case -2:
			printf("PRF:: %s is not a global symbol!\n", function);
			return 0;
		case -4: //Function exists, is global, however it's undefined, this means it's linked dynamically
			address = find_dynamic_symbol(argv[1], argv[2]);
			isDynamic = true;
			break;
	}
	//Address found, time to run program

	pid_t child_pid;
	child_pid = run_target(args);
	if(child_pid > 0)
	{
		run_debugger(child_pid, address, isDynamic);
	}
	return 0;
	
}


//Fork thing, copied from presentation
pid_t run_target(char * const* args)
{
	pid_t pid = fork();

	if(pid == 0)
	{
		if(ptrace(PTRACE_TRACEME, 0, NULL, NULL) < 0)
		{
			perror("ptrace");
		}
		else
		{
			execv(args[0], args);
		}
	}
	return pid;
}

//The actual debugger
void run_debugger(pid_t child_pid, unsigned long address, bool isDynamic)
{
	int counter = 1;
	int wait_status;
	struct user_regs_struct regs;

	wait(&wait_status);
	unsigned long old_address = address;

	if(isDynamic)
    {
        address = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)address, NULL);
        address -= 6;
    }


	long data = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)address, NULL); //Original data at address
	unsigned long data_trap = (data & 0xFFFFFFFFFFFFFF00) | 0xCC; //Data at adress with interrupt inserted

	while(true)
	{
		//Wait until you enter function
		ptrace(PTRACE_POKETEXT, child_pid, (void*)address, (void*)data_trap);

		ptrace(PTRACE_CONT, child_pid, NULL, NULL);

		wait(&wait_status);

		if (WIFEXITED(wait_status) || WIFSIGNALED(wait_status)) //Reached end of program
		{
			break;
		}

		//Start of function
		ptrace(PTRACE_GETREGS, child_pid, 0, &regs);
		printf("PRF:: run #%d first parameter is %d\n", counter, regs.rdi);
		ptrace(PTRACE_POKETEXT, child_pid, (void*)address, (void*)data);
		regs.rip-=1;
		ptrace(PTRACE_SETREGS, child_pid, 0, &regs);
		
		int recursion_depth = 1;
		while(recursion_depth != 0) //While still inside of function
		{
			
			ptrace(PTRACE_GETREGS, child_pid, NULL, &regs);
			unsigned long instr = ptrace(PTRACE_PEEKTEXT, child_pid, regs.rip, NULL);
			if ((instr & 0xFF) == 0xC3) //If instruction is ret
			{
				recursion_depth--;
			}
			else if( ((instr & 0xFF) == 0xE8) || (instr & 0xFF) == 0x9A) //If instruction is call
			{
				recursion_depth++;
			}
			ptrace(PTRACE_SINGLESTEP, child_pid, NULL, NULL);
			wait(&wait_status);
		}
		printf("PRF:: run #%d returned with %d\n", counter, regs.rax);
		//End of function
		counter++;
		if(isDynamic && counter==2){
            address = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)old_address, NULL);
            data = ptrace(PTRACE_PEEKTEXT, child_pid, (void*)address, NULL);
            data_trap = (data & 0xFFFFFFFFFFFFFF00) | 0xCC;
        }
	}
}

unsigned long find_dynamic_symbol(char* symbol_name, char* exe_file_name) {
    FILE* file = fopen(exe_file_name, "rb");
    if(!file) exit(1);
    Elf64_Ehdr ehdr;
    fread(&ehdr, sizeof(ehdr), 1, file);


    Elf64_Shdr shdr;
    fseek(file, ehdr.e_shoff + ehdr.e_shentsize * ehdr.e_shstrndx, SEEK_SET);
    fread(&shdr, ehdr.e_shentsize, 1, file);

    //find string table
    char * stringTable = (char *) malloc(shdr.sh_size);
    fseek(file, shdr.sh_offset, SEEK_SET);
    fread(stringTable, shdr.sh_size, 1, file);


    Elf64_Rela * rela_table = NULL;
    Elf64_Sym* dyn_symbols = NULL;


    int index = -1;
    int num_of_rela = 0;
    int num_of_symbols = 0;
    char * dynNames = NULL;

    for(int i=0; i<ehdr.e_shnum; i++){
        fseek(file, ehdr.e_shoff + i * sizeof(shdr), SEEK_SET);
        fread(&shdr, sizeof(shdr), 1, file);
        char * curr_section_name = (char *) (stringTable+ shdr.sh_name);
        //printf("rela: %s", curr_section_name);

        //found rela.plt
        if (!strcmp(curr_section_name, ".rela.plt")){
            rela_table = malloc(shdr.sh_size);
            fseek(file, shdr.sh_offset, SEEK_SET);
            fread(rela_table, shdr.sh_size , 1, file);
            num_of_rela = shdr.sh_size / shdr.sh_entsize;

        }

        //found dynsym
        else if (!strcmp(curr_section_name, ".dynsym")){

            dyn_symbols = (Elf64_Sym*) malloc (shdr.sh_size);
            fseek(file, shdr.sh_offset, SEEK_SET);
            fread(dyn_symbols, shdr.sh_size, 1, file);
            num_of_symbols = shdr.sh_size / shdr.sh_entsize;
        }
        
        //found dynstr
        else if (!strcmp(curr_section_name, ".dynstr")){

            dynNames = (char *)malloc (shdr.sh_size);
            fseek(file, shdr.sh_offset, SEEK_SET);
            fread(dynNames, shdr.sh_size, 1, file);

        }

    }
    //search for funcName
    for(int i=0; i<num_of_rela; i++){
        Elf64_Rela curr_rela = rela_table[i];
        char * curr = dynNames + dyn_symbols[ELF64_R_SYM(curr_rela.r_info)].st_name;
        if (!strcmp(curr, symbol_name)){
            //printf("found!\n");
            index=i;
        }
    }

    unsigned long addr = index >-1 ? rela_table[index].r_offset : 0;
    free(rela_table);
    free(dyn_symbols);
    free(dynNames);
    free(stringTable);
    return addr;
}