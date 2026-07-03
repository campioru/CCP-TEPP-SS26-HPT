! matmult_blas.f90 - matrix multiplication if Fortran 90 using DGEMM()
! gfortran -O3 -lblas -o matmult_blas matmult_blas.f90

PROGRAM matmult_blas

   INTEGER i, j, k, N, cs, ce, cr
   DOUBLE PRECISION :: t_mult
   DOUBLE PRECISION, DIMENSION(1000,1000) :: A, B, C

      ! Allocate matrices and initialize A and B

   N = 1000
   DO i = 1, N
      DO j = 1, N
         A( i, j ) = DBLE( i + j )
         B( i, j ) = DBLE( i * j + 1.0)
         C( i, j ) = 0.0
      END DO
   END DO

      ! Now time the multiplication

   CALL SYSTEM_CLOCK( COUNT_RATE = cr )
   CALL SYSTEM_CLOCK( COUNT = cs )

   CALL DGEMM( 'N', 'N', N, N, N, 1.0, A, N, B, N, 0.0, C, N )

   CALL SYSTEM_CLOCK( COUNT = ce )
   t_mult = DBLE( ce - cs ) / cr

   WRITE(*,*) "Multiplying 2 matrices of size ", N, " using DGEMM"
   WRITE(*,*) "Time ", t_mult, " seconds"

END PROGRAM matmult_blas
