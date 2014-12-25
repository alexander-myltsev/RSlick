package org.rslick

sealed trait RType { val name: String }
object RType {
  object Character extends RType { val name = "character" }
  object Numeric extends RType { val name = "numeric" }
  object Integer extends RType { val name = "integer" }
  object Logical extends RType { val name = "logical" }
  object Date extends RType { val name = "date" }

  def map(driver: String, typ: String, custom: PartialFunction[String, RType]): RType = driver match {
    case "org.h2.Driver" => typ match {
      case "INT" | "INTEGER" | "TINYINT" | "SMALLINT" | "BIGINT" | "IDENTITY" => Integer
      case "DECIMAL" | "DOUBLE" | "REAL" => Numeric
      case "BOOLEAN" => Logical
      case "DATE" | "TIMESTAMP" => Date
      case "VARCHAR" => Character
      case t => custom(t)
    }
    case "com.mysql.jdbc.Driver" => typ match {
      case "CHAR" | "VARCHAR" | "TINYTEXT" | "TEXT" => Character
      case "TINYINT" | "SMALLINT" | "MEDIUMINT" | "INT" | "BIGINT" => Integer
      case "FLOAT" | "DOUBLE" | "DECIMAL" => Numeric
      case "DATE" | "DATETIME" | "TIMESTAMP" | "TIME" | "YEAR" => Date
      case t => custom(t)
    }
    case _ => custom(typ)
  }
}
