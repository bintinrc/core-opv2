package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.corev2.cucumber.glue.ControlSteps;
import co.nvqa.common.corev2.model.PickupAppointmentJobResponse;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPage;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.emums.ItemsDeleteJobModalWindow;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.emums.PickupAppointmentFilterNameEnum;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.emums.PickupAppointmentPriorityEnum;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.corev2.cucumber.ControlKeyStorage.KEY_CONTROL_CREATED_PA_JOBS;


@ScenarioScoped
public class PickupAppointmentJobSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(PickupAppointmentJobSteps.class);

  private PickupAppointmentJobPage pickupAppointmentJobPage;
  private List<WebElement> listOFPickupJobsBeforeEditNewJob;

  public PickupAppointmentJobSteps() {

  }

  @Override
  public void init() {
    pickupAppointmentJobPage = new PickupAppointmentJobPage(getWebDriver());
  }


  @When("Operator select from failure drop down number = {string}, failure reason = {string}")
  public void operatorSelectFromFailureReasonDropdown(String dropdownIndex, String failReason) {
    String dropDownIndex = String.valueOf(Integer.parseInt(resolveValue(dropdownIndex)) - 1);
    String failureReason = resolveValue(failReason);

    pickupAppointmentJobPage.inFrame(page -> {
      page.clickFailureReasonDropDown(dropDownIndex);
      page.selectFailureReasonItem(failureReason);
    });

  }

  //  @When("Operator goes to Pickup Jobs Page")
  public void operatorGoesToPickupJobsPage() {
    getWebDriver().manage().window().maximize();
    loadShipperAddressConfigurationPage();
    if (pickupAppointmentJobPage.isToastContainerDisplayed()) {
      pickupAppointmentJobPage.waitUntilInvisibilityOfToast();
    }
    getWebDriver().switchTo().frame(0);
    pickupAppointmentJobPage.waitUntilVisibilityOfElementLocated(
        pickupAppointmentJobPage.getLoadSelection().getWebElement());
  }

  //  @When("Operator click on Create or edit job button on this top right corner of the page")
  public void operatorClickOnCreateOrEditJobButtonOnThisPage() {
    pickupAppointmentJobPage.clickOnCreateOrEditJob();
  }

  //  @And("Operator select shipper id or name = {string} in Shipper ID or Name field")
  public void operatorSelectShipperByIdInSHipperIdOrNameField(String shipperId) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().setShipperIDInField(shipperId);
    put(KEY_LEGACY_SHIPPER_ID, shipperId);
  }

  //  @And("Operator select address = {string} in Shipper Address field")
  public void operatorSelectShipperAddressInShipperAddressField(String shipperAddress) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().setShipperAddressField(shipperAddress);
  }

  @And("Get Pickup Jobs from Calendar")
  public void getPickupJobsFromCalendar() {
    listOFPickupJobsBeforeEditNewJob = pickupAppointmentJobPage.getCreateOrEditJobPage()
        .getAllPickupJobsFromCalendar();
  }

  @Then("Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar")
  public void operatorVerifyShipperIDAndAddressAreDisplayed(Map<String, String> dataTable) {
    final String shipperId = dataTable.get("shipperId");
    final String shipperName = dataTable.get("shipperName");
    final String shipperAddress = dataTable.get("shipperAddress");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isElementDisplayedByTitle(shipperId.concat(" - ").concat(shipperName)))
        .as("Shipper field is filled").isTrue();
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().isElementDisplayedByTitle(shipperAddress))
        .as("Shipper field is filled").isTrue();
  }

  //  @And("Operator verify Create button in displayed")
  public void isCreateButtonDisplayed() {
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().isCreateButtonDisplayed())
        .as("Create button is displayed").isTrue();
  }

  @When("Operator select the data range")
  public void selectDataRange(Map<String, String> dataTable) {
    final String startDay = dataTable.get("startDay");
    final String endDay = dataTable.get("endDay");
    pickupAppointmentJobPage.inFrame(() -> {

      pickupAppointmentJobPage.getCreateOrEditJobPage().selectDataRangeByTitle(startDay, endDay);
    });

  }

  @And("Operator select time slot from Select time range field")
  public void selectTimeSlotFromSelectTimeRangeField(Map<String, String> dataTable) {
    final String timeRange = dataTable.get("timeRange");
    pickupAppointmentJobPage.getCreateOrEditJobPage().selectTimeRangeByDataTime(timeRange);
  }

  @And("Operator click on Submit button")
  public void clickOnSubmitButton() {
    pickupAppointmentJobPage.getCreateOrEditJobPage().clickOnCreateButton();
  }

  @Then("QA verify Job created modal displayed with following format")
  public void QAVerifyJobCreatedModalWindow(Map<String, String> dataTable) {
    final String shipperName = dataTable.get("shipperName");
    final String shipperAddress = dataTable.get("shipperAddress");
    final String startTime = dataTable.get("startTime");
    final String endTime = dataTable.get("endTime");
    final String startDay = dataTable.get("startDay");
    final String endDay = dataTable.get("endDay");
    final String tag = dataTable.get("tag");

    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperNameString())
        .as("Shipper name is correct").isEqualTo(shipperName);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperAddressString())
        .as("Shipper address is correct").contains(shipperAddress);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement().getStartTimeString())
        .as("Start time is correct").isEqualTo(startTime);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement().getEndTimeString())
        .as("End time is correct").isEqualTo(endTime);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString())
        .as("Start day is correct").contains(startDay);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString())
        .as("End day is correct").contains(endDay);
    if (tag != null) {
      Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getTags())
          .as("Job tags is correct").contains(tag);
    }

    pickupAppointmentJobPage.getJobCreatedModalWindowElement().clickOnOKButton();
  }

  @And("QA verify the new created Pickup Jobs is shown in the Calendar by date {string}")
  public void verifyTheNewCreatedPickupJobsIsShownInTheCalendar(String date) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().waitLoadJobInTheCalendarDisplayed(date);
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getAllPickupJobsFromCalendar().size())
        .as("The new created Pickup Jobs is shown in the Calendar")
        .isNotEqualTo(listOFPickupJobsBeforeEditNewJob.size());
  }

  @And("QA verify the new created Pickup Jobs is not shown in the Calendar")
  public void verifyTheNewCreatedPickupJobsIsNotShownInTheCalendar() {
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getAllPickupJobsFromCalendar().size())
        .as("The new created Pickup Jobs is shown in the Calendar")
        .isSameAs(listOFPickupJobsBeforeEditNewJob.size());
  }

  @And("Complete Pickup Job With Route Id")
  public void completePickupJobWithRouteId() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    operatorGoesToPickupJobsPage();
    pickupAppointmentJobPage.clickEditButton().setRouteId(String.valueOf(routeId))
        .clickUpdateRouteButton().clickSuccessJobButton();
  }

  @And("Operator load selection job by date range and shipper")
  public void loadSelectionJobByDateRangeAndShipper(Map<String, String> dataTable) {
    final String startDay = dataTable.get("startDay");
    final String endDay = dataTable.get("endDay");
    String shipperId = dataTable.get("shipperId");
    if (shipperId == null) {
      shipperId = get(KEY_LEGACY_SHIPPER_ID);
    }
    operatorGoesToPickupJobsPage();
    pickupAppointmentJobPage.selectDataRangeByTitle(startDay, endDay).setShipperIDInField(shipperId)
        .clickLoadSelectionButton();
  }

  /*The method of choosing custom time according to the criteria is the time on the startTime and endTime.
  When the specified time is less than 10, it is necessary to write like in the example
     Example:
    | startTime | 9:00  |
    | endTime   | 12:00 |
    */
  @And("Operator select customised time range from Select time range")
  public void selectCustomisedTimeRange(Map<String, String> dataTable) {
    final String readyBy = dataTable.get("readyBy");
    final String latestBy = dataTable.get("latestBy");

    int readyByNumber = Integer.parseInt(readyBy.substring(0, readyBy.indexOf(":")));
    int differentBetweenLatestByAndReadyBy =
        Integer.parseInt(latestBy.substring(0, latestBy.indexOf(":"))) - readyByNumber;

    pickupAppointmentJobPage.getCreateOrEditJobPage().selectCustomTimeAndElement(readyByNumber,
        pickupAppointmentJobPage.getCreateOrEditJobPage().getReadyByField());
    pickupAppointmentJobPage.getCreateOrEditJobPage()
        .selectCustomTimeAndElement(differentBetweenLatestByAndReadyBy,
            pickupAppointmentJobPage.getCreateOrEditJobPage().getLatestByField());

  }

  @Then("QA verify the {int} Job displayed on the Pickup Jobs page")
  public void verifyTheNewJobCreatedOnThePickupJobsPage(Integer numberJobs) {
    Assertions.assertThat(pickupAppointmentJobPage.getNumberOfJobs())
        .as("The new Job created on the Pickup Jobs page").isEqualTo(numberJobs);
  }

  @And("Operator get Job Id from Pickup Jobs page")
  public void operatorGetJobIdFromPickupJobsPage() {
    List<String> jobId = pickupAppointmentJobPage.getJobIdsText();
    put(KEY_LIST_OF_PICKUP_JOB_IDS, jobId);
  }

  @And("QA verify error message shown on the modal and close by message body {string}")
  public void verifyErrorMessageShownOnTheModalAndClose(String messagesBody) {
    getWebDriver().switchTo().defaultContent();
    Assertions.assertThat(
        pickupAppointmentJobPage.verifyMessageInToastModalIsDisplayed(messagesBody)).isTrue();
    while (pickupAppointmentJobPage.isElementExistFast("//*[contains(@class,'toast-error')]")) {
      pickupAppointmentJobPage.closeToast();
    }
  }

  @When("Operator select job tag = {string} in Job Tags Field")
  public void selectJobTagsInJobTagsField(String tag) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().selectTagInJobTagsField(tag);
  }


  @When("Operator click success button in pickup job drawer")
  public void clickFourceSuccess() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.clickForceSuccessButton();
    });
  }

  @When("Operator click Fail button in pickup job drawer")
  public void clickForceFail() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.clickForceFailButton();
    });
  }


  @When("^Operator check Success button (enabled|disabled) in pickup job drawer")
  public void checkSuccessButtonState(String state) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        if (state.equals("enabled")) {
          page.forceSuccess.waitUntilClickable();
        }
        Assertions.assertThat(page.forceSuccess.isEnabled()).as("Force Success button enable state")
            .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
      });
    }, 1000, 5);


  }

  @When("Operator hover on Success button in pickup job drawer")
  public void hoverOnSuccessButton() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.forceSuccess.moveToElement();

    });
  }

  @When("Operator hover on Fail button in pickup job drawer")
  public void hoverOnFailButton() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.forceFail.moveToElement();

    });
  }

  @When("^Operator check Tool tip is (shown|hidden)")
  public void successFailTooltipStatus(String state) {
    pickupAppointmentJobPage.inFrame(page -> {
      page.waitUntilLoaded();
      Assertions.assertThat(page.successFailToolTip.isDisplayed()).as("Check Success Fail tool tip")
          .isEqualTo(StringUtils.equalsIgnoreCase(state, "shown"));
    });


  }


  @When("^Operator check Fail button (enabled|disabled) in pickup job drawer")
  public void checkFailButtonState(String state) {
    pickupAppointmentJobPage.inFrame(page -> {
      if (state.equals("enabled")) {
        page.forceFail.waitUntilClickable();
      }
      Assertions.assertThat(page.forceFail.isEnabled()).as("Force Fail button enable state")
          .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
    });

  }

  @When("Operator click submit button on pickup success job")
  public void clickSubmitSuccess() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.clickSubmitButton();

    });
  }

  @When("Operator click submit button on pickup fail job")
  public void clickSubmitFail() {
    pickupAppointmentJobPage.inFrame(page -> {
      page.clickSubmitButton();

    });
  }

  @When("Operator check proof photo in edit pickup job drawer")
  public void checkProofPhotoInEditDrawer() {
    pickupAppointmentJobPage.inFrame(page -> {
      Assertions.assertThat(page.getProofPhotoInDrawer()).as("Proof photo appears").isNotNull();
    });
  }


  @When("Operator add pickup instructions = {string} in Comment Field")
  public void addPickupInstructionsInJobCommentField(String comment) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().addCommentInCommentField(comment);
  }

  @When("Operator remove pickup instructions in Comment Field")
  public void removePickupInstructionsInJobCommentField() {
    pickupAppointmentJobPage.getCreateOrEditJobPage().clearCommentsInCommentField();
  }

  @Then("QA verify there is Delete button in that particular job tag")
  public void verifyDeleteButtonIsDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isDeleteButtonByJobIdDisplayed(listJobIds.get(0)))
        .as("Delete Button in Job with id = " + listJobIds.get(0) + " displayed").isTrue();
  }

  @Then("QA verify there is no Delete button in that particular job tag")
  public void verifyDeleteButtonIsNotDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isDeleteButtonByJobIdDisplayed(listJobIds.get(0)))
        .as("Delete Button in Job with id = " + listJobIds.get(0) + " displayed").isFalse();
  }

  @Then("QA verify that particular job is removed from calendar on date {string} with status {string}")
  public void verifyParticularJobIsRemoved(String date, String status) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().waitNotificationMessageInvisibility();
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isParticularJobDisplayedByDateAndStatus(date, status))

        .as(f("Particular job is removed from calendar on date %s with status %s", date, status))

        .isFalse();
  }

  @Then("QA verify the jobs with status {string} displayed in the Calendar on the date {string} as well")
  public void verifyJobWithStatusIsDisplayed(String status, String date) {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isParticularJobDisplayedByDateAndStatus(date, status))

        .as(f("Job in the calendar on date $s with status %s displayed", date, status))

        .isTrue();
  }

  @Then("QA verify there is Edit button in that particular job tag")
  public void verifyEditButtonIsDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isEditButtonByJobIdDisplayed(listJobIds.get(0)))
        .as(f("Edit Button in Job with id = %s displayed", listJobIds.get(0))).isTrue();
  }

  @Then("QA verify there is no Edit button in that particular job tag")
  public void verifyEditButtonIsNotDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isEditButtonByJobIdDisplayed(listJobIds.get(0)))
        .as("Edit Button in Job with id = " + listJobIds.get(0) + " displayed").isFalse();
  }

  @When("Operator click on Edit button")
  public void clickOnEditButton() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    pickupAppointmentJobPage.getCreateOrEditJobPage().clickOnEditButtonByJobId(listJobIds.get(0));
  }

  @When("Operator click on Delete button")
  public void clickOnDeleteButton() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    pickupAppointmentJobPage.getCreateOrEditJobPage().clickOnDeleteButtonByJobId(listJobIds.get(0));
  }

  // For correct assertions the start and end day have to be in format dd/MM/yyyy
  @Then("Operator verify the dialog displayed the editable data fields")
  public void verifyTheDialogDisplayedTheEditableDataFields(Map<String, String> dataTable) {
    final String startDay = dataTable.get("startDay");
    final String endDay = dataTable.get("endDay");
    final String timeRange = dataTable.get("timeRange");
    final String readyBy = dataTable.get("readyBy");
    final String latestBy = dataTable.get("latestBy");
    final String tag = dataTable.get("tag");
    final String totalApproxVolume = dataTable.get("totalApproxVolume");
    final String historicalSizeBreakDown = dataTable.get("historicalSizeBreakDown");
    final String comments = dataTable.get("comments");

    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getValueSelectedStartDay())
        .as("Selected start day is correct").isEqualTo(startDay);
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getValueSelectedEndDay())
        .as("Selected end day is correct").isEqualTo(endDay);
    if (timeRange != null) {
      Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
              .isSelectedTimeRangeWebElementDisplayed(timeRange)).as("Selected time range is correct")
          .isTrue();
    }
    if (tag != null) {
      Assertions.assertThat(
              pickupAppointmentJobPage.getCreateOrEditJobPage().getAllTagsFromJobTagsField())
          .as("Selected tags is correct").contains(tag);
    }
    if (comments != null) {
      Assertions.assertThat(
              pickupAppointmentJobPage.getCreateOrEditJobPage().getCommentFromJobCommentField())
          .as("Comment is correct").isEqualToIgnoringCase(comments);
    }
  }

  @Then("Operator verify the Save button still disabled")
  public void verifyIsSaveButtonDisabled() {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isSaveButtonEnable())
        .as("Save button still disabled").isFalse();
  }

  @Then("Operator verify the Cancel button is enabled")
  public void verifyIsCancelButtonIsEnabled() {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isCancelButtonEnable())
        .as("Cancel button is enabled").isTrue();
  }

  @Then("Operator verify the Save button is enabled")
  public void verifyIsSaveButtonIsEnabled() {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isSaveButtonEnable())
        .as("Save button is enabled").isTrue();
  }

  @When("Operator click on Save Button")
  public void clickOnSaveButton() {
    pickupAppointmentJobPage.getCreateOrEditJobPage().clickOnSaveButton();
  }

  @When("Operator click on Cancel Button")
  public void clickOnCancelButton() {
    pickupAppointmentJobPage.getCreateOrEditJobPage().clickOnCancelButton();
  }

  @Then("QA verify successful message is displayed with the job's date and time")
  public void verifySuccessfulMessageIsDisplayedWithDataAndTime(Map<String, String> dataTable) {
    final String startDay = dataTable.get("startDay");
    final String timeRange = dataTable.get("timeRange");
    String notificationMessage = dataTable.get("notificationMessage");
    if (notificationMessage == null) {
      notificationMessage = "Job updated";
    }
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationMessage())
        .as("Notification message is displayed").isEqualTo(notificationMessage);
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationDescription())
        .as("Notification message is contains " + startDay).contains(startDay);
    Assertions.assertThat(
            pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationDescription())
        .as("Notification message is contains " + timeRange).contains(timeRange);
  }

  @Then("QA verify successful message is displayed with the jobID:")
  public void verifySuccessfulMessageIsDisplayedWithJobID(Map<String, String> dataTable) {

    String jobID = resolveValue(dataTable.get("jobID"));
    final String notificationMessage = dataTable.get("notificationMessage");

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(page -> {
        Assertions.assertThat(page.getCreateOrEditJobPage().getTextFromNotificationMessage())
            .as("Notification message is displayed").isEqualTo(notificationMessage);
        Assertions.assertThat(page.getCreateOrEditJobPage().getTextFromNotificationDescription())
            .as(f("Notification message is contains %s:", jobID)).contains(jobID);
      });
    }, 1000, 3);


  }

  @Then("Operator verify the dialog shows the job tag")
  public void verifyTheDialogShowsTheJogTag(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String tag = dataTable.get("tag");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
        .isTagDisplayedOnPickupJobByDate(date, tag)).as("Tag is displayed").isTrue();
  }

  @Then("Operator verify the dialog shows the comment")
  public void verifyTheDialogShowsTheComment(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String comment = dataTable.get("comment");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
        .isDisplayedCommentTextInCalendar(date, comment)).as("Comment is displayed").isTrue();
  }

  @Then("Operator verify the particular job tag in the Calendar changes from grey to black with white text")
  public void verifyThePickupJobInTheCalendarChangesFromGreyToBlack(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String status = dataTable.get("status");
    final String color = dataTable.get("color");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .getColorAttributeInPickupJobFromCalendar(date, status)).as("Pickup job has correct color")
        .contains("color: " + color);
  }

  @Then("Operator verify the dialog not shows the job tag")
  public void verifyTheDialogNotShowsTheJogTag(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String tag = dataTable.get("tag");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
        .isTagDisplayedOnPickupJobByDate(date, tag)).as("Tag is displayed").isFalse();
  }

  @When("Operator remove the tags in Job Tag field")
  public void removeTheTagsInJobTagField() {
    pickupAppointmentJobPage.getCreateOrEditJobPage().removeAllTags();
  }

  /*For list of data using ', ' symbols
   * Example
   * | jobStatus      | Ready for Routing, Routed        |*/
  @Then("QA verify filters on Pickup Jobs page are shown")
  public void verifyFiltersOnPickupJobsPageAreShown(Map<String, String> dataTable) {

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {

        final String dateStart = dataTable.get("dateStart");
        String dateEnd = dataTable.get("dateEnd");
        final String priority = dataTable.get("priority");
        final String jobServiceType = dataTable.get("jobServiceType");
        final String jobServiceLevel = dataTable.get("jobServiceLevel");
        final String jobStatus = dataTable.get("jobStatus");
        final String zones = dataTable.get("zones");
        final String masterShippers = dataTable.get("masterShippers");
        final String shippers = dataTable.get("shippers");

        if (dateEnd == null) {
          dateEnd = dateStart;
        }
        verifyDataRange(dateStart, dateEnd);
        verifyPriority(priority);

        if (jobServiceLevel == null) {
          verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.SERVICE_LEVEL.getName(),
              "Job Service Level is correct");
        } else {
          verifySelectedInJobAppointmentPage(Arrays.asList(jobServiceLevel.split(", ")),
              PickupAppointmentFilterNameEnum.SERVICE_LEVEL.getName(),
              "Job Service Level is correct");
        }
        if (jobServiceType == null) {
          verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.SERVICE_TYPE.getName(),
              "Job Service Type is correct");
        } else {
          verifySelectedInJobAppointmentPage(Arrays.asList(jobServiceType.split(", ")),
              PickupAppointmentFilterNameEnum.SERVICE_TYPE.getName(),
              "Job Service Type is correct");
        }
        if (jobStatus == null) {
          verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.STATUS.getName(), "Job Status is correct");
        } else {
          verifySelectedInJobAppointmentPage(Arrays.asList(jobStatus.split(", ")),
              PickupAppointmentFilterNameEnum.STATUS.getName(), "Job Status is correct");
        }
        if (zones == null) {
          verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.ZONES.getName(), "Zones is correct");
        } else {
          verifySelectedInJobAppointmentPage(Arrays.asList(zones.split(", ")),
              PickupAppointmentFilterNameEnum.ZONES.getName(), "Zones is correct");
        }
        if (masterShippers == null) {
          verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.MASTER_SHIPPER.getName(),
              "Master Shippers is correct");
        } else {
          verifySelectedInJobAppointmentPage(Arrays.asList(masterShippers.split(", ")),
              PickupAppointmentFilterNameEnum.MASTER_SHIPPER.getName(),
              "Master Shippers is correct");
        }
        if (shippers == null) {
          verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.SHIPPER.getName(), "Shippers is correct");
        } else {
          verifySelectedInJobAppointmentPage(Arrays.asList(shippers.split(", ")),
              PickupAppointmentFilterNameEnum.SHIPPER.getName(), "Shippers is correct");
        }
      });
    }, 1000, 3);
  }

  @When("Operator click on Show or hide dropdown button")
  public void clickOnShowOrHideDropdownButton() {
    pickupAppointmentJobPage.inFrame(() -> {

      pickupAppointmentJobPage.clickOnShowOrHideFilters();
    });
  }

  @Then("QA verify filters are hidden")
  public void verifyFiltersAreHidden() {
    pickupAppointmentJobPage.inFrame(() -> {
      Assertions.assertThat(pickupAppointmentJobPage.verifyIsFiltersBlockInvisible())
          .as("Filters are hidden").isTrue();
    });
  }

  @When("Operator fills in the Shippers field with valid shipper = {string}")
  public void fillInTheShippersFieldValidShipper(String shipperId) {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.setShipperIDInField(shipperId);
    });

  }

  @When("Operator click load selection on pickup jobs filter")
  public void clickLoadSelection() {
    pickupAppointmentJobPage.inFrame(() -> {

      pickupAppointmentJobPage.clickLoadSelectionButton();
    });
  }

  @After("@deletePickupJob")
  public void deletePickUpJob() {
    try {
      List<PickupAppointmentJobResponse> listPAJobs = get(KEY_CONTROL_CREATED_PA_JOBS);
      List<Long> jobIds = listPAJobs.stream().map(PickupAppointmentJobResponse::getId).collect(
          Collectors.toList());
      jobIds.forEach((jobId) -> {
        new ControlSteps().operatorDeletePickupAppointmentJobWithJobID(String.valueOf(jobId));
      });
    } catch (Throwable ex) {
      LOGGER.warn(f("Can not delete pickup job: %s", ex.getMessage()));
    }

  }

  @When("Operator select only In progress job status, on pickup jobs filter")
  public void selectInProgressJobStatus() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clearJobStatusFilter();
      pickupAppointmentJobPage.selectInprogressJobStatus();
    });
  }


  @When("Operator click on Clear Selection button")
  public void clickOnClearSelectionButton() {
    pickupAppointmentJobPage.inFrame(() -> {

      pickupAppointmentJobPage.clickOnClearSelectionButton();
    });
  }

  @When("Operator upload Success proof photo on pickup appointment job")
  public void uploadSuccessProofPhoto() {
    pickupAppointmentJobPage.inFrame(page -> {
      pickupAppointmentJobPage.addSuccessProofPhoto();
    });
  }

  @When("Operator upload Fail proof photo on pickup appointment job")
  public void uploadFailProofPhoto() {
    pickupAppointmentJobPage.inFrame(page -> {
      pickupAppointmentJobPage.addFailProofPhoto();
    });
  }

  @When("Operator click proceed fail on pickup appointment job")
  public void clickProceedOnFail() {
    pickupAppointmentJobPage.inFrame(page -> {
      pickupAppointmentJobPage.clickFailProceed();
    });
  }

  @When("Operator check pickup fail modal for job id = {string} has:")
  public void checkFailPickupModal(String jobID, List<String> data) {

    String finalJobID = resolveValue(jobID);
    pickupAppointmentJobPage.inFrame(page -> {
      String failTitle = page.getFailModelTitle();
      Assertions.assertThat(failTitle).as("Fail Model contain reason").contains(finalJobID);
    });

    data = resolveValues(data);
    data.forEach(reason -> {
      pickupAppointmentJobPage.inFrame(page -> {
        String failReason = page.getFailModelReasons();
        Assertions.assertThat(failReason).as("Fail Model contain reason").contains(reason);
      });
    });

  }


  @When("Operator click Preset Filters field")
  public void openPresetFiltersField() {
    pickupAppointmentJobPage.inFrame(() -> {
          pickupAppointmentJobPage.clickOnPresetFilters();

        }
    );
  }

  @Then("QA verify dropdown menu shown with a list of saved preset")
  public void verifyDropdownMenuShownWIthAListOfSavedPreset() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
      Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuDisplayed())
          .as("Preset Filter Dropdown Menu is displayed").isTrue();
      pickupAppointmentJobPage.clickOnPresetFilters();
    });

  }

  @When("Operator click Data Range field")
  public void clickDataRangeField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnSelectStartDay();

    });
  }

  @When("Operator click Priority field")
  public void clickPriorityField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnPriorityButton();
    });

  }

  @Then("QA verify a dropdown menu shown with priority option")
  public void verifyADropdownMenuShownWIthPriorityOption() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
      Assertions.assertThat(pickupAppointmentJobPage.isJobPriorityFilterByNameDisplayed(
              PickupAppointmentPriorityEnum.PRIORITY.getName()))
          .as("Priority in Priority Filter is displayed").isTrue();
      Assertions.assertThat(pickupAppointmentJobPage.isJobPriorityFilterByNameDisplayed(
              PickupAppointmentPriorityEnum.NON_PRIORITY.getName()))
          .as("Non-Priority in Priority Filter is displayed").isTrue();
      pickupAppointmentJobPage.clickOnPriorityButton();
    });

  }

  @When("Operator click Job Service Type field")
  public void clickJobServiceTypeField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnJobServiceType();
    });

  }

  @Then("QA verify a dropdown menu shown with no data")
  public void verifyServiceTypeDropdownMenuShown() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
      Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuDisplayed())
          .as("Service Type Filter Dropdown Menu is displayed").isTrue();
      pickupAppointmentJobPage.clickOnJobServiceType();
    });

  }

  @When("Operator click Job Service Level field")
  public void clickJobServiceLevelField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnJobServiceLevel();

    });
  }

  @When("Operator click Job Status field")
  public void clickJobStatusField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnJobStatus();
    });

  }

  @And("QA verify data start to end limited to 7 days")
  public void verifyDataStartToEndLimitedToSevenDays() {
    pickupAppointmentJobPage.inFrame(() -> {
      String startDay = getDateByDaysAgo(7);
      String endDay = getDateByDaysLater(7);
      pickupAppointmentJobPage.verifyDataStartToEndLimited(startDay, endDay);
    });

  }

  @And("Select multiple service level")
  public void selectMultipleServiceLevel() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.selectServiceLevel();
      pickupAppointmentJobPage.selectServiceLevel();
      pickupAppointmentJobPage.clickOnJobServiceLevel();
    });


  }

  @And("Select multiple job Status")
  public void selectMultipleJobStatus() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.selectJobStatus();
      pickupAppointmentJobPage.selectJobStatus();
      pickupAppointmentJobPage.clickOnJobStatus();
    });

  }

  /*For list of data using ', ' symbols
   * Example
   * | zones      | Zone1, Zone2        |*/
  @And("Select multiple job Zone")
  public void selectMultipleJobZone(Map<String, String> dataTable) {
    pickupAppointmentJobPage.inFrame(() -> {
      final String zones = dataTable.get("zones");
      List<String> zone = Arrays.asList(zones.split(", "));
      zone.forEach(s -> {
        pickupAppointmentJobPage.inputOnJobZone(s);
        pickupAppointmentJobPage.selectJobSelection(s);
      });
      pickupAppointmentJobPage.clickOnJobZone();
    });

  }

  /*For list of data using ', ' symbols
   * Example
   * | masterShipper      | masterShipper1, masterShipper2        |*/
  @And("Select multiple job Master Shipper")
  public void selectMultipleJobMasterShipper(Map<String, String> dataTable) {
    pickupAppointmentJobPage.inFrame(() -> {
      final String zones = dataTable.get("masterShipper");
      List<String> zone = Arrays.asList(zones.split(", "));
      zone.forEach(s -> {
        pickupAppointmentJobPage.inputOnJobMasterShipper(s);
        pickupAppointmentJobPage.selectJobSelection(s);
      });
      pickupAppointmentJobPage.clickOnJobMasterShipper();
    });

  }

  @When("Operator click Job Zone field")
  public void clickJobZoneField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnJobZone();
    });

  }

  @When("Operator click Job Master Shipper field")
  public void clickJobMasterShipperField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnJobMasterShipper();
    });

  }

  @When("Operator click Job Shipper field")
  public void clickJobShipperField() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.clickOnJobShipper();
    });

  }

  @Then("QA verify a dropdown menu shown")
  public void verifyADropdownMenuShown() {
    pickupAppointmentJobPage.inFrame(() -> {
      pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
      Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuDisplayed())
          .as("Dropdown Menu is displayed").isTrue();
    });

  }

  @Then("QA verify Shipper list will be shown after operator type 3 characters or more {string} in the Shipper field")
  public void verifyShipperListShownAfterTypeThreeCharacters(String text) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      pickupAppointmentJobPage.inFrame(() -> {
        pickupAppointmentJobPage.inputOnJobShipper(text);
        pickupAppointmentJobPage.clearOnJobShipper();
        pickupAppointmentJobPage.inputOnJobShipper(text);
        pickupAppointmentJobPage.clearOnJobShipper();
      });
    }, 3000, 3);


  }

  @Then("QA verify Delete dialog displays the jobs information")
  public void verifyDeleteJobModalWindow(Map<String, String> dataTable) {
    final String shipperName = dataTable.get("shipperName");
    final String shipperAddress = dataTable.get("shipperAddress");
    final String readyBy = dataTable.get("readyBy");
    final String latestBy = dataTable.get("latestBy");
    final String priority = dataTable.get("priority");
    Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement()
            .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.SHIPPER_NAME.getName()))
        .as("Shipper name is correct").isEqualTo(shipperName);
    Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement()
            .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.SHIPPER_ADDRESS.getName()))
        .as("Shipper address is correct").contains(shipperAddress);
    Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement()
            .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.READY_BY.getName()))
        .as("Ready by is correct").isEqualTo(readyBy);
    Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement()
            .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.LATEST_BY.getName()))
        .as("Latest by is correct").isEqualTo(latestBy);
    if (priority != null) {
      Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement()
              .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.PRIORITY.getName()))
          .as("Priority tags is correct").contains(priority);
    }
  }

  @When("Operator click on Submit button on Delete Job modal window")
  public void clickOnSubmitButtonOnDeleteJobModal() {
    pickupAppointmentJobPage.getJobCreatedModalWindowElement()
        .clickOnSubmitButtonOnDeleteJobModal();
  }

  // This method can be removed once redirection to Shipper Address is added in operator V2 menu
  public void loadShipperAddressConfigurationPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
  }

  public void verifyDataRange(String dataRangeStart, String dataRangeEnd) {
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedStartDay())
        .as("Start day in Date range is correct").isEqualTo(dataRangeStart);
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedEndDay())
        .as("End day in Date range is correct").isEqualTo(dataRangeEnd);
  }

  public void verifyPriority(String priority) {
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedPriority()).as("Priority is correct")
        .isEqualTo(priority);
  }

  public void verifySelectedInJobAppointmentPage(List<String> jobServiceTypeList,
      String jobNameFilter, String messages) {
    verifyFilters(pickupAppointmentJobPage.getAllSelectedByJobName(jobNameFilter),
        jobServiceTypeList, messages);
  }

  private void verifyFilters(List<String> actualList, List<String> expectedList, String message) {
    Assertions.assertThat(actualList).as(message).isEqualTo(expectedList);
  }

  private String getDateByDaysAgo(int amount) {
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    LocalDateTime now = LocalDateTime.now();
    LocalDateTime then = now.minusDays(amount);
    return then.format(format);
  }

  private String getDateByDaysLater(int amount) {
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    LocalDateTime now = LocalDateTime.now();
    LocalDateTime then = now.plusDays(amount);

    return then.format(format);
  }

  @Then("QA verify a service level dropdown menu shown")
  public void verifyServiceLevelDropdownMenuShown() {
    pickupAppointmentJobPage.inFrame(() -> {
      Assertions.assertThat(pickupAppointmentJobPage.isServiceLevelDropdownMenuDisplayed())
          .as("Service Level Dropdown Menu is displayed").isTrue();
    });
  }

  @Then("QA verify a service type dropdown menu shown")
  public void verifyServiceTypeDropdownShown() {
    pickupAppointmentJobPage.inFrame(() -> {
      Assertions.assertThat(pickupAppointmentJobPage.isServiceTypeDropdownMenuDisplayed())
          .as("Service Type Dropdown Menu is displayed").isTrue();
    });
  }

  @Then("QA verify a job status dropdown menu shown")
  public void verifyJobStatusDropdownShown() {
    pickupAppointmentJobPage.inFrame(() -> {
      Assertions.assertThat(pickupAppointmentJobPage.isJobStatusDropdownMenuDisplayed())
          .as("Job Status Dropdown Menu is displayed").isTrue();
    });
  }

  @Then("QA verify a zones dropdown menu shown")
  public void verifyZonesDropdownShown() {
    pickupAppointmentJobPage.inFrame(() -> {
      Assertions.assertThat(pickupAppointmentJobPage.isZonesDropdownMenuDisplayed())
          .as("Zones Dropdown Menu is displayed").isTrue();
    });
  }
}
