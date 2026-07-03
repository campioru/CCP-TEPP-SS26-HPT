# Inserts data into rows in a data.table of a given size
# USAGE:  Rscript datatable.R 1000      for a 1000 row datatable

library( data.table )    # Must use install.packages("data.table") first

   # Get the number of rows from the command line

args <- commandArgs(TRUE)
nrows <- as.integer( args[1] )

name <- list( "Dr", "Dave", "Eric", "Turner" )
city <- list( "Osceola", "Beatrice", "Leigh", "Omaha", "Ames", "Manhattan" )
#col_key <- cbind( 0L, name[1], 0.0, city[1], 0L )   # Key to set column types
col_key <- cbind( 0L, "nobody", 0.0, "nowhere", 0L )   # Key to set column types

   # Pre-allocate the data.table

dt <- as.data.table( as.matrix( col_key, nrow=nrows, ncol=5, byrow=TRUE ) )

colnames(dt) <- c( "Row", "Name", "IQ", "City", "Shoe_Size" )


   # Insert the values using set()

t_start <- proc.time()[[3]]

for( i in 1:nrows )
{
   set( dt, i, 1L, i )
   set( dt, i, 2L, name[ (i-1) %% 4 + 1 ] )
   set( dt, i, 3L, 100.001 )
   set( dt, i, 4L, city[ (i-1) %% 6 + 1 ] )
   set( dt, i, 5L, 12L )
}

t_end <- proc.time()[[3]]

print(sprintf("Datatable insert by set for %i rows took %6.3f seconds", n, t_end-t_start))


   # Insert the values using assignment :=

t_start <- proc.time()[[3]]

for( i in 1:nrows )
{
   dt[ i, Row:=i ]
   dt[ i, Name:=name[ (i-1) %% 4 + 1 ] ]
   dt[ i, IQ:=100.002 ]
   dt[ i, City:=city[ (i-1) %% 6 + 1 ] ]
   dt[ i, Shoe_Size:=13L ]
}

t_end <- proc.time()[[3]]

print(sprintf("Datatable insert by assignment for %i rows took %6.3f seconds", n, t_end-t_start))

