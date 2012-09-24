<<<<<<< HEAD
=======
## Enable required libraries
library(Hmisc)

## READ IN DATA

## FIRST PREFERENCE VOTES 2010
>>>>>>> Export of COMBE work
## Define the location of the data (AEC website)
theURL <- "http://results.aec.gov.au/15508/Website/Downloads/HouseFirstPrefsByCandidateByVoteTypeDownload-15508.csv"

## Read in the data
voteType <- read.csv(url(theURL),
                     skip=1,
                     header=TRUE,
                     quote="\"",
                     stringsAsFactors=FALSE)

## Vote counts occuring by type
vars <- c("OrdinaryVotes","AbsentVotes","ProvisionalVotes",
          "PrePollVotes","PostalVotes","TotalVotes")

out <- NULL
for(v in vars){
  theVar <- voteType[,match(v,names(voteType))]
  out <- cbind(out,
               tapply(theVar,voteType$DivisionNm,sum,na.rm=TRUE))
}

<<<<<<< HEAD
outvars <-  c("DivisionNm","OrdinaryVotes","AbsentVotes","ProvisionalVotes",
              "PrePollVotes","PostalVotes","TotalVotes")
colnames(out) <- outvars

colnames(out)[1] <- "Division Name"
colnames(out)[2] <- "Ordinary Votes"
colnames(out)[3] <- "Absent Votes"
colnames(out)[4] <- "Provisional Votes"
colnames(out)[5] <- "PrePoll Votes"
colnames(out)[6] <- "Postal Votes"
colnames(out)[7] <- "Total Votes"

library(Hmisc)
describe(out)
=======
outvars <-  c("OrdinaryVotes","AbsentVotes","ProvisionalVotes",
              "PrePollVotes","PostalVotes","TotalVotes","DivisionName")
#
#describe(out)
>>>>>>> Export of COMBE work

z <- apply(out,2,function(x)sum(x!=0))
names(z) <- vars
print(z)

# Swing against ALP candidates 
swing <- aggregate(voteType, list(Party = voteType["PartyAb" = "ALP"]), mean)
print(swing)
<<<<<<< HEAD
=======

outdf <- as.data.frame(out)

# outdf$Division <- gsub("\\..*$","", row.names)
# Transform division from row.names to a variable 
# http://stackoverflow.com/questions/11427434/how-to-create-a-variable-of-rownames
outdf$Division = rownames(outdf)
rownames(outdf) = NULL

# Assign column (variable) names
colnames(outdf) <- outvars

# Describe the data
describe(outdf)


>>>>>>> Export of COMBE work
