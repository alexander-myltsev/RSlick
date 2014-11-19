package org.rslick

import scala.collection.mutable.ListBuffer
import scala.slick.driver.JdbcDriver.backend.Database
import scala.slick.jdbc.{StaticQuery => Q, PositionedResult, GetResult}

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

  def execute(sql: java.lang.String): java.util.List[java.lang.String] = {
    Database.forURL(url, driver = driver, user = user, password = password) withSession { implicit session =>
      import scala.collection.JavaConversions.seqAsJavaList
      Q.queryNA[String](sql).list
    }
  }
}
