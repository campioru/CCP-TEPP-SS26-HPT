! Dot product in Fortran using OpenMP

PROGRAM dot_product_fortran_openmp
   USE omp_lib

   INTEGER :: i, n, nthreads
   CHARACTER(100) :: arg1

   DOUBLE PRECISION :: dprod, t_start, t_elapsed
   DOUBLE PRECISION, ALLOCATABLE :: x(:), y(:)
   DOUBLE PRECISION, ALLOCATABLE :: dummy(:)

      ! Dynamically allocate large arrays to avoid overflowing the stack

   n = 100000000
   ALLOCATE( x(n) )
   ALLOCATE( y(n) )
   ALLOCATE( dummy(125000000) )

      ! Set the number of threads from the command line argument

   CALL GET_COMMAND_ARGUMENT( 1, arg1 )
   READ( arg1, *) nthreads
   CALL OMP_SET_NUM_THREADS( nthreads )   ! Set the number of threads

      ! Initialize the vectors

   DO i = 1, n
      x(i) = i
      y(i) = i
   END DO

      ! Initialize a dummy array to clear cache

   DO i = 1, 125000000
      dummy(i) = 0.0
   END DO

      ! Now start the timer and do the calculations

t_start = OMP_GET_WTIME()

   dprod = 0.0
!$OMP PARALLEL DO REDUCTION(+:dprod)
   DO i = 1, n
      dprod = dprod + x(i) * y(i)
   END DO

t_elapsed = OMP_GET_WTIME() - t_start

   WRITE(*,*) "dot product = ", dprod, " took ", &
      t_elapsed, " seconds  on ", nthreads, " threads"

END PROGRAM dot_product_fortran_openmp

