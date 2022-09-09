package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.selenium.page.ShipperAddressConfigurationPage;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.InvalidFailedWP;
import co.nvqa.operator_v2.selenium.page.StationRouteMonitoringPage.StationRouteMonitoring;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.junit.Assert;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.TimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@SuppressWarnings("unused")
@ScenarioScoped
public class ShipperAddressConfigurationSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(
      ShipperAddressConfigurationSteps.class);
  private ShipperAddressConfigurationPage shipperAddressConfigurationPage;

  public ShipperAddressConfigurationSteps() {
  }

  @Override
  public void init() {
    shipperAddressConfigurationPage = new ShipperAddressConfigurationPage(getWebDriver());
  }

  @When("Operator loads Shipper Address Configuration page")
  public void operator_loads_shipper_address_configuration_page() {
    shipperAddressConfigurationPage.loadShipperAddressConfigurationPage();
  }

  @SuppressWarnings("unchecked")
  @And("Operator selects {string} in the Address Status dropdown")
  public void operatorSelectsInTheAddressStatusDropdown(String option) {
    retryIfExpectedExceptionOccurred(
        () -> shipperAddressConfigurationPage.selectAddressStatus(option),
        null, LOGGER::warn, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, 3,
        NoSuchElementException.class, NoSuchWindowException.class,
        ElementNotInteractableException.class, ElementNotInteractableException.class,
        TimeoutException.class, StaleElementReferenceException.class,
        InvalidElementStateException.class, InvalidArgumentException.class);
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator chooses start and end date on Address Creation date using the following data:")
  public void operatorChoosesStartAndEndDateOnAddressCreationDateUsingTheFollowingData(
      Map<String, String> addressCreationDate) {
    addressCreationDate = resolveKeyValues(addressCreationDate);
    String startDate = addressCreationDate.get("From");
    String endDate = addressCreationDate.get("To");

    retryIfExpectedExceptionOccurred(
        () -> shipperAddressConfigurationPage.selectDateRange(startDate,
            endDate),
        null, LOGGER::warn, DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS, 3,
        NoSuchElementException.class, NoSuchWindowException.class,
        ElementNotInteractableException.class, ElementNotInteractableException.class,
        TimeoutException.class, StaleElementReferenceException.class,
        InvalidElementStateException.class, InvalidArgumentException.class);
    takesScreenshot();
  }

  @And("Operator clicks on the load selection button")
  public void operatorClicksOnTheLoadSelectionButton() {
    shipperAddressConfigurationPage.clickLoadSelection();
  }

  @Then("Operator filter the column {string} with {string}")
  public void operator_Searches_By(String filterBy, String filterValue) {
    filterValue = resolveValue(filterValue);
    shipperAddressConfigurationPage.filterBy(filterBy, filterValue);
    takesScreenshot();
  }

  @Then("Operator verifies table is filtered {string} based on input in {string} in shipper address page")
  public void operatorVerifiesTableIsFilteredBasedOnInputInShipperAddresPage(String filterBy,
      String filterValue) {
    filterValue = resolveValue(filterValue);
    shipperAddressConfigurationPage.validateFilter(filterBy, filterValue);
    takesScreenshot();
  }

  @Then("Operator verifies that green check mark icon is shown under the Lat Long")
  public void operatorVerifiesGreenCheckMarkIconIsShownUndertheLatLong() {
    shipperAddressConfigurationPage.validateGreenCheckMark();
    takesScreenshot();
  }

  @Then("Operator verifies that green check mark icon is not shown under the Lat Long")
  public void operatorVerifiesGreenCheckMarkIconIsNotShownUndertheLatLong() {
    shipperAddressConfigurationPage.validateGreenCheckMarkNotDisplayed();
    takesScreenshot();
  }


}


