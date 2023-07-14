package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.StationPendingPickupJobsPage;
import co.nvqa.operator_v2.selenium.page.StationPendingPickupJobsPage.PendingPickupJobs;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import java.util.List;
import java.util.Map;
import org.junit.Assert;
import org.openqa.selenium.ElementNotInteractableException;
import org.openqa.selenium.InvalidArgumentException;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.NoSuchWindowException;
import org.openqa.selenium.TimeoutException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Sathish
 */

@SuppressWarnings("unused")
@ScenarioScoped
public class StationPendingPickupJobsSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(StationPendingPickupJobsSteps.class);

  private StationPendingPickupJobsPage stationPendingPickupJobsPage;

  public StationPendingPickupJobsSteps() {
  }

  @Override
  public void init() {
    stationPendingPickupJobsPage = new StationPendingPickupJobsPage(getWebDriver());
  }

  @When("Operator expects no results when searching address by applying the following filters:")
  public void operator_expects_no_results_when_searching_for_the_address_by_applying_the_following_filters(
      DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationPendingPickupJobsPage.applyFiltersInPendingPickupTableAndValidateResultCount(filter, 0);
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator searches data in the pending pickup table by applying the following filters and expect one record:")
  public void operator_searches_data_in_the_pending_pickup_table_by_applying_the_following_filters_and_expect_one_record(
      DataTable searchParameters) {
    doWithRetry(() -> {
      List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
      Map<String, String> filter = resolveKeyValues(filters.get(0));
      stationPendingPickupJobsPage.applyFiltersInPendingPickupTable(filter);
      pause5s();
      if (stationPendingPickupJobsPage.noOfReultsInTable.size() != 1) {
        getWebDriver().navigate().refresh();
        throw new NvTestRuntimeException("One record is not displayed after filtering "
            + "the table Pending Pickup table record" + filter);
      }
    }, "filter records and expect one record");
    takesScreenshot();
  }

  @SuppressWarnings("unchecked")
  @And("Operator searches data in the pending pickup table by applying the following filters and expect zero record:")
  public void operator_searches_data_in_the_pending_pickup_table_by_applying_the_following_filters_and_expect_zero_record(
      DataTable searchParameters) {
    doWithRetry(() -> {
      List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
      Map<String, String> filter = resolveKeyValues(filters.get(0));
      stationPendingPickupJobsPage.applyFiltersInPendingPickupTable(filter);
      pause5s();
      if (stationPendingPickupJobsPage.noOfReultsInTable.size() != 0) {
        getWebDriver().navigate().refresh();
        throw new NvTestRuntimeException("Record are displayed after filtering "
            + "the table Pending Pickup table record" + filter);
      }
    }, "filter records and expect zero records");
    takesScreenshot();
  }

  @When("Operator clicks on the {string} button in the Pending pickup page")
  public void operatorClicksOnTheButtonInThePendingPickupPage(String buttonText) {
    stationPendingPickupJobsPage.clickButton(buttonText);
    takesScreenshot();
  }

  @Then("Operator verifies that url is redirected to {string} page on clicking the {string} button")
  public void operatorVerifiesThatUrlIsRedirectedToPickupAppointmentPageOnclickingTheButton(
      String expectedURL, String buttonText) {
    pause8s();
    String windowHandle = getWebDriver().getWindowHandle();
    stationPendingPickupJobsPage.clickButton(buttonText);
    stationPendingPickupJobsPage.verifyCurrentPageURL(expectedURL);
    //stationPendingPickupJobsPage.closeAllWindows(windowHandle);
  }

  @Then("Operator verifies {string} is matching in the jobs for today")
  public void operatorVerifiesIsMatchingInTheJobsForToday(String reservationId) {
    reservationId = resolveValue(reservationId);
    Assertions.assertThat(stationPendingPickupJobsPage.getValueFromJobsforToday())
        .as("Validation of reservation matching in jobs for today column").isEqualTo(reservationId);
    takesScreenshot();
  }

  @Then("Operator verify Assign to Route button is displayed for the record")
  public void operatorVerifyAssignToRouteButtonIsDisplayedForTheRecord() {
    Assertions.assertThat(
            stationPendingPickupJobsPage.assignToRouteButton.get(0).getWebElement().isDisplayed())
        .as("Validation for presence of Assign to Route button").isTrue();
    takesScreenshot();
  }

  @Then("Operator verifies one row is displayed in the table after applying filter")
  public void operatorVerifiesOneRowIsDisplayedInTheTableAfterApplyingFilter() {
    Assertions.assertThat(stationPendingPickupJobsPage.noOfReultsInTable.size() == 1)
        .as("Validation for presence of Assign to Route button").isTrue();
    takesScreenshot();
  }

  @Then("Operator verifies zero row is displayed in the table after applying filter")
  public void operatorVerifiesZeroRowIsDisplayedInTheTableAfterApplyingFilter() {
    Assertions.assertThat(stationPendingPickupJobsPage.noOfReultsInTable.size() == 0)
        .as("Validation for presence of Assign to Route button").isTrue();
    takesScreenshot();
  }

  @Then("Operator verify value on pending pickup table for the {string} column is equal to {string}")
  public void operatorVerifyValueOnPendingPickupTableForTheColumnIsEqualTo(
      String columnName, String expectedValue) {
    expectedValue = resolveValue(expectedValue);
    pause5s();
    stationPendingPickupJobsPage.switchToFrame();
    PendingPickupJobs columnValue = PendingPickupJobs.valueOf(columnName);
    String actualColumnValue = stationPendingPickupJobsPage.getColumnValue(columnValue);
    Assert.assertEquals(f("expected Value is not matching for column : %s", columnName),
        expectedValue, actualColumnValue);
    takesScreenshot();
  }

  @Then("Operator verifies that {string} action button is displayed")
  public void operatorVerifiesThatActionButtonIsDisplayed(String buttonText) {
    stationPendingPickupJobsPage.validateThePresenceOfButton(buttonText);
    takesScreenshot();
  }

  @Then("Operator verifies that No Pending Pickups message is displayed")
  public void operatorVerifiesThatNoPendingPickupsMessageIsDisplayed() {
    stationPendingPickupJobsPage.validateNoPendingPickupRecords();
    takesScreenshot();
  }

  @When("Operator clicks on the sort icon in the Parcel to Pickup column")
  public void operatorClicksOnTheSortIconInTheParcelToPickupColumn() {
    stationPendingPickupJobsPage.clickSortParcelsToPick();
    takesScreenshot();
  }

  @When("operator click {string} filter button")
  public void operatorClickFilterButton(String buttonText) {
    stationPendingPickupJobsPage.switchToFrame();
    stationPendingPickupJobsPage.clickFilterButton(buttonText);
  }

  @Then("Operator verifies that {string} button is in clicked status")
  public void operatorVerifiesThatButtonIsInClickedStatus(String buttonText) {
    stationPendingPickupJobsPage.validateButtonIsClicked(buttonText);
    takesScreenshot();
  }

  @Then("Operator verifies that {string} button is in unclicked status")
  public void operatorVerifiesThatButtonIsInUnClickedStatus(String buttonText) {
    stationPendingPickupJobsPage.validateButtonIsUnClicked(buttonText);
    takesScreenshot();
  }

}
