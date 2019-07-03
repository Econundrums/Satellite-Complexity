# Satellite-Complexity

# Table of Contents

1. [Introduction](#introduction)

2. [Dataset](#dataset)

3. [Hierarchical Clustering](#hc)
    
    i. [AGNES](#agnes)
    
    ii. [DIANA](#diana)
    
    iii. [Comparisons](#comparisons)

<a name="introduction"></a> 
# Introduction

How do you estimate the cost a new, more complex version of an existing satellite? Typically, when estimating the first theoretical unit cost (T1), an analyst will simply multiply the old T1 cost of the existing satellite by a *complexity factor*, which is derived by meeting with the Program Manager(s) and technical team to discuss an appropriate value. This way of doing business can be very subjective and prone to much uncertainty. Fortunately for me, one of my more clever colleagues devised a way to capture complexity for satellite payloads in a more objective manner using *hierarchical clustering*, a technique that I attempted to replicate to capture complexity at the bus level of the satellites my team and I were tasked to estimate.

<a name="dataset"></a> 
# Dataset

The real data I used is proprietary, so I'm going to be using replicated "fake" data that will behave in a manner similar to the real thing. There will be some simplifications of course (e.g. no N/As, data pre-cleaned, and fewer variables used), however the code used is the same except for additional cleaning script that wouldn't be relevant for pre-cleaned data. Real results will also be presented towards the end with the names of the programs/datum points removed. 

For this analysis, the variables chosen to categorize satellites by complexity will be the following:

1. Orbit: There are two orbits listed: LEO and GEO (Low Earth Orbit and Geostationary Orbit, respectively). Satellites in LEO orbit     are more complex than ones in GEO because, since there are more of them in order to cover larger geographical areas, they require more ground antennas to have successful communicaiton operations. This can get expensive, especially when ground antennas need to be installed at varying elevations.

2. Mission Type: There are four mission types: Scientific, Experimental, Environmental, and Communications. Missions involving research (i.e. Scientific and sometimes Experimental) typically use more current technology in order to enhance performance and measurement accuracy. 

3. Bus Type: There are two bus types: Standard and Unique. Unique busses require more nonrecurring development in order to be able to perform more unique/specific mission CONOPs.  

4. Level of Protection: There are two levels of protection: Low and Medium. Satellites with higher levels of protection are thought to require more nonrecurring development in order to be able to enhance durability. 

5. Date Difference: This is a user created numerical variable that measures the number of days between when the satellites' contract was awarded to a vendor and the first launch date. The logic being that more complex satellites typically take longer to develop, as well as have delays in their program acquisition scheduling.

Now on to the actual code. First, fetch and organize the data (xlsx file).

```R

library(readxl)

Fake_Bus_Data = read_excel("Fake Bus Data.xlsx", sheet = "Fake Bus Data - For RStudio")

df = as.data.frame(Fake_Bus_Data)

# We're going to want the rows labeled by program name for our dendrogram charts later.

row.names(df) = df$`Variable ID` 

#The "for-loop" below runs through each column and sets each cell's value to either 
#"numeric" if the value checks out as a number, or a as a factor otherwise. For some 
#reason this was necessary to do because importing the data from Excel to R didn't carry
#over the proper categorization of the datum points.

for (i in 1:ncol(df)) {
    if(is.numeric(df[1,i]) == TRUE)
      df[,i] = as.numeric(df[,i])
    else
      df[,i] = as.factor(df[,i])
}


```
<a name="hc"></a> 
# Hierarchical Clustering

The first thing needed is to measure how similar/different each datum point is from the rest, which requires that a disparity matrix be generated using [Gower's distance](https://www.math.vu.nl/~sbhulai/papers/thesis-vandenhoven.pdf) to measure the disparity. This is trivial to do in R.

```R
library(cluster)
dfGower = daisy(df, metric = 'gower')
```

Now a clustering algorithm must be chosen; the two main types that will be used are *agglomerative* and *divisive* clustering, or AGNES and DIANA for short. Typically you want to use AGNES for finding smaller clusters and DIANA for larger ones, but for my purposes I'm going to look at both and compare.

<a name="agnes"></a> 
## AGNES

In a nutshell, AGNES works like this: It groups datum points most similar to each other into clusters, then it groups those clusters with other clusters most similar to each other, and so on until there are no more clusters to group. To do this, AGNES requires that you choose a *linking* algorithm to link datum points/clusters with other datum points/clusters. There are a few ways to do this, so it's best to try them all out and see which one is producing a stronger cluster structure as measured by the agglomeration coefficient (index between 0 - 1 with values closer to 1 indicating stronger cluster structures). 

```R
linkMethod = c("average", "single", "complete", "ward")

## Function to fetch agglomeration coefficients

ac = function(algorithm){agnes(dfGower, method = algorithm)$ac}
map_dbl(linkMethod, ac)

> [1] 0.9027225 0.8490075 0.9372001 0.9836746
```
[Ward's method](https://en.wikipedia.org/wiki/Ward%27s_method) does the best (it usually does), but you can see that all method's have good AC values, so in this case you should see very similar results no matter which method you use.



<a name="diana"></a> 
## DIANA

DIANA is very similar to AGNES, but the difference is DIANA is the inverse of AGNES: It starts off by having every datum point in a single cluster, then breaks the cluster into other clusters that are the most different from eachother, and so on until there are only individual datum points left.

<a name="comparisons"></a>
## Comparisons
