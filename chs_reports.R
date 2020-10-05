#######################################
# Correctional Health Services Reports
# Creates df of CHS Reports from 2019-2020
# by Mari Roberts
# 10/4/2020
#######################################

setwd("/Users/mr4909/chs_boc_reports")

# connect custom functions and R libraries file
source('chs_functions.R')

############################################################
# import the pdf files from your directory location
# january 2019 - june 2019 (missing substance abuse category)
############################################################

# set working directory
setwd("/Users/mr4909/chs_boc_reports/chs_access_reports_01_2019_to_06_2019")

# read all of the pdf files in the directory folder 
# ensure there are only the pdf files you need in there
temp <- list.files(pattern = "*.pdf", full.names = TRUE)
temp

# create an empty data frame for the for loop
chs_reports <- setNames(data.frame(matrix(ncol = 3, nrow = 0)), 
                       c("service_type", "pct_completed", "report_date"))

# cycle through each pdf and save data to a final dataframe 
for(i in 1:length(temp)){
  
  # read in each pdf file
  pdf_name <- pdf_text(temp[i]) %>% read_lines() 
  
  # extract date from cover page
  pdf_date <- pdf_name[c(1)]

  # call custom function to set up pdf
  pdf_name <- pdf_setup(pdf_name)
  
  # add NAs to substance abuse (future category after June 2019)
  pdf_name$substance_abuse <- NA
  
  # call custom function to get final pdf data
  pdf_name <- pdf_get_data(pdf_name)
  
  # bind the rows of each pdf into a master df
  chs_reports <- rbind(chs_reports, pdf_name)
}

############################################################
# import the pdf files from your directory location
# june 2019 - december 2019 (has substance abuse category)
############################################################

# set working directory
setwd("/Users/mr4909/chs_boc_reports/chs_access_reports_08_2019_to_06_2020")

# read all of the pdf files in the directory folder 
# ensure there are only the pdf files you need in there
temp <- list.files(pattern = "*.pdf", full.names = TRUE)
temp

# cycle through each pdf and save data to a final dataframe 
for(i in 1:length(temp)){
  
  # read in each pdf file
  pdf_name <- pdf_text(temp[i]) %>% read_lines() 
  
  # extract date from cover page
  pdf_date <- pdf_name[c(1)]
  
  # call custom function to set up pdf
  pdf_name <- pdf_setup(pdf_name)
  
  # call custom function to get final pdf data
  pdf_name <- pdf_get_data(pdf_name)
  
  # bind the rows of each pdf into a master df
  chs_reports <- rbind(chs_reports, pdf_name)
}

