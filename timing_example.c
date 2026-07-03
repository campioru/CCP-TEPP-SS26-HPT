// timing_example.c - Example code showing how to put timing around an IO loop.

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

int main (int argc, char **argv)
{
   int i, N;
   double t_loop, t_sum, t_io, a_sum, *array;
   struct timespec ts, tf, ts_sum, tf_sum, ts_io, tf_io;
   FILE *fd;

      // Allocate space for the array and initialize it

   N = 1000000;
   array = malloc( N * sizeof(double) );

   for( i = 0; i < N; i++ ) {
      array[i] = (double) i;
   }

      // Put timing around our loop
 
   clock_gettime(CLOCK_REALTIME, &ts);

   a_sum = 0.0;
   //t_sum = 0.0;
   for( i = 0; i < N; i++ ) {
      //clock_gettime(CLOCK_REALTIME, &ts_sum);
      a_sum += array[i];
      //clock_gettime(CLOCK_REALTIME, &tf_sum);
      //t_sum =  (double) ( tf_sum.tv_sec - ts_sum.tv_sec );
      //t_sum += (double) (tf_sum.tv_nsec - ts_sum.tv_nsec) * 1e-9;
   }

   clock_gettime(CLOCK_REALTIME, &tf);
   t_loop =  (double) ( tf.tv_sec - ts.tv_sec );
   t_loop += (double) (tf.tv_nsec - ts.tv_nsec) * 1e-9;

   //printf( "The sum took %lf seconds\n", t_sum );
   printf( "The loop took %lf seconds\n", t_loop );

      // Now time the file write
 
   clock_gettime(CLOCK_REALTIME, &ts_io);

   fd = fopen( "time_example.out", "w" );
   for( i = 0; i < N; i++ ) {
      fprintf( fd, "%lf\n", array[i] );
   }
   fclose( fd );
   
   clock_gettime(CLOCK_REALTIME, &tf_io);
   t_io =  (double) ( tf_io.tv_sec - ts_io.tv_sec );
   t_io += (double) (tf_io.tv_nsec - ts_io.tv_nsec) * 1e-9;

   printf( "The IO write took %lf seconds\n", t_io );
}

