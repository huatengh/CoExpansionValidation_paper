###Extract *_hyperstat.txt from each folder (100 replicates for every species) within *_folder
### ./msReject Con_5S10L_Recent_Rep1_hyperstat.txt testprior_5S10L_reference_table_Recent.txt 0.1 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 > Posterior
### Rename Posterior
###Change sampling tolerance in line 16 (here we use 0.005) 
MsRejectallocation<-"./msReject"
timefile <- list.files(path=".", pattern = '*_hyperstat.txt');

hsfolders<-list.files(path = '.',pattern = "\\w+_\\d+S\\d+L_\\w+_folder",recursive = T,include.dirs = T)
hsfolder<-hsfolders[1]
for(hsfolder in hsfolders){
  hsfiles<-list.files(path = hsfolder,pattern = "\\w+_\\d+S\\d+L_\\w+_Rep\\d+_hyperstat.txt",include.dirs = T,full.names = T)
  hsfile<-hsfiles[1]
  reffile<-sub("\\w+_(\\d+S\\d+L)_(\\w+)_folder","\\2_\\1_reference_table.txt",hsfolder)
  for(hsfile in hsfiles){
    outposteriorname<-sub("hyperstat.txt","Posterior",hsfile)
    command<-paste(MsRejectallocation,hsfile,reffile, "0.005 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 > ", outposteriorname, sep=' ')
    system(command)
  }
}
