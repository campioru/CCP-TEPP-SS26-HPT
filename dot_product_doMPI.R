# Dot product in R using message passing with Rmpi
# USAGE:  Rscript dot_product_doMPI.R 100000 8         for 100,000 elements on 8 cores
#   on multiple nodes run with 'mpirun -np #'

   # Load the Rmpi and doMPI libraries and initialize the cluster of all cores available

library( iterators )
library( foreach )
library( parallel )    # Needed for detectCores()
library( Rmpi )
library( doMPI )

   # Get the vector size and nRanks from the command line

args <- commandArgs(TRUE)
if( length( args ) == 2 ) {
   n <- as.integer( args[1] )
   nRanks <- as.integer( args[2] )
} else {
   n <- 100000
   nRanks <- detectCores()
}

cl <- startMPIcluster( nRanks )   # Can hang here for some versions of R and OpenMPI
registerDoMPI( cl )

   # Allocate space for and initialize the array

x <- vector( "double", n )
y <- vector( "double", n )

for( i in 1:n )
{
   x[i] <- as.double(i)
   y[i] <- as.double(3*i)
}


   # Time the multi-threaded dot product foreach loop

########################################################
# This takes exceedingly long, around 8 hours for 100,000 element vectors
########################################################

#dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

#t_start <- proc.time()[[3]]

#dot_product_vector <- foreach( i = 1:n, .combine = c ) %dopar% {

   #x[i] * y[i]

#}
#dot_product <- sum ( dot_product_vector )

#t_end <- proc.time()[[3]]

#print(sprintf("Rmpi dot product took %6.3f seconds", t_end-t_start))
#print(sprintf("dot_product = %.6e on %icores for vector size %i", dot_product, nRanks, n ) )


   # Now let's try a more complex but more efficient method where
   #    we create 1 worker process per core

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

t_start <- proc.time()[[3]]

dot_product_vector <- foreach( myRank = 1:nRanks, .combine = c ) %dopar% {

   psum <- 0.0;
   for( j in seq( myRank, n, nRanks ) ) {
      psum <- psum + x[j] * y[j]
   }
   psum

}
dot_product <- sum( dot_product_vector )

t_end <- proc.time()[[3]]

print(sprintf("Rmpi dot product with nRanks workers took %6.3f seconds", t_end-t_start))
print(sprintf("dot_product = %.6e on %i MPI ranks for vector size %i", dot_product, nRanks, n ) )

quit()   # Shutting down the virtual cluster properly often hangs
#stopCluster( cl )
#mpi.finalize()

