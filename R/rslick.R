require(rJava)

#' Creates RSlick session that should be provided to slick.sql
#' 
#' @param url URL to database
#' @param driver JDBC driver to be used for connection
#' @param user User name that has access to database
#' @param password User password that has access to database
#' 
#' @export
slick.session <- function(url, driver, user = "", password = "") {
  .jcall("org/rslick/SqlExecuter", "Lscala/slick/jdbc/JdbcBackend$SessionDef;", "session", url, driver, user, password)
}

#' Evaluates given sql template against created session
#' 
#' @param sql is a template. \{\{id\}\} would be replaced by provided parameter with name `id`
#' @param ... list of named parameters
#' 
#' @export
slick.sql <- function(session, sql, ...) {
  params <- c(...)
  list <- .jcall("org/rslick/SqlExecuter", "Lscala/collection/immutable/List;", "execute", session, sql, as.character(names(params)), as.character(params))
  res <- c()
  while (list$size() > 0) {
    res <- c(res, list$head())
    list <- list$tail()
  }
  return(res)
}
