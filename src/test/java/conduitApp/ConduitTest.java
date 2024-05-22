package conduitApp;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import com.intuit.karate.junit5.Karate;
import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;




class ConduitTest {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:conduitApp")
                .outputCucumberJson(true)
                .parallel(1);
                generateReport(results.getReportDir());
                assertTrue(results.getFailCount() == 0, results.getErrorMessages());
    }




    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "conduitApp");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }




    // this will run all *.feature files that esists in sub-directories
    // see https://github.com/intuit/karate#naming-conventions

    // @Karate.Test
    // Karate testAll() {
    //     return Karate.run().relativeTo(getClass());
    // }    

    
    // @Karate.Test
    // Karate testTags() {
    //     return Karate.run().tags("@smoke").relativeTo(getClass());
    // } 

}
