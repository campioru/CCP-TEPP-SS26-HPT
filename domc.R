# load libraries 
library(doMC)
library(foreach)
library(parallel)

# detect how many cores are available
# This function will return how many total cores are available
# on the machine. It should not be use on the cluster to 
# query the number of cores for parallelization 
( nCores <- detectCores() )


nSim<-10000

# If you plan to use 8 cores on the cluster
# you MUST add option -pe omp 8
# to your qsub command
#nCores <- as.numeric(Sys.getenv("NSLOTS"))
#paste("Running code using",nCores,"cores") 
nCores <- 8
registerDoMC(nCores)

# simulate some data
D <- rnorm(1000, 165, 5)
M <- D + rnorm(1000, 0, 1)

# calculate linear model
DataModel <- lm(D ~ M)
Beta <- coef( DataModel )[2]


# Original non-parallel code
# matrix <- matrix(0, nrow=nSim, ncol = )
# for (i in 1:nSim) {
#   perm <- sample(D, replace=FALSE)
#   mdl <- lm(perm ~ M)
#   matrix [i,] <- c(i, coef(mdl))
# }


# Execute sampling and analysis in parallel
matrix <- foreach(i=1:nSim, .combine=rbind) %dopar% {
    perm <- sample(D, replace=FALSE)
    mdl <- lm(perm ~ M)
    c(i, coef(mdl))
}

# calculate and print p value
pValue <- sum( abs(matrix[,3]) > Beta ) /nrow(matrix)
paste("p-value :",pValue)
