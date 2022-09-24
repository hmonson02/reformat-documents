#!/usr/bin/env python
# coding: utf-8

# # This is the mainfunction

# In[8]:


import re
import pandas as pd
import reformat_functions


# ### To load in data

# In[2]:


def process_embase_df(directory, filename, sheetname, 
                      headerList, columns_mapping
                     ):
    
    file_input = directory + filename
    df_input = pd.read_excel(file_input, sheet_name=sheetname, skiprows=1)
    
    df_output = pd.DataFrame(columns=headerList)
    
    for k, v in columns_mapping.items():
        print("copy column " + str(v) + " to column " + k)
        df_output.loc[:,k] = df_input.iloc[:, v]
        
  
    
    return df_output


# ## Provide your path and file name, sheetname, headerlist and corresponding column location

# In[3]:


directory = '/Users/victoriagao/local_docs/tina_bibliometric/embase_to_pubmed/embase_no_pubmed/'
filename = 'embase_16001-16474_no_pubmed.xlsm'

sheetname = "citations"

headerList = ['Authors',
             'Author(s) ID',
             'Title',
             'Year',
             'Source title',
             'Volume',
             'Issue',
             'Art. No.',
             'Page start',
             'Page end',
             'Page count',
             'Cited by',
             'DOI',
             'Link',
             'Affiliations',
             'Authors with affiliations',
             'Abstract',
             'Author Keywords',
             'Index Keywords', #?
             'Correspondence Address',
             'Editors',
             'Publisher',
             'ISSN',
             'ISBN',
             'CODEN',
             'PubMed ID',
             'Language of Original Document',
             'Abbreviated Source Title',
             'Document Type',
             'Publication Stage',
             'Open Access',
             'Source',
             'EID']


# This column mapping is different for almost every embase export file, need to check one-by-one
columns_mapping = {"Source": 2, #DB
                   "PubMed ID": 5, #PM
                   "Publication Stage": 6, #ST
                   "Title": 7, #TI
                   "Source title": 8, #SO
                   "Authors": 9, #AU
                   "Authors with affiliations": 10, #IN
                   "Correspondence Address": 11, #AD
                   "Publisher": 13, #PB
                   #"Link": , #UR
                   "Index Keywords": 16, #OD
                   "Abstract": 17, #AB
                   "ISSN": 20, #IS
                   "DOI": 36, #DO
                   "Language of Original Document": 22, #LG
                   "Document Type": 25, #PT
                   "Year": 29, #YR
                   "Author Keywords": 14, #KW
                   "CODEN": 21, #CD
                  }



data_frame = process_embase_df(directory,
                  filename,
                  sheetname, 
                  headerList,
                  columns_mapping
                 )


# ## Define main script

# In[9]:


def main(whole_df):
    author_last_first_pattern = "(?P<lastname>[A-Za-z].*)\s" + "(?P<firstname>[A-Z](.*)?.)"
    whole_df = whole_df.fillna('')
    new_authors_affiliation_col = whole_df.apply(lambda row: reformat_functions.main_affiliation(row['Authors'], row['Authors with affiliations']),
                                                 axis=1
                                                 )
    
    whole_df['Authors with affiliations'] = new_authors_affiliation_col
    
    print('=====main_affiliation is done=====')

    new_authors = reformat_functions.split_authors(whole_df)
    whole_df['Authors'] = new_authors

    print('=====split_authors=====')
        
    new_institution = reformat_functions.remove_crap_institution(whole_df)
    whole_df['Source title'] = new_institution
    
    print('=====remove_crap_institution=====')
        
    new_keyword = reformat_functions.add_semi(whole_df)
    whole_df['Author Keywords'] = new_keyword
    
    print('=====add_semi is done=====')
    
    
    return whole_df
    
    
    


# # Run and save the output file

# In[12]:


new_df_output = main(data_frame)


# In[13]:


new_df_output


# In[ ]:




