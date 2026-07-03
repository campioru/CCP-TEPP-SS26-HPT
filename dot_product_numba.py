# Do the dot product between two vectors X and Y then print the result

import time
from numba import jit     # Get the Just-In-Time compiler


N = 1000000      # Do a large enough test to reduce timing variance

x = [ float(int(i)) for i in range( N ) ]
y = [ float(int(i)) for i in range( N ) ]

   # Now initialize a very large dummy array to force X and Y out of all levels of cache
   #    so that our times are for pulling elements up from main memory.

dummy = [ 0.0 for i in range( 125000000 ) ]  # Initialize 1 GB of memory


   # Define our dot product as a function for Numba

@jit(nopython=True,cache=True)               # Try adding cache=True too
def dp( v1, v2, nel ):
   dpsum = 0.0
   for i in range( nel ):
      dpsum += v1[i] * v2[i]
   return dpsum


   # Now we start our timer and do our calculation

t_start = time.perf_counter()

d_prod = dp( x, y, N )

t_elapsed = time.perf_counter() - t_start

   # The calculation is done and timer stopped so print out the answer

print('d_prod = ', d_prod, ' in ', 1000*t_elapsed, ' msecs')
#print( 2*N / t_elapsed, ' flops (floating-point operations per second)')
