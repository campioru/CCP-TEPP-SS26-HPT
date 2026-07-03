#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

int main (int argc, char **argv)
{
   int i, N, m;
   double dprod, *X, *Y;
   double t_elapsed;
   struct timespec ts, tf;

   N = 10000000;
   m = 100;        // Interval between elements (1 would be not sparse)

      // Allocate space for the X and Y vectors

   X = malloc( N * m * sizeof(double) );
   Y = malloc( N * m * sizeof(double) );

      // Initialize the X and Y vectors

   for( i = 0; i < N*m; i += m ) {   // Step by m
      X[i] = (double) (i/m);
      Y[i] = (double) (i/m);
   }

      // Allocate and innitialize a dummy array to clear cache

   double *dummy = malloc( 125000000 * sizeof(double) );
   for( i = 0; i < 125000000; i++ ) { dummy[i] = 0.0; }

      // Now we start the timer and do our calculation

   clock_gettime(CLOCK_REALTIME, &ts);

   dprod = 0.0;
   for( i = 0; i < N*m; i += m ) {
      dprod += X[i] * Y[i];
      //printf( "%d %lf %lf --> %lf\n", i, X[i], Y[i], dprod );
   }

   clock_gettime(CLOCK_REALTIME, &tf);
   t_elapsed =  (double) ( tf.tv_sec - ts.tv_sec );
   t_elapsed += (double) (tf.tv_nsec - ts.tv_nsec) * 1e-9;

   printf("sparse dot product = %lf  took %lf seconds\n", dprod, t_elapsed );
   printf("%lf Gflops (billion floating-point operations per second)\n",
          2.0*N*1.0e-9 / t_elapsed);
   printf( "%lf GB memory used\n", 2.0*N*m*8.0/1.0e9);

}

