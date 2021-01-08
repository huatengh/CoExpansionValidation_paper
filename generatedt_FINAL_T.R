##Generates randomized times for three levels of synchrony (Con= 1 event, Par = 2 events, Dis = 3 events), 
##three sampling strategies (e.g. 6S10L = 6 species and 10 loci per species), and two different time ranges in years (Recent or Old)
##Events here are simulated to be 1N apart, where N=500000 and time ranges are: 0.2N-3.2N (100000-1600000) and 3.5N-6.5N (1750000-3250000)

uptime<-c(1600000,3250000) ##change to the upper limit of each time range
nrep<-100 ##change to the number of replicates to simulate
divmodel<-c("Con","Dis", "Par")
ss<-c("6S10L","60S1L", "12S5L")##change to test alternate sampling schemes 
time.range<-data.frame(div=rep(divmodel,2),time=rep(c("Recent","Old"),each=3),up=c(1600000,1600000,1600000,3250000,3250000,3250000),low=c(100000,100000,100000,1750000,1750000,1750000))##Change to upper and lower limits of time ranges


for (div in divmodel){
  for (s in ss){
    for(t in c("Recent","Old")){  
      output.filename<-paste(div,s,t,sep="_")
      output.filename<-paste(output.filename,".divtime",sep='')
      upbound<-time.range$up[time.range$div==div & time.range$time==t]
      lowerbound<-time.range$low[time.range$div==div & time.range$time==t]
      ncol<-as.integer(sub("(\\d+).*","\\1",s))
      nsample<-ncol
      
      if(div=="Con"){
        sampled.time<-sapply(1:nrep,function(i){
          h<-sample(x = lowerbound:upbound,replace = F,size = 1)})
        sampled.time<-matrix(rep(sampled.time,each=nsample),ncol = nsample,byrow = T)
      }else if(div=="Par"){
        sampled.time<-sapply(1:nrep,function(i){
          h<-sample(x = lowerbound:(upbound-1*500000),replace = F,size = 1)}) #change 500000 to initial effective population size
        sampled.time2<-sampled.time+1*500000 #change 500000 to initial effective population size
        sampled.time<-matrix(rep(sampled.time,each=floor(nsample/2)),nrow=nrep,byrow = T)
        sampled.time2<-matrix(rep(sampled.time2,each=nsample-floor(nsample/2)),nrow=nrep,byrow = T)
        sampled.time<-cbind(sampled.time,sampled.time2)
              }else if(div=="Dis"){
        sampled.time<-sapply(1:nrep,function(i){
          h<-sample(x = lowerbound:(upbound-2*500000),replace = F,size = 1)}) #change 500000 to initial effective population size
        sampled.time2<-sampled.time+1*500000 #change 500000 to initial effective population size
        sampled.time3<-sampled.time+2*500000 #change 500000 to initial effective population size
        sampled.time<-matrix(rep(sampled.time,each=floor(nsample/3)),nrow=nrep,byrow = T)
        sampled.time2<-matrix(rep(sampled.time2,each=floor(nsample/3)),nrow=nrep,byrow = T)
        sampled.time3<-matrix(rep(sampled.time3,each=floor(nsample/3)),nrow=nrep,byrow = T)
        sampled.time<-cbind(sampled.time,sampled.time2)
        sampled.time<-cbind(sampled.time,sampled.time3)       
      } 
      colnames(sampled.time)<-paste("SP",1:dim(sampled.time)[2],sep='')
      row.names(sampled.time)<-paste("Rep",1:dim(sampled.time)[1],sep='')
      write.table(sampled.time,file=output.filename,sep="\t",quote=F)
    }
  }
}

