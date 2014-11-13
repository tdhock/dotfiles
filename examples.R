## Usage examples for some of the functions defined in my .Rprofile.

## Instead of library/require, use works_with_R to declare package
## versions, for more reproducible analyses.
works_with_R("3.0.2", RColorBrewer="1.0.5", ggplot2="0.9.3.1",
             "tdhock/animint@f877163cd181f390de3ef9a38bb8bdd0396d08a4")

## Convert a character vector to a named match matrix using a named
## capture regular expression.
subject <- c(
  "tdhock/animint@057f34055ee876404caae7abc1c077a7bf126580",
  "this subect should not match, resulting in a row of NA",
  "rstudio/ggvis@8aa5ae207b3da0ff218fb5a3829bbdd59e54043c") 
pattern <-
  paste0("(?<GithubUsername>[^/]+)",
         "/",
         "(?<GithubRepo>[^@]+)",
         "@",
         "(?<GithubSHA1>[a-f0-9]{40})")
str_match_perl(subject, pattern)

## when there are no capturing groups defined, we can still return the
## entire match.
no.groups <-
  paste0("[^/]+",
         "/",
         "[^@]+",
         "@",
         "[a-f0-9]{40}")
str_match_perl(subject, no.groups)
str_match_all_perl(subject, no.groups)
