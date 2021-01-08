
## Requirements

 *  [BayeSSC - Serial Simcoal](http://www.stanford.edu/group/hadlylab/ssc/)   
 *  [Python 2.x](https://www.python.org/) >= 2.4   
 *  hBayeSSC.py (https://github.com/UH-Bioinformatics/hBayeSSC)
 *  [msReject]


## Files
~generatedt_FINAL_T.R
BayeSSCtemplate.par
~runBayeSSC_Expansion.R
~edit_bayeSSCfile.R
testprior.R
PODsimulation_expansion.R
sampleexptime.R
~runpodsimualtionew.R
~generatehyperstatsobs.R
~RunMsReject.R

##Usage

Generating Test Datasets: 

Change time ranges, and number of replicates (note it is set up for 3 sampling schemes, 3 levels of synchrony, and 2 time ranges) in "generatedt_FINAL_T.R"


~~Run "generatedt_FINAL_T.R" ### Generates randomized expansion times within a given time range and a set distance between co-expansions


Change parameters (e.g. number of individuals, population size, base pairs, mutation rate) in "BayeSSCtemplate.par" (first number under historical event is the time of the expansion and will be replaced. See http://www.stanford.edu/group/hadlylab/ssc/ for detailed description.


~~Run "runBayeSSC_Expansion.R" ### Generates genetic data (remove extra folders that do not contain test data in the same directory) 


Change parameters (e.g. number of individuals, time range, base pairs, mutation rate) in "edit_bayeSSCfile.R" 


~~Run "edit_bayeSSCfile.R" ### Pulls out summary statistics from folders to create the obs file


Generating Priors:

Change number of species (line 3), loci (line 4), number of replicates (line 5), gamma distribution of the concentration parameter (lines 6 & 7), and buffer (line 8)
in "runpodsimualtionew.R"

Change parameters and time range of prior in "testprior.R" 

Change numbers in "PODsimulation_expansion.R" lines 74-80, 128, & 137 to match empirical data to be simulated. See https://github.com/UH-Bioinformatics/hBayeSSC for descriptions.

	
~Run "runpodsimualtionew.R" ###Generates Reference table: Must have BayeSSC, hBayeSSC.py, "PODsimulation_expansion.R", "sampleexptime.R" and "testprior.par" in the folder


#Move reference table (prior) to same folder as test data from one time range and rename (e.g. Recent_6S10L_reference_table.txt)

~~Run "generatehyperstatsobs.R" ### Runs hBayes and generates hyperstatistics (Need to use different testpriors for Old or Recent, move to different folder)

Rejection: 

Change sampling tolerance in "RunMsReject.R". "msReject", reference table, and test data must be in the same folder. 

~~Run "RunMsReject.R" 

