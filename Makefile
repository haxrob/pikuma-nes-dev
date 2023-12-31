build:
	ca65 main.asm -o main.o
	ld65 -C nes.cfg main.o -o main.nes

clean:
	rm *.o *.nes

run:
	fceux main.nes
