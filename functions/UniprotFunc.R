
### Uniprot API functions

## uniprot functions 
isJobReady <- function(jobId) {
  pollingInterval = 5
  nTries = 20
  for (i in 1:nTries) {
    url <- paste("https://rest.uniprot.org/idmapping/status/", jobId, sep = "")
    r <- GET(url = url, accept_json())
    status <- content(r, as = "parsed")
    if (!is.null(status[["results"]]) || !is.null(status[["failedIds"]])) {
      return(TRUE)
    }
    if (!is.null(status[["messages"]])) {
      print(status[["messages"]])
      return (FALSE)
    }
    Sys.sleep(pollingInterval)
  }
  return(FALSE)
}

getResultsURL <- function(redirectURL) {
  if (grepl("/idmapping/results/", redirectURL, fixed = TRUE)) {
    url <- gsub("/idmapping/results/", "/idmapping/stream/", redirectURL)
  } else {
    url <- gsub("/results/", "/results/stream/", redirectURL)
  }
}

