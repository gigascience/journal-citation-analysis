# Title     : Explore WOS data files
# Objective : TODO
# Created by: peterli
# Created on: 5/1/2018

# Read in database tags
dbtags <- read.table("data/wos/database_tags.tab", sep="\t", header=FALSE, stringsAsFactors=FALSE)
# There are 54 tags
nrow(dbtags)
[1] 54

# Read in citation tags
citetags <- read.table("data/wos/citation_index_tags.tab", sep="\t", header=FALSE, stringsAsFactors=FALSE)
# There are 44 tags
nrow(citetags)
[1] 44

# Combine both sets of tags
alltags <- rbind(dbtags, citetags)
# Add column names
colnames(alltags) <- c("tag", "description")
# Total number of tags
nrow(alltags)
[1] 98

# Check for duplicate tags
duplicated(alltags[,1])
[1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[25] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[37] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[49] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
[61]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE
[73] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE
[85] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
[97]  TRUE  TRUE

# Get duplicated tags
duptags <- alltags[duplicated(alltags[,1]),]$tag
[1] "FN" "VR" "AU" "CA" "TI" "SO" "AB" "RI" "OI" "Z9" "U1" "U2" "PY" "DI" "SU"
[16] "UT" "OA" "HP" "HC" "DA" "ER" "EF"

# Query tag in alltags data frame
alltags[alltags$tag == "EF",]
tag description
54  EF End of File
98  EF End of File

# Remove duplicated tags
cleantags <- alltags[!duplicated(alltags[,1]), ]
# There are 76 tags now
nrow(cleantags)
[1] 76

# Read in GigaScience tab delimited file
gigatags <- read.table("data/wos/savedrecs_gigascience_289all.txt", sep="\t", nrows=1, stringsAsFactors=FALSE)
# There are 68 cols
ncol(gigatags)
[1] 68

# Transpose
gigatags <- t(gigatags)

# Subset data based on gigatags
savedrecs_tags <- cleantags[cleantags$tag %in% gigatags[,1],]
savedrecs_tags <- savedrecs_tags[ order(match(savedrecs_tags$tag, gigatags[,1])), ]
write.table(savedrecs_tags, row.names = FALSE, file = "data/wos/savedrecs_tags.txt")

# Read in GigaScience citation report tab delimited file
giga_citation_colnames <- read.table("data/wos/savedrecs_gigascience_289all_citation_report.txt", sep=",", skip=3, nrows=1, stringsAsFactors=FALSE)
# There are 68 cols
ncol(giga_citation_colnames)
[1] 140

# Transpose
gigatags <- t(gigatags)

# Subset data based on gigatags
savedrecs_tags <- cleantags[cleantags$tag %in% gigatags[,1],]
savedrecs_tags <- savedrecs_tags[ order(match(savedrecs_tags$tag, gigatags[,1])), ]

