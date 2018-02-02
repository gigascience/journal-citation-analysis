# Title     : TODO
# Objective : TODO
# Created by: peterli
# Created on: 1/2/2018

library(plotly)
library(stargazer)

# Read in GigaScience tab delimited file
gigatags <- read.table("data/wos/savedrecs_gigascience_289all.txt", sep="\t", nrows=1, stringsAsFactors=FALSE)
# There are 68 cols
ncol(gigatags)
[1] 68

# Reading data from GigaScience tab delimited file will fail
giga <- read.table("data/wos/savedrecs_gigascience_289all.txt", sep="\t", nrows=1, skip=1, stringsAsFactors=FALSE)
# Converted data/wos/savedrecs_gigascience_289all.txt into CSV file using Excel

# Try read data again
giga <- read.csv("data/wos/savedrecs_gigascience_289all.csv", sep=",", stringsAsFactors=FALSE)
# Number of papers
nrow(giga)
[1] 289

# Remove Correction articles
giga <- giga[!grepl("Correction", giga$DT),]

# Number of papers published since 2012
nrow(giga)
[1] 278
# Therefore 11 correction articles

# Get total number of GigaScience papers per year
num_pub_per_year <- giga$PY
num_pub_per_year <- table(num_pub_per_year)
# Convert to data frame
num_pub_per_year <- as.data.frame(num_pub_per_year)
years <- num_pub_per_year[,1]
num_pub_per_year <- num_pub_per_year[,2]
# Update column names
#colnames(num_pub_per_year) <- c("Year", "No. publications")

# Get all BGI papers from GigaScience using "BGI" in author addresses
giga_bgi_idx <- grep("BGI", giga$C1, ignore.case = TRUE)
# Select these BGI rows from giga data
giga_bgi_papers <- subset(giga[giga_bgi_idx,],)
# Get number of BGI papers per year
num_BGI_pub_per_year <- giga_bgi_papers$PY
num_BGI_pub_per_year <- table(num_BGI_pub_per_year)
# Convert to data frame
num_BGI_pub_per_year <- as.data.frame(num_BGI_pub_per_year)
num_BGI_pub_per_year <- num_BGI_pub_per_year[,2]
# Update column names
#colnames(num_BGI_pub_per_year) <- c("Year", "No. publications")

# Get other papers in gigascience journal
giga_not_bgi_idx <- grep("BGI", giga$C1, ignore.case = TRUE, invert = TRUE)
# Select these not BGI rows from giga data
giga_not_bgi_papers <- subset(giga[giga_not_bgi_idx, ], )
# Get number of not BGI papers per year
num_not_BGI_pub_per_year <- giga_not_bgi_papers$PY
num_not_BGI_pub_per_year <- table(num_not_BGI_pub_per_year)
# Convert to data frame
num_not_BGI_pub_per_year <- as.data.frame(num_not_BGI_pub_per_year)
num_not_BGI_pub_per_year <- num_not_BGI_pub_per_year[,2]

# Visualise results
data <- data.frame(years, num_BGI_pub_per_year, num_not_BGI_pub_per_year)
p <- plot_ly(data,
x = ~years,
y = ~num_BGI_pub_per_year,
type = 'bar',
text = num_BGI_pub_per_year, textposition = 'auto',
name = 'BGI papers') %>%
add_trace(y = ~num_not_BGI_pub_per_year,
text = num_pub_per_year, textposition = 'auto',
name = 'Non-BGI papers') %>%
layout(title = "Number of papers published in GigaScience",
xaxis = list(title = "Year"),
yaxis = list(title = 'No. papers'),
barmode = 'stack')

####

# Read in citation data
gigac <- read.table("data/wos/savedrecs_gigascience_289all_citation_report.txt", sep=",", skip=3, stringsAsFactors=FALSE)
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
