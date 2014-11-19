require(rJava)

#' Creates rSlick session that should be called on in slick.sql
#' 
#' @export
slick.session <- function(url, driver, user, password) {
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
  session$execute(sql, names(params), as.character(params))
}
