#Generates prior
#Change number of species (line 3), loci (line 4), number of replicates (line 5), gamma distribution of the concentration parameter (lines 6 & 7), and buffer (line 8)
spnum=6
locinum=10
repn=10
concentrationShape = 2.0 
concentrationScale = 4.7  
buffer=50000
BayeSSCallocation<-"./BayeSSC"
hBayeallocation<-"hBayeSSC.py"

  for (rep in 1:repn){
    concentrationprior<-rgamma(1, shape=concentrationShape, scale=concentrationScale )
    command=paste("Rscript --vanilla PODsimulation_expansion.R", spnum,locinum,concentrationprior,buffer,rep,"testprior.par", BayeSSCallocation, hBayeallocation)
    system(command)
  }
