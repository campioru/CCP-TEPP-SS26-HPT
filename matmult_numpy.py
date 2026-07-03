# Do the dot product between two vectors X and Y then print the result

# USAGE - python matmult.py 100      for a matrix size of 100x100

import sys
import time
import numpy as np
import csv

N = int( sys.argv[1] )   # The matrix size is the first command line argument

   # Initialize the A and B matrices, zero out the C matrix

A = [ [ float((i+1)/(j+1)) for i in range( N ) ] for j in range( N ) ]
B = [ [ float((i+1)/(j+1)) for i in range( N ) ] for j in range( N ) ]
C = [ [ float( 0.0 )       for i in range( N ) ] for j in range( N ) ]

   # Now initialize a very large dummy array to force A, B, C out of all 
   # levels of cache so that we start with matrices in main memory.

dummy = [ 0.0 for i in range( 125000000 ) ]  # Initialize 1 GB of memory

   # Now we start our timer and do our calculation

t_start = time.perf_counter()

C = np.matmul( A, B )

t_elapsed = time.perf_counter() - t_start

   # The calculation is done and timer stopped so print out the answer

print('multiplication of matrices size ', N, ' took ', t_elapsed, ' seconds')
print( 2*N**3*1e-9 / t_elapsed, ' Gflops (billion floating-point operations per second)')
print( 3*N*N*8/1e9, ' GB memory used')

   # Now dump out the C matrix for validating the results

def formatdata( Z ):
   for row in Z:
      yield[ "%0.2f" % v for v in row]

with open("matmult_numpy-" + str(N) + ".out", "w") as fd:
   writer = csv.writer(fd)
   writer.writerows( formatdata( C ), lineterminator="\n" )

