#include "elfReader.h"
pid_t run_target(char * const* args);
void run_debugger(pid_t child_pid, unsigned long address);


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
			//???????????????? Find a way to get its address
			break;
	}
	//Address found, time to run program

	pid_t child_pid;
	child_pid = run_target(args);
	if(child_pid > 0)
	{
		run_debugger(child_pid, address);
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
void run_debugger(pid_t child_pid, unsigned long address)
{
	int counter = 1;
	int wait_status;
	struct user_regs_struct regs;

	wait(&wait_status);

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
		printf("PRF:: run #%d first parameter is %lli\n", counter, regs.rdi);
		ptrace(PTRACE_POKETEXT, child_pid, (void*)address, (void*)data);
		regs.rip-=1;
		ptrace(PTRACE_SETREGS, child_pid, 0, &regs);
		
		int recursion_depth = 1;
		while(recursion_depth != 0) //While still inside of function
		{
			ptrace(PTRACE_SINGLESTEP, child_pid, NULL, NULL);
			wait(&wait_status);
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
		}
		printf("PRF:: run #%d returned with %lli\n", counter, regs.rax);
		//End of function
		counter++;
	}
}