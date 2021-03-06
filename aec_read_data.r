## Enable required libraries
library(Hmisc)
library(foreign)
library(XML)

## READ IN DATA

## FIRST PREFERENCE VOTES 2010 BY _Candidate_ CSV file
## Code from Simon Jackman - source is comments section of:
## http://jackman.stanford.edu/blog/?p=1760 

## Define the location of the data (AEC website)
theURL <- "http://results.aec.gov.au/15508/Website/Downloads/HouseFirstPrefsByCandidateByVoteTypeDownload-15508.csv"

## Read in the data
First_Preferences_By_Candidate_By_Vote_Type <- read.csv(url(theURL),
                     skip=1,
                     header=TRUE,
                     quote="\"",
                     stringsAsFactors=FALSE)

## Vote counts occuring by type
vars <- c("OrdinaryVotes","AbsentVotes","ProvisionalVotes",
          "PrePollVotes","PostalVotes","TotalVotes")

out <- NULL
for(v in vars){
  theVar <- First_Preferences_By_Candidate_By_Vote_Type[,match(v,names(First_Preferences_By_Candidate_By_Vote_Type))]
  out <- cbind(out,
               tapply(theVar,First_Preferences_By_Candidate_By_Vote_Type$DivisionNm,sum,na.rm=TRUE))
}

outvars <-  c("OrdinaryVotes","AbsentVotes","ProvisionalVotes",
              "PrePollVotes","PostalVotes","TotalVotes","DivisionName")

z <- apply(out,2,function(x)sum(x!=0))
names(z) <- vars
print(z)

## Swing against ALP candidates 
## THIS CODE TO GENERATE SWING DOESNT WORK??
#swing <- aggregate(First_Preferences_By_Candidate_By_Vote_Type, list(Party = First_Preferences_By_Candidate_By_Vote_Type["PartyAb" = "ALP"]), mean)
#print(swing)

# Convert out data matrix to a data frame
outdf <- as.data.frame(out)

# Transform division from row.names to a variable 
# http://stackoverflow.com/questions/11427434/how-to-create-a-variable-of-rownames
outdf$Division = rownames(outdf)
rownames(outdf) = NULL

# Assign column (variable) names
colnames(outdf) <- outvars

# Describe the data
describe(outdf)

# Rename the data frame
jackman_votetype_by_division <- outdf
remove(outdf)
remove(out)

## FILE TWO
## FIRST PREFERENCE RESULTS BY _Division_ - HTML table

# IF REQUIRED:
# remove(HouseFirstPrefsTppByDivision)
## READ IN DATA - NOTE StringsAsFactors - False to avoid FACTOR problems
HouseFirstPrefsTppByDivision <- readHTMLTable("http://results.aec.gov.au/15508/Website/HouseFirstPrefsTppByDivision-15508-NAT.htm",
                            header = c("Division","State","ALP_1Prf","LP_1Pref","LNQ_1Pref","GRN_1Pref","NP_1Pref","OTH_1Pref","ALP_2PP","LNP_2PP"),
                            skip.rows=c(1,2), trim=TRUE, as.data.frame=TRUE, which=5, stringsAsFactors=FALSE)

# Describe the data
describe(HouseFirstPrefsTppByDivision)

# Apply variable names to columns
HouseFirstPrefsTppByDivision_varnames <-  c("Division","State","ALP_1Prf","LP_1Pref","LNQ_1Pref","GRN_1Pref","NP_1Pref","OTH_1Pref","ALP_2PP","LNP_2PP")
colnames(HouseFirstPrefsTppByDivision) <- HouseFirstPrefsTppByDivision_varnames

##UPTOHERE
# Recode values of NATIONAL TOTAL due to missing State value
# select rows where v1 is 99 and recode column v1 

HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","State"] <- "National"
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","ALP_1Prf"] <- 37.99
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","LP_1Pref"] <- 30.46
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","LNQ_1Pref"] <- 9.12
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","GRN_1Pref"] <- 11.76
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","NP_1Pref"] <- 3.73
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","OTH_1Pref"] <- 6.94
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","ALP_2PP"] <- 50.12
HouseFirstPrefsTppByDivision[HouseFirstPrefsTppByDivision$Division=="National Total","LNP_2PP"] <- 49.88

#CHECK CHANGES APPLIED CORRECTLY
#VALUES: National Total [STATE]  37.99  30.46  9.12  11.76  3.73  6.94  50.12  49.88
tail(HouseFirstPrefsTppByDivision)

#CREATE A State FACTOR VARIABLE
HouseFirstPrefsTppByDivision$State_factor <- as.factor(HouseFirstPrefsTppByDivision$State)

#RENAME THE DIVISION VARIABLE (FOR FILE MERGING)
HouseFirstPrefsTppByDivision$DivisionNm <- as.character(HouseFirstPrefsTppByDivision$Division)
HouseFirstPrefsTppByDivision$Division <- NULL


## FILE THREE - HOUSE VOTES COUNTED BY DIVISION

## Define the location of the data (AEC website)
theURL <- "http://results.aec.gov.au/15508/Website/Downloads/HouseVotesCountedByDivisionDownload-15508.csv"

## Read in the data
HouseVotesCountedByDivision <- read.csv(url(theURL),
                               skip=1,
                               header=TRUE,
                               quote="\"",
                               stringsAsFactors=FALSE)

## 

