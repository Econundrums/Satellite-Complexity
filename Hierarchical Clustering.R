## Note: This version is specifically for RStudio Cloud because the actual data is proprietary. 
## Also, rows 10 - 31 have been commented out because I will be using cleaned fake data.
## Also, note that the bottom code where "fviz_cluster()" starts is relative to the project/data
## you're using, so don't forget to change it as needed.

library(readxl)
library(tidyverse)
library(factoextra)
library(dendextend)
library(cluster)

Fake_Bus_Data = read_excel("Fake Bus Data.xlsx")

View(Fake_Bus_Data)

df = as.data.frame(Fake_Bus_Data)

# We're going to want the rows labeled by program name for our dendrogram charts later.

row.names(df) = df$program_name 
df$program_name = NULL

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

## Shuffles the data because clustering algorithms are 
## sensitive to the order of the data.

set.seed(1)
df = df[sample(nrow(df)), ]

View(df)

dfGower = daisy(df, metric = 'gower')

linkMethod = c("average", "single", "complete", "ward")

## Function to fetch agglomeration coefficients

ac = function(algorithm){agnes(dfGower, method = algorithm)$ac}
map_dbl(linkMethod, ac)

agnesCluster = agnes(dfGower, method = 'complete')
pltree(agnesCluster, cex = 0.7, main = "AGNES: Complete-Linkage")

diana(dfGower)$dc

dianaCluster = diana(dfGower)
pltree(dianaCluster, cex = 0.7, main = "DIANA")

agnesDendro = as.dendrogram(agnesCluster)
dianaDendro = as.dendrogram(dianaCluster)

tanglegram(agnesDendro, dianaDendro)
entanglement(agnesDendro, dianaDendro)

# tanglegram(agnesDendro, dianaDendro) %>% untangle(method = 'step1side') %>% entanglement

## For finding the optimal number of clusters

hcut_agnes = function(data, k){hcut(data, k, hc_method = "complete", 
                                    hc_func = "agnes")}
hcut_diana = function(data, k){hcut(data, k, hc_method = "complete", 
                                    hc_func = "diana")}

fviz_nbclust(as.matrix(dfGower), FUN = hcut_agnes, k.max = 20, nboot = 500, 
             method = "wss")
fviz_nbclust(as.matrix(dfGower), FUN = hcut_diana, k.max = 20, nboot = 500, 
             method = "wss")

fviz_nbclust(as.matrix(dfGower), FUN = hcut_agnes, k.max = 20, nboot = 500,
             method = "silhouette")
fviz_nbclust(as.matrix(dfGower), FUN = hcut_diana, k.max = 20, nboot = 500,
             method = "silhouette")

fviz_nbclust(as.matrix(dfGower), FUN = hcut_agnes, k.max = 20, nboot = 500,
             method = "gap_stat")
fviz_nbclust(as.matrix(dfGower), FUN = hcut_diana, k.max = 20, nboot = 500, 
             method = "gap_stat")

## The following code is relative to the data you're working with, so 
## don't forget to change it as needed! In this case, I'm analyzing
## the data using AGNES: Complete-Linkage.

clusters = hcut(as.matrix(dfGower), 4, hc_func = "agnes", 
                   hc_method = "complete")
 
fviz_cluster(clusters)

dfCat = data.frame('program_name' = clusters$order.lab,
                   'category' = clusters$cluster)
row.names(dfCat) = dfCat$program_name
dfCat$program_name = NULL

df2 = merge(df, dfCat, by = 'row.names')
row.names(df2) = df2$Row.names
df2$Row.names = NULL

df2$cat1 = ifelse(df2$category == 1, 1, 0)
df2$cat2 = ifelse(df2$category == 2, 1, 0)
df2$cat3 = ifelse(df2$category == 3, 1, 0)


df2$log_t1 = log(df2$t1_k)
df2$log_weight = log(df2$weight_lbs)

lmFit = lm(log_t1 ~ log_weight, data = df2)
summary(lmFit)

lmFit2 = lm(log_t1 ~ log_weight + cat1, data = df2)
summary(lmFit2)

lmFit3 = lm(log_t1 ~ log_weight + cat1 + cat2, data = df2)
summary(lmFit3)

lmFit4 = lm(log_t1 ~ log_weight + cat1 + cat2 + cat3, data = df2)
summary(lmFit4)
