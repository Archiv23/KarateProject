package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class PerfTest extends Simulation {

  val protocol = karateProtocol(

  )

  //protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
  //protocol.runner.karateEnv("perf")

  val createArticle = scenario("create and delete article").exec(karateFeature("classpath:conduitApp/performance/CreateDeleteArticle.feature"))
  //val delete = scenario("delete").exec(karateFeature("classpath:mock/cats-delete.feature@name=delete"))

  setUp(
    //createArticle.inject(rampUsers(10) during (5 seconds)).protocols(protocol)
    //,
    //delete.inject(rampUsers(5) during (5 seconds)).protocols(protocol)
    createArticle.inject(atOnceUsers(1)).protocols(protocol)
  )

}