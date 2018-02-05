# Title     : TODO
# Objective : TODO
# Created by: peterli
# Created on: 2/2/2018

library(plotly)
library(stargazer)

# Reading data from GigaScience tab delimited file will fail
data2012 <- read.table("data/wos/savedrecs_2012.txt", sep="\t", stringsAsFactors=FALSE)
# Converted all data/wos/savedrecs_201*.txt into CSV files using Excel

# Try read data again
data2012 <- read.csv("data/wos/savedrecs_2012.csv", sep=",", stringsAsFactors=FALSE)
data2013 <- read.csv("data/wos/savedrecs_2013.csv", sep=",", stringsAsFactors=FALSE)
data2014 <- read.csv("data/wos/savedrecs_2014.csv", sep=",", stringsAsFactors=FALSE)
data2015 <- read.csv("data/wos/savedrecs_2015.csv", sep=",", stringsAsFactors=FALSE)
data2016 <- read.csv("data/wos/savedrecs_2016.csv", sep=",", stringsAsFactors=FALSE)
data2017 <- read.csv("data/wos/savedrecs_2017.csv", sep=",", stringsAsFactors=FALSE)

# Combine data
alldata <- rbind(data2012, data2013, data2014, data2015, data2016, data2017)

# Number of papers
nrow(alldata)
[1] 1551

# Remove Correction articles
alldata <- alldata[!grepl("Correction", alldata$DT), ]

# Number of papers after collection articles removed
nrow(alldata)
[1] 1541
# 10 correction articles

# Get number of BGI papers per year
papers_per_year <- alldata$PY
papers_per_year <- table(papers_per_year)
# Convert to data frame
papers_per_year <- as.data.frame(papers_per_year)
years <- papers_per_year[,1]
papers_per_year <- papers_per_year[,2]

# Get number of papers published in gigascience
giga_bgi_idx <- grep("GIGASCIENCE", alldata$SO, ignore.case = TRUE)
# Select these GIGASCIENCE rows
giga_bgi_papers <- subset(alldata[giga_bgi_idx, ], )
# Get number of GIGASCIENCE papers per year
num_gigasci_pub_per_year <- giga_bgi_papers$PY
num_gigasci_pub_per_year <- table(num_gigasci_pub_per_year)
# Convert to data frame
num_gigasci_pub_per_year <- as.data.frame(num_gigasci_pub_per_year)
num_gigasci_pub_per_year <- num_gigasci_pub_per_year[,2]

# Visualise results
data <- data.frame(years, num_gigasci_pub_per_year, papers_per_year)
p <- plot_ly(data,
x = ~years,
y = ~num_gigasci_pub_per_year,
type = 'bar',
text = num_gigasci_pub_per_year, textposition = 'auto',
name = 'Published in GigaScience ') %>%
add_trace(y = ~papers_per_year,
text = papers_per_year, textposition = 'auto',
name = 'Published in other journals') %>%
layout(title = "Number of papers published by BGI",
xaxis = list(title = "Year"),
yaxis = list(title = 'No. papers'),
barmode = 'stack')

####

# Read in citation data
bgicitation2012 <- read.table("data/wos/savedrecs_2012_citation_report.txt", sep=",", skip=4, stringsAsFactors=FALSE)
bgicitation2013 <- read.table("data/wos/savedrecs_2013_citation_report.txt", sep=",", skip=4, stringsAsFactors=FALSE)
bgicitation2014 <- read.table("data/wos/savedrecs_2014_citation_report.txt", sep=",", skip=4, stringsAsFactors=FALSE)
bgicitation2015 <- read.table("data/wos/savedrecs_2015_citation_report.txt", sep=",", skip=4, stringsAsFactors=FALSE)
bgicitation2016 <- read.table("data/wos/savedrecs_2016_citation_report.txt", sep=",", skip=4, stringsAsFactors=FALSE)
bgicitation2017 <- read.table("data/wos/savedrecs_2017_citation_report.txt", sep=",", skip=4, stringsAsFactors=FALSE)

# Tidy up column names
colnames(gigac) <- gigac[1, ]
gigac <- gigac[-c(1),]

# Get top 10 most cited papers in GigaScience
top10_mostcited <- subset(gigac[1:10,], select=c("Title", "Authors", "Publication Year", "Total Citations", "Average per Year"))
# Shorten authors to first author
first_authors <- top10_mostcited$Authors
first_authors <- sapply(strsplit(first_authors, ";"), "[", 1)
top10_mostcited$Authors <- first_authors
colnames(top10_mostcited) <- c("Title", "First Author", "Publication Year", "Total Citations", "Average per Year")

# Display
stargazer(top10_mostcited, type = "html", summary = FALSE, rownames = FALSE)

####

# Get top 10 most cited papers in GigaScience with BGI author list
# Need to get hold of DOIs from BGI papers
giga_bgi_papers$DI

top10_BGI_mostcited <- subset(gigac[1:10,], select=c("Title", "Authors", "Publication Year", "Total Citations", "Average per Year"))
# Shorten authors to first author
first_authors <- top10_mostcited$Authors
first_authors <- sapply(strsplit(first_authors, ";"), "[", 1)
top10_mostcited$Authors <- first_authors
colnames(top10_mostcited) <- c("Title", "First Author", "Publication Year", "Total Citations", "Average per Year")

# Display
stargazer(top10_mostcited, type = "html", summary = FALSE, rownames = FALSE)

