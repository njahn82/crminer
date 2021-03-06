context("crm_text")

crm_cache$cache_path_set(path = "crminer", type = "tempdir")

test_that("crm_text works: pdf", {
  skip_on_cran()

  links <- crm_links("10.7717/peerj.1268", "pdf")
  pdf_read <- suppressMessages(crm_text(links, "pdf", read = FALSE,
                                        verbose = FALSE))
  pdf <- suppressMessages(crm_text(links, "pdf", verbose = FALSE))

  expect_is(pdf_read, "character")
  expect_is(pdf, "crm_pdf")

  expect_equal(length(pdf_read), 1)
  expect_equal(length(pdf), 2)
  expect_is(pdf$info, "list")
  expect_equal(length(pdf$text), pdf$info$pages)
})

test_that("crm_text fails well", {
  skip_on_cran()

  expect_error(crm_text(), 'argument "url" is missing')
  expect_error(crm_text("3434"), "no 'crm_text' method for character")

  links <- crm_links("10.1155/mbd.1994.183", "all")
  expect_error(crm_text(links, type = "adfasf"),
               "'type' must be one of xml, plain, html, or pdf")
})

test_that("crm_text with pdf works for 'unspecified' = TRUE",{
  skip_on_cran()

  skip_if_not(Sys.getenv("CROSSREF_TDM") != "",
              "Needs 'Sys.setenv(CROSSREF_TDM = \"your-key\")' to be set.")
  links <- crm_links("10.2903/j.efsa.2014.3550",type = "all")

  res <- suppressMessages(crm_text(links, type = "pdf",
                                   overwrite_unspecified = TRUE))
  expect_equal(res$info$pages, 11)
})

test_that("crm_text with pdf fails for 'unspecified' = FALSE",{
  skip_on_cran()
  
  links <- crm_links("10.2903/j.efsa.2014.3550", type = "all")

  expect_error(crm_text(links, type = "pdf", overwrite_unspecified = FALSE),
              "no links for type pdf")
})

