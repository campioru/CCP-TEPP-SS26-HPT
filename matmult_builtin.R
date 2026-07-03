# Matrix multiply using the built-in function in R
# USAGE:  Rscript matmult_builtin.R 1000      for a 1000x1000 matrix size


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


   # Time the matrix multiplication using the built in method

dummy <- matrix( 1:125000000 )       # 1 GB of data to flush caches

t_start <- proc.time()[[3]]

   c <- a %*% b

t_end <- proc.time()[[3]]

print(sprintf("Built in matrix multiply of size %ix%i took %6.3f seconds", n, n, t_end-t_start))

#write.table( c, file="matrix-built-in.csv", row.names=FALSE, col.names=FALSE, sep = ',')



