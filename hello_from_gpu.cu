// C calling CUDA code to say 'Hello!' from the GPU card
// COMPILATION:  nvcc hello.cu -o hello_from_gpu
// USAGE:        ./hello_from_gpu

#include <stdio.h>

   // Function to run on the GPU to say 'Hello!'

__global__ void cuda_hello(){
   printf("Hello from the Graphics Card!\n");
}

   // main function to call the remote CUDA code on the GPU

int main() {

   printf( "Hello from main() on the CPU!\n");

   cuda_hello<<<1,1>>>(); 

      // Sync the CPU and GPU otherwise the GPU print might not come
      // before the program ends.

   cudaDeviceSynchronize();
}
