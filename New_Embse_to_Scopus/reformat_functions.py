#!/usr/bin/env python
# coding: utf-8

# In[ ]:





# In[1]:


import re
import pandas as pd


# ## Make a name dictionary 

# ### for one cell

# In[2]:


#define the pattern between last name and first name from the authors column
author_last_first_pattern = "(?P<lastname>[A-Za-z].*)\s" + "(?P<firstname>[A-Z](.*)?.)"


# In[3]:


def make_last_first_dic(author_cell, author_last_first_pattern):
    author_last_first_dic =     [m.groupdict() for m in re.finditer(author_last_first_pattern, author_cell)]
    
    author_last_first_dic =     { o['lastname']: o['firstname'] for o in author_last_first_dic }
    
    return author_last_first_dic

# make_last_first_dic('first_author_cell', author_last_first_pattern)


# ## Make main_affiliation function:

# ##### split individual cells:

# In[7]:


# first_author_affiliation_cell = df_output["Authors with affiliations"][0]
def split_by_lines(one_affiliation_cell):
    affiliation_cell = one_affiliation_cell.split('\n\n')
    return affiliation_cell

#splitted_first_author_affiliation_cell = split_by_lines(first_author_affiliation_cell)


# ##### Create function that organizes affiliation for each cell

# In[8]:


# One function for each cell
# authors_affiliation -> list of '(authors) affiliation_A', '(authors) affiliation_B'
def create_affiliation_one_cell(raw_authors_affiliation_one_cell, last_first_dict):
    
    # namescope
    
    affiliation_list = [expand_author_per_affiliation(each_element, last_first_dict) 
                        for each_element in raw_authors_affiliation_one_cell]
    #print(affiliation_list)
    
        
    return affiliation_list # output is a string


# Returns a list of authors' lastnames and the corresponding institute (one element of one cell)
def expand_author_per_affiliation(one_element, last_first_dict):

    full_name_list_one_element = []

    # try extracting authors from () with pattern '\((.*?)\)\s+(.*)'
    try:
        authors_affiliation = re.match('\((.*?)\)\s+(.*)', one_element).groups() #there's (authors) and affiliation

        authors = authors_affiliation[0]
        affiliation = authors_affiliation[1]

        #print(authors)
        #print(affiliation)

        authors_list_one_element = authors.split(', ')

        for this_last_name in authors_list_one_element:
            first_name_found = last_first_dict[this_last_name]
            full_name = ' '.join([this_last_name, first_name_found])

            full_name_list_one_element.append(full_name + ', ' + affiliation)
            #print(last_first_name_list)
            full_string_one_element = '; '.join(full_name_list_one_element)

    except AttributeError as e:
        print(str(e))
        # authors = ''
        # affiliation = ''
        full_string_one_element = ''
    except KeyError as e:
        print(str(e))
        full_string_one_element = ''
    except UnboundLocalError as e:
        print(str(e))
        full_string_one_element = ''
#         finally:
#             print('we do this anyway')
#             # authors = ''
#             # affiliation = ''  
#             full_string_one_element = ''

    return full_string_one_element


# In[9]:


def main_affiliation(authors_col, affiliation_col):
    
    name_dic = make_last_first_dic(authors_col, author_last_first_pattern)
    #print(name_dic)
    
    affiliation_cell = split_by_lines(affiliation_col)
    #print(affiliation_cell)
    
    
    author_affiliation_one_cell = create_affiliation_one_cell(affiliation_cell, name_dic)
    full_author_affiliation_one_cell = '; '.join(author_affiliation_one_cell)
    
    # print(full_full_affiliation_one_cell)
    
    return full_author_affiliation_one_cell
    
    


# ## Define 3 other functions

# ### split authors and add , after authors

# In[10]:


# a column of a dataframe --> Series
def split_authors(df_input):
    
    authors_dlmt = "\n\n"

    # df_output["Authors"] = \
    splitted = df_input["Authors"]               .str.strip()               .str.split(authors_dlmt)               .str.join(', ')

    return splitted


# ### remove crap after institutions

# In[11]:


def remove_crap_institution(df_input):
    institutions_dlmt = "."

    clean_institution = df_input["Source title"]                        .str.strip()                        .str.split(institutions_dlmt,1)                        .str[0]

    return clean_institution


# ### add semicolon after each keyword

# In[12]:


def add_semi(df_input):
    keyword_dlmt = "\n\n"

    # df_output["Authors"] = \
    added_semi = df_input["Author Keywords"]                 .str.strip()                 .str.split(keyword_dlmt)                 .str.join('; ')
    
    return added_semi


# In[ ]:




