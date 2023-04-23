layout asm
layout reg

set breakpoint pending on
break _start
commands
end

define xl
	if $argc == 1
		set $offset = 0
	else
		set $offset = $arg1
	end
	x/8bx ((void*)&$arg0)+$offset
end
define xb
	if $argc == 1
		set $offset = 0
	else
		set $offset = $arg1
	end
	x/1gx ((void*)&$arg0)+$offset
end