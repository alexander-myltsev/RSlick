require(jvmr)

#' Executes SQL
#' 
#' @export
anorm.sql <- function(sql.driver, sql.connection.string, sql) {
  options(jvmr.class.path = c("./lib/anorm_2.11-2.4-SNAPSHOT.jar", "./lib/joda-time-2.3.jar", "./lib/scala-arm_2.11-1.4.jar", "./lib/scala-library-2.11.3.jar", "./lib/joda-convert-1.6.jar", "./lib/mysql-connector-java-5.1.12.jar", "./lib/scala-continuations-library_2.11-1.0.1.jar", "./lib/scala-parser-combinators_2.11-1.0.2.jar", "./lib/nzjdbc.jar"))
  
  si <- scalaInterpreter()
  si['
import anorm._
import java.sql.DriverManager

Class.forName("${1}")
val connectionString = "${2}"
implicit val conn = DriverManager.getConnection(connectionString)

SQL("${3}").executeQuery().apply().toList
     ', sql.driver, sql.connection.string, sql, echo.output = FALSE]
}