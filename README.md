# Satellite-Complexity

# Table of Contents

1. [Introduction](#introduction)

2. [Dataset](#dataset)

<a name="introduction"></a> 
# Introduction

How do you estimate the cost a new, more complex version of an existing satellite? This is a very tricky thing to do for cost analysts, yet common enough to where a more objective means of estimating said cost from an increase in complexity would add more validity to our estimates. Typically, when estimating the first theoretical unit cost (T1) of this new complex satellite, an analyst will simply multiply the old T1 cost of the existing satellite by a *complexity factor*, which is derived by meeting with the Program Manager(s) and technical team to discuss an appropriate value. This way of doing business can be very subjective and prone to much uncertainty. Fortunately for me, one of my more clever colleagues devised a way to capture complexity for satellite payloads in a more objective manner using *hierarchical clustering*, a technique that I attempted to replicate to capture complexity at the bus level of the satellites my team and I were tasked to estimate.

<a name="dataset"></a> 
# Dataset

Unfortunately the data I used is proprietary, so placing it on a public repository would get me into trouble. Luckily, "fake" data can be replicated that will behave in a manner similar to the real thing. There will be some simplifications of course (e.g. no N/As, data pre-cleaned, and fewer variables used), however the code used is the same. Real results will also be presented towards the end with the names of the programs (i.e. data points) removed. 
