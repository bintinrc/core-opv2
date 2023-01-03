package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.corev2.model.PickupAppointmentJobResponse;
import co.nvqa.common.corev2.model.persisted_class.PickupAppointmentJob;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2.BulkSelectTable.ACTION_SELECTED;

import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS;
import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT;
import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOB_IDS;
import static co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2.BulkSelectTable.ACTION_SELECTED;

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
            .as(f("Delete Button in Job with id = %s displayed", jobId)).isTrue();
      }, 5000, 3);


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

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
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
    }, 2000, 3);

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

  @Given("Operator clicks {string} button on Pickup Jobs page")
  public void operatorClicksButtonOnPickupJobsPage(String buttonName) {
    pickupAppointmentJobPage.inFrame(() -> {
      switch (buttonName) {
        case "Load Selection":
          pickupAppointmentJobPage.loadSelection.click();
          pickupAppointmentJobPage.loadingIcon.waitUntilInvisible();
          break;
        case "Bulk select dropdown":
          pickupAppointmentJobPage.bulkSelect.bulkSelectDropdown.click();
          break;
        case "Select All Shown":
          pickupAppointmentJobPage.bulkSelect.selectAll.click();
          pickupAppointmentJobPage.bulkSelect.bulkUpdateDropdown.waitUntilClickable();
          break;
        case "Unselect All Shown":
          pickupAppointmentJobPage.bulkSelect.unSelectAll.click();
          break;
        case "Clear Selection":
          pickupAppointmentJobPage.bulkSelect.clearSelection.click();
          break;
        case "Display only selected":
          pickupAppointmentJobPage.bulkSelect.displayOnlySelected.click();
          pickupAppointmentJobPage.bulkSelect.bulkUpdateDropdown.waitUntilClickable();
          break;
        case "Filter by job ID":
          pickupAppointmentJobPage.bulkSelect.filterByJobId.click();
          pickupAppointmentJobPage.filterJobByIDModal.close.waitUntilVisible();
          break;
        case "Filter Jobs":
          pickupAppointmentJobPage.filterJobByIDModal.confirmButton.waitUntilClickable();
          pickupAppointmentJobPage.filterJobByIDModal.confirmButton.click();
          pickupAppointmentJobPage.filterJobByIDModal.confirmButton.waitUntilInvisible();
          break;
        case "Create / edit job":
          pickupAppointmentJobPage.createEditJobButton.click();
          break;
      }
    });
  }

  @Then("Operator verifies number of selected rows on Pickup Jobs page")
  public void operatorVerifiesNumberOfSelectedRows() {
    pickupAppointmentJobPage.inFrame(() ->
        pickupAppointmentJobPage.verifyBulkSelectResult()
    );
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

  @When("Operator filters on the table with values below:")
  public void operatorFiltersValueOnTheTable(Map<String, String> data) {
    Map<String, String> resolvedData = resolveKeyValues(data);
    pickupAppointmentJobPage.inFrame(() -> {
      if (resolvedData.get("status") != null) {
        pickupAppointmentJobPage.bulkSelect.filterByColumnV2(
            pickupAppointmentJobPage.bulkSelect.COLUMN_STATUS, resolvedData.get("status"));
      }
    });
  }

  @Then("Operator verify number of selected row is not updated")
  public void operatorVerifyNumberOfSelectedRowIsNotUpdated() {
    pickupAppointmentJobPage.inFrame(() -> {
      String selectedRows = pickupAppointmentJobPage.bulkSelect.selectedRowCount.getText();
      Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
          .contains(pickupAppointmentJobPage.KEY_LAST_SELECTED_ROWS_COUNT);
    });
  }

  @Then("Operator verify the number of selected rows is {value}")
  public void operatorVerifiesNumberOfSelectedRow(String expectedRowCount) {
    pickupAppointmentJobPage.inFrame(() -> {
      String selectedRows = pickupAppointmentJobPage.bulkSelect.selectedRowCount.getText();
      Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
          .contains(expectedRowCount);
    });
  }

  @Given("Operator selects {int} rows on Pickup Jobs page")
  public void operatorSelectRowsOnPickupJobsPage(int numberOfRows) {
    pickupAppointmentJobPage.inFrame(() -> {
      for (int i = 1; i <= numberOfRows; i++) {
        pickupAppointmentJobPage.bulkSelect.clickActionButton(i, ACTION_SELECTED);
      }
    });
  }

  @Then("Operator verifies Filter Job button is disabled on Pickup job page")
  public void operatorVerifiesFilterJobButtonDisabled() {
    pickupAppointmentJobPage.inFrame(
        () -> Assertions.assertThat(pickupAppointmentJobPage.filterJobByIDModal.confirmButton.
            getAttribute("disabled")).as("Filter Job button is disabled").isEqualTo("true"));
  }

  @Given("Operator fills the pickup job ID list below:")
  public void operatorFillsThePickupJobIDs(List<String> data) {
    List<String> listOfPickupJobIds = resolveValues(data);
    pickupAppointmentJobPage.inFrame(() -> {
      listOfPickupJobIds.forEach((Id) -> {
        pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(Id);
        pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(Keys.ENTER);
        pause100ms();
      });
    });
  }

  @Then("Operator verify pickup job table on Pickup Jobs page:")
  public void verifyPickupJobsTable(List<String> data) {
    List<String> expectedIDs = resolveValues(data);
    pickupAppointmentJobPage.inFrame(page -> {
      page.waitUntilLoaded(1);
      List<String> actualIDs = page.bulkSelect.getListIDs();
      Assertions.assertThat(actualIDs).as("Result is the same").isEqualTo(expectedIDs);
    });
  }

  @Then("Operator verifies error message below:")
  public void operatorVerifiesErrorMessage(String expectedResult) {
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(expectedResult).as("Message is the same")
          .isEqualToIgnoringCase(page.getAntTopRightText());
    });
  }

  @Given("Operator clears the filter jobs list on Pickup Jobs Page")
  public void operatorClearsPickupJobsList() {
    pickupAppointmentJobPage.inFrame(
        () -> pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(
            Keys.chord(Keys.CONTROL, "a", Keys.DELETE)));
  }

  @Then("Operator verifies invalid pickup ID error message below on Pickup Jobs Page:")
  public void operatorVerifiesErrorMessageOnPickupJobsPage(String expectedMessage) {
    pickupAppointmentJobPage.inFrame(
        () -> pickupAppointmentJobPage.filterJobByIDModal.verifyErrorMessages(expectedMessage));
  }

  @Given("Operator fill more than 1000 pickup jobs Id on Pickup Jobs Page:")
  public void addmore1000(String ID) {
    String jobId = resolveValue(ID);
    Random random = new Random();
    int numberOfId = random.ints(1002, 1010)
        .findFirst()
        .getAsInt();
    pickupAppointmentJobPage.inFrame(page -> {
      for (int i = 0; i < numberOfId; i++) {
        pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(jobId);
        pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(Keys.ENTER);
      }
    });
  }

  @Then("Operator verifies the Table on Pickup Jobs Page")
  public void operatorVerifiesTableOnPickupJobsPage() {
    pickupAppointmentJobPage.inFrame(() -> {
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "pickupAppointmentJobId")).isEnabled()).as("Job ID is display and can be sorted")
          .isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "status"))
          .isEnabled()).as("Job status is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "tagNames"))
          .isEnabled()).as("Job tags is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "priorityLevel"))
          .isEnabled()).as("Priority level is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "legacyShipperId"))
          .isEnabled()).as("Shipper ID is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "shipperInfo"))
          .isEnabled()).as("Shipper name & contact is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "pickupAddress"))
          .isEnabled()).as("Pickup address is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "driverName"))
          .isEnabled()).as("Driver name is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "routeId"))
          .isEnabled()).as("Route ID is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "pickupReadyDatetimeStr")).isEnabled()).as("Ready by is display and can be sorted")
          .isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "pickupLatestDatetimeStr")).isEnabled()).as("Latest by is display and can be sorted")
          .isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              "//div[@data-testid = 'tableHeaderTitle.historicalSize']").isEnabled())
          .as("Historical size breakdown is display").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "pickupApproxVolume")).isEnabled()).as("Approx vol is display and can be sorted")
          .isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "pickupServiceLevel")).isEnabled())
          .as("Job service level is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH, "pickupServiceType"))
          .isEnabled()).as("Job service type is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "failureReasonDescription")).isEnabled())
          .as("Failure reason is display and can be sorted").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.findElementByXpath(
              f(pickupAppointmentJobPage.PICKUP_JOBS_COLUMN_HEADER_SORTICON_XPATH,
                  "pickupInstructions")).isEnabled()).as("Comments is display and can be sorted")
          .isTrue();
    });
  }

  @Then("Operator verifies Existing upcoming job page")
  public void operatorVerifiesExistingUpcomingJobPage() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.existingUpcomingJob.header.waitUntilVisible();
      Assertions.assertThat(pickupAppointmentJobPage.existingUpcomingJob.header.isDisplayed())
          .as("Existing upcoming job header is display").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.existingUpcomingJob.title.isDisplayed())
          .as("Existing upcoming job title is display").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.existingUpcomingJob.startDate.isDisplayed())
          .as("Existing upcoming job Start date is display").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.existingUpcomingJob.endDate.isDisplayed())
          .as("Existing upcoming job end date is display").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.existingUpcomingJob.timeRange.isEnabled())
          .as("Existing upcoming job time range is display").isTrue();
      Assertions.assertThat(
              pickupAppointmentJobPage.existingUpcomingJob.useExistingTimeslot.isEnabled())
          .as("Existing upcoming job Apply existing time slots is display").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.existingUpcomingJob.pickupTag.isEnabled())
          .as("Existing upcoming job pickup tag is display").isTrue();
      Assertions.assertThat(
              pickupAppointmentJobPage.existingUpcomingJob.submit.getAttribute("disabled"))
          .as("Existing upcoming job submit is disabled").isEqualTo("true");
    });
  }

  @Given("Operator selects time range {string} on Existing Upcoming Job page")
  public void operatorSelectsTimeRangeOnExistingJobpage(String timeRange) {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.existingUpcomingJob.timeRange.click();
      pickupAppointmentJobPage.selectItem(timeRange);
    });
  }

  @Given("Operator clicks Submit button on Existing Upcoming Job page")
  public void operatorClicksSubmitOnExistingJobPage() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.existingUpcomingJob.submit.waitUntilClickable();
      pickupAppointmentJobPage.existingUpcomingJob.submit.click();
      pickupAppointmentJobPage.existingUpcomingJob.submit.waitUntilInvisible();
    });
  }

  @Given("Operator creates new PA Job on Existing Upcoming Job page:")
  public void operatorCreatesNewPaJobOnExistingJobPage(Map<String, String> data) {
    Map<String, String> resolvedData = resolveKeyValues(data);
    pickupAppointmentJobPage.inFrame(page -> {
      if (resolvedData.get("startDate") != null) {
        page.existingUpcomingJob.startDate.click();
        page.existingUpcomingJob.startDate.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
        page.existingUpcomingJob.startDate.sendKeys(resolvedData.get("startDate"));
        page.existingUpcomingJob.startDate.sendKeys(Keys.ENTER);
      }
      if (resolvedData.get("endDate") != null) {
        page.existingUpcomingJob.endDate.click();
        page.existingUpcomingJob.endDate.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
        page.existingUpcomingJob.endDate.sendKeys(resolvedData.get("endDate"));
        page.existingUpcomingJob.endDate.sendKeys(Keys.ENTER);
      }
      if ((resolvedData.get("useExistingTimeslot") != null) && (resolvedData.get(
          "useExistingTimeslot").equalsIgnoreCase("true"))) {
        page.existingUpcomingJob.useExistingTimeslot.click();
      } else {
        pickupAppointmentJobPage.existingUpcomingJob.timeRange.click();
        pickupAppointmentJobPage.selectItem(resolvedData.get("timeRange"));
      }
      if (resolvedData.get("pickupTag") != null) {
        page.existingUpcomingJob.pickupTag.click();
        pickupAppointmentJobPage.selectItem(resolvedData.get("pickupTag"));
      }
    });
  }

  @Then("Operator verifies job created success following data below:")
  public void operatorVerifiesJobCreatedSuccess(Map<String, String> data) {
    Map<String, String> resolvedData = resolveKeyValues(data);
    pickupAppointmentJobPage.inFrame(() -> {

      if (data.get("timeSlot") != null) {
        pickupAppointmentJobPage.jobCreatedSuccess.title.waitUntilVisible();
        Assertions.assertThat(pickupAppointmentJobPage.jobCreatedSuccess.createdTime.getText())
            .as("Time slot is the same").isEqualToIgnoringCase(resolvedData.get("timeSlot"));
      }
      if (resolvedData.get("pickupTag") != null) {
        pickupAppointmentJobPage.jobCreatedSuccess.title.waitUntilVisible();
        Assertions.assertThat(pickupAppointmentJobPage.isElementExist(
            f(pickupAppointmentJobPage.jobCreatedSuccess.COLUMN_DATA_XPATH,
                resolvedData.get("pickupTag")))).as("Job tag is the same").isTrue();
      }
      if (resolvedData.get("errorMessage") != null) {
        pickupAppointmentJobPage.jobCreatedModal.title.waitUntilVisible();
        Assertions.assertThat(pickupAppointmentJobPage.isElementExist(
                f(pickupAppointmentJobPage.jobCreatedModal.ERROR_MESSAGE_XPATH,
                    resolvedData.get("errorMessage"))))
            .as("Error mesaage is the same").isTrue();
      }
    });
  }

}
