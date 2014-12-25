package org.rslick

import scala.slick.driver.JdbcDriver.backend.{Session => SlickSession}

class Session(val instance: SlickSession, val driver: String)
