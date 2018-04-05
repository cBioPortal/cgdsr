# About 

The package provides a basic set of R functions for querying the Cancer Genomics Data Server (CGDS), hosted by the Computational Biology Center at Memorial-Sloan-Kettering Cancer Center (MSKCC).

# Information 
[Homepage](http://cran.r-project.org/web/packages/cgdsr/index.html)

# Install cgdsr Development Version from GitHub

    setRepositories(ind=1:6)
    options(repos="http://cran.rstudio.com/")
    if(!require(devtools)) { install.packages("devtools") }
    library(devtools) 
    
    install_github("cBioPortal/cgdsr")
