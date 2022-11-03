package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.PickupAppointmentJobPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.openqa.selenium.WebElement;

import java.util.List;
import java.util.Map;

@ScenarioScoped
public class PickupAppointmentJobSteps extends AbstractSteps{

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
        pickupAppointmentJobPage.waitUntilInvisibilityOfToast();
        getWebDriver().switchTo().frame(0);
    }

    @And("Operator click on Create or edit job button on this top right corner of the page")
    public void operatorClickOnCreateOrEditJobButtonOnThisPage() {
        pickupAppointmentJobPage.clickOnCreateOrEditJob();
    }

    @And("Operator select shipper id or name = {string} in Shipper ID or Name field")
    public void operatorSelectShipperByIdInSHipperIdOrNameField(String shipperId) {
       pickupAppointmentJobPage.getCreateOrEditJobElement().setShipperIDInField(shipperId);
       put(KEY_LEGACY_SHIPPER_ID, shipperId);
    }

    @And("Operator select address = {string} in Shipper Address field")
    public void operatorSelectShipperAddressInShipperAddressField(String shipperAddress) {
        pickupAppointmentJobPage.getCreateOrEditJobElement().setShipperAddressField(shipperAddress);
    }

    @And("Get Pickup Jobs from Calendar")
    public void getPickupJobsFromCalendar() {
        listOFPickupJobsBeforeEditNewJob = pickupAppointmentJobPage.getCreateOrEditJobElement().getAllPickupJobsFromCalendar();
    }

    @Then("Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar")
    public void operatorVerifyShipperIDAndAddressAreDisplayed(Map<String, String> dataTable) {
        final String shipperId = dataTable.get("shipperId");
        final String shipperName = dataTable.get("shipperName");
        final String shipperAddress = dataTable.get("shipperAddress");

        assertTrue("Shipper field is filled",
                pickupAppointmentJobPage.getCreateOrEditJobElement().isElementDisplayedByTitle(shipperId.concat(" - ").concat(shipperName)));
        assertTrue("Shipper field is filled",
                pickupAppointmentJobPage.getCreateOrEditJobElement().isElementDisplayedByTitle(shipperAddress));
    }

    @And("Operator verify Create button in displayed")
    public void isCreateButtonDisplayed() {
        assertTrue("Create button is displayed",
                pickupAppointmentJobPage.getCreateOrEditJobElement().isCreateButtonDisplayed());
    }

    @When("Operator select the data range")
    public void selectDataRange(Map<String, String> dataTable) {
        final String startDay = dataTable.get("startDay");
        final String endDay = dataTable.get("endDay");

        pickupAppointmentJobPage.getCreateOrEditJobElement().selectDataRangeByTitle(startDay, endDay);
    }

    @And("Operator select time slot from Select time range field")
    public void selectTimeSlotFromSelectTimeRangeField(Map<String, String> dataTable) {
        final String startTime = dataTable.get("startTime");
        final String endTime = dataTable.get("endTime");
        String timeRange = startTime.concat(" - ").concat(endTime);

        pickupAppointmentJobPage.getCreateOrEditJobElement().selectTimeRangeByDataTime(timeRange);
    }

    @And("Operator click on Submit button")
    public void clickOnSubmitButton() {
        pickupAppointmentJobPage.getCreateOrEditJobElement().clickOnCreateButton();
    }

    @Then("QA verify Job created modal displayed with following format")
    public void QAVerifyJobCreatedModalWindow(Map<String, String> dataTable) {
        final String shipperName = dataTable.get("shipperName");
        final String shipperAddress = dataTable.get("shipperAddress");
        final String startTime = dataTable.get("startTime");
        final String endTime = dataTable.get("endTime");
        final String startDay = dataTable.get("startDay");
        final String endDay = dataTable.get("endDay");

        assertTrue("Shipper name is correct",
                pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperNameString()
                        .equals(shipperName));
        assertTrue("Shipper address is correct",
                pickupAppointmentJobPage.getJobCreatedModalWindowElement().getShipperAddressString()
                        .contains(shipperAddress));
        assertTrue("Start time is correct",
                pickupAppointmentJobPage.getJobCreatedModalWindowElement().getStartTimeString()
                        .equals(startTime));
        assertTrue("End time is correct",
                pickupAppointmentJobPage.getJobCreatedModalWindowElement().getEndTimeString()
                        .equals(endTime));
        assertTrue("Start day is correct",
                pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString()
                        .contains(startDay));
        assertTrue("End day is correct",
                pickupAppointmentJobPage.getJobCreatedModalWindowElement().getDatesString()
                        .contains(endDay));

        pickupAppointmentJobPage.getJobCreatedModalWindowElement().clickOnOKButton();
    }

    @And("QA verify the new created Pickup Jobs is shown in the Calendar")
    public void verifyTheNewCreatedPickupJobsIsShownInTheCalendar() {
        assertNotEquals("The new created Pickup Jobs is shown in the Calendar",
                pickupAppointmentJobPage.getCreateOrEditJobElement().getAllPickupJobsFromCalendar().size(),
                listOFPickupJobsBeforeEditNewJob.size());
    }

    @And("QA verify the new created Pickup Jobs is not shown in the Calendar")
    public void verifyTheNewCreatedPickupJobsIsNotShownInTheCalendar() {
        assertEquals("The new created Pickup Jobs is shown in the Calendar",
                pickupAppointmentJobPage.getCreateOrEditJobElement().getAllPickupJobsFromCalendar().size(),
                listOFPickupJobsBeforeEditNewJob.size());
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
                .selectDataRangeByTitle(startDay,endDay)
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
    public void  selectCustomisedTimeRange(Map<String, String> dataTable) {
        final String readyBy = dataTable.get("readyBy");
        final String latestBy = dataTable.get("latestBy");

        int readyByNumber = Integer.parseInt(readyBy.substring(0, readyBy.indexOf(":")));
        int differentBetweenLatestByAndReadyBy = Integer.parseInt(latestBy.substring(0, latestBy.indexOf(":"))) - readyByNumber;

        pickupAppointmentJobPage.getCreateOrEditJobElement().selectCustomTimeAndElement(readyByNumber, pickupAppointmentJobPage.getCreateOrEditJobElement().readyByField);
        pickupAppointmentJobPage.getCreateOrEditJobElement().selectCustomTimeAndElement(differentBetweenLatestByAndReadyBy, pickupAppointmentJobPage.getCreateOrEditJobElement().latestByField);

    }

    @Then("QA verify the {int} Job displayed on the Pickup Jobs page")
    public void verifyTheNewJobCreatedOnThePickupJobsPage(Integer numberJobs) {
        assertEquals("The new Job created on the Pickup Jobs page",
                pickupAppointmentJobPage.getNumberOfJobs(),numberJobs);
    }

    @And("Operator get Job Id from Pickup Jobs page")
    public void operatorGetJobIdFromPickupJobsPage() {
        List<String> jobId = pickupAppointmentJobPage.getJobIdsText();
        putInList(KEY_LIST_OF_PICKUP_JOB_IDS, jobId);
    }

    @And("QA verify error message shown on the modal and close by message body {string}")
    public void verifyErrorMessageShownOnTheModalAndClose(String messagesBody) {
        pickupAppointmentJobPage.waitUntilInvisibilityOfToast("Network Request Error");
        pickupAppointmentJobPage.getCreateOrEditJobElement().verifyMessageInToastModalIsDisplayed(messagesBody);
        while (pickupAppointmentJobPage.isElementExistFast("//*[contains(@class,'toast-error')]")) {
            pickupAppointmentJobPage.closeToast();
        }
    }

    // This method can be removed once redirection to Shipper Address is added in operator V2 menu
    public void loadShipperAddressConfigurationPage() {
        getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
    }
}
