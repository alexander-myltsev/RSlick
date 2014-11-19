package org.rslick

import scala.collection.mutable.ListBuffer
import scala.slick.driver.JdbcDriver.backend.Database
import scala.slick.jdbc.{GetResult, PositionedResult, StaticQuery => Q}

class SqlExecuter(url: String, driver: String, user: String, password: String) {
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

  def execute(sqlTemplate: String, names: Array[String], values: Array[String]): Array[String] = {
    Database.forURL(url, driver = driver, user = user, password = password) withSession { implicit session =>
      val sql = names.zip(values).foldLeft(sqlTemplate) { case (s, (n, v)) => s.replace(s"""{{$n}}""", v) }
      Q.queryNA[String](sql).list.toArray
    }
  }
}
