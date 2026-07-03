# Dot product in R using a loop and a vector summation
# USAGE:  Rscript dot_product_multi_thread.R 100000 8   for 100,000 elements on 8 cores

library( parallel )

   # Get the vector size and nThreads from the command line

args <- commandArgs(TRUE)
if( length( args ) == 2 ) {
   n <- as.integer( args[1] )
   nThreads <- as.integer( args[2] )
} else {
   n <- 100000
   nThreads <- detectCores()
}

cl <- makeCluster( nThreads )


   # Allocate space for and initialize the arrays

x <- vector( "double", n )
y <- vector( "double", n )

for( i in 1:n )
{
   x[i] <- as.double(i)
   y[i] <- as.double(3*i)
}

   # Export variables needed within the functions

clusterExport( cl, "x" )
clusterExport( cl, "y" )
clusterExport( cl, "n" )
clusterExport( cl, "nThreads" )

   # Time a multi-threaded dot product even though it's inefficient

dot_product_function <- function( i ) {

   return( x[i] * y[i] )

}

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product_list <- clusterApply( cl, 1:n, dot_product_function )
dot_product <- sum( unlist(dot_product_list) )

t_end <- proc.time()[[3]]

print(sprintf("Threaded dot product by clusterApply took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e on %i threads for vector size %i", dot_product, nThreads, n ) )


   # Now try dividing the iterations manually between workers

dot_product_workers <- function( myThread ) {

   mySum <- 0.0
   for( i in seq( myThread, n, by = nThreads ) )
   {
      mySum <- mySum + x[i] * y[i]
   }
   return( mySum )

}

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product_list <- clusterApply( cl, 1:nThreads, dot_product_workers )
dot_product <- sum( unlist(dot_product_list) )

t_end <- proc.time()[[3]]

print(sprintf("Threaded dot product with nThreads workers took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e on %i threads for vector size %i", dot_product, nThreads, n ) )

stopCluster( cl )
