library("tidyverse")



#load_data
file_dir = "/Users/victoriagao/local_docs/tina_bibliometric/split_data/Cochrane2_files"
filenames <- c(file.path(file_dir, dir(path = file_dir)))
# filenames_sample <- filenames[1:200]


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

#main function

journal_data = map_dfr(filenames, function(x){
  
  cat(x, "\n")
  raw_dat <- read_delim(
    x,
    delim = ': ', 
    col_names = FALSE,
    show_col_types = FALSE
  )
  keywords <- c(
    filter(raw_dat, X1 == "Keywords") %>% pull(X2),
    setdiff(raw_dat[["X1"]], col_names)
  ) %>%
    paste(collapse = ", ")
  
  dat_tidy <- raw_dat %>%
    filter(X1 %in% col_names) %>%
    mutate(X2 = ifelse(X1 == "Keywords", keywords, X2)) %>%
    t() %>%
    as_tibble %>%
    setNames(col_names) %>%
    .[-1, ]
  
  dat_tidy

})

write.csv(journal_data,"/Users/victoriagao/local_docs/tina_bibliometric/reformatted/Cochrane2_part_reformatted.csv", row.names = FALSE)


