! timing_example.f90 - Example code showing how to put timing around an IO loop.

PROGRAM timing_example

   INTEGER :: i, N, c_start, c_stop, c_rate, cs_start, cs_stop
   INTEGER :: cio_start, cio_stop, fd
   DOUBLE PRECISION :: t_sum, t_loop, a_sum, t_io
   DOUBLE PRECISION, ALLOCATABLE :: array(:)
   DOUBLE PRECISION, ALLOCATABLE :: dummy(:)


      ! Allocate space for the array and initialize it

   N = 100000000;
   ALLOCATE( array(N) )   

   DO i = 1, N
      array(i) = i
   END DO

      ! Initialize a dummy array to clear cache

   ALLOCATE( dummy(125000000) )
   DO i = 1, 125000000
      dummy(i) = 0.0
   END DO

      ! Put timing around our loop

   CALL SYSTEM_CLOCK( COUNT_RATE = c_rate )
   CALL SYSTEM_CLOCK( COUNT = c_start )

   !t_sum = 0.0
   a_sum = 0.0
   DO i = 1, N
      !CALL SYSTEM_CLOCK( COUNT = cs_start )
      a_sum = a_sum + array(i)
      !CALL SYSTEM_CLOCK( COUNT = cs_stop )
      !t_sum = t_sum + DBLE(cs_stop - cs_start) / c_rate
   END DO

   CALL SYSTEM_CLOCK( COUNT = c_stop )
   t_loop = DBLE(c_stop - c_start) / c_rate

   WRITE(*,*) "a_sum = ", a_sum
   !WRITE(*,*) "The sum took ", t_sum, " seconds "
   WRITE(*,*) "The loop took ", t_loop, " seconds "

      ! Now time the file write

   CALL SYSTEM_CLOCK( COUNT = cio_start, COUNT_RATE = c_rate )

   open( fd, file = "timing_example.out" )
   DO i = 1, N
      write( fd, *) array(i)
   END DO

   close( fd )

   CALL SYSTEM_CLOCK( COUNT = cio_stop )
   t_io = DBLE(cio_stop - cio_start) / c_rate

   WRITE(*,*) "The IO write  took = ", t_io, " seconds "

END PROGRAM timing_example

