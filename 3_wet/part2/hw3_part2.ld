

PHDRS {
  text PT_LOAD;    
  data PT_LOAD  ;
  rodata PT_LOAD ;   
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
  } :data = 0x60000 > REGION_DATA

  .text :
  {
  }  :text=0x400000 > REGION_TEXT

  
  rodata
  {
  }:rodata = 0x80000000  > REGION_RODATA

}
