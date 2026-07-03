
PROGRAM dot_product_fortran

   INTEGER :: i, n, clock_start, clock_stop, clock_rate

   DOUBLE PRECISION :: dprod
   DOUBLE PRECISION, ALLOCATABLE :: x(:), y(:)
   DOUBLE PRECISION, ALLOCATABLE :: dummy(:)

      ! Dynamically allocate large arrays to avoid overflowing the stack

   n = 100000000
   ALLOCATE( x(n) )
   ALLOCATE( y(n) )
   ALLOCATE( dummy(125000000) )

      ! Initialize the vectors

   DO I = 1, n
      x(i) = i
      y(i) = i
   END DO

      ! Initialize a dummy array to clear cache

   DO i = 1, 125000000
      dummy(i) = 0.0
   END DO

      ! Now start the timer and do the calculations

   CALL SYSTEM_CLOCK( COUNT_RATE = clock_rate )
   CALL SYSTEM_CLOCK( COUNT = clock_start )

   dprod = DOT_PRODUCT( x, y )

   CALL SYSTEM_CLOCK( COUNT = clock_stop )

   WRITE(*,*) "dot product = ", dprod, " took ", &
      REAL(clock_stop-clock_start) / REAL(clock_rate), " seconds"

END PROGRAM dot_product_fortran

