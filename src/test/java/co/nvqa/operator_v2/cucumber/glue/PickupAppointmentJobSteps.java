package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;

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

    @When("Operator loads Shipper Address Configuration page Pickup Appointment")
    public void operatorLoadsShipperAddressConfigurationPage() {
        loadShipperAddressConfigurationPage();
        if (pickupAppointmentJobPage.isToastContainerDisplayed()) {
            pickupAppointmentJobPage.waitUntilInvisibilityOfToast();
        }
        getWebDriver().switchTo().frame(0);
        pickupAppointmentJobPage.waitUntilVisibilityOfElementLocated(pickupAppointmentJobPage.getLoadSelection().getWebElement());
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
        listOFPickupJobsBeforeEditNewJob = pickupAppointmentJobPage.getCreateOrEditJobPage().getAllPickupJobsFromCalendar();
    }

    @Then("Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar")
    public void operatorVerifyShipperIDAndAddressAreDisplayed(Map<String, String> dataTable) {
        final String shipperId = dataTable.get("shipperId");
        final String shipperName = dataTable.get("shipperName");
        final String shipperAddress = dataTable.get("shipperAddress");

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isElementDisplayedByTitle(shipperId.concat(" - ").concat(shipperName)))
                .as("Shipper field is filled")
                .isTrue();
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isElementDisplayedByTitle(shipperAddress))
                .as("Shipper field is filled")
                .isTrue();
    }

    @And("Operator verify Create button in displayed")
    public void isCreateButtonDisplayed() {
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isCreateButtonDisplayed())
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

        Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperNameString())
                .as("Shipper name is correct")
                .isEqualTo(shipperName);
        Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperAddressString())
                .as("Shipper address is correct")
                .contains(shipperAddress);
        Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getStartTimeString())
                .as("Start time is correct")
                .isEqualTo(startTime);
        Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getEndTimeString())
                .as("End time is correct")
                .isEqualTo(endTime);
        Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString())
                .as("Start day is correct")
                .contains(startDay);
        Assertions.assertThat(pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString())
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
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getAllPickupJobsFromCalendar().size())
                .as("The new created Pickup Jobs is shown in the Calendar")
                .isNotEqualTo(listOFPickupJobsBeforeEditNewJob.size());
    }

    @And("QA verify the new created Pickup Jobs is not shown in the Calendar")
    public void verifyTheNewCreatedPickupJobsIsNotShownInTheCalendar() {
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getAllPickupJobsFromCalendar().size())
                .as("The new created Pickup Jobs is shown in the Calendar")
                .isSameAs(listOFPickupJobsBeforeEditNewJob.size());
    }

    @And("Complete Pickup Job With Route Id")
    public void completePickupJobWithRouteId() {
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        operatorLoadsShipperAddressConfigurationPage();
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
        String shipperId = get(KEY_LEGACY_SHIPPER_ID);
        operatorLoadsShipperAddressConfigurationPage();
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
        int differentBetweenLatestByAndReadyBy = Integer.parseInt(latestBy.substring(0, latestBy.indexOf(":"))) - readyByNumber;

        pickupAppointmentJobPage.getCreateOrEditJobPage().selectCustomTimeAndElement(readyByNumber, pickupAppointmentJobPage.getCreateOrEditJobPage().getReadyByField());
        pickupAppointmentJobPage.getCreateOrEditJobPage().selectCustomTimeAndElement(differentBetweenLatestByAndReadyBy, pickupAppointmentJobPage.getCreateOrEditJobPage().getLatestByField());

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
        pickupAppointmentJobPage.verifyMessageInToastModalIsDisplayed(messagesBody);
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
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isDeleteButtonByJobIdDisplayed(listJobIds.get(0)))
                .as("Delete Button in Job with id = " + listJobIds.get(0) + " displayed")
                .isTrue();
    }

    @Then("QA verify there is Edit button in that particular job tag")
    public void verifyEditButtonIsDisplayed() {
        List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isEditButtonByJobIdDisplayed(listJobIds.get(0)))
                .as("Edit Button in Job with id = " + listJobIds.get(0) + " displayed")
                .isTrue();
    }

    @When("Operator click on Edit button")
    public void clickOnEditButton() {
        List<String> listJobIds = get(KEY_LIST_OF_PICKUP_JOB_IDS);
        pickupAppointmentJobPage.getCreateOrEditJobPage().clickOnEditButtonByJobId(listJobIds.get(0));
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

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getValueSelectedStartDay())
                .as("Selected start day is correct")
                .isEqualTo(startDay);
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getValueSelectedEndDay())
                .as("Selected end day is correct")
                .isEqualTo(endDay);
        if (timeRange != null) {
            Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isSelectedTimeRangeWebElementDisplayed(timeRange))
                    .as("Selected time range is correct")
                    .isTrue();
        }
        if (tag != null) {
            Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getAllTagsFromJobTagsField())
                    .as("Selected tags is correct")
                    .contains(tag);
        }
        if (comments != null) {
            Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getCommentFromJobCommentField())
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

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationMessage())
                .as("Notification message is displayed")
                .isEqualTo("Job updated");
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationDescription())
                .as("Notification message is contains " + startDay)
                .contains(startDay);
        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getTextFromNotificationDescription())
                .as("Notification message is contains " + timeRange)
                .contains(timeRange);
    }

    @Then("Operator verify the dialog shows the job tag")
    public void verifyTheDialogShowsTheJogTag(Map<String, String> dataTable) {
        final String date = dataTable.get("date");
        final String tag = dataTable.get("tag");

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isTagDisplayedOnPickupJobByDate(date, tag))
                .as("Tag is displayed")
                .isTrue();
    }

    @Then("Operator verify the dialog shows the comment")
    public void verifyTheDialogShowsTheComment(Map<String, String> dataTable) {
        final String date = dataTable.get("date");
        final String comment = dataTable.get("comment");

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isDisplayedCommentTextInCalendar(date, comment))
                .as("Comment is displayed")
                .isTrue();
    }

    @Then("Operator verify the particular job tag in the Calendar changes from grey to black with white text")
    public void verifyThePickupJobInTheCalendarChangesFromGreyToBlack(Map<String, String> dataTable) {
        final String date = dataTable.get("date");
        final String color = dataTable.get("color");

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().getColorAttributeInPickupJobFromCalendar(date))
                .as("Pickup job has correct color")
                .contains("color: " + color);
    }

    @Then("Operator verify the dialog not shows the job tag")
    public void verifyTheDialogNotShowsTheJogTag(Map<String, String> dataTable) {
        final String date = dataTable.get("date");
        final String tag = dataTable.get("tag");

        Assertions.assertThat(pickupAppointmentJobPage.getCreateOrEditJobPage().isTagDisplayedOnPickupJobByDate(date, tag))
                .as("Tag is displayed")
                .isFalse();
    }

    @When("Operator remove the tags in Job Tag field")
    public void removeTheTagsInJobTagField() {
        pickupAppointmentJobPage.getCreateOrEditJobPage().removeAllTags();
    }

    // This method can be removed once redirection to Shipper Address is added in operator V2 menu
    public void loadShipperAddressConfigurationPage() {
        getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
    }
}
