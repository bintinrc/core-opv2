package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationPendingPickupJobsPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import java.util.List;
import java.util.Map;
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
  }

  @And("Operator searches data in the pending pickup table by applying the following filters:")
  public void operator_searches_data_in_the_pending_pickup_table_by_applying_the_following_filters(
      DataTable searchParameters) {
    List<Map<String, String>> filters = searchParameters.asMaps(String.class, String.class);
    Map<String, String> filter = resolveKeyValues(filters.get(0));
    stationPendingPickupJobsPage.applyFiltersInPendingPickupTable(filter);
  }

  @When("Operator clicks on the create job button in the Pending pickup page")
  public void operatorClicksOnTheCreateJobButtonInThePendingPickupPage() {
    stationPendingPickupJobsPage.clickCreateJobButton();
    takesScreenshot();
  }

  @Then("Operator verifies that url is redirected to {string} page")
  public void operatorVerifiesThatUrlIsRedirectedToPickupAppointmentPage(String expectedURL) {
    stationPendingPickupJobsPage.verifyCurrentPageURL(expectedURL);
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
        .as("Validation for presence of Assign to Route button").isEqualTo(true);
    takesScreenshot();
  }

  @Then("Operator verifies one row is displayed in the table after applying filter")
  public void operatorVerifiesOneRowIsDisplayedInTheTableAfterApplyingFilter() {
    Assertions.assertThat(stationPendingPickupJobsPage.noOfReultsInTable.size() == 1)
        .as("Validation for presence of Assign to Route button").isTrue();
    takesScreenshot();
  }

}
