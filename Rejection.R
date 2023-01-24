library(ade4)
library(adegenet)
library(poppr)
library(rmarkdown)
library(devtools)
library(readr)
library(CoExpansionValidation)

path_to_msreject<-"./msReject"
samplingtolerance<-0.005 
prefix<-'temp'

ref<-read.table("Prior.txt",header = TRUE,sep="\t") ###Read in Prior 
hs<-read.table("hyperstat_con",header=FALSE,sep="\t") ###Read in observed/test data
colnames(ref)<-c("uid","nevent","nspecies",paste0("species",1:hs$V3[1]),"haptypes_Mean", "haptypes_Variance", "haptypes_Skewness", "haptypes_Kurtosis", "hapdiv_Mean", "hapdiv_Variance", "hapdiv_Skewness", "hapdiv_Kurtosis", "nucdiv_Mean", "nucdiv_Variance", "nucdiv_Skewness", "nucdiv_Kurtosis", "tajimasD_Mean", "tajimasD_Variance", "tajimasD_Skewness", "tajimasD_Kurtosis", "fusf_Mean", "fusf_Variance", "fusf_Skewness", "fusf_Kurtosis", "pairDiffs_Mean", "pairDiffs_Variance", "pairDiffs_Skewness", "pairDiffs_Kurtosis", "segsites_Mean", "segsites_Variance", "segsites_Skewness", "segsites_Kurtosis")
colnames(hs)<-c("uid","nevent","nspecies", "haptypes_Mean", "haptypes_Variance", "haptypes_Skewness", "haptypes_Kurtosis", "hapdiv_Mean", "hapdiv_Variance", "hapdiv_Skewness", "hapdiv_Kurtosis", "nucdiv_Mean", "nucdiv_Variance", "nucdiv_Skewness", "nucdiv_Kurtosis", "tajimasD_Mean", "tajimasD_Variance", "tajimasD_Skewness", "tajimasD_Kurtosis", "fusf_Mean", "fusf_Variance", "fusf_Skewness", "fusf_Kurtosis", "pairDiffs_Mean", "pairDiffs_Variance", "pairDiffs_Skewness", "pairDiffs_Kurtosis", "segsites_Mean", "segsites_Variance", "segsites_Skewness", "segsites_Kurtosis")

for (i in 1:dim(hs)[1]){
  path_to_msreject<-"./msReject"
  samplingtolerance<-0.005 
  prefix<-paste0('temp',i)#edit it to save one file for each line of the hyperstat
  run_msreject(hyperstat=hs[i,,drop=F],reference.table=ref,MsRejectallocation=path_to_msreject,samplingtolerance=samplingtolerance,prefix=prefix)
}








