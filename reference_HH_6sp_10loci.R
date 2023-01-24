library(CoExpansionValidation)
options(stringsAsFactors = F)
nspecies<-6 ##Number of species
nloci<-10 ##Number of loci
buffer<-10000 ##Buffer between coexpansion events
time.range<-c(20000,320000) #Time range
concentrationShape<-1.4 
concentrationscale<-2.8
bayessc_par_file<-'testprior_HH.par' ##Parameter file
ncore<-8
path_to_bayessc<-'./BayeSSC'


gen<-1 ##Number of years per generation
npod<-1000000 ## reference table / prior
species<-1:nspecies
prefix<-sub(".par",paste0("_",length(species),"sp_",nloci,"loci"),bayessc_par_file)
conf<-par_to_config(bayessc_par_file,species,nloci,gen)
#running ABC simulation
reference.table<-ABC_simulation_with_conf(npod=npod,conf=conf,time.range=time.range,buffer=buffer,concentrationscale=concentrationscale,concentrationShape=concentrationShape,BayeSSCallocation=path_to_bayessc,prefix=prefix,do.parallel=ncore,write.reference.file = T)
