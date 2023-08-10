package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.corev2.model.PickupAppointmentJobResponse;
import co.nvqa.common.corev2.model.persisted_class.PickupAppointmentJob;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2;
import com.beust.jcommander.Strings;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS;
import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS_DB_OBJECT;
import static co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2.BulkSelectTable.ACTION_DETAILS;
import static co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2.BulkSelectTable.ACTION_EDIT;
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
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
    if (pickupAppointmentJobPage.isToastContainerDisplayed()) {
      doWithRetry(() -> {
        pickupAppointmentJobPage.waitUntilInvisibilityOfToast();
      }, "wait toast until invisible", 2000, 5);
    }
    pickupAppointmentJobPage.inFrame(page ->{
      pickupAppointmentJobPage.waitUntilVisibilityOfElementLocated(
          pickupAppointmentJobPage.getLoadSelection().getWebElement());
    });
  }

  @When("Operator click on Create or edit job button on this top right corner of the page")
  public void operatorClickOnCreateOrEditJobButtonOnThisPage() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        page.clickOnCreateOrEditJob();
      });
    }, 1000, 5);


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

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {

      pickupAppointmentJobPage.inFrame(page -> {
        String pageNotificationMessage = pickupAppointmentJobPage.notificationModal.message.getAttribute(
            "innerText");
        String pageNotifcationDescription = pickupAppointmentJobPage.notificationModal.description.getAttribute(
            "innerText");
        dataTable.forEach(entry -> {
          Map<String, String> data = new HashMap<>(entry);
          String message = resolveValue(notificationMessage);
          String description = resolveValue(data.get("description"));
          retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {

            Assertions.assertThat(pageNotificationMessage)
                .as(f("Notification Message contains: %s", message)).contains(message);
            Assertions.assertThat(pageNotifcationDescription)
                .as(f("Notification Description contains: %s", description)).contains(description);
          }, 1000, 10);
        });
      });
    }, 1000, 5);
  }


  @Then("^Operator verify Create button in (enabled|disabled)")
  public void isCreateButtonDisabled(String state) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        Assertions.assertThat(
                page.createOrEditJobPage.isCreateButtonDisabled())
            .as("Create button enable state")
            .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
      });
    }, 1000, 5);

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

  @And("Operator click on button to view job details on Pickup Appointment Job page")
  public void clickOnJobDetailsButton() {
    Runnable clickButton = () -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.clickOnJobDetailsButton();
      });
    };
    doWithRetry(clickButton, "Click on View Job Detail Button");
    takesScreenshot();
  }

  @And("Operator click on button to view second pick up proof on Pickup Appointment Job page")
  public void clickOnPickUpProofButton() {
    Runnable clickButton = () -> {
      pickupAppointmentJobPage.inFrame((page) -> {
        page.viewJobDetailModal.clickOnSecondPickUpProofButton();
      });
    };
    doWithRetry(clickButton, "Click on View Job Detail Button");
    takesScreenshot();
  }

  @And("Operator click on button to view image on Pickup Appointment Job page")
  public void clickOnJobToViewImageButton() {
    Runnable clickButton = () -> {
      pickupAppointmentJobPage.inFrame((page) -> {
        page.viewJobDetailModal.clickOnSignatureImage();
      });
    };
    doWithRetry(clickButton, "Click On Button To View Image");
    takesScreenshot();
  }

  @And("Operator click on button to cancel image on Pickup Appointment Job page")
  public void clickOnJobToCancelImageButton() {
    Runnable clickButton = () -> {
      pickupAppointmentJobPage.inFrame((page) -> {
        page.viewJobDetailModal.clickOnSignatureImageToCancel();
      });
    };
    doWithRetry(clickButton, "Click On Button To View Image");
    takesScreenshot();
  }

  @Then("QA verify values on Pickup Jobs Details page are shown")
  public void verifyFiltersOnPickupJobsDetailsPageAreShown(Map<String, String> dataTable) {
    Map<String, String> resolvedData = resolveKeyValues(dataTable);
    String resolvedDate = resolvedData.get("time");
    String formattedDate = "[" + resolvedDate + "]";
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(
              page.viewJobDetailModal.getJobDetailItemsXpath("Shipper Name & Contact")).
          as("Shipper Contact & Name are correct").isEqualToIgnoringCase("Shipper Name & Contact");
      Assertions.assertThat(page.viewJobDetailModal.getJobDetailItemsXpath("Pickup Address")).
          as("Pick Up Address Title is correct").isEqualToIgnoringCase("Pickup Address");
      Assertions.assertThat(
              page.viewJobDetailModal.getJobDetailItemsXpath(resolvedData.get("waypointId"))).
          as("Waypoint Id is correct").isEqualToIgnoringCase(resolvedData.get("waypointId"));
      Assertions.assertThat(
              page.viewJobDetailModal.getJobDetailItemsXpath(resolvedData.get("shipperId"))).
          as("Shipper Id is correct").isEqualToIgnoringCase(resolvedData.get("shipperId"));
      Assertions.assertThat(
              page.viewJobDetailModal.getJobDetailItemsXpath(resolvedData.get("jobId"))).
          as("Job Id is correct").isEqualToIgnoringCase(resolvedData.get("jobId"));
      Assertions.assertThat(
              page.viewJobDetailModal.getJobDetailItemsXpath(resolvedData.get("status"))).
          as("Status is correct").isEqualToIgnoringCase(resolvedData.get("status"));
      Assertions.assertThat(
              page.viewJobDetailModal.getButtonsOnJobDetailsPage("Download Parcel List")).
          as("Download Parcel List Button is Clickable").isTrue();
      Assertions.assertThat(
              page.viewJobDetailModal.getButtonsOnJobDetailsPage("Download Signature")).
          as("Download Signature Button is Click").isTrue();
    });
  }

  @Then("QA verify signature image on Pickup Appointment Job page")
  public void verifySignatureImage() {
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.viewJobDetailModal.getImagesOnJobDetailsPage()).isTrue();
    });
  }

  @And("Operator click on button to download parcel list on Pickup Appointment Job page")
  public void clickDownloadParcelListv2() {
    Runnable clickButton = () -> {
      pickupAppointmentJobPage.inFrame(page -> {
        page.viewJobDetailModal.clickOnButtons("Download Parcel List");
      });
    };
    doWithRetry(clickButton, "Click on Download Parcel List Button");
    takesScreenshot();
  }

  @And("Operator click on button to download image signature on Pickup Appointment Job page")
  public void clickDownloadSignature() {
    Runnable clickButton = () -> {
      pickupAppointmentJobPage.inFrame(page -> {
        page.viewJobDetailModal.clickOnButtons("Download Signature");
      });
    };
    doWithRetry(clickButton, "Click on Download Parcel List Button");
    takesScreenshot();
  }

  @Then("Verify that csv file is downloaded on pick up job page with filename for Job Id")
  public void verifyThatCsvFileIsDownloadedWithFilename(Map<String, String> dataTable) {
    Map<String, String> data = resolveKeyValues(dataTable);
    String newFilename = "pop-file-id-%s.csv";
    System.out.println(data.get("Job Id"));
    String formattedFilename = newFilename.replace("%s", data.get("Job Id"));
    Runnable verifyDownloadedFilename = () -> {
      pickupAppointmentJobPage.inFrame(page -> {
        page.viewJobDetailModal.verifyThatCsvFileIsDownloadedWithFilename(formattedFilename);
      });
    };
    doWithRetry(verifyDownloadedFilename, "Verify Downloaded Filename");
    takesScreenshot();
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

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        page.createOrEditJobPage.selectTagInJobTagsField(tag);
        pause3s();
      });
    }, 1000, 5);

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
          pickupAppointmentJobPage.bulkSelect.filterByJobId.waitUntilVisible();
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
        case "Bulk Update dropdown":
          pickupAppointmentJobPage.bulkSelect.bulkUpdateDropdown.click();
          break;
        case "Assign job tag":
          pickupAppointmentJobPage.bulkSelect.assignJobTag.click();
          break;
        case "Route ID":
          pickupAppointmentJobPage.bulkSelect.routeId.click();
          break;
        case "Remove route":
          pickupAppointmentJobPage.bulkSelect.removeRoute.click();
          break;
        case "Fail job":
          pickupAppointmentJobPage.bulkSelect.failJob.click();
          break;
      }
    });
  }

  @Then("Operator open Job Details for {value} job on Pickup Jobs page")
  public void openJobDetails(String jobId) {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.bulkSelect.filterTableUsing("pickupAppointmentJobId", jobId);
      pickupAppointmentJobPage.bulkSelect.clickActionButton(1, ACTION_DETAILS);
    });
  }

  @Then("Operator verify Job Details values on Pickup Jobs page:")
  public void vetifyJobDetails(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.jobDetailsModal.waitUntilVisible();
      SoftAssertions assertions = new SoftAssertions();
      if (finalData.containsKey("status")) {
        assertions.assertThat(pickupAppointmentJobPage.jobDetailsModal.status.getNormalizedText())
            .as("Status")
            .isEqualTo(finalData.get("status"));
      }
      if (finalData.containsKey("removedTid")) {
        assertions.assertThat(
                pickupAppointmentJobPage.jobDetailsModal.removedTid.getNormalizedText())
            .as("Removed TID")
            .isEqualTo(finalData.get("removedTid"));
      }
      if (finalData.containsKey("scannedAtShipperCount")) {
        assertions.assertThat(
                pickupAppointmentJobPage.jobDetailsModal.scannedAtShipperCount.getNormalizedText())
            .as("Scanned at Shipper Count")
            .isEqualTo(finalData.get("scannedAtShipperCount"));
      }
      if (finalData.containsKey("scannedAtShippers")) {
        String value = finalData.get("scannedAtShippers");
        if (value == null) {
          assertions.assertThat(pickupAppointmentJobPage.jobDetailsModal.scannedAtShippers)
              .withFailMessage("Scanned at Shipper's list is not empty")
              .isEmpty();
        } else {
          var actual = pickupAppointmentJobPage.jobDetailsModal.scannedAtShippers.stream().map(
                  PageElement::getNormalizedText)
              .collect(Collectors.toList());
          assertions.assertThat(actual)
              .as("Scanned at Shipper's")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(value));
        }
      }
    });
  }

  @Then("Operator verify no Proof of Pickup details in Job Details modal on Pickup Jobs page")
  public void vetifyNoJobDetails() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.jobDetailsModal.waitUntilVisible();
      Assertions.assertThat(pickupAppointmentJobPage.jobDetailsModal.noDetailsYet.isDisplayed())
          .withFailMessage("'No details yet' message is not displayed")
          .isTrue();
    });
  }

  @Then("Operator click Download Parcel List button in Job Details modal on Pickup Jobs page")
  public void clickDownloadParcelList() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.jobDetailsModal.waitUntilVisible();
      pickupAppointmentJobPage.jobDetailsModal.downloadParcelList.click();
    });
  }

  @Then("Operator verify downloaded parcel list contains TIDs on Pickup Jobs page:")
  public void verifyDownloadedParcelList(List<String> tids) {
    pickupAppointmentJobPage.inFrame(() -> {
      String fileanme = pickupAppointmentJobPage.getLatestDownloadedFilename("pop-file-id-");
      String content = "Scanned at Shipper (POP)\n" + String.join("\n", resolveValues(tids));
      pickupAppointmentJobPage.verifyFileDownloadedSuccessfully(fileanme, content);
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
      if (data.get("readyBy") != null) {
        pickupAppointmentJobPage.jobCreatedSuccess.title2.waitUntilVisible();
        Assertions.assertThat(pickupAppointmentJobPage.jobCreatedSuccess.startTime.getText())
            .as("Start time is the same").isEqualToIgnoringCase(resolvedData.get("readyBy"));
      }
      if (data.get("latestBy") != null) {
        pickupAppointmentJobPage.jobCreatedSuccess.title2.waitUntilVisible();
        Assertions.assertThat(pickupAppointmentJobPage.jobCreatedSuccess.endTime.getText())
            .as("End time is the same").isEqualToIgnoringCase(resolvedData.get("latestBy"));
      }
      if (data.get("followingDates") != null) {
        pickupAppointmentJobPage.jobCreatedSuccess.title2.waitUntilVisible();
        Assertions.assertThat(pickupAppointmentJobPage.jobCreatedSuccess.followingDates.getText())
            .as("Following dates is the same")
            .isEqualToIgnoringCase(resolvedData.get("followingDates"));
      }
    });
  }

  @When("Operator search for address = {string} in pickup jobs table")
  public void searchForAddressInPickupTable(String address) {
    pickupAppointmentJobPage.inFrame(page -> {
      page.bulkSelect.filterTableUsing("pickupAddress", resolveValue(address));
    });
  }

  @When("Operator click edit icon for Pickup job row")
  public void clickEditIconRouteRow() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame((page) -> {
        page.bulkSelect.clickEditButton();
      });
    }, 1000, 5);
  }

  @When("Operator click on edit button for pickup job id = {string}")
  public void clickEditButtonForJobId(String JobId) {
    String jobId = resolveValue(JobId);
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        page.createOrEditJobPage.clickEditButton(jobId);
      });
    }, 1000, 5);

  }

  @When("Operator check star icon on job = {string} with status = {string}")
  public void clickEditButtonForJobId(String JobId, String Status) {
    String jobId = resolveValue(JobId);
    String status = resolveValue(Status);
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.createOrEditJobPage
              .isStarByJobIdDisplayed(jobId, status))
          .as("Star in Job with id = " + jobId + " is displayed").isTrue();
    });
  }

  @When("Operator check tag = {string} is displayed on job")
  public void clickTagForJobId(String name) {
    String tagName = resolveValue(name);

    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.createOrEditJobPage
              .isTagDisplayed(tagName))

          .as(f("%s tag is displayed", tagName)).isTrue();
    });
  }

  @Then("^Operator verify Save button in (enabled|disabled)")
  public void isSaveButtonDisabled(String state) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        Assertions.assertThat(
                page.createOrEditJobPage.isSaveButtonDisabled())
            .as("Save button enable state")
            .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
      });
    }, 1000, 5);


  }

  @Then("Operator click Save button")
  public void clickSaveButton() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clickSaveButton();
    });

  }

  @When("Operator hover on job = {string} edit button")
  public void hoverOnSuccessButton(String JobId) {
    String jobId = resolveValue(JobId);
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.hoverOnEditButton(jobId);
    });
  }

  @When("Operator clear job tags input")
  public void operatorClearJobTagsInput() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clearTagsInput();
    });
  }

  @When("Operator clear job comments input")
  public void operatorClearJobCommentsInput() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clearJobComments();
    });
  }

  @When("Operator check no star icon on job = {string} with status = {string}")
  public void checkStarForJobId(String JobId, String Status) {
    String jobId = resolveValue(JobId);
    String status = resolveValue(Status);
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        Assertions.assertThat(page.createOrEditJobPage
                .isStarByJobIdDisplayed(jobId, status))
            .as("No Star in Job with id = " + jobId + " is displayed").isFalse();
      }, 1000, 5);
    });

  }

  @When("Operator check no tag = {string} is displayed on job")
  public void checkTagForJobId(String name) {
    String tagName = resolveValue(name);

    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.createOrEditJobPage
              .isTagDisplayed(tagName))

          .as(f("No %s tag is displayed", tagName)).isFalse();
    });
  }

  @Given("Operator clicks edit PA job on Pickup Jobs Page")
  public void operatorCLicksEditPAJob() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.bulkSelect.clickActionButton(1, ACTION_EDIT);
      pickupAppointmentJobPage.editPAJob.close.waitUntilVisible();
    });
  }

  @Given("Operator clicks Job details on Pickup Jobs Page")
  public void operatorCLicksJobDetails() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.bulkSelect.clickActionButton(1, ACTION_DETAILS);
      pickupAppointmentJobPage.editPAJob.close.waitUntilVisible();
    });
  }

  @When("Operator selects route {string} on Edit PA job page")
  public void operatorSelectsRouteOnEditJobPage(String routeIdAsString) {

    pickupAppointmentJobPage.inFrame(() -> {
      String routeId = resolveValue(routeIdAsString);
      pickupAppointmentJobPage.setRouteOnEditPAJobPage(routeId);
    });
  }

  @When("Operator clicks update route button on Edit PA job page")
  public void operatorClicksUpdateRouteButton() {
    pickupAppointmentJobPage.inFrame(() ->
        pickupAppointmentJobPage.updateRouteOnEditPAJobPage());
  }

  @Then("Operator verifies update route successful message below on Edit PA job page:")
  public void operatorVerifiesUpdateRouteSuccessfulMessage(String expectedString) {
    pickupAppointmentJobPage.inFrame(page -> {
      String expectedResult = resolveValue(expectedString);
      Assertions.assertThat(expectedResult).as("Message is the same")
          .isEqualToIgnoringCase(page.getAntTopRightText());
    });
  }

  @Then("Operator verifies current route is updated to {string} on Edit PA job page")
  public void operatorVerifiesCurrentRouteIsUpdated(String routeIdAsString) {
    pickupAppointmentJobPage.inFrame(() -> {
      String expectedRouteId = resolveValue(routeIdAsString);
      String actualRouteId = pickupAppointmentJobPage.editPAJob.currentRoute.getText();
      Assertions.assertThat(actualRouteId).as("Current route is the same")
          .isEqualToIgnoringCase(expectedRouteId);
    });
  }

  @Then("Operator verifies PA job status is {string} on Edit PA job page")
  public void operatorVerifiesPAJobStatus(String expectedStatus) {
    pickupAppointmentJobPage.inFrame(() -> {
      String actualStatus = pickupAppointmentJobPage.editPAJob.status.getText();
      Assertions.assertThat(actualStatus).as("Status is the same")
          .isEqualToIgnoringCase(expectedStatus);
    });
  }

  @When("Operator selects tag {string} on Edit PA job page")
  public void operatorSelectsTagOnEditJobPage(String tagAsString) {

    pickupAppointmentJobPage.inFrame(() -> {
      String tag = resolveValue(tagAsString);
      pickupAppointmentJobPage.setTagsOnEditPAJobPage(tag);
    });
  }

  @When("Operator clicks update tags button on Edit PA job page")
  public void operatorClicksUpdateTagsButton() {
    pickupAppointmentJobPage.inFrame(() ->
        pickupAppointmentJobPage.updateTagsOnEditPAJobPage());
  }

  @Then("Operator verifies update tags successful message below on Edit PA job page:")
  public void operatorVerifiesUpdateTagSuccessfulMessage(String expectedString) {
    pickupAppointmentJobPage.inFrame(page -> {
      String expectedResult = resolveValue(expectedString);
      Assertions.assertThat(expectedResult).as("Message is the same")
          .isEqualToIgnoringCase(page.getAntTopRightText());
    });
  }

  @Given("Operator remove tag {string} on Edit PA job page")
  public void operatorRemoveTagOnEditPAJobPage(String tagNameAsString) {
    pickupAppointmentJobPage.inFrame(page -> {
      String tagName = resolveValue(tagNameAsString);
      page.removeTagOnEditJobpage(tagName);
    });
  }

  @Then("Operator check pickup jobs {string} ready = {string} and latest = {string}")
  public void checkPickup(String pickupjob, String ready, String latest) {

    PickupAppointmentJob pickupJob = resolveValue(pickupjob);

    Assertions.assertThat(String.valueOf(pickupJob.getPickupReadyDatetime()))
        .as(f("PA Jobs ready time %s: ", ready))
        .contains(ready);
    Assertions.assertThat(String.valueOf(pickupJob.getPickupLatestDatetime()))
        .as(f("PA Jobs latest time %s: ", latest))
        .contains(latest);
  }

  @When("Operator clear pickup job Time Range input")
  public void operatorClearTimeRangeInput() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clearTimeRangeInput();
    });
  }

  @When("Operator clear pickup job custom time Range input")
  public void operatorClearCustomTimeRangeInput() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.createOrEditJobPage.clearCustomTimeRangeInput();
    });
  }


  @Then("Operator verifies button update jobs tag is {string} on Edit PA job page")
  public void operatorVerifiesUpdateTagButtonStatus(String status) {
    pickupAppointmentJobPage.inFrame(page -> {
      switch (status) {
        case "enable":
          Assertions.assertThat(page.editPAJob.updateTags.getAttribute("disabled"))
              .as("Button is enable").isEqualTo(null);
          break;
        case "disable":
          Assertions.assertThat(page.editPAJob.updateTags.getAttribute("disabled"))
              .as("Button is disable").isEqualTo("true");
      }
    });
  }

  @When("Operator clicks Create new job on Edit PA job page")
  public void operatorClickCreateNewJobOnEditJobPage() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.editPAJob.createNewJob.waitUntilClickable();
      page.editPAJob.createNewJob.click();
    });
  }

  @When("Operator select Pickup job tag = {string} in Job Tags Model")
  public void selectJobTagsInJobTagsModel(String tag) {
    pickupAppointmentJobPage.inFrame(page -> {
      page.editJobTagModel.selectTagInJobTagsField(tag);
    });
  }

  @When("Operator check {int} tags with name = {string}")
  public void checkNumberOfTagsWithName(Integer tagsNumber, String tagName) {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        List<String> tagsListInTable = page.bulkSelect.getTagsListWithName(tagName);
        Assertions.assertThat(tagsListInTable)
            .as(f("tag %s in table count is = %s", tagName, tagsNumber)).hasSize(tagsNumber);
      }, 1000, 5);

    });
  }

  @Then("Operator verifies Bulk Update button is {string} on Pickup Jobs page")
  public void operatorVerifiesBulkUpdateButtonStatus(String status) {
    pickupAppointmentJobPage.inFrame(page -> {
      switch (status) {
        case "enable":
          Assertions.assertThat(page.bulkSelect.bulkUpdateDropdown.getAttribute("disabled"))
              .as("Button is enable").isEqualTo(null);
          break;
        case "disable":
          Assertions.assertThat(page.bulkSelect.bulkUpdateDropdown.getAttribute("disabled"))
              .as("Button is disable").isEqualTo("true");
      }
    });
  }

  @Then("Operator verifies the status of Bulk Update options below on Pickup Jobs page")
  public void operatorVerifiesBulkUpdateOptionsStatus(Map<String, String> listOfOptions) {
    pickupAppointmentJobPage.inFrame(page -> {
      if (listOfOptions.get("Route ID") != null) {
        Assertions.assertThat(
                page.bulkSelect.verifyBulkSelectOption("Route ID", listOfOptions.get("Route ID"))).
            as("Route ID status is the same").isTrue();
      }
      if (listOfOptions.get("Success job") != null) {
        Assertions.assertThat(
                page.bulkSelect.verifyBulkSelectOption("Success job",
                    listOfOptions.get("Success job"))).
            as("Success job status is the same").isTrue();
      }
      if (listOfOptions.get("Remove route") != null) {
        Assertions.assertThat(
                page.bulkSelect.verifyBulkSelectOption("Remove route",
                    listOfOptions.get("Remove route"))).
            as("Remove route status is the same").isTrue();
      }
      if (listOfOptions.get("Fail job") != null) {
        Assertions.assertThat(
                page.bulkSelect.verifyBulkSelectOption("Fail job", listOfOptions.get("Fail job"))).
            as("Fail job status is the same").isTrue();
      }
    });
  }

  @When("Operator add route {string} to job {string} in bulk route edit Modal")
  public void addRouteToJobInBulkRouteEditModal(String route, String JobId) {
    pickupAppointmentJobPage.inFrame(page -> {
      String routeName = resolveValue(route);
      String jobId = resolveValue(JobId);

      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        pickupAppointmentJobPage.inFrame(() -> {
          pickupAppointmentJobPage.editJobRouteModal.selectRouteForJob(routeName, jobId);
        });
      }, 1000, 5);
    });
  }

  @When("Operator click update route id button in bulk edit")
  public void clickUpdateRouteId() {
    pickupAppointmentJobPage.inFrame(() -> {

      pickupAppointmentJobPage.editJobRouteModal.updateRouteId.click();

    });
  }

  @When("Operator check {int} route with id = {string}")
  public void checkNumberOfRouteWithId(Integer routeNumber, String id) {

    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        String routeId = resolveValue(id);
        List<String> tagsListInTable = page.bulkSelect.getRouteListWithId(routeId);
        Assertions.assertThat(tagsListInTable)
            .as(f("tag %s in table count is = %s", routeId, routeNumber)).hasSize(routeNumber);
      }, 1000, 5);

    });
  }

  @When("Operator check {int} driver with name = {string}")
  public void checkNumberOfDriverWithName(Integer driverNumber, String name) {

    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        String driverName = resolveValue(name);
        LOGGER.debug(driverName);
        List<String> tagsListInTable = page.bulkSelect.getColListByValue(driverName);
        Assertions.assertThat(tagsListInTable)
            .as(f("tag %s in table count is = %s", driverName, driverNumber)).hasSize(driverNumber);
      }, 1000, 5);

    });
  }

  @When("Operator click Apply to all button in bulk route edit Modal")
  public void clickApplyToAllInBulkRouteEdit() {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        pickupAppointmentJobPage.editJobRouteModal.ApplyThisIdToAll.click();
      }, 1000, 5);

    });
  }

  @When("Operator click on submit button in bulk remove route modal")
  public void clickSubminInBulkRemoveRoute() {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        pickupAppointmentJobPage.removeJobRouteModal.submitButton.click();
      }, 1000, 5);

    });
  }

  @When("Operator check Remove route button is disabled on Pickup Jobs page")
  public void clickBulkRemoveRouteButtonDisabled() {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {

        Assertions.assertThat(pickupAppointmentJobPage.bulkSelect.removeRouteStatus())
            .as("Remove route button is disabled").isTrue();
      }, 1000, 5);

    });
  }

  @When("Operator clicks option {string} of Bulk Update on Pickup Jobs page")
  public void clickOptionOfBulkUpdate(String optionName) {
    pickupAppointmentJobPage.inFrame(page ->
        page.bulkSelect.clickBulkUpdateOption(optionName));
  }

  @Then("Operator verifies error message of {string} on Bulk Update Success Job page")
  public void operatorVerifiesMessageOnSuccessJobPage(String jobIdAsText, String message) {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        String expectedMessage = resolveValue(message);
        String jobId = resolveValue(jobIdAsText);
        String actualMessage = pickupAppointmentJobPage.bulkUpdateSuccess.getErrorMessage(jobId);
        Assertions.assertThat(actualMessage.trim()).as("Error message is the same")
            .isEqualToIgnoringCase(expectedMessage.trim());
      }, 1000, 2);

    });
  }

  @Then("Operator verifies Submit button is {string} on Bulk Update Success Job page")
  public void operatorVerifiesSubmitButtonStatus(String status) {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        switch (status) {
          case "enable":
            Assertions.assertThat(page.bulkUpdateSuccess.submitButton.getAttribute("disabled"))
                .as("Button is enable").isEqualTo(null);
            break;
          case "disable":
            Assertions.assertThat(page.bulkUpdateSuccess.submitButton.getAttribute("disabled"))
                .as("Button is disable").isEqualTo("true");
        }
      }, 1000, 2);

    });
  }

  @When("Operator click select fail reason on bulk fail modal for jobId = {string}")
  public void clickSelectFailReasonOnBulkFailModal(String JobId) {
    String jobId = resolveValue(JobId);
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.bulkFailJobsModal.clickSelectFailReasonForJob(jobId);
      });
    }, 1000, 3);
  }

  @When("Operator click on Submit button on bulk fail modal")
  public void clickSubmitOnBulkFail() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.bulkFailJobsModal.submitButton.click();
      });
    }, 1000, 3);
  }

  @When("Operator click apply fail reason for all in bulk fail modal for jobId = {string}")
  public void clickSelectApplyToAllFailReasonOnBulkFailModal(String JobId) {
    String jobId = resolveValue(JobId);
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.bulkFailJobsModal.clickApplyFailReasonToAll(jobId);
      });
    }, 1000, 3);
  }


  @When("Operator check Error message is shown in fail modal for jobId = {string}")
  public void clickCheckErrorMessageOnBulkFailModal(String JobId) {
    String jobId = resolveValue(JobId);
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        Assertions.assertThat(
                pickupAppointmentJobPage.bulkFailJobsModal.checkCannotFailedErrorMessageForJob(jobId))
            .as("check error message in bulk fail").isTrue();
      });
    }, 1000, 3);
  }

  @When("Operator check Submit button disabled on bulk fail modal")
  public void clickSubmitDisabledOnBulkFail() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        Assertions.assertThat(
                pickupAppointmentJobPage.bulkFailJobsModal.submitButton.isEnabled())
            .as("check Submit button disabled in bulk fail").isFalse();
      });
    }, 1000, 3);
  }


  @Given("Operator performs Success jobs action with data below:")
  public void operatorPeformsBulkUpdateAction(Map<String, String> data) {
    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        Map<String, String> resolvedData = resolveKeyValues(data);
        page.bulkUpdateSuccess.submitButton.waitUntilClickable();
        if ((resolvedData.get("proofUpload") != null) && (resolvedData.get("proofUpload")
            .equalsIgnoreCase("yes"))) {
          page.setProofUploadFile();
        }
        page.bulkUpdateSuccess.submitButton.click();
        page.bulkUpdateSuccess.submitButton.waitUntilInvisible();
      }, 1000, 2);

    });
  }

  @Then("Operator verifies bulk update success job successful message below on Pickup Jobs page:")
  public void operatorVerifiesSuccessJobSuccessfulMessage(String expectedString) {
    pickupAppointmentJobPage.inFrame(page -> {
      String expectedResult = resolveValue(expectedString);
      Assertions.assertThat(expectedResult).as("Message is the same")
          .isEqualToIgnoringCase(page.getAntTopRightText());
    });
  }

  @And("Operator open Route Manifest of created route {value} from Pickup Jobs page")
  public void operatorOpenRouteManifestOfCreatedRouteFromPickupJobPage(String routeId) {

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.bulkSelect.clickColumnRoute(resolveValue(routeId));

        pickupAppointmentJobPage.switchToOtherWindowAndWaitWhileLoading(
            "route-manifest/" + resolveValue(routeId));
      });
    }, 5000, 3);


  }

  @When("Operator click on Create Modify preset button in pickup appointment")
  public void operatorClickCreateModifyPresetInPAM() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.createOrModifyPresetButton.click();
      });
    }, 1000, 3);

  }

  @When("Operator click on Save as Preset button in pickup appointment")
  public void operatorClickSaveAsPresetInPAM() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.saveAsPresetButton.click();
      });
    }, 1000, 3);

  }

  @When("Operator fill Preset name in pickup appointment with = {string}")
  public void operatorFillPresetNameInPAM(String name) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.presetModal.fillPresetName(resolveValue(name));
      });
    }, 1000, 3);

  }

  @When("Operator click save in Preset modal in pickup appointment")
  public void operatorClickSaveInPresetModalInPAM() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.presetModal.savePresetButton.click();
      });
    }, 1000, 3);

  }


  @When("Operator select Preset with name = {string} in pickup appointment")
  public void operatorSelectPresetInPAM(String name) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.presetFilters.click();
        pickupAppointmentJobPage.choosePresetByName(name);
      });
    }, 5000, 5);

  }

  @When("Operator click on Update current Preset button in pickup appointment")
  public void operatorClickUpdateCurrentPresetInPAM() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.updateCurrentPresetButton.click();
      });
    }, 1000, 3);

  }

  @When("Operator verify Preset with name = {string} is not in pickup appointment")
  public void operatorVerifyPresetNotInPAM(String name) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.presetFilters.click();
        pickupAppointmentJobPage.verifyPresetByNameNotInList(name);
      });
    }, 1000, 3);

  }

  @When("Operator click on Delete Preset Preset button in pickup appointment")
  public void operatorClickDeletePresetInPAM() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.deletePresetButton.click();
      });
    }, 1000, 3);

  }

  @When("Operator click on Save as New Preset Preset button in pickup appointment")
  public void operatorClickSaveAsNewPresetInPAM() {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.saveAsNewPresetButton.click();
      });
    }, 1000, 3);

  }

  @When("Operator check {int} Column with value = {string} in PAM search table")
  public void checkNumberOfColumnWithValueInPAMSearchTable(Integer countOfCol, String value) {

    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        String colValue = resolveValue(value);
        List<String> ListInTable = page.bulkSelect.getColListByValue(colValue);
        Assertions.assertThat(ListInTable)
            .as(f("Column %s in table count is = %s", colValue, countOfCol)).hasSize(countOfCol);
      }, 1000, 5);

    });
  }


  @When("Operator pare date time to string {string}")
  public void parseDateTimeToString(String date) {
    String dateToParse = resolveValue(date);
    LocalDateTime dateTime = LocalDateTime.parse(dateToParse,
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'"));
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    String formattedDateTime = dateTime.format(dateTimeFormatter);
    LOGGER.debug(formattedDateTime);
    putInList("KEY_FORMATTED_DATE_TIME", formattedDateTime);
  }


  @When("Operator check {int} route with value = {string} in PAM search table")
  public void checkNumberOfRouteWithValueInPAMSearchTable(Integer countOfCol, String value) {

    pickupAppointmentJobPage.inFrame(page -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        String colValue = resolveValue(value);
        List<String> tagsListInTable = page.bulkSelect.getRouteListByValue(colValue);
        Assertions.assertThat(tagsListInTable)
            .as(f("Column %s in table count is = %s", colValue, countOfCol)).hasSize(countOfCol);
      }, 1000, 5);

    });
  }

  @When("Operator search for {string} = {string} in pickup jobs table")
  public void searchForFailureReasonPickupTable(String SearchTerm, String SearchString) {
    pickupAppointmentJobPage.inFrame(page -> {
      String searchTerm = resolveValue(SearchTerm);
      String searchString = resolveValue(SearchString);
      switch (searchTerm) {
        case "latest time":
          page.bulkSelect.filterTableUsing("pickupLatestDatetimeStr", resolveValue(searchString));
          break;
        case "ready time":
          page.bulkSelect.filterTableUsing("pickupReadyDatetimeStr", resolveValue(searchString));
          break;
        case "address name":
          page.bulkSelect.filterTableUsing("pickupAddress", resolveValue(searchString));
          break;
        case "shipper name":
          page.bulkSelect.filterTableUsing("shipperInfo", resolveValue(searchString));
          break;
        case "shipper id":
          page.bulkSelect.filterTableUsing("legacyShipperId", resolveValue(searchString));
          break;
        case "job id":
          page.bulkSelect.filterTableUsing("pickupAppointmentJobId", resolveValue(searchString));
          break;
        case "failure Reason":
          page.bulkSelect.filterTableUsing("failureReasonDescription", resolveValue(searchString));
          break;
        case "route id":
          page.bulkSelect.filterTableUsing("routeId", resolveValue(searchString));
          break;
        case "driver":
          page.bulkSelect.filterTableUsing("driverName", resolveValue(searchString));
          break;
        case "comment":
          page.bulkSelect.filterTableUsing("pickupInstructions", resolveValue(searchString));
          break;
        case "approx vol":
          page.bulkSelect.filterTableUsing("pickupApproxVolume", resolveValue(searchString));

          break;
        case "create time":
          page.bulkSelect.filterTableUsing("jobCreationTimeStr", resolveValue(searchString));
          break;
      }
    });
  }

  @When("Operator select status = {string} in pickup jobs table")
  public void selectStatusPickupTable(String status) {
    pickupAppointmentJobPage.inFrame(page -> {
      String statusToSelect = resolveValue(status);
      switch (statusToSelect) {
        case "Routed":
          page.bulkSelect.selectStatusInTableUsing("routed");
          break;
        case "Ready for Routing":
          page.bulkSelect.selectStatusInTableUsing("ready-for-routing");
          break;
        case "Failed":
          page.bulkSelect.selectStatusInTableUsing("failed");
          break;
        case "In Progress":
          page.bulkSelect.selectStatusInTableUsing("in-progress");
          break;
        case "Cancelled":
          page.bulkSelect.selectStatusInTableUsing("cancelled");
          break;
        case "Completed":
          page.bulkSelect.selectStatusInTableUsing("completed");
          break;
      }
    });
  }


}

