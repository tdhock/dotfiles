# -*- Mode: R -*-
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
  for(pkg in names(pkg.vers)){
    if(!suppressWarnings(require(pkg, character.only=TRUE))){
      install.packages(pkg)
    }
    pkg_ok_have(pkg, pkg.vers[[pkg]], packageVersion(pkg))
    library(pkg, character.only=TRUE)
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
    captured.groups <- do.call(rbind,lapply(seq_along(string),function(i){
      st <- attr(parsed,"capture.start")[i,]
      if(is.na(parsed[i]) || parsed[i]==-1)return(rep(NA,length(st)))
      substring(string[i],st,st+attr(parsed,"capture.length")[i,]-1)
    }))
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
      starts <- attr(r,"capture.start")
      if(r[1]==-1)return(matrix(nrow=0,ncol=1+ncol(starts)))
      names <- attr(r,"capture.names")
      lengths <- attr(r,"capture.length")
      full <- substring(string[i],r,r+attr(r,"match.length")-1)
      subs <- substring(string[i],starts,starts+lengths-1)
      m <- matrix(c(full,subs),ncol=length(names)+1)
      colnames(m) <- c("",names)
      m
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
  ## of a file.
  wc <- function(f){
    stopifnot(is.character(f))
    stopifnot(length(f)==1)
    if(file.exists(f)){
      cmd <- sprintf("wc -l '%s'",f)
      as.integer(sub(" .*","",system(cmd,intern=TRUE)))
    }else{
      0L
    }
  }
})

