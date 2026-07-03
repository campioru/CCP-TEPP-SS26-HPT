# Dot product in R using a loop and a vector summation
# USAGE:  Rscript dot_product_sparse.R


   # Allocate space for and initialize the array

n <- 100000
m <- 100         # Interval between elements in each vector
x <- vector( "double", n*m )
y <- vector( "double", n*m )

j <- 0
for( i in seq( 1, n*m, by = m ) )
{
   j <- j + 1
   x[i] <- as.double(j)
   y[i] <- as.double(3*j)
}


   # Time a simple dot product loop first

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product <- 0.0
for( i in seq( 1, n*m, by = m ) )
{
   dot_product <- dot_product + x[i] * y[i]
}

t_end <- proc.time()[[3]]

print(sprintf("Sparse dot product by for loop took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e for vector size %i", dot_product, n ) )

