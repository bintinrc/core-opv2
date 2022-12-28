package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.corev2.model.PickupAppointmentJobResponse;
import co.nvqa.common.corev2.model.persisted_class.PickupAppointmentJob;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS;
import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT;
import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOB_IDS;
import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_PA_JOBS_IN_DB;

public class PickupAppointmentJobStepsV2 extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(PickupAppointmentJobStepsV2.class);

  private PickupAppointmentJobPageV2 pickupAppointmentJobPage;

  public PickupAppointmentJobStepsV2() {

  }

  @Override
  public void init() {
    pickupAppointmentJobPage = new PickupAppointmentJobPageV2(getWebDriver());
  }

  @When("Operator goes to Pickup Jobs Page")
  public void operatorGoesToPickupJobsPage() {

    getWebDriver().manage().window().maximize();
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
    if (pickupAppointmentJobPage.isToastContainerDisplayed()) {
      pickupAppointmentJobPage.waitUntilInvisibilityOfToast();
    }
    getWebDriver().switchTo().frame(0);
    pickupAppointmentJobPage.waitUntilVisibilityOfElementLocated(
        pickupAppointmentJobPage.getLoadSelection().getWebElement());
    pickupAppointmentJobPage.waitWhilePageIsLoading();
  }

  @When("Operator click on Create or edit job button on this top right corner of the page")
  public void operatorClickOnCreateOrEditJobButtonOnThisPage() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.clickOnCreateOrEditJob();
    });

  }

  @When("Operator select shipper id or name = {string} in Shipper ID or Name field")
  public void operatorSelectShipperByIdInSHipperIdOrNameField(String shipperId) {
    String newShipperId = resolveValue(shipperId);
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.fillShipperIdField(newShipperId);
      page.createOrEditJobPage.selectShipperFromList(newShipperId);
    });
  }

  @When("Operator select address = {string} in Shipper Address field")
  public void operatorSelectShipperAddressInShipperAddressField(String shipperAddress) {

    String newShipperAddress = resolveValue(shipperAddress);
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.fillShipperAddressField(newShipperAddress);
      page.createOrEditJobPage.selectShipperAddressFromList(newShipperAddress);
    });
  }

  @Then("Operator verify there is Delete button in job with id = {string}")
  public void verifyDeleteButtonIsDisplayed(String JobId) {
    String jobId = resolveValue(JobId);
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        Assertions.assertThat(page.createOrEditJobPage
                .isDeleteButtonByJobIdDisplayed(jobId))
            .as("Delete Button in Job with id = " + jobId + " displayed").isTrue();
      }, 2000, 3);


    });
  }

  @Then("Operator verify there is no Delete button in job with id = {string}")
  public void verifyDeleteButtonIsNotDisplayed(String JobId) {
    String jobId = resolveValue(JobId);
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.createOrEditJobPage
              .isDeleteButtonByJobIdDisplayed(jobId))
          .as("Delete Button in Job with id = " + jobId + " is not displayed").isFalse();
    });
  }

  @Then("Operator verify there is Edit button in job with id = {string}")
  public void verifyEditButtonIsDisplayed(String JobId) {
    String jobId = resolveValue(JobId);
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.createOrEditJobPage
              .isEditButtonByJobIdDisplayed(jobId))
          .as("Delete Button in Job with id = " + jobId + " displayed").isTrue();
    });
  }

  @Then("Operator verify there is no Edit button in job with id = {string}")
  public void verifyEditButtonIsNotDisplayed(String JobId) {
    String jobId = resolveValue(JobId);
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.createOrEditJobPage
              .isEditButtonByJobIdDisplayed(jobId))
          .as("Delete Button in Job with id = " + jobId + " is not displayed").isFalse();
    });
  }

  @When("Operator click on delete button for pickup job id = {string}")
  public void clickDeleteButtonForJobId(String JobId) {
    String jobId = resolveValue(JobId);
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clickDeleteButton(jobId);
    });
  }

  @Then("Operator verify Delete dialog displays data below:")
  public void verifyDeleteJobModalWindow(Map<String, String> dataTable) {
    Map<String, String> data = resolveKeyValues(dataTable);
    final String shipperName = data.get("shipperName");
    final String shipperAddress = data.get("shipperAddress");
    final String readyBy = data.get("readyBy");
    final String latestBy = data.get("latestBy");

    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Shipper name:"))
          .as("Shipper name is correct").isEqualTo(shipperName);
      Assertions.assertThat(
              page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Shipper address:"))
          .as("Shipper address is correct").contains(shipperAddress);
      Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Ready by:"))
          .as("Ready by is correct").isEqualTo(readyBy);
      Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Latest by:"))
          .as("Latest by is correct").isEqualTo(latestBy);
    });
  }

  @When("Operator click on Submit button on Delete Pickup Job delete modal")
  public void clickOnSubmitButtonOnDeleteJobModal() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.deletePickupJobModal.submitButton.click();
    });
  }

  @Then("Operator verify notification is displayed with message = {string} and description below:")
  public void verifyNotificationDisplayedWith(String notificationMessage,
      List<Map<String, String>> dataTable) {
    pickupAppointmentJobPage.inFrame(page -> {
      dataTable.forEach(entry -> {
        Map<String, String> data = new HashMap<>(entry);
        String message = resolveValue(notificationMessage);
        String description = resolveValue(data.get("description"));
        Assertions.assertThat(page.notificationModal.message.getText())
            .as(f("Notification Message contains: %s", message)).contains(message);
        Assertions.assertThat(page.notificationModal.description.getText())
            .as(f("Notification Description contains: %s", description)).contains(description);
      });
    });
  }


  @Then("^Operator verify Create button in (enabled|disabled)")
  public void isCreateButtonDisabled(String state) {
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(
              page.createOrEditJobPage.isCreateButtonDisabled())
          .as("Create button is displayed")
          .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
    });

  }


  @When("Operator select the data range below:")
  public void selectDataRange(Map<String, String> dataTable) {
    final String startDay = dataTable.get("startDay");
    final String endDay = dataTable.get("endDay");
    pickupAppointmentJobPage.inFrame(page -> {
      pickupAppointmentJobPage.createOrEditJobPage.selectDataRangeByTitle(startDay, endDay);
    });

  }


  @And("Operator select time slot from Select time range field below:")
  public void selectTimeSlotFromSelectTimeRangeField(Map<String, String> dataTable) {
    final String timeRange = resolveValue(dataTable.get("timeRange"));
    pickupAppointmentJobPage.inFrame(page -> {
      pickupAppointmentJobPage.createOrEditJobPage.selectTimeRange(timeRange);
    });

  }

  @Then("Operator click Create button")
  public void clickCreateButton() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clickCreateButton();
    });

  }

  @Then("Operator verify Job Created dialog displays data below:")
  public void verifyJobCreatedModalWindow(Map<String, String> dataTable) {
    Map<String, String> data = resolveKeyValues(dataTable);
    final String shipperName = data.get("shipperName");
    final String shipperAddress = data.get("shipperAddress");
    final String readyBy = data.get("readyBy");
    final String latestBy = data.get("latestBy");
    final String jobTags = (data.get("jobTags") == null) ? "" : data.get("jobTags");

    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.jobCreatedModal.getFieldTextOnJobCreatedModal("Shipper name:"))
          .as("Shipper name is correct").isEqualTo(shipperName);
      Assertions.assertThat(
              page.jobCreatedModal.getFieldTextOnJobCreatedModal("Shipper address:"))
          .as("Shipper address is correct").contains(shipperAddress);
      Assertions.assertThat(page.jobCreatedModal.getFieldTextOnJobCreatedModal("Ready by:"))
          .as("Ready by is correct").isEqualTo(readyBy);
      Assertions.assertThat(page.jobCreatedModal.getFieldTextOnJobCreatedModal("Latest by:"))
          .as("Latest by is correct").isEqualTo(latestBy);
      Assertions.assertThat(page.jobCreatedModal.getFieldTextOnJobCreatedModal("Job Tags:"))
          .as("Job Tags is correct").isEqualTo(jobTags);
    });
  }

  @Then("Operator get Pickup Jobs for date = {string} from pickup jobs list = {string}")
  public void getPickupFromListWithDate(String date, String jobList) {

    List<PickupAppointmentJob> pickupjobs = resolveValue(jobList);

    for (PickupAppointmentJob job : pickupjobs) {
      if (job.getPickupReadyDatetime().toString().contains(date)) {
        putInList(KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT, job);
        PickupAppointmentJobResponse mockResponse = new PickupAppointmentJobResponse();
        mockResponse.setId(job.getId());
        putInList(KEY_CONTROL_CREATED_PA_JOBS, mockResponse);
      }
    }
  }

  @Then("Operator check pickup jobs list = {string} size is = {int}")
  public void checkPickupJobsListSize(String jobList, Integer size) {

    Integer expectedSize = size;
    Integer listSize = 0;
    if (resolveValue(jobList) != null) {
      List<PickupAppointmentJob> pickupjobs = resolveValue(jobList);
      listSize = pickupjobs.size();
    }
    Assertions.assertThat(listSize)
        .as(f("PA Jobs List size is equal to %s: ", expectedSize))
        .isEqualTo(expectedSize);

  }

  @When("Operator select Pickup job tag = {string} in Job Tags Field")
  public void selectJobTagsInJobTagsField(String tag) {

    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.selectTagInJobTagsField(tag);

    });
  }

  @When("Operator select Ready by and Latest by in Pickup Job create:")
  public void selectCustomisedTimeRange(Map<String, String> dataTable) {
    final String readyBy = resolveValue(dataTable.get("readyBy"));
    final String latestBy = resolveValue(dataTable.get("latestBy"));

    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.selectReadybyTime(readyBy);
      page.createOrEditJobPage.selectLatestbyTime(latestBy);

    });
  }

  @When("Operator add comment to pickup job = {string}")
  public void selectCustomisedTimeRange(String comment) {

    String finalComment = resolveValue(comment);
    ;
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.addJobComments(finalComment);


    });
  }

  @Then("Operator close Job Created dialog")
  public void verifyJobCreatedModalWindow() {

    pickupAppointmentJobPage.inFrame(page -> {
      page.jobCreatedModal.close();
    });
  }

  @Then("Operator check pickup id {string} is equal to {string}")
  public void checkPickupIdIsEquals(String firstID, String secondID) {
    String Id1 = resolveValue(firstID);
    String Id2 = resolveValue(secondID);
    Assertions.assertThat(Id1).as("Created Pickup job id is equal to old Pickup job id")
        .isEqualTo(Id2);
  }

  @Then("Operator check Job Created Module have errors:")
  public void checkPickupJobCreatedModuleErrors(List<Map<String, String>> dataTable) {
    pickupAppointmentJobPage.inFrame(page -> {
      dataTable.forEach(entry -> {
        Map<String, String> data = new HashMap<>(entry);
        String message = resolveValue(data.get("message"));
        Assertions.assertThat(page.jobCreatedModal.getErrorMessageWithText(message))
            .as(f("Job Created error contains: %s", message)).contains(message);
      });
    });
  }

  @Then("Operator check Notification Error contains= {string}")
  public void checkPickupJobCreatedModuleErrors(String message) {

    String notificationMessage = resolveValue(message);
    Assertions.assertThat(
            pickupAppointmentJobPage.pickupPageErrorNotification.toastBottom.getText())
        .as(f("Job Created error contains: %s", notificationMessage)).contains(notificationMessage);

  }


}
