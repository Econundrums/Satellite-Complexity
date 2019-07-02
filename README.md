# Satellite-Complexity

# Table of Contents

1. [Introduction](#introduction)

2. [Dataset](#dataset)

3. [Analysis](#analysis)

    i. [Disparity Matrix & Linking Algorithm](#disparity&link)

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
<a name="analysis"></a> 
# Analysis

<a name="disparity&link"></a> 
## Disparity Matrix & Linking Algorithm



