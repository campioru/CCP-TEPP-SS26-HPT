# timing_example.py - Example code showing how to put timing around an IO loop.

import time

N = 1000000
array = [ float(i) for i in range( N ) ]

t_start = time.perf_counter()

a_sum = 0.0
#t_sum = 0.0
for i in range( N ):
   # t0 = time.perf_counter()
   a_sum += array[i]
   # t_sum += time.perf_counter() - t0

t_loop = time.perf_counter() - t_start

#print("The sum took ", t_sum, " seconds")
print("The loop took ", t_loop, " seconds")

t_start = time.perf_counter()

fd = open( "array.out", "w")
for i in range( N ):
   fd.write( str(array[i]) + "\n" )
fd.close()

t_output = time.perf_counter() - t_start
print("The output took ", t_output, " seconds")

