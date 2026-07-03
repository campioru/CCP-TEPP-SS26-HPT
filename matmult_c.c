#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

double myclock();

void main (int argc, char **argv)
{
   int i, j, k, N;
   double *A, *B, *C;
   double t_start, t_elapsed;
   char outfile[20];
   FILE *fd;

   char *a = argv[1];
   N = atoi( a );

      // Alocate space for the 3 matrices

   A = malloc( N*N * sizeof(double) );
   B = malloc( N*N * sizeof(double) );
   C = malloc( N*N * sizeof(double) );

      // Initialize the A and B matrices, zero the C matrix

   for( i = 0; i < N; i++ ) {
      for( j = 0; j < N; j++ ) {
         A[i*N+j] = (double) (j+1) / (double) (i+1);
         B[i*N+j] = (double) (j+1) / (double) (i+1);
         C[i*N+j] = (double) 0.0;
      }
   }

      // Allocate and initialize a dummy array to clear out cache

   double *dummy = malloc( 125000000 * sizeof(double) );
   for( i = 0; i < 125000000; i++ ) { dummy[i] = 0.0; }


      // Now we start the timer and do our calculation

t_start = myclock();

   for( i = 0; i < N; i++ ) {
      for( j = 0; j < N; j++ ) {
         for( k = 0; k < N; k++ ) {
            C[i*N+j] += A[i*N+k] * B[k*N+j];
         }
      }
   }

t_elapsed = myclock() - t_start;


   printf("multiplication of matrices size %d took %lf seconds\n", N, t_elapsed );
   printf("%lf Gflops (billion floating-point operations per second)\n", 
          2*N*N*N*1e-9 / t_elapsed);
   printf( "%lf GB memory used\n", 3*N*N*8/1.0e9);

      // Dump the matrix to a file for validation

   sprintf( outfile, "matmult_c-%d.out", N);
   fd = fopen( outfile, "w");
   for( i = 0; i < N; i++ ) {
      for( j = 0; j < N; j++ ) {
         if( j == 0 ) fprintf(fd,  "%0.2lf", C[i*N+j]);
         else         fprintf(fd, ",%0.2lf", C[i*N+j]);
      }
      fprintf(fd, "\n");
   }

}

double myclock() {
   static time_t t_start = 0;  // Save and subtract off each time

   struct timespec ts;
   clock_gettime(CLOCK_REALTIME, &ts);
   if( t_start == 0 ) t_start = ts.tv_sec;

   return (double) (ts.tv_sec - t_start) + ts.tv_nsec * 1.0e-9;
}
