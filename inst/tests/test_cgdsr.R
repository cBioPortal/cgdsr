context("GGDSR Tests")

test_that("getCancerStudies", {
  mycgds <- CGDS("http://www.cbioportal.org/public-portal/")

  cancerstudies <- getCancerStudies(mycgds)
  expect_identical(colnames(cancerstudies), c("cancer_study_id","name","description"))
})

test_that("getCaseLists", {
  mycgds <- CGDS("http://www.cbioportal.org/public-portal/")  
  cancerstudies <- getCancerStudies(mycgds)
  ct <- cancerstudies[2,1] # should be row 1 instead ...

  expect_identical(colnames(getCaseLists(mycgds,ct)), 
                   c("case_list_id","case_list_name", "case_list_description","cancer_study_id","case_ids"))
  expect_identical(colnames(getCaseLists(mycgds,'xxx')), 
                   'Error..Problem.when.identifying.a.cancer.study.for.the.request.')
})

test_that("getGeneticProfiles", {
  mycgds <- CGDS("http://www.cbioportal.org/public-portal/")  
  cancerstudies <- getCancerStudies(mycgds)
  ct <- cancerstudies[2,1] # should be row 1 instead ...
  
  expect_identical(colnames(getGeneticProfiles(mycgds,ct)),
              c("genetic_profile_id","genetic_profile_name","genetic_profile_description",
                "cancer_study_id","genetic_alteration_type","show_profile_in_analysis_tab"))

  expect_identical(colnames(getGeneticProfiles(mycgds,'xxx')),
                   'Error..Problem.when.identifying.a.cancer.study.for.the.request.')
})

test_that("getClinicalData", {
  mycgds <- CGDS("http://www.cbioportal.org/public-portal/")  
  
  expect_identical(colnames(getClinicalData(mycgds,'gbm_tcga_all'))[1],
                   c("DFS_MONTHS"))
})

test_that("getProfileData", {
  mycgds <- CGDS("http://www.cbioportal.org/public-portal/")  

  # check one gene, one profile
  expect_identical(colnames(getProfileData(mycgds,'NF1','gbm_tcga_mrna','gbm_tcga_all')),
                   "NF1")
  
  # check many genes, one profile
  expect_identical(colnames(getProfileData(mycgds,c('MDM2','MDM4'),'gbm_tcga_mrna','gbm_tcga_all')),
                   c("MDM2","MDM4"))

  # check one gene, many profile
  expect_identical(colnames(getProfileData(mycgds,'NF1',c('gbm_tcga_mrna','gbm_tcga_mutations'),'gbm_tcga_all')),
                   c('gbm_tcga_mrna','gbm_tcga_mutations'))

  # check 3 cases returns matrix with 3 columns
  expect_identical(rownames(getProfileData(mycgds,'BRCA1','gbm_tcga_mrna',cases=c('TCGA-02-0001','TCGA-02-0003'))),
                   make.names(c('TCGA-02-0001','TCGA-02-0003')))
  
  # invalid gene names return empty data.frame
  expect_identical(nrow(getProfileData(mycgds,c('NF10','NF11'),'gbm_tcga_mrna','gbm_tcga_all')),as.integer(0))

  # invalid case_list_id returns error
  expect_identical(colnames(getProfileData(mycgds,'NF1','gbm_tcga_mrna','xxx')),
                   'Error..Invalid.case_set_id...xxx.')
})