library("tidyverse")
library("xml2")
library("XML")

#load_data
file_dir = "/Users/victoriagao/local_docs/tina_bibliometric/for_hayley_xml/Cochrane2.xml"
xml_file <- xmlParse(file_dir)
# df_file <- xmlToDataFrame(xml_file) (This won't work, xml file too messy)

# 1. Chaning the xml file to a list
xml_dat <- xmlToList(xml_file) # list_file <-  xml2::as_list(xml_file) does the same thing

# 1.1 Extracting records, want to make each record a individual dataframe then bind/merge them 
record <- as.list(xml_dat[["records"]][["record"]])
records <- as.list(xml_dat[["records"]])
# authors <- as.list(xml_dat[["records"]][["record"]][["contributors"]][["authors"]][["author"]][["style"]])


# ------this is only one record
authors_messy <- unlist(record[["contributors"]][["authors"]])
# authors <- grep(",", strsplit(authors_messy,"author.style.text"), value = T)
authors <- authors_messy[c(names(authors_messy) == "author.style.text")]
authors <- paste0(authors, collapse = ",")

keyword_messy <- unlist(record[["keywords"]])
keyword <- keyword_messy[c(names(keyword_messy) == "keyword.style.text")]
keyword <- paste0(keyword, collapse = ";")


key <- unlist(record[["foreign-keys"]][["key"]][["text"]])
ref_type <- unlist(record[["ref-type"]][[".attrs"]])
title <- unlist(record[["titles"]][["title"]][["style"]][["text"]])
year <- unlist(record[["dates"]][["year"]][["style"]][["text"]])
link <- unlist(record[["urls"]][["related-urls"]][["url"]][["style"]][["text"]])

df_file <- data.frame(
  "Reference Type" = ref_type,
  "Authors" = authors,
  "Title" = title,
  "Year" = year,
  "Links" = link,
  "Key Words" = keyword,
  "Key" = key
)
# ------this is only one record





# ------try looping through to get all records
records_dat <- lapply(records, function(x){

authors_messy <- unlist(x[["contributors"]][["authors"]])
# authors <- grep(",", strsplit(authors_messy,"author.style.text"), value = T)
authors <- authors_messy[c(names(authors_messy) == "author.style.text")]
authors <- paste0(authors, collapse = ", ")

keyword_messy <- unlist(x[["keywords"]])
keyword <- keyword_messy[c(names(keyword_messy) == "keyword.style.text")] # synonomous to the grep() for authors
keyword <- paste0(keyword, collapse = "; ")

key <- unlist(x[["foreign-keys"]][["key"]][["text"]])
ref_type <- unlist(x[["ref-type"]][[".attrs"]])
title <- unlist(x[["titles"]][["title"]][["style"]][["text"]])
year <- unlist(x[["dates"]][["year"]][["style"]][["text"]])
link <- unlist(x[["urls"]][["related-urls"]][["url"]][["style"]][["text"]])

df_file <- data.frame(
  "ReferenceType" = ref_type,
  "Authors" = authors,
  "Title" = title,
  "Year" = year,
  "Links" = link,
  "KeyWords" = keyword,
  "Key" = key
)

})

records_dataframe = do.call('rbind.data.frame', records_dat)
write.csv(records_dataframe,"/Users/victoriagao/local_docs/tina_bibliometric/reformatted/Cochrane2_reformatted.csv", row.names = FALSE)

# ------try looping through to get all records

# define col_names
col_names <- c(
  "Reference Type",
  "Record Number",
  "Author",
  "Year",
  "Title",
  "Journal",
  "Issue",
  "Short Title",
  "ISSN",
  "DOI",
  "Accession Number",
  "Keywords",
  "Abstract",
  "Notes",
  "URL"
)



# extract columns with desired col names
