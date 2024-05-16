package conduitApp;

// import com.intuit.karate.Results;
// import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

// import static org.junit.jupiter.api.Assertions.*;
// import org.junit.jupiter.api.Test;

class ConduitTest {

    // @Test
    // void testParallel() {
    //     Results results = Runner.path("classpath:conduitApp")
    //             //.outputCucumberJson(true)
    //             .parallel(5);
    //     assertEquals(0, results.getFailCount(), results.getErrorMessages());
    // }

    // this will run all *.feature files that esists in sub-directories
    // see https://github.com/intuit/karate#naming-conventions

    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }    

    
    // @Karate.Test
    // Karate testTags() {
    //     return Karate.run().tags("@smoke").relativeTo(getClass());
    // } 

}
