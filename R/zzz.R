cwd <- getwd()

path <- paste(dirname(system.file(".",package="rSlick")), .Platform$file.sep, "", sep="")
lib.java.path <- paste(path, "java", sep="")
dir.create(lib.java.path, recursive=TRUE, showWarnings=FALSE)
setwd(lib.java.path)
rSlick.jars <- c("rSlick-lib-0.1.jar", "mysql-connector-java-5.1.12.jar")

download.sites <- c("file:///home/alex/tmp/", "http://github.com/alexander-myltsev/rSlick/releases/download/v0.1/")
for ( jarName in rSlick.jars ) {
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
