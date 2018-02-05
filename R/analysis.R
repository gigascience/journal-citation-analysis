# Title     : TODO
# Objective : TODO
# Created by: peterli
# Created on: 1/2/2018

library(plotly)
library(stargazer)

library(dplyr)  # For color???

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

# Get total article types in GigaScience
reviews <- giga[which(giga$DT=="Review"), ]
datanotes <- giga[which(giga$DT=="Article; Data Paper"), ]
articles <- giga[which(giga$DT=="Article"), ]
commentaries <- giga[which(giga$DT=="Editorial Material"), ]

# Display
x <- c('Commentaries', 'Articles', 'Data Notes', 'Reviews')
y <- c(nrow(commentaries), nrow(articles), nrow(datanotes), nrow(reviews))
text <- c('', '', '')
data <- data.frame(x, y, text)

p <- plot_ly(data, x = ~x, y = ~y, type = 'bar',
text = y, textposition = 'auto',
marker = list(color = 'rgb(114,147,203)',
line = list(color = 'rgb(114,147,203)', width = 1.5))) %>%
layout(title = "Number of types of articles published in GigaScience",
xaxis = list(title = ""),
yaxis = list(title = ""))

####

# Get article types per year in GigaScience
articles2012 <- giga[which(giga$DT=="Article" & giga$PY=="2012"), ]
articles2013 <- giga[which(giga$DT=="Article" & giga$PY=="2013"), ]
articles2014 <- giga[which(giga$DT=="Article" & giga$PY=="2014"), ]
articles2015 <- giga[which(giga$DT=="Article" & giga$PY=="2015"), ]
articles2016 <- giga[which(giga$DT=="Article" & giga$PY=="2016"), ]
articles2017 <- giga[which(giga$DT=="Article" & giga$PY=="2017"), ]
articles <- c(nrow(articles2012), nrow(articles2013), nrow(articles2014), nrow(articles2015), nrow(articles2016), nrow(articles2017))

commentaries2012 <- giga[which(giga$DT=="Editorial Material" & giga$PY=="2012"), ]
commentaries2013 <- giga[which(giga$DT=="Editorial Material" & giga$PY=="2013"), ]
commentaries2014 <- giga[which(giga$DT=="Editorial Material" & giga$PY=="2014"), ]
commentaries2015 <- giga[which(giga$DT=="Editorial Material" & giga$PY=="2015"), ]
commentaries2016 <- giga[which(giga$DT=="Editorial Material" & giga$PY=="2016"), ]
commentaries2017 <- giga[which(giga$DT=="Editorial Material" & giga$PY=="2017"), ]
commentaries <- c(nrow(commentaries2012), nrow(commentaries2013), nrow(commentaries2014), nrow(commentaries2015), nrow(commentaries2016), nrow(commentaries2017))

datanotes2012 <- giga[which(giga$DT=="Article; Data Paper" & giga$PY=="2012"), ]
datanotes2013 <- giga[which(giga$DT=="Article; Data Paper" & giga$PY=="2013"), ]
datanotes2014 <- giga[which(giga$DT=="Article; Data Paper" & giga$PY=="2014"), ]
datanotes2015 <- giga[which(giga$DT=="Article; Data Paper" & giga$PY=="2015"), ]
datanotes2016 <- giga[which(giga$DT=="Article; Data Paper" & giga$PY=="2016"), ]
datanotes2017 <- giga[which(giga$DT=="Article; Data Paper" & giga$PY=="2017"), ]
datanotes <- c(nrow(datanotes2012), nrow(datanotes2013), nrow(datanotes2014), nrow(datanotes2015), nrow(datanotes2016), nrow(datanotes2017))

reviews2012 <- giga[which(giga$DT=="Review" & giga$PY=="2012"), ]
reviews2013 <- giga[which(giga$DT=="Review" & giga$PY=="2013"), ]
reviews2014 <- giga[which(giga$DT=="Review" & giga$PY=="2014"), ]
reviews2015 <- giga[which(giga$DT=="Review" & giga$PY=="2015"), ]
reviews2016 <- giga[which(giga$DT=="Review" & giga$PY=="2016"), ]
reviews2017 <- giga[which(giga$DT=="Review" & giga$PY=="2017"), ]
reviews <- c(nrow(reviews2012), nrow(reviews2013), nrow(reviews2014), nrow(reviews2015), nrow(reviews2016), nrow(reviews2017))


# Display
x <- c('2012', '2013', '2014', '2015', '2016', '2017')
y1 <- articles
y2 <- commentaries
y3 <- datanotes
y4 <- reviews
# text <- c('', '', '')
data <- data.frame(x, y1, y2, y3, y4)

p <- data %>%
plot_ly() %>%
add_trace(x = ~x, y = ~y1, type = 'bar',
text = y1, textposition = 'auto',
marker = list(color = 'rgb(114,147,203)',
line = list(color = 'rgb(114,147,203)', width = 1.5)),
name = 'Articles') %>%
add_trace(x = ~x, y = ~y2, type = 'bar',
text = y2, textposition = 'auto',
marker = list(color = 'rgb(225,151,76)',
line = list(color = 'rgb(225,151,76)', width = 1.5)),
name = 'Commentaries') %>%
add_trace(x = ~x, y = ~y3, type = 'bar',
text = y3, textposition = 'auto',
marker = list(color = 'rgb(132,186,91)',
line = list(color = 'rgb(132,186,91)', width = 1.5)),
name = 'Data Notes') %>%
add_trace(x = ~x, y = ~y4, type = 'bar',
text = y4, textposition = 'auto',
marker = list(color = 'rgb(211,94,96)',
line = list(color = 'rgb(211,94,96)', width = 1.5)),
name = 'Reviews') %>%
layout(title = "Types of articles published per year in GigaScience",
barmode = 'group',
xaxis = list(title = "Year"),
yaxis = list(title = "Number of articles"))

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

####

# Citation statistics for BGI papers published in GigaScience

# Get DOIs for BGI papers
giga <- read.csv("data/wos/savedrecs_gigascience_289all.csv", sep=",", stringsAsFactors=FALSE)
# Remove Correction articles
giga <- giga[!grepl("Correction", giga$DT),]
# Get all BGI papers from GigaScience using "BGI" in author addresses
giga_bgi_idx <- grep("BGI", giga$C1, ignore.case = TRUE)
# Select these BGI rows from giga data
giga_bgi_papers <- subset(giga[giga_bgi_idx,],)

bgi_dois <- giga_bgi_papers$DI
length(bgi_dois)
# Remove values which are empty strings
bgi_dois <- bgi_dois[-which(bgi_dois == "")]
length(bgi_dois)

# Read in citation data
gigac <- read.table("data/wos/savedrecs_gigascience_289all_citation_report.txt", sep=",", skip=3, stringsAsFactors=FALSE)
# Tidy up column names
colnames(gigac) <- gigac[1, ]
gigac <- gigac[-c(1),]

# Get BGI paper citations using bgi_dois
bgi_paper_citations <- gigac[gigac$DOI %in% bgi_dois,]
bgi_paper_citations <- subset(bgi_paper_citations, select=c("Title", "Authors", "Publication Year", "Total Citations", "Average per Year"))
# Shorten authors to first author
first_authors <- bgi_paper_citations$Authors
first_authors <- sapply(strsplit(first_authors, ";"), "[", 1)
bgi_paper_citations$Authors <- first_authors
# Display
stargazer(bgi_paper_citations, type = "html", summary = FALSE, rownames = FALSE)
