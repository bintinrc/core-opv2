package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.CodReportPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.text.ParseException;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CodReportSteps extends AbstractSteps
{
    private CodReportPage codReportPage;

    @Inject
    public CodReportSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        codReportPage = new CodReportPage(getWebDriver());
    }

    @When("^Operator filter COD Report by Mode = \"([^\"]*)\" and Date = \"([^\"]*)\"$")
    public void operatorFilterCodReportByGivenModeAndDate(String mode, String dateAsString)
    {
        try
        {
            codReportPage.filterCodReportBy(mode, YYYY_MM_DD_SDF.parse(dateAsString));
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @Then("^Operator verify order is exist on COD Report table with correct info$")
    public void operatorVerifyOrderIsExistWithCorrectInfo()
    {
        Order order = get(KEY_ORDER_DETAILS);
        codReportPage.verifyOrderIsExistWithCorrectInfo(order);
    }

    @When("^Operator download COD Report$")
    public void operatorDownloadCodReport()
    {
        codReportPage.downloadCsvFile();
    }

    @Then("^Operator verify the downloaded COD Report data is correct$")
    public void operatorVerifyTheDownloadedCodReportDataIsCorrect()
    {
        Order order = get(KEY_ORDER_DETAILS);
        codReportPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(order);
    }
}
