CFLAGS=-std=c11 -g -static

test: 
	./test.sh

clean:
	rm -f 9cc *.o *~ tmp*

.PHONY: test clean