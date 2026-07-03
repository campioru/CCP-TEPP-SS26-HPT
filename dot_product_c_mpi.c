#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <mpi.h>

void main (int argc, char **argv)
{
   int i, j, N, myrank, nranks, n_elements;
   double psum, dprod, *X, *Y;
   double t_elapsed;
   struct timespec ts, tf;

   MPI_Init( NULL, NULL);
   MPI_Comm_rank( MPI_COMM_WORLD,&myrank );
   MPI_Comm_size( MPI_COMM_WORLD,&nranks );

   N = 100000000;
   n_elements = N / nranks;
   if( N % nranks != 0 ) {
      printf("Please use an even number of ranks\n");
      exit(0);
   }

      // Allocate space for my parts of the X and Y vectors

   X = malloc( n_elements * sizeof(double) );
   Y = malloc( n_elements * sizeof(double) );

      // Initialize the X and Y vectors

   j = 0;
   for( i = myrank; i < N; i += nranks ) {
      j++;
      X[j] = (double) i;
      Y[j] = (double) i;
   }

      // Allocate and innitialize a dummy array to clear cache

   double *dummy = malloc( 125000000 * sizeof(double) );
   for( i = 0; i < 125000000; i++ ) { dummy[i] = 0.0; }


      // Now we sync then start the timer and do our calculation

   MPI_Barrier( MPI_COMM_WORLD );
   clock_gettime(CLOCK_REALTIME, &ts);

   psum = 0.0;
   for( i = 0; i < n_elements; i++ ) {
      psum += X[i] * Y[i];
   }

   dprod = 0.0;
   MPI_Allreduce( &psum, &dprod, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

   clock_gettime(CLOCK_REALTIME, &tf);
   t_elapsed =  (double) ( tf.tv_sec - ts.tv_sec );
   t_elapsed += (double) (tf.tv_nsec - ts.tv_nsec) * 1e-9;

   if( myrank == 0 ) {
      printf("dot product = %lf  took %lf seconds on %d tasks\n", dprod, t_elapsed, nranks );
      printf("%lf Gflops (billion floating-point operations per second)\n",
            2.0*N*1.0e-9 / t_elapsed);
      printf( "%lf GB memory used\n", 2.0*N*8.0/1.0e9);
   }

   MPI_Finalize( );
}

