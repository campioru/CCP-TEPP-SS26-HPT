# Do the dot product between two vectors X and Y then print the result

import time

N = 1000000      # Do a large enough test to reduce timing variance
m = 1            # Interval between elements to use
                 #   (1 for no interval,  100 for sparse)

x = [ float(int(i/m)) for i in range( N*100 ) ]
y = [ float(int(i/m)) for i in range( N*100 ) ]

   # Now initialize a very large dummy array to force X and Y out of all levels of cache
   #    so that our times are for pulling elements up from main memory.

dummy = [ 0.0 for i in range( 125000000 ) ]  # Initialize 1 GB of memory

   # Now we start our timer and do our calculation

t_start = time.perf_counter()

d_prod = 0.0
for i in range( 0, N*m, m ):
   d_prod += x[i] * y[i]

t_elapsed = time.perf_counter() - t_start

   # The calculation is done and timer stopped so print out the answer

print('d_prod = ', d_prod, ' in ', 1000*t_elapsed, ' msecs')
#print( 2*N / t_elapsed, ' flops (floating-point operations per second)')
