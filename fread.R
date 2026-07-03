# Compares the difference between fread() from data.table to read.csv()
# USAGE:  Rscript fread.R 1000      for a 1000 row data.table

library( data.table )    # Must use install.packages("data.table") first

   # Get the number of rows from the command line

args <- commandArgs(TRUE)
nrows <- as.integer( args[1] )

   # Create the data.table file

mat <- data.frame( as.matrix( runif( nrows ), nrow=nrows ) )
write.csv( mat, "fread-mat.csv", row.names = F )

   # Time to read the data.frame using write.csv()

t_start <- proc.time()[[3]]

df <- read.csv( "fread-mat.csv" )

t_end <- proc.time()[[3]]

print(sprintf("Read CSV of %i rows took %6.3f seconds", nrows, t_end-t_start))


   # Time to read using fread() from the data.table package

t_start <- proc.time()[[3]]

dt <- fread( "fread-mat.csv" )

t_end <- proc.time()[[3]]

print(sprintf("fread() of %i rows took %6.3f seconds", nrows, t_end-t_start))

