#######################################
# Correctional Health Services Reports
# Custom functions
# by Mari Roberts
# 10/4/2020
#######################################

# function to create basic dataframe with percent completed values
pdf_setup <- function(pdf_name) {
    
    # get location of "Percent completed"
    pct_line <- grep(pattern = "Percent completed", pdf_name)
    
    # select line with percent completed
    pdf_name <-pdf_name[c(pct_line)]
    
    # clean line
    pdf_name <- pdf_name[1] %>%
      str_squish() %>%
      str_replace_all("%","") %>% # remove % 
      str_replace_all("  "," ")   # remove extra white space
    
    # rename percent completed
    pdf_name <- mgsub::mgsub(pdf_name, c("4.1 Percent completed"), c("pct_completed"))
    
    # # create dataframe
    pdf_name <- data.frame(pdf_name)
    
    # separate string by white space
    pdf_name <- data.frame(do.call('rbind', strsplit(as.character(pdf_name$pdf_name),' ',fixed=TRUE)))
    
    return(pdf_name)
}

# function to creates final dataframe with percent completed values
pdf_get_data <- function(pdf_name) {
  
    # create and assign variable names
    var_lines <- c("service_type",
                   "medical",
                   "nursing",
                   "mental",
                   "social",
                   "dental",
                   "clinic_on",
                   "clinic_off",
                   "total",
                   "substance_abuse")
    colnames(pdf_name) <- var_lines
    
    # remove totals
    pdf_name <- pdf_name %>% select(-total)
    
    # convert to long form
    pdf_name <- pdf_name %>% gather(service_type, pct_completed, 2:9)
    
    # add report date
    pdf_name$report_date <- pdf_date
    
    # fix date for 2020 quarterly report
    pdf_name$report_date <- gsub('CHS Access Report: CY2020 Quarter 1','January 2020', 
                                 pdf_name$report_date)
    
    # extract month and year from string
    months.regex <- paste(month.name, collapse='|')
    pdf_name$month_year <- gsub(paste0(".*(", months.regex, ")"), "\\1", 
                                pdf_name$report_date[grep(months.regex, pdf_name$report_date, TRUE)], TRUE)
    
    # put in formal date format
    pdf_name$month_year <- lubridate::mdy(pdf_name$month_year)
    pdf_name$month_year <- format(pdf_name$month_year, "%m/%Y")
    
    # remove report date string variable
    pdf_name <- pdf_name %>% select(-report_date)
    
    return(pdf_name)
}
