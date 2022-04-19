library("tidyverse")
raw_dat <- read_delim(
  "/Users/victoriagao/local_docs/tina_bibliometric/process/one_example.txt",
  delim = ': ', 
  col_names = FALSE
)

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
  
