
PROGRAM dot_product_fortran

   INTEGER :: i, N, clock_start, clock_stop, clock_rate

   DOUBLE PRECISION :: dprod
   DOUBLE PRECISION, ALLOCATABLE :: x(:), y(:)
   DOUBLE PRECISION, ALLOCATABLE :: dummy(:)

      ! Dynamically allocate large arrays to avoid overflowing the stack

   N = 10000000
   ALLOCATE( x(N) )
   ALLOCATE( y(N) )
   ALLOCATE( dummy(125000000) )

      ! Initialize the vectors

   DO i = 1, N
      x(i) = i-1
      y(i) = i-1
   END DO

      ! Initialize a dummy array to clear cache

   DO i = 1, 125000000
      dummy(i) = 0.0
   END DO

      ! Now start the timer and do the calculations

   CALL SYSTEM_CLOCK( COUNT_RATE = clock_rate )
   CALL SYSTEM_CLOCK( COUNT = clock_start )

   dprod = 0.0
   DO i = 1, N
      dprod = dprod + x(i) * y(i)
   END DO

   CALL SYSTEM_CLOCK( COUNT = clock_stop )

   WRITE(*,*) "dot product = ", dprod, " took ", &
      REAL(clock_stop-clock_start) / REAL(clock_rate), " seconds"

END PROGRAM dot_product_fortran

