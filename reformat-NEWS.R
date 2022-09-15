Sys.glob("*/NEWS")
NEWS <- "animint2/NEWS"
change.dt <- nc::capture_all_str(
  NEWS,
  version="[0-9]+[.][0-9]+[.][0-9]+",
  "\\s*\n",
  changes="(?:[^0-9].*\n*)*")
change.dt[, change.list := strsplit(changes, "\n\n")]
change.dt[, new.str := sapply(change.list, function(change.vec){
  no.newline <- gsub("\n", " ", change.vec)
  with.dash <- paste0("- ", no.newline)
  paste(with.dash, collapse="\n")
})]
change.dt[, new.block := sprintf(
  "Changes in version %s\n\n%s", version, new.str)]
out.str <- paste(change.dt$new.block, collapse="\n\n")
cat(out.str)
