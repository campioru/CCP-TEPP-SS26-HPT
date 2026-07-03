# Matrix multiply using parallel foreach loops in R
# USAGE:  Rscript matmult_foreach.R 1000 8        for a 1000x1000 matrix size on 8 cores

library( foreach )
library( iterators )
library( parallel )
library( doParallel )   # This is the parallel package that is doing the work


   # Get the matrix size and ncores from the command line

args <- commandArgs(TRUE)
if( length( args ) == 2 ) {
   n <- as.integer( args[1] )
   ncores <- as.integer( args[2] )
} else {
   n <- 1000
   ncores <- detectCores()
}

   # Initialize our virtual cluster

cl <- makeCluster( ncores )
registerDoParallel( cl, ncores )
print(sprintf("Matrix multiply using doParallel library for size %ix%i on %i cores", n, n, ncores ) )


   # Start by allocating space for all 3 matrices

a <- matrix( 1:n*n, ncol = n, nrow = n )
b <- matrix( 1:n*n, ncol = n, nrow = n )
c <- matrix( 1:n*n, ncol = n, nrow = n )

   # Now initialize the a and b matrices and zero the c matrix

for( i in 1:n )
{
   for( j in 1:n )
   {
      a[i,j] <- as.double(j+1) / as.double(i+1)
      b[i,j] <- as.double(j+1) / as.double(i+1)
      c[i,j] <- 0.0
   }
}


   # Time the matrix multiplication using multi-threaded foreach loops

dummy <- matrix( 1:125000000 )       # 1 GB of data to flush caches

t_start <- proc.time()[[3]]

   df <- foreach( i = 1:n ) %dopar%
   {
      for( j in 1:n )
      {
         for( k in 1:n )
         {
            c[i,j] <- c[i,j] + a[i,k] * b[k,j]
         }
      }
   }

t_end <- proc.time()[[3]]

print(sprintf("Matrix multiply with foreach dopar on %i cores took %6.3f seconds", ncores, t_end-t_start))
#write.table( c, file="matrix-foreach.csv", row.names=FALSE, col.names=FALSE, sep = ',')

