# Dot product in R using a loop and a vector summation
# USAGE:  Rscript dot_product.R


   # Allocate space for and initialize the array

n <- 100000
x <- vector( "double", n )
y <- vector( "double", n )

for( i in 1:n )
{
   x[i] <- as.double(i)
   y[i] <- as.double(3*i)
}


   # Time a simple dot product loop first

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product <- 0.0
for( i in 1:n )
{
   dot_product <- dot_product + x[i] * y[i]
}

t_end <- proc.time()[[3]]

print(sprintf("Dot product by for loop took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e for vector size %i", dot_product, n ) )


   # Time the dot product by vector sums

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product <- sum( x * y )

t_end <- proc.time()[[3]]

print(sprintf("Dot product by vector sum took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e for vector size %i", dot_product, n ) )
