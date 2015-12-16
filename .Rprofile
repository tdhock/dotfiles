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
          "http://probability.ca/cran",
          "http://cran.r-project.org"))

if(interactive())suppressMessages({
  options(bitmapType="cairo")
  require(grDevices)
  X11.options(type="cairo")
  x11(width=17.5,height=10.2,xpos=-1,ypos=-1)
  library(lattice)
  lattice.options(print.function = function(x, ...) {
    if ( (length(dim(x)) == 2) && require(latticeExtra) ){
      plot(useOuterStrips(x),...)
    }else{
      plot(x, ...)
    }
  },default.args={
    list(as.table=TRUE,
         strip=strip.custom(strip.names=TRUE),
         strip.left=strip.custom(strip.names=TRUE))
  })
  if(require(RColorBrewer)){
    require(grDevices)
    custom.pal <- brewer.pal(9,"Set1")
    custom.pal[6] <- "#DDDD33"
    trellis.par.set(theme=simpleTheme(col=custom.pal))
    ##show.settings()
  }
  if(require(ggplot2)){
    theme_set(theme_bw())
    facet_grid_label <- function(f,...){
      facet_grid(f,labeller=function(var,val)sprintf("%s : %s",var,val))
    }
  }

  ## Parse the first occurance of pattern from each of several strings
  ## using (named) capturing regular expressions, returning a matrix
  ## (with column names).
  str_match_perl <- function(string,pattern){
    stopifnot(is.character(string))
    stopifnot(is.character(pattern))
    stopifnot(length(pattern)==1)
    parsed <- regexpr(pattern,string,perl=TRUE)
    captured.text <- substr(string,parsed,parsed+attr(parsed,"match.length")-1)
    captured.text[captured.text==""] <- NA
    captured.groups <- if(is.null(attr(parsed, "capture.start"))){
      NULL
    }else{
      do.call(rbind,lapply(seq_along(string),function(i){
        st <- attr(parsed,"capture.start")[i,]
        if(is.na(parsed[i]) || parsed[i]==-1)return(rep(NA,length(st)))
        substring(string[i],st,st+attr(parsed,"capture.length")[i,]-1)
      }))
    }
    result <- cbind(captured.text,captured.groups)
    colnames(result) <- c("",attr(parsed,"capture.names"))
    result
  }
  regexpr.groups <- function(pattern,string){
    str_match_perl(string,pattern)[,-1]
  }

  ## Parse several occurances of pattern from each of several strings
  ## using (named) capturing regular expressions, returning a list of
  ## matrices (with column names).
  str_match_all_perl <- function(string,pattern){
    stopifnot(is.character(string))
    stopifnot(is.character(pattern))
    stopifnot(length(pattern)==1)
    parsed <- gregexpr(pattern,string,perl=TRUE)
    lapply(seq_along(parsed),function(i){
      r <- parsed[[i]]
      full <- substring(string[i],r,r+attr(r,"match.length")-1)
      starts <- attr(r,"capture.start")
      if(is.null(starts)){
        m <- cbind(full)
        colnames(m) <- ""
        m
      }else{
        if(r[1]==-1)return(matrix(nrow=0,ncol=1+ncol(starts)))
        names <- attr(r,"capture.names")
        lengths <- attr(r,"capture.length")
        subs <- substring(string[i],starts,starts+lengths-1)
        m <- matrix(c(full,subs),ncol=length(names)+1)
        colnames(m) <- c("",names)
        m
      }
    })
  }
  gregexpr.groups <- function(pattern,string){
    lists <- str_match_all_perl(string,pattern)
    lapply(lists,function(m)m[,-1])
  }

  ## Parse html to find the first occurence of match which is preceded
  ## by before. A quick way to parse 1 thing out of several files.
  get.first <- function(html,before,match){
    stopifnot(is.character(before))
    stopifnot(is.character(match))
    stopifnot(length(before)==1)
    stopifnot(length(match)==1)
    pattern <- sprintf("%s(%s)",before,match)
    p <- regexpr(pattern,html,perl=TRUE)
    st <- attr(p,"capture.start")
    substr(html,st,st+attr(p,"capture.length")-1)
  }

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
    browser()
    if(any(h > 0)){
      sprintf("%dh%dm", h, m)
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

  vmstat <- function(){
    vmstat.pattern <-
      paste0(" *",
             "(?<value>[0-9]+)",
             " ",
             "(?<variable>.*)")
    vmstat.lines <- system("vmstat -s", intern=TRUE)
    vmstat.mat <- str_match_perl(vmstat.lines, vmstat.pattern)
    vmstat.df <-
      data.frame(value=as.numeric(vmstat.mat[, "value"]),
                 row.names=vmstat.mat[, "variable"])
    vmstat.df$megabytes <- as.integer(vmstat.df$value/1024)
    vmstat.df
  }

  free <- function(){
    free.lines <- system("free -m", intern=TRUE)
    df <- read.table(text=free.lines, sep=":", row.names=1)
    names(df) <- "values"
    mb.text <- sub(" +.*", "", sub("^ *", "", df$values))
    data.frame(megabytes=as.numeric(mb.text),
               row.names=c("total", "used", "swap"))
  }
  
  ann.colors <-
    c(noPeaks="#f6f4bf",
      peakStart="#ffafaf",
      peakEnd="#ff4c4c",
      peaks="#a445ee")
  hex.color.pattern <-
    paste0("#?",
           "(?<red>[0-9a-fA-F]{2})",
           "(?<green>[0-9a-fA-F]{2})",
           "(?<blue>[0-9a-fA-F]{2})")
  hex.mat <- str_match_perl(ann.colors, hex.color.pattern)
  dec.mat <- apply(hex.mat[,-1], 2, function(x)strtoi(paste0("0x", x)))
  dput(apply(dec.mat, 1, paste, collapse=","))
})

