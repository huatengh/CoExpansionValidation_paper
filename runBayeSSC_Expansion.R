dir<- setwd("./")

timefile <- list.files(, pattern = '*.divtime');
templateparfile<- scan(file = "BayeSSCtemplate.par",what = 'character',sep = "\n")

#figure out the expansion time and number of loci

for (i in 1:length(timefile)){
nsp<-as.numeric(sub(".*_(\\d+)S.*","\\1",timefile[i]))
nloci<-as.numeric(sub(".*S(\\d+)L.*","\\1",timefile[i]))
sampled.time<-read.table(timefile[i],row.names = 1,header=T,sep="\t")
for (ind in 1:length(unlist(sampled.time))){
  nrow<- (ind-1) %/% nsp +1
  ncol<- (ind-1) %% nsp+1
  divtime<-sampled.time[nrow,ncol]
  repname<-row.names(sampled.time)[nrow]
  spname<-colnames(sampled.time)[ncol]
  
  #read in the template file
  #change the historical event
  lline<-grep("1 historical event",templateparfile)
  templateparfile[lline+1]<-sub("^\\d+(.*)$","\\1",templateparfile[lline+1])
  templateparfile[lline+1]<-paste(divtime,templateparfile[lline+1],sep='')

  outparfilename<-sub(".divtime", paste("_",repname,"_",spname,".par",sep=''),timefile[i])
  dir_name<-sub(".divtime",paste("_",repname,"_",spname,sep=''),timefile[i])
  dir.create(dir_name)
    
  #write the par file 
  sink(outparfilename)
    for(n in templateparfile){
    cat(n,"\n",sep='')
    }
    sink()

  file.copy(from= paste(dir,"/","BayeSSC", sep=""), to=paste(dir,"/",dir_name,  sep="") )
  file.copy(from= paste(dir,"/",outparfilename, sep=""), to=paste(dir,"/",dir_name,  sep="") )
  file.remove(outparfilename)

  setwd(paste(dir,"/",dir_name, sep=""))
  
  BayeSSCallocation<-"./BayeSSC"
  #run BayeSSC
  #BayeSSC command is
  #BayeSSC -a -p -f [outparfilename] [# sims]
  command<-paste(BayeSSCallocation,"-a -p -f", outparfilename,nloci, sep=' ')
  system(command)
  setwd(dir)
  
  dir_name2<-sub(".divtime",paste("_","folder",sep=''),timefile[i])
  dir.create(dir_name2)
  file.copy(from= paste(dir,"/",dir_name, sep=""), to=paste(dir,"/",dir_name2,  sep=""), recursive=TRUE )
  unlink(dir_name, recursive = TRUE)
  
  }
}



  





