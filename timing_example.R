# timing example code for R
# USAGE:  Rscript timing_example.R


   # Allocate space for and initialize the array

n <- 1000000
x <- vector( "double", n )

for( i in 1:n )
{
   x[i] <- as.double(i)
}


   # Time a simple summation loop first

dummy <- matrix( 1:125000000 )       # 1 GB of data to flush caches

t_start <- proc.time()[[3]]

a_sum <- 0.0
for( i in 1:n )
{
   a_sum <- a_sum + x[i]
}

t_end <- proc.time()[[3]]

print(sprintf("Summation with for loop took %6.3f seconds", t_end-t_start))
print(sprintf("a_sum = %.6e for vector size %i", a_sum, n ) )


   # Time the file write

t_start <- proc.time()[[3]]

writeLines( as.character( x ), "timing_example.out" )

t_end <- proc.time()[[3]]

print(sprintf("File write for vector size %i took %6.3f seconds", n, t_end-t_start))
