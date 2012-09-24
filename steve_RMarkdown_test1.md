AEC Data Analysis
========================================================

This is my first attempt at an R Markdown document. 

When you click the **Knit HTML** button a web page will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

## FUNC??

This code loads the relevant packages into R.


```r
## Enable required libraries
library(Hmisc)
```

```
## Loading required package: survival
```

```
## Loading required package: splines
```

```
## Hmisc library by Frank E Harrell Jr
## 
## Type library(help='Hmisc'), ?Overview, or ?Hmisc.Overview') to see overall
## documentation.
## 
## NOTE:Hmisc no longer redefines [.factor to drop unused levels when
## subsetting.  To get the old behavior of Hmisc type dropUnusedLevels().
```

```
## Attaching package: 'Hmisc'
```

```
## The following object(s) are masked from 'package:survival':
## 
## untangle.specials
```

```
## The following object(s) are masked from 'package:base':
## 
## format.pval, round.POSIXt, trunc.POSIXt, units
```

```r
library(foreign)
library(XML)
```


## LOAD

This code reads in the first set of data.


```r
## READ IN DATA

## FIRST PREFERENCE VOTES 2010 BY _Candidate_ CSV file Code from Simon
## Jackman - source is comments section of:
## http://jackman.stanford.edu/blog/?p=1760

## Define the location of the data (AEC website)
theURL <- "http://results.aec.gov.au/15508/Website/Downloads/HouseFirstPrefsByCandidateByVoteTypeDownload-15508.csv"

## Read in the data
First_Preferences_By_Candidate_By_Vote_Type <- read.csv(url(theURL), skip = 1, 
    header = TRUE, quote = "\"", stringsAsFactors = FALSE)

## READ IN DATA

## FIRST PREFERENCE VOTES 2010 BY _Candidate_ CSV file Code from Simon
## Jackman - source is comments section of:
## http://jackman.stanford.edu/blog/?p=1760

## Define the location of the data (AEC website)
theURL <- "http://results.aec.gov.au/15508/Website/Downloads/HouseFirstPrefsByCandidateByVoteTypeDownload-15508.csv"

## Vote counts occuring by type
vars <- c("OrdinaryVotes", "AbsentVotes", "ProvisionalVotes", "PrePollVotes", 
    "PostalVotes", "TotalVotes")

out <- NULL
for (v in vars) {
    theVar <- First_Preferences_By_Candidate_By_Vote_Type[, match(v, names(First_Preferences_By_Candidate_By_Vote_Type))]
    out <- cbind(out, tapply(theVar, First_Preferences_By_Candidate_By_Vote_Type$DivisionNm, 
        sum, na.rm = TRUE))
}

outvars <- c("OrdinaryVotes", "AbsentVotes", "ProvisionalVotes", "PrePollVotes", 
    "PostalVotes", "TotalVotes", "DivisionName")

z <- apply(out, 2, function(x) sum(x != 0))
names(z) <- vars
print(z)
```

```
##    OrdinaryVotes      AbsentVotes ProvisionalVotes     PrePollVotes 
##              150              150              150              150 
##      PostalVotes       TotalVotes 
##              150              150 
```

```r

## Swing against ALP candidates THIS CODE TO GENERATE SWING DOESNT WORK??
## swing <- aggregate(First_Preferences_By_Candidate_By_Vote_Type,
## list(Party = First_Preferences_By_Candidate_By_Vote_Type['PartyAb' =
## 'ALP']), mean) print(swing)

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
```

```
## outdf 
## 
##  7  Variables      150  Observations
## ---------------------------------------------------------------------------
## OrdinaryVotes 
##       n missing  unique    Mean     .05     .10     .25     .50     .75 
##     150       0     149   73852   61940   65536   69770   74234   78000 
##     .90     .95 
##   81693   83883 
## 
## lowest :  42257  47881  57272  57375  57801
## highest:  88520  89736  94172 103628 105358 
## ---------------------------------------------------------------------------
## AbsentVotes 
##       n missing  unique    Mean     .05     .10     .25     .50     .75 
##     150       0     149    4821    2561    3042    4108    4878    5761 
##     .90     .95 
##    6488    7078 
## 
## lowest :  791  924 1547 1688 1708, highest: 7279 7523 7618 7902 8826 
## ---------------------------------------------------------------------------
## ProvisionalVotes 
##       n missing  unique    Mean     .05     .10     .25     .50     .75 
##     150       0     114   248.9   118.5   143.9   171.5   229.0   299.5 
##     .90     .95 
##   402.4   446.2 
## 
## lowest :  77  81  84  99 101, highest: 512 522 609 615 656 
## ---------------------------------------------------------------------------
## PrePollVotes 
##       n missing  unique    Mean     .05     .10     .25     .50     .75 
##     150       0     150    3240    1768    1967    2466    3053    3791 
##     .90     .95 
##    4808    5206 
## 
## lowest : 1393 1653 1663 1668 1677, highest: 5663 5711 6174 6682 6745 
## ---------------------------------------------------------------------------
## PostalVotes 
##       n missing  unique    Mean     .05     .10     .25     .50     .75 
##     150       0     150    5383    3276    3529    4284    5166    6386 
##     .90     .95 
##    7216    7874 
## 
## lowest :  1242  2049  2736  2849  2921
## highest:  8267  8295  8471  9627 11118 
## ---------------------------------------------------------------------------
## TotalVotes 
##       n missing  unique    Mean     .05     .10     .25     .50     .75 
##     150       0     150   87544   75664   80588   84404   87798   91302 
##     .90     .95 
##   94484   97121 
## 
## lowest :  46409  53672  67294  67896  68216
## highest: 105033 109950 110052 116712 117911 
## ---------------------------------------------------------------------------
## DivisionName 
##       n missing  unique 
##     150       0     150 
## 
## lowest : Adelaide  Aston     Ballarat  Banks     Barker   
## highest: Wentworth Werriwa   Wide Bay  Wills     Wright    
## ---------------------------------------------------------------------------
```

```r

# Rename the data frame
jackman_votetype_by_division <- outdf
remove(outdf)
remove(out)
```


## DO

### Vote Distribution

Plot the vote distribution by division


```r
library(ggplot2)
qplot(jackman_votetype_by_division$TotalVotes, main = "Total Votes by Division, 2010 Federal Election", 
    xlab = "Total votes")
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust
## this.
```

![plot of chunk plotTest](figure/plotTest.png) 


## END

End of my first file

