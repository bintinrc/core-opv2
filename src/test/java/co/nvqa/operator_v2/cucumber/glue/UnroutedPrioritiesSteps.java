package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.ScenarioStorage;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvTestRuntimeException;
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
    public UnroutedPrioritiesSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
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
            String routeDateAsString = mapOfData.get("routeDate");
            Date routeDate;

            if("GET_FROM_ORDER_DELIVERY_END_TIME_TRANSACTION".equalsIgnoreCase(routeDateAsString))
            {
                Order order = get(KEY_CREATED_ORDER);
                routeDate = ISO_8601_WITHOUT_MILLISECONDS.parse(order.getTransactions().get(1).getEndTime());
            }
            else
            {
                routeDate = YYYY_MM_DD_SDF.parse(routeDateAsString);
            }

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
        Order order = get(KEY_CREATED_ORDER);
        unroutedPrioritiesPage.verifyOrderIsListedAndContainsCorrectInfo(order);
    }

    @Then("^Operator verify order with delivery date is next day should not be listed on page Unrouted Priorities$")
    public void operatorVerifyOrderWithDeliveryDateIsNextDayShouldNotBeListedOnPageUnroutedPriorities()
    {
        Order order = get(KEY_CREATED_ORDER);
        unroutedPrioritiesPage.verifyOrderIsNotListed(order);
    }

    @Then("^Operator verify order with delivery date is next day should be listed on next 2 days route date on page Unrouted Priorities$")
    public void operatorVerifyOrderWithDeliveryDateIsNextDayShouldBeListedOnNext2DaysRouteDateOnPageUnroutedPriorities()
    {
        Order order = get(KEY_CREATED_ORDER);
        unroutedPrioritiesPage.verifyOrderIsListedAndContainsCorrectInfo(order);
    }
}
