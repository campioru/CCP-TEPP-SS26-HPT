# Dot product in R using a loop and a vector summation
# USAGE:  Rscript dot_product_threaded_doMC 100000 8     for 100,000 elements on 8 threads

library( foreach )
library( iterators )
library( parallel )
library( doMC )

   # Get the vector size and nThreads from the command line

args <- commandArgs(TRUE)
if( length( args ) == 2 ) {
   n <- as.integer( args[1] )
   nThreads <- as.integer( args[2] )
} else {
   n <- 100000
   nThreads <- detectCores()
}

   # Initialize the vectors and our virtual cluster

x <- vector( "double", n )
y <- vector( "double", n )

for( i in 1:n )
{
   x[i] <- as.double(i)
   y[i] <- as.double(3*i)
}

print(nThreads)
registerDoMC( nThreads )
getDoParWorkers()    # 8
getDoParName()       # doMC
getDoParVersion()    # 1.3.8

   # Time the multi-threaded dot product foreach loop
   #   This returns a vector of size 'n' that will need to be summed
   #   so it is very inefficient.

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

############################################################
# NOTE - htop shows this spawning no other processes, and scaling shows no improvement
# If anyone can fix this email daveturner@ksu.edu
# The second loop below is clearly spawning multiple threads as can be seen
# by slowing down the process with a Sys.sleep(5)
############################################################

#dot_product_vector <- foreach( i = 1:n, .combine = c, .options.mulicore = list(preschedule = TRUE )) %dopar% {
#dot_product_vector <- foreach( i = 1:n, .combine = c ) %dopar% {

   #x[i] * y[i]

#}
#dot_product <- sum( dot_product_vector )

#dot_product_vector <- foreach( i = 1:512, .combine = c ) %dopar% {

   #Sys.sleep(1)

#}

t_end <- proc.time()[[3]]

print(sprintf("dopar dot product took %6.3f seconds", t_end-t_start))
#print(sprintf("dot_product = %.6e on %i threads for vector size %i", dot_product, nThreads, n ) )


   # Now let's try a more complex but more efficient method where
   #    we manually divide the work between the threads.

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product_vector <- foreach( myThread = 1:nThreads, .combine = c ) %dopar% {

   psum <- 0.0
   for( j in seq( myThread, n, nThreads ) ) {
      psum <- psum + x[j] * y[j]
   }
   #Sys.sleep(5)
   psum

}
dot_product <- sum( dot_product_vector )

t_end <- proc.time()[[3]]

print(sprintf("dopar dot product with nThreads workers took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e on %i threads for vector size %i", dot_product, nThreads, n ) )

