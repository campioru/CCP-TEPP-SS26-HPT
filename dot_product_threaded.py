# Do the dot product between two vectors X and Y then print the result
# USAGE:  python dot_product_threaded.py 4       to run on 4 threads

import sys
import time
import pymp

   # Get and set nthreads from the command line

pymp.config.num_threads = int( sys.argv[1] )
nthreads = pymp.config.num_threads

N = 100000000      # Do a large enough test to reduce timing variance

x = [ float( i ) for i in range( N ) ]
y = [ float( i ) for i in range( N ) ]

   # Now initialize a very large dummy array to force X and Y out of all levels of cache
   #    so that our times are for pulling elements up from main memory.

dummy = [ 0.0 for i in range( 125000000 ) ]  # Initialize 1 GB of memory

   # Now we start our timer and do our calculation using multiple threads

t_start = time.perf_counter()

psum = pymp.shared.array( (nthreads,), dtype='float' )
for i in range( nthreads ):
   psum[i] = 0.0

d_prod = 0.0
with pymp.Parallel( nthreads ) as p:
   for i in p.range( N ):
      #d_prod += x[i] * y[i]
      psum[p.thread_num] += x[i] * y[i]

for i in range( nthreads ):     # Explicitly do the reduction across threads
   d_prod += psum[i]

t_elapsed = time.perf_counter() - t_start

   # The calculation is done and timer stopped so print out the answer

print('dot product = ', d_prod, 'took ', t_elapsed, ' seconds' );
print( 2.0*N*1.0e-9 / t_elapsed, ' Gflops (billion floating-point operations per second)')
print( 2.0*N*8.0/1.0e9, ' GB memory used' )

