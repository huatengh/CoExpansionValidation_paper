#Runs hBayeSSC for hypervariables
#Requires hBayeSSC.py (https://github.com/UH-Bioinformatics/hBayeSSC), BayeSSC (https://web.stanford.edu/group/hadlylab/ssc/), and testprior.par to be in folder
priorparfile<- "testprior.par" 
hBayeallocation<-"hBayeSSC.py"
BayeSSCallocation<-"./BayeSSC" 

obfolders<-list.files(path = '.',pattern = "\\w+_\\d+S\\d+L_\\w+_folder",recursive = T,include.dirs = T)
obfolder<-obfolders[1]
for(obfolder in obfolders){
  obsfiles<-list.files(path = obfolder,pattern = "\\w+_\\d+S\\d+L_\\w+_Rep\\d+_obs_file",include.dirs = T,full.names = T)
  obsfile<-obsfiles[1]
  for(obsfile in obsfiles){
    command=paste("python",hBayeallocation,"--mode=initial -p",priorparfile,"-i",obsfile, "-r 1 -m 0 -u",sub("obs_file","",obsfile), "-t 100:200 -b", BayeSSCallocation,"-o",obfolder,"--obs_stats")
    system(command)
    
    #read in the hyperstats
    #hyperstats<-read.table("hyperstats_observations.txt",sep="\t")
    file.rename(paste(obfolder,"/hyperstats_observations.txt",sep=''), sub("_obs_file","_hyperstat.txt",obsfile))
    
    #write.table(hyperstats,file=sub(".par",paste("_",spnum,"S",locinum,"L_reference_table.txt",sep=''),priorparfile),col.names = F,row.names = F,quote=F,sep="\t",append = T)
    
  }
}


