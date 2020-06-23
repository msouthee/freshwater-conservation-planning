#Set wd to Cost data folder

#load packages
library(vegan)
library(MASS)
library(permute)


#load 16 variable matrix

selcostvars<-read.csv("SelCostVars.csv", header = TRUE)
selcostvars[1,]
scvars<-selcostvars[,2:17]
row.names(scvars) = selcostvars$HydroID
scvars[1,]

#log(x+1) transformation to help with zero inflation 
tscvars<-log(scvars+1)

#Run a pca using correlations (env vars implicitly standardized using z scores [-xbar/s])
tscostpca<-princomp(tscvars, cor=TRUE)
summary(tscostpca,loadings=TRUE,cutoff=0.001)

#Loadings - association of input variables to PCA components (axes)
tscostpca$loadings
write.csv(tscostpca$loadings, file = "TransfSelectCostVarPCAloadings.csv", row.names = TRUE)

#Site scores - position of each site along each PCA component (axis)
tscostpca$scores
write.csv(tscostpca$scores, file = "TransfSelectCostVarPCAscores.csv", row.names = TRUE)

#USe broken stick method to determine number of meaningful components 
#(explaining more variation than would be expected by chance):
bstick(tscostpca)
screeplot(tscostpca,bstick=TRUE,type="lines")

#biplot ordination showing site positions and associations of input variables
biplot(tscostpca)

