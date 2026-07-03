// Matrix multiplication in raw C
//   May need to do 'ulimit -s unlimited' to increase stack size
//   On Apple use 'ulimit -s hard' to increase to 64 MB

// gcc -O3 -o matmult_cblas -lopenblas matmult_cblas.c

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <cblas.h>

int main (int argc, char **argv)
{
   int i, j, k;
   double t_mult;
   struct timespec ts, tf;

      // Allocate matrices and initialize A and B

   int N = 1000;
   double A[N][N], B[N][N], C[N][N];

   for( i = 0; i < N; i++ ) {
      for( j = 0; j < N; j++ ) {
         A[i][j] = (double) (i+j);
         B[i][j] = (double) (i*j + 1.0);
         C[i][j] = (double) (0.0);
      }
   }

      // Multiply A and B into C

   clock_gettime(CLOCK_REALTIME, &ts);

   cblas_dgemm( CblasRowMajor, CblasNoTrans, CblasNoTrans,
                N, N, N, 1.0, *A, N, *B, N, 1.0, *C, N );

   clock_gettime(CLOCK_REALTIME, &tf);
   t_mult =  (double) ( tf.tv_sec - ts.tv_sec );
   t_mult += (double) (tf.tv_nsec - ts.tv_nsec) * 1e-9;

   printf( "Multiplying 2 matrices of size %d took %lf seconds\n", N, t_mult);
}
