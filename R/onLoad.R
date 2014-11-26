.onLoad <- function(libname, pkgname) {
  require(rJava)
  cp = as.character(sapply(rSlick.jars, 
                           function(jar) { paste(lib.java.path, .Platform$file.sep, jar, sep="") } ))
  .jinit(classpath =  cp)
}
