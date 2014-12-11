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
* MySQL: mysql-connector-java-5.1.12.jar
* H2: h2-1.4.182.jar
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
slick.sql(session, 'insert into "TEST" ("ID","NAME") values (1, \'name1\'), (2, \'name2\'), (3, \'name3\')')
# executing SQL: insert into "TEST" ("ID","NAME") values (1, 'name1'), (2, 'name2'), (3, 'name3')
# [1] 3
slick.sql(session, 'insert into "TEST" ("ID","NAME") values (10, \'abc\'), (20, {{v}}), (30, {{v}})', v="'some_name'")
# executing SQL: insert into "TEST" ("ID","NAME") values (10, 'abc'), (20, 'some_name'), (30, 'some_name')
# [1] 3
slick.sql(session, 'select * from "TEST"')
# executing SQL: select * from "TEST"
# [1] "(1, name1)"      "(2, name2)"      "(3, name3)"      "(10, abc)"       "(20, some_name)" "(30, some_name)"
slick.sql(session, 'select * from "TEST" where "ID" > {{id}}', id=2)
# executing SQL: select * from "TEST" where "ID" > 2
# [1] "(3, name3)"      "(10, abc)"       "(20, some_name)" "(30, some_name)"
slick.sql(session, 'update "TEST" set "NAME"={{v}} where "ID" > {{id}}', id=2, v="'new_name'")
# executing SQL: update "TEST" set "NAME"='new_name' where "ID" > 2
# [1] 4
slick.sql(session, 'select * from "TEST"')
# executing SQL: select * from "TEST"
# [1] "(1, name1)"     "(2, name2)"     "(3, new_name)"  "(10, new_name)" "(20, new_name)" "(30, new_name)"
slick.sql(session, 'delete from "TEST" where "ID" > {{id1}} and "ID" < {{id2}}', id1=2, id2=25)
# executing SQL: delete from "TEST" where "ID" > 2 and "ID" < 25
# [1] 3
slick.sql(session, 'select * from "TEST"')
# executing SQL: select * from "TEST"
# [1] "(1, name1)"     "(2, name2)"     "(30, new_name)"
}


\references{
RSlick is a wrapper package of Scala Slick library [http://slick.typesafe.com]. Scala Slick plain queries [http://slick.typesafe.com/doc/2.1.0/upgrade.html#static-plain-sql-queries] are used under the hood while running SQL statements.
}

\author{
Sergei Izrailev (https://github.com/sizrailev)
Alexander Myltsev (https://github.com/alexander-myltsev)

Maintainer: Alexander Myltsev <alexander.myltsev@phystech.edu>
}

\keyword{package}
\keyword{interface}