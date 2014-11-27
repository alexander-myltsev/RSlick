\name{RSlick-package}
\alias{RSlick-package}
\alias{RSlick}
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
Package: \tab RSlick\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2014-11-14\cr
License: \tab Apache 2 [http://www.apache.org/licenses/LICENSE-2.0]\cr
}
}

\usage{
session <- slick.session(url, driver, user, password) # creates connection session to database
slick.sql(session, sql, ...) # runs SQL statement against created session
slick.sql(session, "SELECT * FROM test WHERE id > {{id}}", id=2)
}

\examples{
session <- slick.session("jdbc:h2:mem:test1", "org.h2.Driver")
slick.sql(session, 'create table "TEST" ("ID" INTEGER NOT NULL PRIMARY KEY,  "NAME" VARCHAR NOT NULL)')
# executing SQL: create table "TEST" ("ID" INTEGER NOT NULL PRIMARY KEY,  "NAME" VARCHAR NOT NULL)
# [1] 0
slick.sql(session, 'insert into "TEST" ("ID","NAME") values (1, \'abc\'), (2, \'efg\'), (3, \'kkk\')')
# executing SQL: insert into "TEST" ("ID","NAME") values (1, 'abc'), (2, 'efg'), (3, 'kkk')
# [1] 3
slick.sql(session, 'insert into "TEST" ("ID","NAME") values (10, \'abc\'), (20, {{v}}), (30, {{v}})', v="'kkkkk'")
# executing SQL: insert into "TEST" ("ID","NAME") values (10, 'abc'), (20, 'kkkkk'), (30, 'kkkkk')
# [1] 3
slick.sql(session, 'select * from "TEST"')
# executing SQL: select * from "TEST"
# [1] "(1, abc)"    "(2, efg)"    "(3, kkk)"    "(10, abc)"   "(20, kkkkk)" "(30, kkkkk)"
slick.sql(session, 'select * from "TEST" where "ID" > {{id}}', id=2)
# executing SQL: select * from "TEST" where "ID" > 2
# [1] "(3, kkk)"    "(10, abc)"   "(20, kkkkk)" "(30, kkkkk)"
slick.sql(session, 'update "TEST" set "NAME"={{v}} where "ID" > {{id}}', id=2, v="'hhhhhhhh'")
# executing SQL: update "TEST" set "NAME"='hhhhhhhh' where "ID" > 2
# [1] 4
slick.sql(session, 'select * from "TEST"')
# executing SQL: select * from "TEST"
# [1] "(1, abc)"       "(2, efg)"       "(3, hhhhhhhh)"  "(10, hhhhhhhh)" "(20, hhhhhhhh)" "(30, hhhhhhhh)"
slick.sql(session, 'delete from "TEST" where "ID" > {{id1}} and "ID" < {{id2}}', id1=2, id2=25)
# executing SQL: delete from "TEST" where "ID" > 2 and "ID" < 25
# [1] 3
slick.sql(session, 'select * from "TEST"')
# executing SQL: select * from "TEST"
# [1] "(1, abc)"       "(2, efg)"       "(30, hhhhhhhh)"
}


\references{
RSlick is a wrapper of Scala Slick library. Scala Slick plain queries [http://slick.typesafe.com/doc/2.1.0/upgrade.html#static-plain-sql-queries] are used under the hood while running SQL statements.
}

\author{
Sergei Izrailev (https://github.com/sizrailev)
Alexander Myltsev (https://github.com/alexander-myltsev)

Maintainer: Alexander Myltsev <alexander.myltsev@phystech.edu>
}

\keyword{package}
\keyword{interface}