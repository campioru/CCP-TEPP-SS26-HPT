// Dot product in C using OpenMP
// USAGE:  dot_product_openmp 4   to run with 4 cores

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <omp.h>

void main (int argc, char **argv)
{
   int i, N;
   double dprod, *X, *Y;
   double t_elapsed;
   struct timespec ts, tf;

      // Get the number of threads from the command line

   char *a = argv[1];
   int nthreads = atoi( a );

   N = 100000000;

      // Allocate space for the X and Y vectors

   X = malloc( N * sizeof(double) );
   Y = malloc( N * sizeof(double) );

      // Initialize the X and Y vectors

   for( i = 0; i < N; i++ ) {
      X[i] = (double) i;
      Y[i] = (double) i;
   }

      // Allocate and innitialize a dummy array to clear cache

   double *dummy = malloc( 125000000 * sizeof(double) );
   for( i = 0; i < 125000000; i++ ) { dummy[i] = 0.0; }


      // Now we start the timer and do our calculation

   clock_gettime(CLOCK_REALTIME, &ts);

   omp_set_num_threads( nthreads );

   dprod = 0.0;
#pragma omp parallel for reduction( +:dprod)
   for( i = 0; i < N; i++ ) {
      dprod += X[i] * Y[i];
   }

   clock_gettime(CLOCK_REALTIME, &tf);
   t_elapsed =  (double) ( tf.tv_sec - ts.tv_sec );
   t_elapsed += (double) (tf.tv_nsec - ts.tv_nsec) * 1e-9;

   printf("dot product = %e on %d threads took %lf seconds\n", dprod, nthreads, t_elapsed );
   printf("%lf Gflops (billion floating-point operations per second)\n",
          2.0*N*1.0e-9 / t_elapsed);
   printf( "%lf GB memory used\n", 2.0*N*8.0/1.0e9);

}

