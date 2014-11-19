.onLoad <- function(libname, pkgname) {
  require(rJava)
  .jinit(classpath = c("./lib/rSlick-lib.jar"))
}
