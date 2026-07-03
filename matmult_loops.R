# Matrix multiply using loops in R
# USAGE:  Rscript matmult_loops.R 1000      for a 1000x1000 matrix size


   # Get the matrix size from the command line

args <- commandArgs(TRUE)
n <- as.integer( args[1] )


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


   # Time the matrix multiplication using loops

dummy <- matrix( 1:125000000 )       # 1 GB of data to flush caches

t_start <- proc.time()[[3]]

for( i in 1:n )
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

print(sprintf("Matrix multiply %ix%i took %6.3f seconds", n, n, t_end-t_start))
#write.table( c, file="matrix-loops.csv", row.names=FALSE, col.names=FALSE, sep = ',')


