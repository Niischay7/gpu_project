/*
 * GPU Specialization Capstone Project
 * Big Data Sorting Engine using CUDA Thrust
 * 
 * This program generates a massive array of random numbers, copies them 
 * to the GPU, sorts them in parallel using Thrust, and writes a log 
 * of the execution time and a data sample to verify correctness.
 */

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/random.h>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

// Function to parse command line arguments for the CLI requirement
void parseCLI(int argc, char** argv, int& numElements, string& outputFile) {
    for (int i = 1; i < argc; i++) {
        string arg = argv[i];
        if (arg == "-n" && i + 1 < argc) {
            numElements = stoi(argv[++i]);
        } else if (arg == "-o" && i + 1 < argc) {
            outputFile = argv[++i];
        }
    }
}

int main(int argc, char** argv) {
    // Default parameters
    int numElements = 50000000; // 50 Million default
    string outputFile = "execution_log.txt";

    // Parse CLI arguments
    parseCLI(argc, argv, numElements, outputFile);

    cout << "Initializing Big Data Sort with " << numElements << " elements..." << endl;

    // Initialize host vectors and random engine
    thrust::host_vector<float> h_keys(numElements);
    thrust::default_random_engine rng(1337);
    thrust::uniform_real_distribution<float> dist(0.0f, 1000.0f);

    cout << "Generating random data on CPU..." << endl;
    for(int i = 0; i < numElements; i++) {
        h_keys[i] = dist(rng);
    }

    // Allocate device memory and copy data
    cout << "Transferring data to GPU..." << endl;
    thrust::device_vector<float> d_keys = h_keys;

    // Setup CUDA timing events
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cout << "Sorting data on GPU using Thrust..." << endl;
    
    // Start timing
    cudaEventRecord(start);
    
    // Execute Parallel Sort
    thrust::sort(d_keys.begin(), d_keys.end());
    
    // Stop timing
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    cout << "Sort completed in " << milliseconds << " ms." << endl;

    // Copy sorted data back to host to verify
    thrust::host_vector<float> h_sorted = d_keys;

    // Write Execution Proof to Log File
    cout << "Writing execution artifacts to " << outputFile << "..." << endl;
    ofstream out(outputFile);
    out << "--- GPU SORT EXECUTION LOG ---\n";
    out << "Data Size: " << numElements << " elements\n";
    out << "Execution Time: " << milliseconds << " ms\n";
    out << "Throughput: " << (numElements / (milliseconds / 1000.0)) / 1e6 << " Million Elements / Second\n\n";
    
    out << "--- DATA VERIFICATION (First 20 Elements) ---\n";
    for(int i = 0; i < 20; i++) {
        out << "[" << i << "]: " << h_sorted[i] << "\n";
    }
    
    out << "...\n--- DATA VERIFICATION (Last 20 Elements) ---\n";
    for(int i = numElements - 20; i < numElements; i++) {
        out << "[" << i << "]: " << h_sorted[i] << "\n";
    }
    
    out.close();
    cout << "Process Complete! Ready for grading." << endl;

    return 0;
}