#Generate prior
#Requires hBayeSSC.py (https://github.com/UH-Bioinformatics/hBayeSSC), BayeSSC (https://web.stanford.edu/group/hadlylab/ssc/), sampleexptime.R and testprior.par to be in folder
#Change numbers in lines 74-80, 128, & 130 to match empirical data to be simulated, see https://github.com/UH-Bioinformatics/hBayeSSC for descriptions
#run as Rscript --vanilla PODsimulation_expansion.R [speciesnumber] [locinumber][concentrationprior][buffer][rep] [hbayeSCCpriorparfile] [bayeSCClocation][hbayeSSClocation]
#example: Rscript --vanilla PODsimulation_expansion.R 10 5 3.3 1000 4 testprior.par
library(stringr)
source("sampleexptime.R")
args = commandArgs(trailingOnly=TRUE)

priorparfile='testprior.par'
BayeSSCallocation<-"./BayeSSC"
hBayeallocation<-"hBayeSSC.py"

spnum=as.integer(args[1])
locinum=as.integer(args[2])
alpha=as.numeric(args[3])
buffer=as.integer(args[4])
repn=as.integer(args[5])
priorparfile=args[6]
if(! is.na(args[7])){BayeSSCallocation<-args[7]}
if(! is.na(args[8])){hBayeallocation<-args[8]}

#read prior par and get the range of expansion time and the population size
priorpar<- scan(file = priorparfile,what = 'character',sep = "\n")
#get the historical event time range
lline<-grep("1 historical event",priorpar)
line<-sub("^\\{U:(\\d+),(\\d+).+","\\1 \\2",priorpar[lline+1],perl=T)
timerange<-as.numeric(unlist(str_split(line, ' ')))

#get the population size time range
lline<-grep("Population sizes",priorpar)
line<-sub("^\\{U:(\\d+),(\\d+).+","\\1 \\2",priorpar[lline+1],perl=T)
poprange<-as.numeric(unlist(str_split(line, ' ')))

runbayeSCC<-function(BayeSSCallocation, parfile,nloci){
  command<-paste(BayeSSCallocation,"-f",parfile,nloci, sep=' ')
  system(command)
}
write.parfile<-function(temppar,popsize,time,outfile){
  lline<-grep("1 historical event",temppar)
  temppar[lline+1]<-sub("^\\{U:(\\d+),(\\d+)}",time,temppar[lline+1],perl=T)
  
  #get the population size time range
  lline<-grep("Population sizes",temppar)
  temppar[lline+1]<-sub("^\\{U:(\\d+),(\\d+)}",popsize,temppar[lline+1],perl=T)
  sink(outfile)
  cat(temppar,sep = '\n')
  sink()
  
}

popsizes<-sample(x=poprange[1]:poprange[2],size = spnum,replace = T)

histtime<-sampleexptime(timerange = timerange,n=spnum,alpha = alpha,buffer=buffer)
cat(histtime)

model<-length(unique(histtime))
datalist<-list()
for(i in 1:length(popsizes)){
  outparfile<-sub(".par$",paste("_",spnum,"S",locinum,"L_M",model,"_Rep",repn,".par",sep=''),priorparfile)
  write.parfile(priorpar,popsizes[i],histtime[i],outparfile)
  runbayeSCC(BayeSSCallocation = BayeSSCallocation,parfile = outparfile,nloci = locinum)
  datalist[[i]]<-read.csv(sub(".par","_stat.csv",outparfile),header = T)
}
#get all files together

myfulldata <- do.call("rbind", datalist)
# building the obs file  
temp_matrix<-  matrix(0,nrow = dim(myfulldata)[1], ncol = 16)
colnames(temp_matrix)<- c("species", "nsam", "nsites", "tstv", "gamma", "gen", "locuslow","locushigh",
                          "Nelow","Nehigh", "SegSites", "nucdiv", "Haptypes", "HapDiver", "TajimasD", "F*" )
temp_matrix[1: dim(myfulldata)[1],"species"] <- 
  paste("SP", rep(1:spnum,each=locinum),"L",rep(1:locinum,times=spnum),sep='')
