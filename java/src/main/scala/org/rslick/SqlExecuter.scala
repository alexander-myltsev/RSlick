package org.rslick

import org.slf4j.LoggerFactory

import scala.collection.mutable.ListBuffer
import scala.slick.driver.JdbcDriver.backend.{Database, Session}
import scala.slick.jdbc.{GetResult, PositionedResult, StaticQuery => Q}

object SqlExecuter {
  val logger = LoggerFactory.getLogger(getClass)

  implicit object GetString extends GetResult[String] {
    def apply(rs: PositionedResult) = {
      val lb = ListBuffer.empty[String]
      while (rs.hasMoreColumns) {
        lb.append(rs.nextString())
      }
      if (lb.length > 1) {
        lb.mkString("(", ", ", ")")
      } else {
        lb.mkString(", ")
      }
    }
  }

  def session(url: String, driver: String, user: String, password: String): Session = {
    Database.forURL(url, driver = driver, user = user, password = password)
            .createSession()
  }

  def execute(session: Session, sqlTemplate: String, name: String, value: String): List[String] = {
    execute(session, sqlTemplate, Array(name), Array(value))
  }

  def execute(session: Session, sqlTemplate: String, names: Array[String], values: Array[String]): List[String] = {
    implicit val s: Session = session
    val sql =
      if (names == null || values == null) {
        sqlTemplate
      } else {
        names
          .zip(values)
          .filterNot { case (n, v) => n.isEmpty}
          .foldLeft(sqlTemplate) { case (str, (n, v)) => str.replace( s"""{{$n}}""", v)}
      }
    println(s"# executing SQL: $sql")
    Q.queryNA[String](sql).list
  }
}
