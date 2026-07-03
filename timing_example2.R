# timing example code with internal loop timings for R
#   This shows how to do this, but demonstrates that it can be very intrusive
# USAGE:  Rscript timing_example2.R


   # Allocate space for and initialize the array

n <- 1000000
x <- vector( "double", n )

for( i in 1:n )
{
   x[i] <- as.double(i)
}


   # Time a simple summation loop with internal timing as well

dummy <- matrix( 1:125000000 )       # 1 GB of data to flush caches

t_sum <- 0.0
t_start <- proc.time()[[3]]

a_sum <- 0.0
for( i in 1:n )
{
   t_0 <- proc.time()[[3]]
   a_sum <- a_sum + x[i]
   t_sum <- t_sum + ( proc.time()[[3]] - t_0 )
}

t_end <- proc.time()[[3]]

print(sprintf("Internal sums took %6.3f seconds", t_sum))
print(sprintf("For loop with internal timing too took %6.3f seconds", t_end-t_start))
print(sprintf("a_sum = %.6e for vector size %i", a_sum, n ) )

