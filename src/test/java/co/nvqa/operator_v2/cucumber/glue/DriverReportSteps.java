package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.DriverReportPage;
import cucumber.api.java.en.When;

import javax.inject.Inject;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverReportSteps extends AbstractSteps
{
    private DriverReportPage driverReportPage;

    @Inject
    public DriverReportSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        driverReportPage = new DriverReportPage(getWebDriver());
    }

    @When("^Operator set the filter date to current date$")
    public void operatorSetTheFilterDateToCurrentDate()
    {
        Date currentDate = new Date();
        driverReportPage.setFromDate(currentDate);
        driverReportPage.setToDate(currentDate);
    }
}
