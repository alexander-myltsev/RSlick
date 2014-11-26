require(rJava)

#' Creates rSlick session that should be called on in slick.sql
#' 
#' @export
slick.session1 <- function(url, driver, user, password) {
  .jnew("org.rslick.SqlExecuter", url, driver, user, password)
}

#' Evaluates given sql template against created session
#' 
#' @param sql is a template. \{\{id\}\} would be replaced by provided parameter with name `id`
#' @param ... list of named parameters
#' 
#' @export
slick.sql <- function(session, sql, ...) {
  params <- c(...)
  list <- session$execute(sql, names(params), as.character(params))
  res <- c()
  while (list$size() > 0) {
    res <- c(res, list$head())
    list <- list$tail()
  }
  return(res)
}
