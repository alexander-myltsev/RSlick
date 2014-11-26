name := "lib-src"

version := "0.1"

scalaVersion := "2.11.4"

libraryDependencies ++= Seq(
  "com.typesafe.slick"             %% "slick"              % "2.1.0"
)

assemblyJarName in assembly := s"rSlick-lib-${version.value}.jar"
