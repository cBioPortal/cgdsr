setRepositories(ind=1:6)

if (!("devtools" %in% installed.packages())) install.packages("devtools")
if (!("testthat" %in% installed.packages())) install.packages("testthat")

library(devtools)

install_deps(".")

library(testthat)

#Source all scripts in R 
load_all() 

tmpFile <- tempfile()

sink(tmpFile)
test_dir("inst/tests", reporter="tap")
sink()

con <- file(tmpFile, "r")
outFile <- file("outputFile", "w")
tmp <- ""

startTap <- FALSE
startMultiLine <- FALSE
firstMultiLine <- FALSE
curMultiLine <- FALSE

while(length(line <- readLines(con, n=1)) > 0) {  
  # Check for the start of the TAP file
  if(grepl("\\d\\.\\.\\d", line)) {
    startTap <- TRUE
  }
  
  # Check for the start of multiline comments
  if(startTap && grepl("^\\s\\s", line)) {
    startMultiLine <- TRUE
    #writeLines("  ---", con=outFile)
    if(!curMultiLine) {
      tmp <- paste0(tmp, "  ---\n")      
      curMultiLine <- TRUE
      firstMultiLine <- TRUE
    }
  }  
  
  if(startTap) {  
    # Check for the end of the multiline
    if(startMultiLine && grepl("^[ok|#]", line)) {
      #writeLines("  ...", con=outFile)     
      #writeLines(line, con=outFile) 
      
      tmp <- paste0(tmp, "  ...\n")
      tmp <- paste0(tmp, line, "\n")
      
      startMultiLine <- FALSE
      curMultiLine <- FALSE
    } else {
      
      # Check for the first line of the multiline 
      if(firstMultiLine) {
        #writeLines(line, con=outFile) 
        # Remove any existing trailing colon that corrupts YAML format
        line <- gsub(":", "", line)
        # Trim trailing space 
        line <- gsub(" $", "", line)
        tmp <- paste0(tmp, line, ":\n")       
        firstMultiLine <- FALSE
      } else {
        #writeLines(line, con=outFile) 
        tmp <- paste0(tmp, line, "\n")                
      }
    }
  }
  
  #cat(line)
} 

cat(tmp, file="jenkins_results.txt")