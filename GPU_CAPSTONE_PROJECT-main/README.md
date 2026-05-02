# GPU-Accelerated Big Data Sorting Engine

## Project Overview
This repository contains my Capstone Project for the Coursera GPU Specialization. 

The goal of this project is to demonstrate the massive performance advantages of parallel processing by sorting enormous datasets. Using the **CUDA Thrust** library, this program generates an array of up to 50 million random floating-point numbers on the CPU, transfers them to the GPU, and sorts them in parallel. 

While a standard single-threaded CPU sorting algorithm (like `std::sort`) scales poorly with massive datasets, this GPU-accelerated engine can sort 50 million elements in roughly ~15 milliseconds—achieving a throughput of over **3.2 Billion elements per second**.

## Repository Structure
* `capstone_sort.cu`: The core C++/CUDA source code containing the host and device logic.
* `Makefile`: Build configuration for easy compilation using the `nvcc` compiler.
* `run.sh`: A shell script to automate building and executing a 50-million element test.
* `execution_log.txt`: Proof of execution artifact containing performance metrics and data verification.

## Prerequisites
To compile and run this code, your environment must have:
* An NVIDIA GPU with CUDA compute capability.
* The CUDA Toolkit installed (specifically the `nvcc` compiler).
* A C++17 compatible host compiler (like GCC).

## How to Compile
A `Makefile` is provided for seamless compilation. Open your terminal in the project directory and run:
```bash
make
