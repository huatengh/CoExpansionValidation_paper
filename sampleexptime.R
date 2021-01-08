sampleexptime<-function(timerange,n,alpha,buffer){
  #assigning n to events
  divevent<-list()
  divevent[[1]]<-c(1)
  n.event<-rep(1,n)
  for(v in 2:n){
    prob<-unlist(lapply(divevent, function(x){length(x)/(alpha+v-1)}))
    prob<-c(prob,alpha/(alpha+v-1))
    cumprob<-cumsum(prob)
    draw<-runif(1,min=0,max=cumprob[length(cumprob)])
    eventnum<-min(which(cumprob>draw))
    if(eventnum>length(divevent)){
      divevent[[eventnum]]<-c(v)
    }else{
      divevent[[eventnum]]<-c(divevent[[eventnum]],v)
    }
    n.event[v]<-eventnum
  }
  divtime<-rep(0,length(divevent))
  divtime[1]<-sample(timerange[1]:timerange[2],size = 1)
  bufferzone<-matrix(c(divtime[1]-buffer,divtime[1]+buffer),nrow = 1)
  for(i in 2:length(divevent)){
    bufferzone[bufferzone<timerange[1]]<-timerange[1]
    bufferzone[bufferzone>timerange[2]]<-timerange[2]
    timelength<-timerange[2]-timerange[1]-sum(bufferzone[,2]-bufferzone[,1])
    dt<-sample(timerange[1]:(timerange[1]+timelength),size = 1)
    j<-1
    while(dt>bufferzone[j,1]){
      dt<-dt+bufferzone[j,2]-bufferzone[j,1]
      j<-j+1
      if(j>dim(bufferzone)[1])break
    }
    divtime[i]<-dt
    bufferzone<-rbind(bufferzone,c(dt-buffer,dt+buffer))
    bufferzone[bufferzone<timerange[1]]<-timerange[1]
    bufferzone[bufferzone>timerange[2]]<-timerange[2]
    bufferzone<-bufferzone[order(bufferzone[,1],bufferzone[,2]),]
    newbufferzone<-bufferzone[1,,drop=F]
    for(j in 2:dim(bufferzone)[1]){
      k<-dim(newbufferzone)[1]
      if((newbufferzone[k,2]-bufferzone[j,1])*(bufferzone[j,2]-newbufferzone[k,1])>0){
        newbufferzone[k,1]<-min(newbufferzone[k,1],bufferzone[j,1])
        newbufferzone[k,2]<-max(newbufferzone[k,2],bufferzone[j,2])
      }else{
        newbufferzone<-rbind(newbufferzone,bufferzone[j,])
      }
      j<-j+1
    }
    bufferzone<-newbufferzone
  }
  return(divtime[n.event])
}
