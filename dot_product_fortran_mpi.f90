! Do product in Fortran using MPI message-passing

PROGRAM dot_product_fortran_mpi
   USE mpi

   INTEGER :: i, n, myrank, nranks, n_elements, ierr

   DOUBLE PRECISION :: psum, dprod, t_start, t_elapsed
   DOUBLE PRECISION, ALLOCATABLE :: x(:), y(:)
   DOUBLE PRECISION, ALLOCATABLE :: dummy(:)

      ! Initialize the MPI environment

   CALL MPI_Init( ierr )
   CALL MPI_Comm_rank( MPI_COMM_WORLD, myrank, ierr )
   CALL MPI_Comm_size( MPI_COMM_WORLD, nranks, ierr )

      ! Dynamically allocate large arrays to avoid overflowing the stack

   n = 100000000
   n_elements = n / nranks
   IF( MOD( n, nranks) .NE. 0 ) THEN
      WRITE(*,*) "Please use an even number of ranks"
      CALL EXIT(0)
   END IF

   ALLOCATE( x(n_elements) )
   ALLOCATE( y(n_elements) )
   ALLOCATE( dummy(125000000) )

      ! Initialize the vectors

   j = 0
   DO i = myrank+1, n, nranks    ! Initialize to match non-MPI vectors
      j = j + 1
      x(j) = i
      y(j) = i
   END DO

      ! Initialize a dummy array to clear cache

   DO i = 1, 125000000
      dummy(i) = 0.0
   END DO

      ! Now start the timer and do the calculations

   CALL MPI_Barrier( MPI_COMM_WORLD, ierr )  ! Sync before starting timer
   t_start = MPI_Wtime( )

   psum = 0.0
   DO i = 1, n_elements
      psum = psum + x(i) * y(i)
   END DO

   dprod = 0.0
   CALL MPI_Allreduce( psum, dprod, 1, MPI_DOUBLE_PRECISION, MPI_SUM, &
        MPI_COMM_WORLD, ierr )

   t_elapsed = MPI_Wtime( ) - t_start

   IF( myrank .eq. 0 ) THEN
      WRITE(*,*) "dot product = ", dprod, " took ", &
         t_elapsed, " seconds  on ", nranks, " tasks"
   END IF

   CALL MPI_Finalize( ierr )

END PROGRAM dot_product_fortran_mpi

