#' Creates RSlick session that should be provided to slick.sql
#' 
#' @param classpath Classpath that is provided to JVM to search for new JDBC drivers
#' @param url URL to database
#' @param driver JDBC driver to be used for connection
#' @param user User name that has access to database
#' @param password User password that has access to database
#' 
#' @export
slick.session <- function(url, driver, user = "", password = "", classpath = c()) {
  require(rJava)
  .jpackage("RSlick", morePaths=c(".", classpath))
  .jcall("org/rslick/SqlExecuter", "Lorg/rslick/Session;", "session", url, driver, user, password)
}

#' Evaluates given sql template against created session
#' 
#' @param sql is a template. \{\{id\}\} would be replaced by provided parameter with name `id`
#' @param ... list of named parameters
#' 
#' @export
slick.sql <- function(session, sql, ...) {
  params <- c(...)
  dataArr <- .jcall("org/rslick/SqlExecuter", "[Lorg/rslick/Data;", "execute", session, sql, as.character(names(params)), as.character(params))
  
  if (length(dataArr) == 0) 
    return (data.frame())
  
  labels <- mapply(function (obj) { obj$columnName() }, dataArr)
  
  extractValues <- function(obj) {
    jlist <- obj$values()
    v <- c()
    while (jlist$size() > 0) {
      v  <- c(v, jlist$head())
      jlist <- jlist$tail()
    }
    
    t <- obj$columnType()$name()
    res = if (t == "character") {
      as.character(v)
    } else if (t == "numeric") {
      as.numeric(v)
    } else if (t == "integer") {
      as.integer(v)
    } else if (t == "logical") {
      as.logical(v)
    } else if (t == "date") {
      as.Date(v)
    } else {
      stop (sprintf("unexpected type of column %s", t))
    }
    return (res)
  }
  
  res <- data.frame(extractValues(dataArr[[1]]))
  
  if (length(dataArr) > 1) {
    for (i in 2:length(dataArr)) {
      obj <- dataArr[[i]]
      res[, i] <- extractValues(obj)
    }
  }

  names(res) <- labels

  return(res)
}
