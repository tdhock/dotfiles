Sys.glob("*/NEWS")
NEWS <- "~/teaching/regex-tutorial/NEWS/old/animint2.txt"
change.dt <- nc::capture_all_str(
  NEWS,
  version="[0-9]+[.][0-9]+[.][0-9]+",
  "\\s*\n",
  changes="(?:[^0-9].*\n*)*")
change.dt[, change.list := strsplit(changes, "\n\n")]
change.dt[, new.str := sapply(change.list, function(change.vec){
  no.newline <- gsub("\n", " ", change.vec)
  no.empty <- grep("^\\s*$", no.newline, value=TRUE, invert=TRUE)
  with.dash <- paste0("- ", no.empty)
  paste(with.dash, collapse="\n")
})]
change.dt[, new.block := sprintf(
  "Changes in version %s\n\n%s", version, new.str)]
out.str <- paste(change.dt$new.block, collapse="\n\n")
cat(out.str)
old.dir <- dirname(NEWS)
NEWS.dir <- dirname(old.dir)
new.txt <- file.path(NEWS.dir, "new", basename(NEWS))
cat(out.str, file=new.txt)
bad.dt <- nc::capture_all_str(
  new.txt,
  dash_alone="\n-\\s*\n")
if(nrow(bad.dt)){
  stop("found ", nrow(bad.dt), " empty line(s)")
}
