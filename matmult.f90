! matmult.f90 - matrix multiplication if Fortran 90

PROGRAM matmult

   INTEGER i, j, k, N, cs, ce, cr
   DOUBLE PRECISION :: t_mult
   DOUBLE PRECISION, DIMENSION(1000,1000) :: A, B, C

      ! Allocate matrices and initialize A and B

   N = 1000
   DO i = 1, N
      DO j = 1, N
         A( i, j ) = DBLE( i + j )
         B( i, j ) = DBLE( i * j + 1.0)
      END DO
   END DO

      ! Now time the multiplication

   CALL SYSTEM_CLOCK( COUNT_RATE = cr )
   CALL SYSTEM_CLOCK( COUNT = cs )

   DO i = 1, N
      DO j = 1, N
         C(i,j) = 0.0
         DO k = 1, N
            C( i, j ) = C( i, j ) + A( i, k ) * B( k, j )
         END DO
      END DO
   END DO

   CALL SYSTEM_CLOCK( COUNT = ce )
   t_mult = DBLE( ce - cs ) / cr

   WRITE(*,*) "Multiplying 2 matrices of size ", N
   WRITE(*,*) "Time ", t_mult, " seconds"

END PROGRAM matmult
