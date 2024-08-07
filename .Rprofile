# -*- Mode: R -*-

### Write down what package versions work with your R code, and
### attempt to download and load those packages. The first argument is
### the version of R that you used, e.g. "3.0.2" and then the rest of
### the arguments are package versions. For
### CRAN/Bioconductor/R-Forge/etc packages, write
### e.g. RColorBrewer="1.0.5" and if RColorBrewer is not installed
### then we use install.packages to get the most recent version, and
### warn if the installed version is not the indicated version. For
### GitHub packages, write "user/repo@commit"
### e.g. "tdhock/animint@f877163cd181f390de3ef9a38bb8bdd0396d08a4" and
### we use install_github to get it, if necessary.
works_with_R <- function(Rvers,...){
  local.lib <- file.path(getwd(), "library")
  dir.create(local.lib, showWarnings=FALSE, recursive=TRUE)
  .libPaths(local.lib)
  pkg_ok_have <- function(pkg,ok,have){
    stopifnot(is.character(ok))
    if(!as.character(have) %in% ok){
      warning("works with ",pkg," version ",
              paste(ok,collapse=" or "),
              ", have ",have)
    }
  }
  pkg_ok_have("R",Rvers,getRversion())
  pkg.vers <- list(...)
  for(pkg.i in seq_along(pkg.vers)){
    vers <- pkg.vers[[pkg.i]]
    pkg <- if(is.null(names(pkg.vers))){
      ""
    }else{
      names(pkg.vers)[[pkg.i]]
    }
    if(pkg == ""){# Then it is from GitHub.
      ## suppressWarnings is quieter than quiet.
      if(!suppressWarnings(require(requireGitHub))){
        ## If requireGitHub is not available, then install it using
        ## devtools.
        if(!suppressWarnings(require(devtools))){
          install.packages("devtools")
          require(devtools)
        }
        install_github("tdhock/requireGitHub")
        require(requireGitHub)
      }
      requireGitHub(vers)
    }else{# it is from a CRAN-like repos.
      if(!suppressWarnings(require(pkg, character.only=TRUE))){
        install.packages(pkg)
      }
      pkg_ok_have(pkg, vers, packageVersion(pkg))
      library(pkg, character.only=TRUE)
    }
  }
}

options(repos=c(
          "http://www.bioconductor.org/packages/release/bioc",
          "http://r-forge.r-project.org",
          "http://cloud.r-project.org"))
