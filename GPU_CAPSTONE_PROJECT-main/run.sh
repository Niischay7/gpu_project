#!/bin/bash
echo "Building the Capstone Project..."
make clean
make

echo "Running GPU Sort with 50 Million elements..."
./capstone_sort -n 50000000 -o execution_log.txt

echo "Done! Check execution_log.txt for proof."