package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.UnroutedPrioritiesPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import javax.inject.Inject;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class UnroutedPrioritiesSteps extends AbstractSteps
{
    private UnroutedPrioritiesPage unroutedPrioritiesPage;

    @Inject
    public UnroutedPrioritiesSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        unroutedPrioritiesPage = new UnroutedPrioritiesPage(getWebDriver());
    }

    @When("^Operator select filter and click Load Selection on page Unrouted Priorities using data below:$")
    public void operatorSelectFilterAndClickLoadSelectionOnPageUnroutedPrioritiesUsingDataBelow(Map<String,String> mapOfData)
    {
        try
        {
            Date routeDate = YYYY_MM_DD_SDF.parse(mapOfData.get("routeDate"));
            unroutedPrioritiesPage.filterAndClickLoadSelection(routeDate);
        }
        catch(ParseException ex)
        {
            throw new NvTestRuntimeException("Failed to parse date.", ex);
        }
    }

    @Then("^Operator verify order with delivery date is today should be listed on page Unrouted Priorities$")
    public void operatorVerifyOrderWithDeliveryDateIsTodayShouldBeListedOnPageUnroutedPriorities()
    {
        Order order = get(KEY_ORDER_DETAILS);
        unroutedPrioritiesPage.verifyOrderIsListedAndContainsCorrectInfo(order);
    }

    @Then("^Operator verify order with delivery date is next day should not be listed on page Unrouted Priorities$")
    public void operatorVerifyOrderWithDeliveryDateIsNextDayShouldNotBeListedOnPageUnroutedPriorities()
    {
        Order order = get(KEY_ORDER_DETAILS);
        unroutedPrioritiesPage.verifyOrderIsNotListed(order);
    }

    @Then("^Operator verify order with delivery date is next day should be listed on next 2 days route date on page Unrouted Priorities$")
    public void operatorVerifyOrderWithDeliveryDateIsNextDayShouldBeListedOnNext2DaysRouteDateOnPageUnroutedPriorities()
    {
        Order order = get(KEY_ORDER_DETAILS);
        unroutedPrioritiesPage.verifyOrderIsListedAndContainsCorrectInfo(order);
    }
}
