AVRDUDE_PROGRAMMER	:= usbtiny
TARGET				:= fdioCV2.hex
ELF					:= fdioCV2.elf
SRCS				:= main.c config.c buffer.c usart.c iocontrol.c rtc.c util.c
CC					:= avr-gcc
OBJCOPY				:= avr-objcopy

CCFLAGS = -std=c99 -mmcu=atmega644pa -Os
AVFLAGS = -c ${AVRDUDE_PROGRAMMER} -p m644p
LDFLAGS = 
LIBS    = 
OCFLAGS = -j .text -j .data -O ihex

.PHONY: all clean distclean 
all:: ${TARGET} 


${TARGET}: ${ELF}
	${OBJCOPY} ${OCFLAGS} $< $@
	
${ELF}: ${SRCS} 
	${CC} ${CCFLAGS} ${LDFLAGS} -o $@ ${SRCS} ${LIBS} 

clean:: 
	-rm -f *~ *.o *.dep ${TARGET} ${ELF}
program: ${TARGET}
	avrdude ${AVFLAGS} -U flash:w:${TARGET} -U eeprom:w:config.hex
	
fuse:
	avrdude ${AVFLAGS} -U lfuse:w:0xff:m -U efuse:w:0xff:m -U hfuse:w:0xd9:m

distclean:: clean
