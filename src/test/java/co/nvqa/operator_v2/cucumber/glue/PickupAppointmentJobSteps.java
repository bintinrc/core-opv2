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

    @And("^Operator click on Create/edit job button on this top right corner of the page")
    public void operatorClickOnCreateOrEditJobButtonOnThisPage() {
        pickupAppointmentJobPage.clickOnCreateOrEditJob();
    }

    @And("^Operator select shipper id/name = \"([^\"]*)\" in Shipper ID/Name field")
    public void operatorSelectShipperByIdInSHipperIdOrNameField(String shipperId) {
       pickupAppointmentJobPage.getCreateOrEditJobElement().setShipperIDInField(shipperId);
    }

    @And("^Operator select address = \"([^\"]*)\" in Shipper Address field")
    public void operatorSelectShipperAddressInShipperAddressField(String shipperAddress) {
        pickupAppointmentJobPage.getCreateOrEditJobElement().setShipperAddressField(shipperAddress);
    }

    @And("^Get Pickup Jobs from Calendar")
    public void getPickupJobsFromCalendar() {
        listOFPickupJobsBeforeEditNewJob = pickupAppointmentJobPage.getCreateOrEditJobElement().getAllPickupJobsFromCalendar();
    }

    @Then("^Operator verify all jobs for selected shipper and address on the selected month are displayed in the Calendar")
    public void operatorVerifyShipperIDAndAddressAreDisplayed(Map<String, String> dataTable) {
        final String shipperId = dataTable.get("shipperId");
        final String shipperName = dataTable.get("shipperName");
        final String shipperAddress = dataTable.get("shipperAddress");

        assertTrue("Shipper field is filled",
                pickupAppointmentJobPage.getCreateOrEditJobElement().isElementDisplayedByTitle(shipperId.concat(" - ").concat(shipperName)));
        assertTrue("Shipper field is filled",
                pickupAppointmentJobPage.getCreateOrEditJobElement().isElementDisplayedByTitle(shipperAddress));
    }

    @And("^Operator verify Create button in displayed")
    public void isCreateButtonDisplayed() {
        assertTrue("Create button is displayed",
                pickupAppointmentJobPage.getCreateOrEditJobElement().isCreateButtonDisplayed());
    }

    @When("^Operator select the data range")
    public void selectDataRange(Map<String, String> dataTable) {
        final String startDay = dataTable.get("startDay");
        final String endDay = dataTable.get("endDay");

        pickupAppointmentJobPage.getCreateOrEditJobElement().selectDataRangeByTitle(startDay, endDay);
    }

    @And("^Operator select time slot from Select time range field")
    public void selectTimeSlotFromSelectTimeRangeField(Map<String, String> dataTable) {
        final String startTime = dataTable.get("startTime");
        final String endTime = dataTable.get("endTime");
        String timeRange = startTime.concat(" - ").concat(endTime);

        pickupAppointmentJobPage.getCreateOrEditJobElement().selectTimeRangeByDataTime(timeRange);
    }

    @And("^Operator click on Submit button")
    public void clickOnSubmitButton() {
        pickupAppointmentJobPage.getCreateOrEditJobElement().clickOnCreateButton();
    }

    @Then("^QA verify Job created modal displayed with following format")
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

    @And("^QA verify the new created Pickup Jobs is shown in the Calendar")
    public void verifyTheNewCreatedPickupJobsIsShownInTheCalendar() {
        assertNotEquals("The new created Pickup Jobs is shown in the Calendar",
                pickupAppointmentJobPage.getCreateOrEditJobElement().getAllPickupJobsFromCalendar().size(),
                listOFPickupJobsBeforeEditNewJob.size());
    }

    // This method can be removed once redirection to Shipper Address is added in operator V2 menu
    public void loadShipperAddressConfigurationPage() {
        getWebDriver().get("https://operatorv2-qa.ninjavan.co/#/sg/pickup-appointment");
    }
}
