# Makefile for Capstone Project
CC = nvcc
CFLAGS = -O3 --std c++17

all: capstone_sort

capstone_sort: capstone_sort.cu
	$(CC) $(CFLAGS) capstone_sort.cu -o capstone_sort

clean:
	rm -f capstone_sort execution_log.txt