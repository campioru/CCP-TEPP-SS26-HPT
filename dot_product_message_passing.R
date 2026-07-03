# Do the dot product between two vectors X and Y then print the result
# USAGE:  mpirun -np 4 Rscript dot_product_message_passing.R 100000
#    This will run 100,000 elements on 4 cores, possibly spread on multiple compute nodes
# must install.packages("Rmpi") first

library( Rmpi )     # This does the MPI_Init() behind the scenes

   # Get the vector size from the command line

args <- commandArgs(TRUE)
if( length( args ) == 1 ) {
   n <- as.integer( args[1] )
} else {
   n <- 100000
}

   # Get my rank and the number of ranks - (MPI talks about ranks instead of threads)

com <- 0     # MPI_COMM_WORLD or all ranks
nRanks <- mpi.comm.size( com )    # The number of ranks (threads)
myRank <- mpi.comm.rank( com )    # Which rank am I ( 1 .. nRanks )

if( (n %% nRanks) != 0 ) {
   print("Please ensure vector size is divisable by the number of ranks")
   quit()
}
myElements <- n / nRanks

   # Allocate space and initialize the reduced arrays for each rank

x <- vector( "double", myElements )
y <- vector( "double", myElements )

j <- 0
for( i in seq( myRank+1, n, nRanks ) )
{
   j <- j + 1
   x[j] <- as.double(i)
   y[j] <- as.double(3*i)
}

   # Clear cache then barrier sync so all ranks are ready then time 

dummy <- matrix( 1:125000000 )       # Clear the cache buffers before timing

ret <- mpi.barrier( com )            # mpi.barrier() returns 1 if successful

t_start <- proc.time()[[3]]

p_sum <- 0.0
for( i in 1:myElements )
{
   p_sum <- p_sum + x[i] * y[i]
}

dot_product <- mpi.allreduce( p_sum, type = 2, op = "sum", comm = com )

t_end <- proc.time()[[3]]

if( myRank == 0 ) {
   print(sprintf("Rmpi dot product with nRanks workers took %6.3f seconds", t_end-t_start))
   print(sprintf("dot_product = %.6e on %i MPI ranks for vector size %i", dot_product, nRanks, n ) )
}

mpi.quit( )

