# Description of files

These files contain data returned from queries made on 2 January 2018 by Web of 
Science (WOS).
 
## GigaScience data files

On 02-01-2018, WOS found 289 articles published by GigaScience. Information
about these 289 articles are contained in the following two files:

| File  | Description |
| ----- | ----------- |
| savedrecs_gigascience_289all.txt | Provides information about articles, e.g. authors, article type, publication date and DOI. |
| savedrecs_gigascience_289all_citation_report.txt | Provides information about GigaScience papers and the number of citations they have received on a per year basis. |
  
The article information in both these files can be merged using the paper DOIs, 
for example `10.1093/gigascience/gix088`. Information about the tags in the 
`savedrecs_gigascience_289all.txt` can be found in the `savedrecs_tags.txt` 
file. This file was generated using the `analyse_tags.R` file.
 
In the `savedrecs_gigascience_289all_citation_report.txt` file, tags are not
used in the column names which are provided as descriptions.
 
##  BGI publications data files
 
All of the papers published by BGI in all journals since 2012 that have been 
indexed by WOS can be found in the `savedrecs_year.txt` files, for example, 
`savedrecs_2012.txt`. These `savedrecs_year.txt` files contain information about 
articles, e.g. authors, article type, publication date and DOI. For information 
about the column tags in these files, please see the `savedrecs_tags.txt` file.

The `savedrecs_year_citation_report.txt` files provides information about papers
published in all journals and the number of citations they have received on a 
per year basis. The article information in `savedrecs_year.txt` and
`savedrecs_year_citation_report.txt` files can be merged using the paper DOI.