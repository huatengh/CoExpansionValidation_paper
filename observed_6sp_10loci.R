library(CoExpansionValidation)
options(stringsAsFactors = F)
nspecies<-6 ##Number of species
nloci<-10 ##Number of Loci
coevents<-1 ##Number of co-expansion events
buffer<-10000 ##Buffer between events
time.range<-c(20000,320000) ##Time range
bayessc_par_file<-'testprior_HH.par'
path_to_bayessc<-'./BayeSSC'


gen<-1 ##Years per generation
nrep<-100 ##Number of observed datasets to generate
species<-1:nspecies
outfile<-sub(".par","_obs_hyperstat_file",bayessc_par_file)
if(file.exists(outfile)) {unlink(outfile)};
conf<-par_to_config(bayessc_par_file,species,nloci,gen)

for(rep in 1:nrep){
  species.assignment<-assign_species_to_events(species = species,nco.events = coevents,even = T)
  exp.time<-generate_cotime_with_buffer(time.range = time.range,nco.events =coevents,buffer =  buffer)
  x<-species_exp_time(species.assignment,exp.time)
  prefix<-sub(".par",paste0("_",length(species),"sp_",nloci,"loci"),bayessc_par_file)
  simulatedobs<-runbayeSSC_with_conf(BayeSSCallocation = path_to_bayessc,conf = conf,prefix = paste0("tempobserved_",prefix,"rep",rep),species.assignment = species.assignment,exp.time = exp.time)
  hyperstat<-calculate_hyperstat(simulatedobs)
  a<-rep(0,3)
  a[1]<-paste0('rep',rep) #or any name you want to give to this pseudo-observed dataset
  a[2]<-length(exp.time) #true number of events
  a[3]<-length(species) #total number of species
  names(a)<-c("uid","nevent","nspecies")
  species.time<-species_exp_time(species.assignment = species.assignment,exp.time = exp.time)
  a<-c(a,species.time)
  hyperstat<-c(a,hyperstat)
  #write the hyperstat to a file

  cat(paste(hyperstat,sep='',collapse = "\t"),"\n",sep='',file = outfile,append = T)
}
