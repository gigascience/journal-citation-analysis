# journal-citation-analysis
1, The input file is named 'giga.tsv', which is in the same folder of the script.
2, RCurl, XML, hash and RColorBrewer pacakges are used.
3, The output file is named 'Rst.pdf', which is in the same folder of the script.
4, The statistical function is implemented by Hash instead of SQLite.
5, The records in the input file whose DOI numbers are missing or wrong, are disposed directly.
6, The extraction and parsing of the web pages are the most time-consuming part (more than one hour for 270 records).
7, Due to the instability of the web service, the web page extraction process sometimes collapses. Just re-run the script, it should go green.
