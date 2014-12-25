package org.rslick

import org.slf4j.LoggerFactory

import scala.slick.driver.JdbcDriver.backend.{Database, Session => SlickSession}
import scala.slick.jdbc.{GetResult, PositionedResult, StaticQuery => Q}

case class Data(columnName: String, columnType: RType, values: List[Any])

object SqlExecuter {
  val logger = LoggerFactory.getLogger(getClass)

  implicit object GetString extends GetResult[Any] {
    def apply(pr: PositionedResult) = {
      val rs = pr.rs
      val md = rs.getMetaData
      (1 to pr.numColumns).map { i => (md.getColumnName(i), md.getColumnTypeName(i), rs.getObject(i)) }.toVector
    }
  }

  def session(url: String, driver: String, user: String, password: String): Session = {
    new Session(Database.forURL(url, driver = driver, user = user, password = password)
                .createSession(), driver)
  }

  def execute(session: Session, sqlTemplate: String, name: String, value: String): Array[Data] = {
    execute(session, sqlTemplate, Array(name), Array(value))
  }

  def execute(session: Session, sqlTemplate: String, names: Array[String], values: Array[String]): Array[Data] = {
    implicit val s: SlickSession = session.instance
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
    val res: Array[Data] = Q.queryNA[Any](sql).list match {
      case List() => Array()
      case List(a: Int) => Array(Data("result", RType.Integer, List(a)))
      case vectors =>
        val mp =
          vectors.flatMap { case vector: Vector[Any] => vector.map { case (cn:String, ct:String, v:Any) => ((cn, ct), v) }}
                 .groupBy { _._1 }
                 .map { case ((cn, ct), vals) => cn -> Data(cn, RType.map(session.driver, ct, PartialFunction.empty), vals.map{_._2}) }
        vectors.head.asInstanceOf[Vector[Any]].map { case (cn: String, _, _) => mp(cn) }.toArray
    }
    res
  }
}
