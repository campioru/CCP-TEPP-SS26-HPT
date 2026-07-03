# Add rows to a dataframe of a given size using rbind() in R
# USAGE:  Rscript rbind.R 1000      for a 1000 row dataframe


   # Get the number of rows from the command line

args <- commandArgs(TRUE)
nrows <- as.integer( args[1] )


   # Initialize the data frame and lists

df <- data.frame()
name <- list( "Dr", "Dave", "Eric", "Turner" )
city <- list( "Osceola", "Beatrice", "Leigh", "Omaha", "Ames", "Manhattan" )


   # Start timer and rbind() the requested number of rows

t_start <- proc.time()[[3]]

for( i in 1:nrows )
{
   new_row <- cbind( i, name[ (i-1) %% 4 + 1 ], 100.001, city[ (i-1) %% 6 + 1 ], 12L )
   df <- rbind( df, new_row )
}

t_end <- proc.time()[[3]]

print(sprintf("dataframe rbind() of %i rows took %6.3f seconds", nrows, t_end-t_start))
#colnames(df) <- c( "Row", "Name", "IQ", "City", "Shoe_Size" )
#write.table( df, file="matrix-loops.csv", row.names=FALSE, col.names=FALSE, sep = ',')

