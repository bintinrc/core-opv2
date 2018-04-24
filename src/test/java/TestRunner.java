import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Cucumber - Junit link. Invoke with "gradle test".
 * Sync the configuration here to build.gradle file.
 *
 * @author Ferdinand Kurniadi
 */
@RunWith(Cucumber.class)
@CucumberOptions
(
    plugin =
    {
        "pretty",
        "html:build/reports/cucumber-junit/htmloutput",
        "json:build/reports/cucumber-junit/cucumber.json",
        "junit:build/reports/cucumber-junit/cucumber.xml"
    },
    monochrome = true,
    glue =
    {
        "com.nv.qa.cucumber.glue"
    },
    features =
    {
        "src/test/resources/cucumber/feature"
    }
)
public class TestRunner
{
    public static void main(String[] args)
    {
    }
}
