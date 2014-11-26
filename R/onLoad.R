.onLoad <- function(libname, pkgname) {
  require(rJava)
  .jpackage(pkgname, morePaths=".")
}
