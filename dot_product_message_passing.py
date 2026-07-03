# Do the dot product between two vectors X and Y then print the result
# USAGE:  mpirun -np 4 python dot_product_message_passing.py       to run on 4 tasks
# pip install mpi4py      in your virtual environment before you run this code

import sys
import time
from mpi4py import MPI

   # Get my rank and the number of ranks - (MPI talks about ranks instead of threads)

comm = MPI.COMM_WORLD       # Handshake with other ranks
nranks = comm.Get_size()    # The number of ranks (threads)
myrank = comm.Get_rank()    # Which rank am I ( 0 .. nranks-1 )

N = 100000000      # Do a large enough test to reduce timing variance
N_elements = int( N/nranks )

if ( N % nranks != 0 ):
   print("Please use an even number of ranks")
   exit

x = [ float( myrank + i*nranks ) for i in range( N_elements ) ]
y = [ float( myrank + i*nranks ) for i in range( N_elements ) ]

   # Now initialize a very large dummy array to force X and Y out of all levels of cache
   #    so that our times are for pulling elements up from main memory.

dummy = [ 0.0 for i in range( 125000000 ) ]  # Initialize 1 GB of memory

   # Now we start our timer and do our calculation using multiple threads

comm.barrier()    # Sync all ranks before starting the timer
t_start = time.perf_counter()

psum = 0.0
for i in range( N_elements ):
   psum += x[i] * y[i]

d_prod = comm.reduce( psum, op=MPI.SUM )

t_elapsed = time.perf_counter() - t_start

   # The calculation is done and timer stopped so print out the answer

if ( myrank == 0 ):    # Only rank 0 will print results
   print('dot product = ', d_prod, 'took ', t_elapsed, ' seconds on ', nranks, ' ranks' );
   print( 2.0*N*1.0e-9 / t_elapsed, ' Gflops (billion floating-point operations per second)')
   print( 2.0*N*8.0/1.0e9, ' GB memory used' )


