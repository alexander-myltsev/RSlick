\name{rSlick-package}
\alias{rSlick-package}
\alias{rSlick}
\docType{package}
\title{
SQL templating package
}
\description{
Cross-platform, self-contained packange for running SQL statements.
The package provides unified interface for all types of SQL statements.
It is shipped with SQL templating language that expands to SQL statement before run.
Supported JDBC drivers:
* mysql-connector-java-5.1.12.jar
}

\details{
\tabular{ll}{
Package: \tab rSlick\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2014-11-14\cr
License: \tab Apache 2 [http://www.apache.org/licenses/LICENSE-2.0]\cr
}
}

\usage{
> library(devtools); devtools::install_github("alexander-myltsev/rSlick")
> library(rSlick)
> session <- slick.session(url, driver, user, password) # creates connection session to database
> slick.sql(session, sql, ...) # runs SQL statement against created session

sql is an SQL template. SQL templates are plain strings that contain arguments in double curly brackets. Arguments will be substituted by provided named values. For exapmle, in statement 

> slick.sql(session, "SELECT * FROM test WHERE id > {{id}}", id=2)

"SELECT * FROM test WHERE id > {{id}}" is SQL template. Substring "{{id}}" will be substituted by string "2" as named argument "id=2" is provided. "SELECT * FROM test WHERE id > 2" will be executed against created session.

}

\examples{
> session <- slick.session(url = "jdbc:mysql://localhost:3306/test", driver = "com.mysql.jdbc.Driver", user = "user", password = "password")
> slick.sql(session, "SELECT * FROM test")
[1] "(3, kdeee, cc)" "(7, test, eem)" "(7, test, eem)" "(7, test, eem)" "(7, test, eem)" "(7, test, eem)"
[7] "(1, a, hhh)"    "(2, b, hhh)"
> slick.sql(session, "SELECT * FROM test WHERE id > {{id}}", id=2)
executing SQL: SELECT * FROM test WHERE id > 2
[1] "(3, kdeee, cc)" "(7, test, eem)" "(7, test, eem)" "(7, test, eem)" "(7, test, eem)" "(7, test, eem)"
> slick.sql(session, "INSERT INTO test (id, name, vaule) VALUES (10, 'X', {{v}}), (20, 'Y', {{v}})", v="'hhh'") # returns number of successfully added rows
executing SQL: INSERT INTO test (id, name, vaule) VALUES (10, 'X', 'hhh'), (20, 'Y', 'hhh')
[1] 2
> slick.sql(session, "SELECT * FROM test WHERE id > {{id}}", id=9)
executing SQL: SELECT * FROM test WHERE id > 9
[1] "(10, X, hhh)" "(20, Y, hhh)"
}


\references{
rSlick is a wrapper of Scala Slick library. Scala Slick plain queries [http://slick.typesafe.com/doc/2.1.0/upgrade.html#static-plain-sql-queries] are used under the hood while running SQL statements.
}

\author{
Sergei Izrailev (https://github.com/sizrailev)
Alexander Myltsev (https://github.com/alexander-myltsev)

Maintainer: Alexander Myltsev <alexander.myltsev@phystech.edu>
}

\keyword{package}
\keyword{interface}