options(help_type = "text")
if(interactive())suppressMessages({
  options(bitmapType="cairo")
  require(grDevices)
  X11.options(type="cairo")
  x11(width=17.5,height=10.2,xpos=-1,ypos=-1)

  ## Use the *nix wc program to quickly determine the number of lines
  ## of a file (and print the first few lines).
  wc <- function(f){
    stopifnot(is.character(f))
    stopifnot(length(f)==1)
    if(file.exists(f)){
      system(paste("head", f))
      cmd <- sprintf("wc -l %s", f)
      wc.txt <- system(cmd, intern=TRUE)
      wc.sub <- sub(" .*","",wc.txt)
      as.integer(wc.sub)
    }else{
      0L
    }
  }

  ## Use the *nix ps program to get the memory usage of this R process.
  memory.usage <- function(ps.parameter=paste("-p", Sys.getpid())){
    cmd <- sprintf("ps %s -o pid,cmd,rss", ps.parameter)
    ps.lines <- system(cmd, intern=TRUE)
    stopifnot(length(ps.lines) > 1)
    ps.table <- read.table(text=ps.lines, header=TRUE)
    ps.table$megabytes <- ps.table$RSS/1024
    ps.table
  }

  hms <- function(seconds){
    divide <- function(numerator, denominator){
      list(quotient=numerator %/% denominator,
           remainder=numerator %% denominator)
    }
    minutes <- divide(seconds, 60)
    hours <- divide(minutes$quo, 60)
    days <- divide(hours$quo, 24)
    h <- hours$quo
    m <- hours$rem
    s <- minutes$rem
    if(any(h > 0)){
      ifelse(0 < h, sprintf("%dh%dm", h, m), sprintf("%dm", m))
    }else{
      sprintf("%dm%ds", m, s)
    }
  }


  ## Keep running the code in expr every 2 seconds.
  watch <- function(expr, seconds=2){
    e <- substitute(expr)
    while(TRUE){
      print(Sys.time())
      val <- eval(e)
      print(val)
      Sys.sleep(seconds)
    }
  }

  meminfo <- function(){
    meminfo.df <- read.table("/proc/meminfo", sep=":", row.names=1)
    names(meminfo.df) <- c("text")
    meminfo.df$digits <- gsub("[^0-9]", "", meminfo.df$text)
    meminfo.df$unit <- ifelse(grepl("kB", meminfo.df$text), "kB", "pages")
    meminfo.df$value <- as.numeric(meminfo.df$digits)
    meminfo.df$megabytes <- as.integer(meminfo.df$value/1024)
  }

  free <- function(){
    free.lines <- system("free -m", intern=TRUE)
    df <- read.table(text=free.lines, sep=":", row.names=1)
    names(df) <- "values"
    mb.text <- sub(" +.*", "", sub("^ *", "", df$values))
    data.frame(megabytes=as.numeric(mb.text),
               row.names=c("total", "used", "swap"))
  }

  ## Special print method for long character strings.
  print.character <- function(x, ...){
    row.vec <- rownames(x)
    row.chars <- if(is.null(row.vec)){
      0
    }else{
      max(nchar(row.vec))
    }
    max.chars <- getOption("width") - row.chars
    is.big <- max.chars < nchar(x)
    if(any(is.big)){
      n <- max.chars - 10
      cat("... = only printed first", n, "characters.\n")
      first <- ifelse(is.big, paste0(substr(x, 1, n), "..."), x)
      print.default(first, ...)
    }else{
      print.default(x, ...)
    }
  }

  if(requireNamespace("namedCapture")){

    ## convert an author list string from an automatically formatted
    ## bibtex entry (Hocking, Toby Dylan and Rigaill, Guillem) to a
    ## human readable abbreviated list (Hocking TD, Rigaill G).
    bibAuthors2text <- function(authors.str){
      authors.vec <- strsplit(authors.str, " and ")[[1]]
      authors.mat <- namedCapture::str_match_variable(
        authors.vec,
        last="[^,]+",
        ", ",
        first="[^ ]+",
        list(
          " ",
          rest=".*"
        ), "?")
      abbrev.vec <- data.table(authors.mat)[, paste0(
        last,
        " ",
        substr(first, 1, 1),
        substr(rest, 1, 1)
      )]
      paste(abbrev.vec, collapse=", ")
    }

    vmstat <- function(){
      vmstat.pattern <-
      vmstat.lines <- system("vmstat -s", intern=TRUE)
      vmstat.df <- namedCapture::str_match_variable(
        vmstat.lines,
        " *",
        value="[0-9]+", as.numeric,
        " ",
        name=".*")
      vmstat.df$megabytes <- as.integer(vmstat.df$value/1024)
      vmstat.df
    }
    
    ## Take a character vector of chromosomes such as chr1, chr2,
    ## chr10, chr20, chrX, chrY, chr17, chr17_ctg5_hap1 and assign
    ## each a number that sorts them first numerically if it exists,
    ## then using the _suffix, then alphabetically.
    orderChrom <- function(chrom.vec, ...){
      stopifnot(is.character(chrom.vec))
      value.vec <- unique(chrom.vec)
      chr.mat <- namedCapture::str_match_variable(
        value.vec,
        "chr",
        name_or_number="[^:_]+",
        extra_name="_[^:]*", "?",
        ":?",
        chromStart="[^-]*", "?",
        "-?",
        chromEnd="[^-]*", "?") 
      did.not.match <- is.na(chr.mat[, 1])
      if(any(did.not.match)){
        print(value.vec[did.not.match])
        stop("chroms did not match ", chr.pattern)
      }
      ord.vec <- order(
        suppressWarnings(as.numeric(chr.mat[, "name_or_number"])),
        chr.mat[, "name_or_number"],
        chr.mat[, "extra_name"],
        as.numeric(chr.mat[, "chromStart"]))
      rank.vec <- seq_along(value.vec)
      names(rank.vec) <- value.vec[ord.vec]
      order(rank.vec[chrom.vec], ...)
    }
    
    test.input <- data.frame(
      chrom=c("chr1", "chr1", "chr10", "chr2", "chrY", "chrX", "chr17_ctg5_hap1", "chr21", "chr17"),
      pos = c(     2,      1,      0,       0,      0,      0,       0,      0,           0))
    test.output <- test.input[with(test.input, orderChrom(paste(chrom), pos)),]
    stopifnot(identical(
      paste(test.output$chrom),
      c("chr1", "chr1", "chr2", "chr10", "chr17", "chr17_ctg5_hap1", "chr21", "chrX", "chrY")
      ))
    stopifnot(identical(
      test.output$pos,
      c(1, 2, 0, 0, 0, 0, 0, 0, 0)))
    
    factorChrom <- function(chrom.vec){
      u.vec <- unique(chrom.vec)
      ord.vec <- u.vec[orderChrom(u.vec)]
      factor(chrom.vec, ord.vec)
    }
    ## Converting color hex strings to matrices in R.
    ann.colors <- c(
      noPeaks="#f6f4bf",
      peakStart="#ffafaf",
      peakEnd="#ff4c4c",
      peaks="#a445ee")
    hex.mat <- namedCapture::str_match_variable(
      ann.colors,
      "#?",
      red="[0-9a-fA-F]{2}",
      green="[0-9a-fA-F]{2}",
      blue="[0-9a-fA-F]{2}")
    dec.mat <- apply(hex.mat, 2, function(x)strtoi(paste0("0x", x)))
    
  }

})

## CRAN says that Suggests packages should be used conditionally, so
## the package should pass checks without them.
check_without_suggests <- function(pkg.path){
  Suggests.vec <- remotes::local_package_deps(pkg.path, "Suggests")
  lib <- .libPaths()[1]##assumes Suggests packages are in this first lib.
  tmp.lib <- tempdir()
  old.paths <- file.path(lib, Suggests.vec)
  tmp.paths <- file.path(tmp.lib, Suggests.vec)
  file.rename(old.paths, tmp.paths)
  on.exit({
    file.rename(tmp.paths, old.paths)
  })
  ## ignore vignettes because re-building them may require Suggests
  ## packages e.g. knitr.
  devtools::check_built(pkg.path, args="--ignore-vignettes")
}
