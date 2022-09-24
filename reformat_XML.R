library("tidyverse")
library("xml2")
library("XML")

#load_data
file_dir = "/Users/victoriagao/local_docs/tina_bibliometric/for_hayley_xml/Medline1.xml"
xml_file <- xmlParse(file_dir)

# 1.0 
xml_dat <- xmlToList(xml_file) 

# 1.1 
record <- as.list(xml_dat[["records"]][["record"]])
records <- as.list(xml_dat[["records"]])


# --------------------For Medline------------------------
records_dat <- lapply(records, function(x){

authors_messy <- unlist(x[["contributors"]][["authors"]])
authors <- authors_messy[c(names(authors_messy) == "author.style.text")]
authors <- paste0(authors, collapse = ", ")

keyword_messy <- unlist(x[["keywords"]])
keyword <- keyword_messy[c(names(keyword_messy) == "keyword.style.text")] 
keyword <- paste0(keyword, collapse = "; ")

title <- unlist(x[["titles"]][["title"]][["style"]][["text"]])
year <- unlist(x[["dates"]][["year"]][["style"]][["text"]])
journal_title <- unlist(x[["periodical"]][["full-title"]][["style"]][["text"]])
art_num <- unlist(x[["rec-number"]])
link <- unlist(x[["urls"]][["related-urls"]][["url"]][["style"]][["text"]])
ISSN <- unlist(x[["isbn"]][["style"]][["text"]])

abstract <- unlist(x[["abstract"]][["style"]])
abstract <- abstract[c(names(abstract) == "text")]
abstract <- paste0(abstract, collapse = ", ")

issue <- unlist(x[["number"]][["style"]])
issue <- issue[c(names(issue) == "text")]
issue <- paste0(issue, collapse = ", ")

volume <- unlist(x[["volume"]][["style"]])
volume <- volume[c(names(volume) == "text")]
volume <- paste0(volume, collapse = ", ")


df_file <- data.frame(
  "Authors" = authors,
  "Title" = title,
  "Year" = year,
  "SourceTitle" = journal_title,
  "Volume" = volume,
  "Issue" = issue,
  "Art.No." = art_num,
  "Link" = link,
  "Abstract" = abstract,
  "AuthorKeywords" = keyword,
  "ISSN" = ISSN
)

})

records_dataframe = do.call('rbind.data.frame', records_dat)

# --------------------For Cochrane2------------------------
records_dat <- lapply(records, function(x){
  
  authors_messy <- unlist(x[["contributors"]][["authors"]])
  authors <- authors_messy[c(names(authors_messy) == "author.style.text")]
  authors <- paste0(authors, collapse = ", ")
  
  keyword_messy <- unlist(x[["keywords"]])
  keyword <- keyword_messy[c(names(keyword_messy) == "keyword.style.text")] 
  keyword <- paste0(keyword, collapse = "; ")
  
  title <- unlist(x[["titles"]][["title"]][["style"]][["text"]])
  year <- unlist(x[["dates"]][["year"]][["style"]][["text"]])
  journal_title <- unlist(x[["periodical"]][["full-title"]][["style"]][["text"]])
  art_num <- unlist(x[["accession-num"]][["style"]][["text"]])
  link <- unlist(x[["urls"]][["related-urls"]][["url"]][["style"]][["text"]])
  
  volume <- unlist(x[["volume"]][["style"]])
  volume <- volume[c(names(volume) == "text")]
  volume <- paste0(volume, collapse = ", ")
  
  doi <- unlist(x[["electronic-resource-num"]][["style"]])
  doi <- doi[c(names(doi) == "text")]
  doi <- paste0(doi, collapse = ", ")
  
  abstract <- unlist(x[["abstract"]][["style"]])
  abstract <- abstract[c(names(abstract) == "text")]
  abstract <- paste0(abstract, collapse = ", ")
  issue <- unlist(x[["number"]][["style"]])
  issue <- issue[c(names(issue) == "text")]
  issue <- paste0(issue, collapse = ", ")
  
  df_file <- data.frame(
    "Authors" = authors,
    "Title" = title,
    "Year" = year,
    "SourceTitle" = journal_title,
    "Volume" = volume,
    "Issue" = issue,
    "Art.No." = art_num,
    "DOI" = doi,
    "Link" = link,
    "Abstract" = abstract,
    "AuthorKeywords" = keyword
  )
  
})


df_records = do.call('rbind.data.frame', records_dat)


#---------------------------3.0 write into a csv-------------------
write.csv(records_dataframe,"/Users/victoriagao/local_docs/tina_bibliometric/reformatted/Medline4_reformatted.csv", row.names = FALSE)
write.csv(df_records,"/Users/victoriagao/local_docs/tina_bibliometric/reformatted/Cochrane2_reformatted.csv", row.names = FALSE)

record_1 <- records[[1]]

abstract_1 <- unlist(record_1[["abstract"]][["style"]])
title <- unlist(record_1[["titles"]][["title"]][["style"]][["text"]])
journal_title_1 <- unlist(record[["periodical"]][["full-title"]][["style"]][["text"]])
issue_1 <- unlist(record[["number"]][["style"]])


title <- unlist(x[["titles"]][["title"]][["style"]][["text"]])


doi <- unlist(x[["electronic-resource-num"]][["style"]][["text"]])


key <- unlist(x[["foreign-keys"]][["key"]][["text"]])
ISSN_1 <- unlist(record[["isbn"]][["style"]][["text"]])

