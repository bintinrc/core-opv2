package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.PriorityLevelsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;


@ScenarioScoped
public class PriorityLevelsSteps extends AbstractSteps {

  private PriorityLevelsPage priorityLevelsPage;

  public PriorityLevelsSteps() {
  }

  @Override
  public void init() {
    priorityLevelsPage = new PriorityLevelsPage(getWebDriver());
  }

  @Then("^Operator verifies \"Reservations Sample CSV\" is downloaded successfully and correct$")
  public void operatorsVerifiesSampleCsvReservationsIsDownloadedSuccessfullyAndCorrect() {
    priorityLevelsPage.downloadSimpleCsvReservations.click();
    priorityLevelsPage.verifyDownloadedSampleCsvReservations();
  }

  @And("^Operator uploads \"Order CSV\" using next priority levels for reservations:$")
  public void uploadsReservationsCsv(Map<String, String> data) {
    data = resolveKeyValues(data);
    priorityLevelsPage.uploadCsvReservations.click();
    String csvContent = PriorityLevelsPage.SAMPLE_CSV_RESERVATIONS_EXPECTED_TEXT + "\n" +
        data.entrySet().stream()
            .map(entry -> entry.getKey() + "," + entry.getValue())
            .collect(Collectors.joining("\n"));
    File csvFile = priorityLevelsPage.createFile(
        f(PriorityLevelsPage.SAMPLE_CSV_RESERVATIONS_FILENAME_PATTERN, generateDateUniqueString()),
        csvContent);
    priorityLevelsPage.uploadCsvDialog.uploadFile(csvFile);
  }

  @And("^Operator verifies reservations info in Bulk Priority Edit dialog:$")
  public void verifyReservationInfo(Map<String, String> data) {
    data = resolveKeyValues(data);
    priorityLevelsPage.bulkPriorityEditDialog.waitUntilVisible();
    pause1s();
    List<String> reservationsIds = priorityLevelsPage.bulkPriorityEditDialog.reservationIds.stream()
        .map(PageElement::getText)
        .collect(Collectors.toList());
    Assertions.assertThat(reservationsIds)
        .as("List of displayed Reservation IDs")
        .hasSize(data.size());
    List<String> priorityLevels = priorityLevelsPage.bulkPriorityEditDialog.priorityLevels.stream()
        .map(PageElement::getValue)
        .collect(Collectors.toList());
    for (int i = 0; i < data.size(); i++) {
      String reservationId = reservationsIds.get(i);
      String expectedPriorityLevel = data.get(reservationId);
      if (expectedPriorityLevel == null) {
        Assertions.fail("Unexpected reservation id %s", reservationId);
      }
      Assertions.assertThat(priorityLevels.get(i))
          .as("Priority Level for Reservation ID %s", reservationId)
          .isEqualTo(expectedPriorityLevel);
    }
  }

  @And("^Operator clicks Save Changes in Bulk Priority Edit dialog$")
  public void clickSaveChanges() {
    priorityLevelsPage.bulkPriorityEditDialog.waitUntilVisible();
    pause1s();
    priorityLevelsPage.bulkPriorityEditDialog.saveChanges.clickAndWaitUntilDone();
  }

}