slick.classpath = c()

cwd <- getwd()

path <- paste(dirname(system.file(".",package="RSlick")), .Platform$file.sep, "", sep="")
lib.java.path <- paste(path, "java", sep="")
dir.create(lib.java.path, recursive=TRUE, showWarnings=FALSE)
setwd(lib.java.path)
rslick.jars <- c("RSlick-Scala-0.1.0.jar", "mysql-connector-java-5.1.12.jar", "h2-1.4.182.jar")

download.sites <- c("file:///home/alex/tmp/", "http://github.com/alexander-myltsev/RSlick/releases/download/v0.1.0/")
for ( jarName in rslick.jars ) {
  localUrl <- paste(download.sites[1], jarName, sep="")
  tryCatch({
    download.file(localUrl, jarName, mode="wb", quiet=FALSE)
    print(paste("loaded locally:", jarName))
  }, error = function(e) {
      remoteUrl <- paste(download.sites[2], jarName, sep="")
      download.file(remoteUrl, jarName, mode="wb", quiet=FALSE, method="wget")
    }
  )
}

setwd(cwd)
