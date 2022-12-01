package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPage;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.emums.ItemsDeleteJobModalWindow;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.emums.PickupAppointmentFilterNameEnum;
import co.nvqa.operator_v2.selenium.page.pickupAppointment.emums.PickupAppointmentPriorityEnum;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

  @When("Operator goes to Pickup Jobs Page")
  public void operatorGoesToPickupJobsPage() {
    getWebDriver().manage().window().maximize();
    openPickupJobsPage();
    if (pickupAppointmentJobPage.isToastContainerDisplayed()) {
      pickupAppointmentJobPage.waitUntilInvisibilityOfToast();
    }
    getWebDriver().switchTo().frame(0);
    pickupAppointmentJobPage.waitUntilVisibilityOfElementLocated(
            pickupAppointmentJobPage.getLoadSelection().getWebElement());
  }

  @And("Operator click on Create or edit job button on this top right corner of the page")
  public void operatorClickOnCreateOrEditJobButtonOnThisPage() {
    pickupAppointmentJobPage.clickOnCreateOrEditJob();
  }

  @And("Operator select shipper id or name = {string} in Shipper ID or Name field")
  public void operatorSelectShipperByIdInSHipperIdOrNameField(String shipperId) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().setShipperIDInField(shipperId);
    put(KEY_LEGACY_SHIPPER_ID, shipperId);
  }

  @And("Operator select address = {string} in Shipper Address field")
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
            .as("Shipper field is filled")
            .isTrue();
    Assertions.assertThat(
                    pickupAppointmentJobPage.getCreateOrEditJobPage().isElementDisplayedByTitle(shipperAddress))
            .as("Shipper field is filled")
            .isTrue();
  }

  @And("Operator verify Create button in displayed")
  public void isCreateButtonDisplayed() {
    Assertions.assertThat(
                    pickupAppointmentJobPage.getCreateOrEditJobPage().isCreateButtonDisplayed())
            .as("Create button is displayed")
            .isTrue();
  }

  @When("Operator select the data range")
  public void selectDataRange(Map<String, String> dataTable) {
    final String startDay = dataTable.get("startDay");
    final String endDay = dataTable.get("endDay");

    pickupAppointmentJobPage.getCreateOrEditJobPage().selectDataRangeByTitle(startDay, endDay);
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
            .as("Shipper name is correct")
            .isEqualTo(shipperName);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperAddressString())
            .as("Shipper address is correct")
            .contains(shipperAddress);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getJobCreatedModalWindowElement().getStartTimeString())
            .as("Start time is correct")
            .isEqualTo(startTime);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getJobCreatedModalWindowElement().getEndTimeString())
            .as("End time is correct")
            .isEqualTo(endTime);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString())
            .as("Start day is correct")
            .contains(startDay);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString())
            .as("End day is correct")
            .contains(endDay);
    if (tag != null) {
      Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getTags())
              .as("Job tags is correct")
              .contains(tag);
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
    pickupAppointmentJobPage
            .clickEditButton()
            .setRouteId(String.valueOf(routeId))
            .clickUpdateRouteButton()
            .clickSuccessJobButton();
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
    pickupAppointmentJobPage
            .selectDataRangeByTitle(startDay, endDay)
            .setShipperIDInField(shipperId)
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
            .as("The new Job created on the Pickup Jobs page")
            .isEqualTo(numberJobs);
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
            .as("Delete Button in Job with id = " + listJobIds.get(0) + " displayed")
            .isTrue();
  }

  @Then("QA verify there is no Delete button in that particular job tag")
  public void verifyDeleteButtonIsNotDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isDeleteButtonByJobIdDisplayed(listJobIds.get(0)))
        .as("Delete Button in Job with id = " + listJobIds.get(0) + " displayed")
        .isFalse();
  }

  @Then("QA verify that particular job is removed from calendar on date {string} with status {string}")
  public void verifyParticularJobIsRemoved(String date, String status) {
    pickupAppointmentJobPage.getCreateOrEditJobPage().waitNotificationMessageInvisibility();
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isParticularJobDisplayedByDateAndStatus(date,status))
        .as("Particular job is removed from calendar on date " + date  + " with status " + status)
        .isFalse();
  }

  @Then("QA verify the jobs with status {string} displayed in the Calendar on the date {string} as well")
  public void verifyJobWithStatusIsDisplayed(String status,String date) {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isParticularJobDisplayedByDateAndStatus(date,status))
        .as("Job in the calendar on date " + date  + " with status " + status + " displayed")
        .isTrue();
  }

  @Then("QA verify there is Edit button in that particular job tag")
  public void verifyEditButtonIsDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
                    .isEditButtonByJobIdDisplayed(listJobIds.get(0)))
            .as("Edit Button in Job with id = " + listJobIds.get(0) + " displayed")
            .isTrue();
  }

  @Then("QA verify there is no Edit button in that particular job tag")
  public void verifyEditButtonIsNotDisplayed() {
    List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .isEditButtonByJobIdDisplayed(listJobIds.get(0)))
        .as("Edit Button in Job with id = " + listJobIds.get(0) + " displayed")
        .isFalse();
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
            .as("Selected start day is correct")
            .isEqualTo(startDay);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getCreateOrEditJobPage().getValueSelectedEndDay())
            .as("Selected end day is correct")
            .isEqualTo(endDay);
    if (timeRange != null) {
      Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
                      .isSelectedTimeRangeWebElementDisplayed(timeRange))
              .as("Selected time range is correct")
              .isTrue();
    }
    if (tag != null) {
      Assertions.assertThat(
                      pickupAppointmentJobPage.getCreateOrEditJobPage().getAllTagsFromJobTagsField())
              .as("Selected tags is correct")
              .contains(tag);
    }
    if (comments != null) {
      Assertions.assertThat(
                      pickupAppointmentJobPage.getCreateOrEditJobPage().getCommentFromJobCommentField())
              .as("Comment is correct")
              .isEqualToIgnoringCase(comments);
    }
  }

  @Then("Operator verify the Save button still disabled")
  public void verifyIsSaveButtonDisabled() {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isSaveButtonEnable())
            .as("Save button still disabled")
            .isFalse();
  }

  @Then("Operator verify the Cancel button is enabled")
  public void verifyIsCancelButtonIsEnabled() {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isCancelButtonEnable())
            .as("Cancel button is enabled")
            .isTrue();
  }

  @Then("Operator verify the Save button is enabled")
  public void verifyIsSaveButtonIsEnabled() {
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isSaveButtonEnable())
            .as("Save button is enabled")
            .isTrue();
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
        .as("Notification message is displayed")
        .isEqualTo(notificationMessage);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationDescription())
            .as("Notification message is contains " + startDay)
            .contains(startDay);
    Assertions.assertThat(
                    pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationDescription())
            .as("Notification message is contains " + timeRange)
            .contains(timeRange);
  }

  @Then("Operator verify the dialog shows the job tag")
  public void verifyTheDialogShowsTheJogTag(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String tag = dataTable.get("tag");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
                    .isTagDisplayedOnPickupJobByDate(date, tag))
            .as("Tag is displayed")
            .isTrue();
  }

  @Then("Operator verify the dialog shows the comment")
  public void verifyTheDialogShowsTheComment(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String comment = dataTable.get("comment");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
                    .isDisplayedCommentTextInCalendar(date, comment))
            .as("Comment is displayed")
            .isTrue();
  }

  @Then("Operator verify the particular job tag in the Calendar changes from grey to black with white text")
  public void verifyThePickupJobInTheCalendarChangesFromGreyToBlack(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String status = dataTable.get("status");
    final String color = dataTable.get("color");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
            .getColorAttributeInPickupJobFromCalendar(date,status))
        .as("Pickup job has correct color")
        .contains(color);
  }

  @Then("Operator verify the dialog not shows the job tag")
  public void verifyTheDialogNotShowsTheJogTag(Map<String, String> dataTable) {
    final String date = dataTable.get("date");
    final String tag = dataTable.get("tag");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage()
                    .isTagDisplayedOnPickupJobByDate(date, tag))
            .as("Tag is displayed")
            .isFalse();
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
              PickupAppointmentFilterNameEnum.STATUS.getName(),
              "Job Status is correct");
    }
    if (zones == null) {
      verifySelectedInJobAppointmentPage(new ArrayList<>(),
              PickupAppointmentFilterNameEnum.ZONES.getName(), "Zones is correct");
    } else {
      verifySelectedInJobAppointmentPage(Arrays.asList(zones.split(", ")),
              PickupAppointmentFilterNameEnum.ZONES.getName(),
              "Zones is correct");
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
              PickupAppointmentFilterNameEnum.SHIPPER.getName(),
              "Shippers is correct");
    }
  }

  @When("Operator click on Show or hide dropdown button")
  public void clickOnShowOrHideDropdownButton() {
    pickupAppointmentJobPage.clickOnShowOrHideFilters();
  }

  @Then("QA verify filters are hidden")
  public void verifyFiltersAreHidden() {
    Assertions.assertThat(pickupAppointmentJobPage.verifyIsFiltersBlockInvisible())
            .as("Filters are hidden")
            .isTrue();
  }

  @When("Operator fills in the Shippers field with valid shipper = {string}")
  public void fillInTheShippersFieldValidShipper(String shipperId) {
    pickupAppointmentJobPage.setShipperIDInField(shipperId);
  }

  @When("Operator click on Clear Selection button")
  public void clickOnClearSelectionButton() {
    pickupAppointmentJobPage.clickOnClearSelectionButton();
  }

  @When("Operator click Preset Filters field")
  public void openPresetFiltersField() {
    pickupAppointmentJobPage.clickOnPresetFilters();
  }

  @Then("QA verify dropdown menu shown with a list of saved preset")
  public void verifyDropdownMenuShownWIthAListOfSavedPreset() {
    pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
    Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuDisplayed())
            .as("Preset Filter Dropdown Menu is displayed")
            .isTrue();
    pickupAppointmentJobPage.clickOnPresetFilters();
  }

  @When("Operator click Data Range field")
  public void clickDataRangeField() {
    pickupAppointmentJobPage.clickOnSelectStartDay();
  }

  @When("Operator click Priority field")
  public void clickPriorityField() {
    pickupAppointmentJobPage.clickOnPriorityButton();
  }

  @Then("QA verify a dropdown menu shown with priority option")
  public void verifyADropdownMenuShownWIthPriorityOption() {
    pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
    Assertions.assertThat(pickupAppointmentJobPage.isJobPriorityFilterByNameDisplayed(
                    PickupAppointmentPriorityEnum.PRIORITY.getName()))
            .as("Priority in Priority Filter is displayed")
            .isTrue();
    Assertions.assertThat(
                    pickupAppointmentJobPage.isJobPriorityFilterByNameDisplayed(
                            PickupAppointmentPriorityEnum.NON_PRIORITY.getName()))
            .as("Non-Priority in Priority Filter is displayed")
            .isTrue();
    pickupAppointmentJobPage.clickOnPriorityButton();
  }

  @When("Operator click Job Service Type field")
  public void clickJobServiceTypeField() {
    pickupAppointmentJobPage.clickOnJobServiceType();
  }

  @Then("QA verify a dropdown menu shown with no data")
  public void verifyServiceTypeDropdownMenuShown() {
    pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
    Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuDisplayed())
            .as("Service Type Filter Dropdown Menu is displayed")
            .isTrue();
    pickupAppointmentJobPage.clickOnJobServiceType();
  }

  @When("Operator click Job Service Level field")
  public void clickJobServiceLevelField() {
    pickupAppointmentJobPage.clickOnJobServiceLevel();
  }

  @When("Operator click Job Status field")
  public void clickJobStatusField() {
    pickupAppointmentJobPage.clickOnJobStatus();
  }

  @And("QA verify data start to end limited to 7 days")
  public void verifyDataStartToEndLimitedToSevenDays() {
    String startDay = getDateByDaysAgo(7);
    String endDay = getDateByDaysLater(7);
    pickupAppointmentJobPage
            .verifyDataStartToEndLimited(startDay, endDay);
  }

  @And("Select multiple service level")
  public void selectMultipleServiceLevel() {
    pickupAppointmentJobPage.selectServiceLevel();
    pickupAppointmentJobPage.selectServiceLevel();
    pickupAppointmentJobPage.clickOnJobServiceLevel();
  }

  @And("Select multiple job Status")
  public void selectMultipleJobStatus() {
    pickupAppointmentJobPage.selectJobStatus();
    pickupAppointmentJobPage.selectJobStatus();
    pickupAppointmentJobPage.clickOnJobStatus();
  }

  /*For list of data using ', ' symbols
   * Example
   * | zones      | Zone1, Zone2        |*/
  @And("Select multiple job Zone")
  public void selectMultipleJobZone(Map<String, String> dataTable) {
    final String zones = dataTable.get("zones");
    List<String> zone = Arrays.asList(zones.split(", "));
    zone.forEach(s -> {
      pickupAppointmentJobPage.inputOnJobZone(s);
      pickupAppointmentJobPage.selectJobSelection(s);
    });
    pickupAppointmentJobPage.clickOnJobZone();
  }

  /*For list of data using ', ' symbols
   * Example
   * | masterShipper      | masterShipper1, masterShipper2        |*/
  @And("Select multiple job Master Shipper")
  public void selectMultipleJobMasterShipper(Map<String, String> dataTable) {
    final String masterShipper = dataTable.get("masterShippers");
    List<String> masterShippers = Arrays.asList(masterShipper.split(", "));
    masterShippers.forEach(s -> {
      pickupAppointmentJobPage.inputOnJobMasterShipper(s);
      pickupAppointmentJobPage.selectJobSelection(s);
    });
    pickupAppointmentJobPage.clickOnJobMasterShipper();
  }

  @When("Operator click Job Zone field")
  public void clickJobZoneField() {
    pickupAppointmentJobPage.clickOnJobZone();
  }

  @When("Operator click Job Master Shipper field")
  public void clickJobMasterShipperField() {
    pickupAppointmentJobPage.clickOnJobMasterShipper();
  }

  @When("Operator click Job Shipper field")
  public void clickJobShipperField() {
    pickupAppointmentJobPage.clickOnJobShipper();
  }

  @Then("QA verify a dropdown menu shown")
  public void verifyADropdownMenuShown() {
    pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
    Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuDisplayed())
            .as("Dropdown Menu is displayed")
            .isTrue();
  }

  @Then("QA verify Shipper list will be shown after operator type 3 characters or more {string} in the Shipper field")
  public void verifyShipperListShownAfterTypeThreeCharacters(String text) {
    pickupAppointmentJobPage.waitUntilDropdownMenuVisible();
    Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuWithoutDataDisplayed())
            .as("Dropdown Menu No Data is displayed")
            .isTrue();
    pickupAppointmentJobPage.inputOnJobShipper(text);
    Assertions.assertThat(pickupAppointmentJobPage.isFilterDropdownMenuShipperWithDataDisplayed())
            .as("Dropdown Menu No Data is displayed")
            .isTrue();
    pickupAppointmentJobPage.clearOnJobShipper();
  }

  @Then("QA verify Delete dialog displays the jobs information")
  public void verifyDeleteJobModalWindow(Map<String, String> dataTable) {
    final String shipperName = dataTable.get("shipperName");
    final String shipperAddress = dataTable.get("shipperAddress");
    final String readyBy = dataTable.get("readyBy");
    final String latestBy = dataTable.get("latestBy");
    final String priority = dataTable.get("priority");
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement()
                .getItemTextOnDeleteJobModalByNameItem(
                    ItemsDeleteJobModalWindow.SHIPPER_NAME.getName()))
        .as("Shipper name is correct")
        .isEqualTo(shipperName);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement()
                .getItemTextOnDeleteJobModalByNameItem(
                    ItemsDeleteJobModalWindow.SHIPPER_ADDRESS.getName()))
        .as("Shipper address is correct")
        .contains(shipperAddress);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement()
                .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.READY_BY.getName()))
        .as("Ready by is correct")
        .isEqualTo(readyBy);
    Assertions.assertThat(
            pickupAppointmentJobPage.getJobCreatedModalWindowElement()
                .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.LATEST_BY.getName()))
        .as("Latest by is correct")
        .isEqualTo(latestBy);
    if (priority != null) {
      Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement()
              .getItemTextOnDeleteJobModalByNameItem(ItemsDeleteJobModalWindow.PRIORITY.getName()))
          .as("Priority tags is correct")
          .contains(priority);
    }
  }

  @When("Operator click on Submit button on Delete Job modal window")
  public void clickOnSubmitButtonOnDeleteJobModal() {
    pickupAppointmentJobPage.getJobCreatedModalWindowElement()
        .clickOnSubmitButtonOnDeleteJobModal();
  }

  @When("Operator filled in the filters")
  public void filledInTheFiltersOnPickupJob(Map<String, String> dataTable) {
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

    if (dateStart != null) {
      pickupAppointmentJobPage.selectDataRangeByTitle(dateStart, dateEnd);
    }
    if (priority != null && !pickupAppointmentJobPage.getSelectedPriority().equals(priority)) {
      pickupAppointmentJobPage.selectPriorityByString(priority);
    }
    if (jobServiceLevel != null) {
      Arrays.asList(jobServiceLevel.split(", ")).forEach(serviceLevel -> pickupAppointmentJobPage.selectJobServiceLevelByString(serviceLevel));
    }
    if (jobStatus != null) {
      Arrays.asList(jobStatus.split(", ")).forEach(status -> pickupAppointmentJobPage.selectJobStatusByString(status));
    }
    if (zones != null) {
      selectMultipleJobZone(dataTable);
    }
    if (masterShippers != null) {
      selectMultipleJobMasterShipper(dataTable);
    }
    if (shippers != null) {
      Arrays.asList(shippers.split(", ")).forEach(shipper -> pickupAppointmentJobPage.setShipperIDInField(shipper));
    }
  }

  @When("Operator click on Create or Modify Preset button")
  public void clickOnCreateOrModifyPreset() {
    pickupAppointmentJobPage.clickOnCreateOrModifyPresetButton();
  }

  @And("Operator click on Save as Preset button")
  public void clickOnSaveAsPreset() {
    pickupAppointmentJobPage.clickOnSaveAsPresetButton();
  }

  @Then("QA verify Save as Preset modal shown")
  public void verifySaveAsPresetModalIsShown() {
    Assertions.assertThat(pickupAppointmentJobPage.isPresetModalDisplayed())
            .as("Save as Preset modal window is displayed")
            .isTrue();
  }

  @When("Operator fills in the Preset Name field with a name = {string}")
  public void fillNameInThePresetName(String presetName) {
    put(KEY_APPOINTMENT_PICKUP_JOB_FILTERS_PRESET_NAME, presetName);
    pickupAppointmentJobPage.fillInPresetNamefield(presetName);
  }

  @When("Operator click on Save button")
  public void clickOnSavePresetButton() {
    pickupAppointmentJobPage.clickConfirmPresetModalButton();
  }

  @Then("QA verify New Preset Created popup shown on top right of the page")
  public void verifyNewPresetCreatedPopupIsShown() {
    Assertions.assertThat(pickupAppointmentJobPage.isNewPresetCreatedPopupDisplayed())
            .as("New Preset Created popup is displayed")
            .isTrue();
  }

  @Then("QA verify the preset name is shown on Preset Filters dropdown on top left of the page")
  public void verifyThePresetNameShownOnPresetFiltersDropdownOnTopLeftOfThePage() {
    String presetName = get(KEY_APPOINTMENT_PICKUP_JOB_FILTERS_PRESET_NAME);
    pickupAppointmentJobPage.clickOnPresetFilters();
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedPresetFromDropdownMenu())
            .as("Preset " + presetName + " is shown on Preset Filters dropdown")
            .isEqualTo(presetName);
    pickupAppointmentJobPage.clickOnPresetFilters();
  }

  @When("Operator click on Delete Preset button")
  public void clickOnDeletePresetButton() {
    pickupAppointmentJobPage.clickOnDeletePresetButton();
  }

  @When("Operator fills in the Preset Filters preset with name = {string}")
  public void selectPresetByName(String presetName) {
    pickupAppointmentJobPage.clickOnPresetFilters();
    pickupAppointmentJobPage.choosePresetByName(presetName);
  }

  @When("Operator click on Update Current Preset button")
  public void clickOnUpdateCurrentPresetButton() {
    pickupAppointmentJobPage.clickOnUpdateCurrentPreset();
  }

  @Then("QA verify Update Preset modal shown")
  public void verifyUpdatePresetModalIsShown() {
    Assertions.assertThat(pickupAppointmentJobPage.isPresetModalDisplayed())
            .as("Update Preset modal window is displayed")
            .isTrue();
  }

  @When("Operator click on Confirm button")
  public void clickOnConfirmButton() {
    pickupAppointmentJobPage.clickConfirmPresetModalButton();
  }

  @Then("QA verify Current Preset Updated popup shown on top right of the page")
  public void verifyCurrentPresetUpdatedPopupShownOnTopRightOfThePage() {
    Assertions.assertThat(pickupAppointmentJobPage.isCurrentPresetUpdatedPopupDisplayed())
            .as("Current Preset Update Popup is displayed")
            .isTrue();
    pickupAppointmentJobPage.waitUntilCurrentPresetUpdatedPopupInvisible();
  }

  @Then("QA verify Delete Preset modal shown")
  public void verifyDeletePresetModalIsShown() {
    Assertions.assertThat(pickupAppointmentJobPage.isPresetModalDisplayed())
            .as("Delete Preset modal window is displayed")
            .isTrue();
  }

  @Then("QA verify Preset Deleted popup shown on top right of the page")
  public void verifyPresetDeletedPopupShownOnTopRightOfThePage() {
    Assertions.assertThat(pickupAppointmentJobPage.isPresetDeletedPopupDisplayed())
            .as("Preset Deleted Popup is displayed")
            .isTrue();
    pickupAppointmentJobPage.waitUntilPresetDeletedPopupInvisible();
  }

  @Then("Operator verify the dialog displayed the Customised time range")
  public void verifyTheDialogDisplayedTHeCustomisedTimeRange(Map<String, String> dataTable) {
    final String readyBy = dataTable.get("readyBy");
    final String latestBy = dataTable.get("latestBy");

    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getCustomisedTimeRangeByTitleAndStringName("readyBy"))
        .as("ReadyBy range is correct")
        .isEqualTo(readyBy);
    Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getCustomisedTimeRangeByTitleAndStringName("latestBy"))
        .as("LatestBy range is correct")
        .isEqualTo(latestBy);
  }

  // This method can be removed once redirection to Shipper Address is added in operator V2 menu
  public void openPickupJobsPage() {
    getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
  }

  public void verifyDataRange(String dataRangeStart, String dataRangeEnd) {
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedStartDay())
            .as("Start day in Date range is correct")
            .isEqualTo(dataRangeStart);
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedEndDay())
            .as("End day in Date range is correct")
            .isEqualTo(dataRangeEnd);
  }

  public void verifyPriority(String priority) {
    Assertions.assertThat(pickupAppointmentJobPage.getSelectedPriority())
            .as("Priority is correct")
            .isEqualTo(priority);
  }

  public void verifySelectedInJobAppointmentPage(List<String> jobServiceTypeList,
                                                 String jobNameFilter, String messages) {
    verifyFilters(pickupAppointmentJobPage.getAllSelectedByJobName(jobNameFilter),
            jobServiceTypeList, messages);
  }

  private void verifyFilters(List<String> actualList, List<String> expectedList, String message) {
    Assertions.assertThat(actualList)
            .as(message)
            .isEqualTo(expectedList);
  }

  private String getDateByDaysAgo(int amount) {
    DateTimeFormatter format =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    LocalDateTime now = LocalDateTime.now();
    LocalDateTime then = now.minusDays(amount);
    return then.format(format);
  }

  private String getDateByDaysLater(int amount) {
    DateTimeFormatter format =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    LocalDateTime now = LocalDateTime.now();
    LocalDateTime then = now.plusDays(amount);

    return then.format(format);
  }

}