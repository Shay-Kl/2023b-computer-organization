

PHDRS {
  text PT_LOAD WX ;    
  data PT_LOAD RW ;
  rodata PT_LOAD RX;   
}

ENTRY(_hw3_unicorn)

EXTERN(purple)
EXTERN(white)

SECTIONS
{

  .data : 
  {
	*(.data)
	*(.bss)
  } :data = 0x60000

  .text :
  {
  }  :text=0x400000

  
  rodata
  {
  }:rodata = 0x80000000

}
