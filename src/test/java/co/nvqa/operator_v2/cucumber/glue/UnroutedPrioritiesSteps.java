package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.UnroutedPrioritiesPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeParseException;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class UnroutedPrioritiesSteps extends AbstractSteps {

  private UnroutedPrioritiesPage unroutedPrioritiesPage;

  public UnroutedPrioritiesSteps() {
  }

  @Override
  public void init() {
    unroutedPrioritiesPage = new UnroutedPrioritiesPage(getWebDriver());
  }

  @When("^Operator select filter and click Load Selection on page Unrouted Priorities using data below:$")
  public void operatorSelectFilterAndClickLoadSelectionOnPageUnroutedPrioritiesUsingDataBelow(
      Map<String, String> mapOfData) {
    try {
      String routeDateAsString = mapOfData.get("routeDate");
      ZonedDateTime routeDate;

      if ("GET_FROM_ORDER_DELIVERY_END_TIME_TRANSACTION".equalsIgnoreCase(routeDateAsString)) {
        Order order = get(KEY_CREATED_ORDER);
        routeDate = StandardTestUtils.convertToZonedDateTime(
            order.getTransactions().get(1).getEndTime(),
            ZoneId.of("UTC"), DTF_ISO_8601_LITE);
      } else {
        routeDate = StandardTestUtils.convertToZonedDateTime(routeDateAsString, ZoneId.of("UTC"),
            DTF_NORMAL_DATE);
      }

      unroutedPrioritiesPage.filterAndClickLoadSelection(routeDate);
    } catch (DateTimeParseException ex) {
      throw new NvTestRuntimeException("Failed to parse date.", ex);
    }
  }

  @Then("^Operator verify order with delivery date is today should be listed on page Unrouted Priorities$")
  public void operatorVerifyOrderWithDeliveryDateIsTodayShouldBeListedOnPageUnroutedPriorities() {
    Order order = get(KEY_CREATED_ORDER);
    unroutedPrioritiesPage.verifyOrderIsListedAndContainsCorrectInfo(order);
  }

  @Then("^Operator verify order with delivery date is next day should not be listed on page Unrouted Priorities$")
  public void operatorVerifyOrderWithDeliveryDateIsNextDayShouldNotBeListedOnPageUnroutedPriorities() {
    Order order = get(KEY_CREATED_ORDER);
    unroutedPrioritiesPage.verifyOrderIsNotListed(order);
  }

  @Then("^Operator verify order with delivery date is next day should be listed on next 2 days route date on page Unrouted Priorities$")
  public void operatorVerifyOrderWithDeliveryDateIsNextDayShouldBeListedOnNext2DaysRouteDateOnPageUnroutedPriorities() {
    Order order = get(KEY_CREATED_ORDER);
    unroutedPrioritiesPage.verifyOrderIsListedAndContainsCorrectInfo(order);
  }
}