temp_matrix[1: dim(myfulldata)[1],"nsam"] <- rep(40,dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"nsites"] <- rep(800,dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"gen"] <- rep(1,dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"locuslow"] <- rep (0.00008, dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"locushigh"] <- rep (0.00008, dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"Nelow"] <- rep( 500000, dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"Nehigh"] <- rep( 500000, dim(myfulldata)[1])
temp_matrix[1: dim(myfulldata)[1],"SegSites"] <-myfulldata$SegSites
temp_matrix[1: dim(myfulldata)[1],"nucdiv"] <- myfulldata$NucltdDiv
temp_matrix[1: dim(myfulldata)[1],"Haptypes"] <- myfulldata$Haptypes
temp_matrix[1: dim(myfulldata)[1],"HapDiver"] <- myfulldata$HapDiver
temp_matrix[1: dim(myfulldata)[1],"TajimasD"] <- myfulldata$TajimasD
temp_matrix[1: dim(myfulldata)[1],"F*"] <- myfulldata$F.
list_dir<- dir(".",pattern = sub(".par","",outparfile))
unlink(list_dir)
write.table(temp_matrix, file= sub(".par",".obs",outparfile), quote= FALSE, sep = '\t',row.names=F)

#run hbayes for hypervariables
#python hBayeSSC.py --mode=initial -p testprior.par -i testprior_10S5L_M5_Rep4.obs -r 1 -m 0 -u test -t 100:200 -b ./BayeSSC --obs_stats

command=paste("python",hBayeallocation,"--mode=initial -p",priorparfile,"-i",sub(".par",".obs",outparfile), "-r 1 -m 0 -u",sub(".par","",outparfile), "-t 100:200 -b", BayeSSCallocation,"-o",sub(".par","",outparfile),"--obs_stats")
system(command)

#read in the hyperstats
hyperstats<-read.table(sub(".par","/hyperstats_observations.txt",outparfile),sep="\t")
names(hyperstats)<-c("uid",'congruent_group_size', 'total_observations', 'model_pct',
                     'congruent_time_Mean', 'congruent_time_Dispersion',
                     'random_time_Mean', 'random_time_Dispersion',
                     'overall_time_Mean', 'overall_time_Dispersion',
                     'ne_Mean', 'ne_Variance',
                     'expan_Mean', 'expan_Variance',
                     'mu_Mean', 'mu_Variance',
                     'haptypes_Mean', 'haptypes_Variance', 'haptypes_Skewness', 'haptypes_Kurtosis',
                     'hapdiv_Mean', 'hapdiv_Variance', 'hapdiv_Skewness', 'hapdiv_Kurtosis',
                     'nucdiv_Mean', 'nucdiv_Variance', 'nucdiv_Skewness', 'nucdiv_Kurtosis',
                     'tajimasd_Mean', 'tajimasd_Variance', 'tajimasd_Skewness', 'tajimasd_Kurtosis',
                     'fusf_Mean', 'fusf_Variance', 'fusf_Skewness', 'fusf_Kurtosis',	
                     'pairDiffs_Mean', 'pairDiffs_Variance', 'pairDiffs_Skewness', 'pairDiffs_Kurtosis',
                     'segsites_Mean', 'segsites_Variance', 'segsites_Skewness', 'segsites_Kurtosis')
hyperstats$uid<-sub(".par","",outparfile)
hyperstats$congruent_group_size<-model
hyperstats$total_observations<-spnum
hyperstats$model_pct<-model/spnum

  hyperstats$congruent_time_Mean<-NaN
  hyperstats$congruent_time_Dispersion<-NaN

  hyperstats$random_time_Mean<-NaN
  hyperstats$random_time_Dispersion<-NaN

hyperstats$overall_time_Mean<-mean(histtime)
hyperstats$overall_time_Dispersion<-sd(histtime)/mean(histtime)
hyperstats$ne_Mean<-mean(popsizes)
hyperstats$ne_Variance<-var(popsizes)
hyperstats$expan_Mean<-0.01
hyperstats$expan_Variance<-0
hyperstats$mu_Mean<-0.00008
hyperstats$mu_Variance<-0
write.table(hyperstats,file=sub(".par",paste("_",spnum,"S",locinum,"L_reference_table.txt",sep=''),priorparfile),col.names = F,row.names = F,quote=F,sep="\t",append = T)
unlink(sub(".par","",outparfile),recursive = T)
unlink(sub(".par",".obs",outparfile))

q('no')


