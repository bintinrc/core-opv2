package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2.BulkSelectTable.ACTION_SELECTED;

public class PickupAppointmentJobStepsV2 extends AbstractSteps {

    private static final Logger LOGGER = LoggerFactory.getLogger(PickupAppointmentJobSteps.class);

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
        pickupAppointmentJobPage.inFrame(page->{
            page.clickOnCreateOrEditJob();
        });

    }

    @When("Operator select shipper id or name = {string} in Shipper ID or Name field")
    public void operatorSelectShipperByIdInSHipperIdOrNameField(String shipperId) {
        String newShipperId = resolveValue(shipperId);
        pickupAppointmentJobPage.inFrame(page->{
            page.createOrEditJobPage.fillShipperIdField(newShipperId);
            page.createOrEditJobPage.selectShipperFromList(newShipperId);
        });
    }

    @When("Operator select address = {string} in Shipper Address field")
    public void operatorSelectShipperAddressInShipperAddressField(String shipperAddress) {

        String newShipperAddress = resolveValue(shipperAddress);
        pickupAppointmentJobPage.inFrame(page->{
            page.createOrEditJobPage.fillShipperAddressField(newShipperAddress);
            page.createOrEditJobPage.selectShipperAddressFromList(newShipperAddress);
        });
    }

    @Then("Operator verify there is Delete button in job with id = {string}")
    public void verifyDeleteButtonIsDisplayed(String JobId) {
        String jobId = resolveValue(JobId);
        pickupAppointmentJobPage.inFrame(page->{
            Assertions.assertThat(page.createOrEditJobPage
                            .isDeleteButtonByJobIdDisplayed(jobId))
                    .as("Delete Button in Job with id = " + jobId + " displayed").isTrue();
        });
    }
    @Then("Operator verify there is no Delete button in job with id = {string}")
    public void verifyDeleteButtonIsNotDisplayed(String JobId) {
        String jobId = resolveValue(JobId);
        pickupAppointmentJobPage.inFrame(page->{
            Assertions.assertThat(page.createOrEditJobPage
                    .isDeleteButtonByJobIdDisplayed(jobId))
                .as("Delete Button in Job with id = " + jobId + " is not displayed").isFalse();
        });
    }

    @Then("Operator verify there is Edit button in job with id = {string}")
    public void verifyEditButtonIsDisplayed(String JobId) {
        String jobId = resolveValue(JobId);
        pickupAppointmentJobPage.inFrame(page->{
            Assertions.assertThat(page.createOrEditJobPage
                            .isEditButtonByJobIdDisplayed(jobId))
                    .as("Delete Button in Job with id = " + jobId + " displayed").isTrue();
        });
    }

    @Then("Operator verify there is no Edit button in job with id = {string}")
    public void verifyEditButtonIsNotDisplayed(String JobId) {
        String jobId = resolveValue(JobId);
        pickupAppointmentJobPage.inFrame(page->{
            Assertions.assertThat(page.createOrEditJobPage
                    .isEditButtonByJobIdDisplayed(jobId))
                .as("Delete Button in Job with id = " + jobId + " is not displayed").isFalse();
        });
    }

    @When("Operator click on delete button for pickup job id = {string}")
    public void clickDeleteButtonForJobId(String JobId) {
        String jobId = resolveValue(JobId);
        pickupAppointmentJobPage.inFrame(page->{
            page.createOrEditJobPage.clickDeleteButton(jobId);
        });
    }

    @Then("Operator verify Delete dialog displays data below:")
    public void verifyDeleteJobModalWindow(Map<String, String> dataTable)
    {
        Map<String,String> data = resolveKeyValues(dataTable);
        final String shipperName = data.get("shipperName");
        final String shipperAddress = data.get("shipperAddress");
        final String readyBy = data.get("readyBy");
        final String latestBy = data.get("latestBy");

        pickupAppointmentJobPage.inFrame(page->{
            Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Shipper name:"))
                .as("Shipper name is correct").isEqualTo(shipperName);
            Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Shipper address:"))
                .as("Shipper address is correct").contains(shipperAddress);
            Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Ready by:"))
                .as("Ready by is correct").isEqualTo(readyBy);
            Assertions.assertThat(page.deletePickupJobModal.getFieldTextOnDeleteJobModal("Latest by:"))
                .as("Latest by is correct").isEqualTo(latestBy);
        });
    }

    @When("Operator click on Submit button on Delete Pickup Job delete modal")
    public void clickOnSubmitButtonOnDeleteJobModal() {
        pickupAppointmentJobPage.inFrame(page->{
            page.deletePickupJobModal.submitButton.click();
        });
    }
    @Then("Operator verify notification is displayed with message = {string} and description below:")
    public void verifyNotificationDisplayedWith(String notificationMessage,List<Map<String,String>> dataTable)
    {
        pickupAppointmentJobPage.inFrame(page->{
            dataTable.forEach(entry -> {
                Map<String, String> data = new HashMap<>(entry);
                String message = resolveValue(notificationMessage);
                String description = resolveValue(data.get("description"));
                Assertions.assertThat(page.notificationModal.message.getText()).as(f("Notification Message contains: %s",message)).contains(message);
                Assertions.assertThat(page.notificationModal.description.getText()).as(f("Notification Description contains: %s",description)).contains(description);
            });
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
    public void operatorVerifiesNumberOfSelectedRows(){
        pickupAppointmentJobPage.inFrame(() ->
            pickupAppointmentJobPage.verifyBulkSelectResult()
        );
    }

    @When("Operator filters on the table with values below:")
    public void operatorFiltersValueOnTheTable(Map<String, String> data){
        Map<String,String> resolvedData = resolveKeyValues(data);
        pickupAppointmentJobPage.inFrame(() -> {
            if (resolvedData.get("status") != null) {
                pickupAppointmentJobPage.bulkSelect.filterByColumnV2(
                    pickupAppointmentJobPage.bulkSelect.COLUMN_STATUS, resolvedData.get("status"));
            }
        });
    }

    @Then("Operator verify number of selected row is not updated")
    public void operatorVerifyNumberOfSelectedRowIsNotUpdated(){
        pickupAppointmentJobPage.inFrame(() -> pickupAppointmentJobPage.verifyRowCountHasNotChanged());
    }

    @Then("Operator verify the number of selected rows is {value}")
    public void operatorVerifiesNumberOfSelectedRow(String expectedRowCount){
        pickupAppointmentJobPage.inFrame(() -> pickupAppointmentJobPage.verifyRowCountisEqualTo(expectedRowCount));
    }

    @Given("Operator selects {int} rows on Pickup Jobs page")
    public void operatorSelectRowsOnPickupJobsPage(int numberOfRows){
        pickupAppointmentJobPage.inFrame(() -> {
            for (int i = 1; i<=numberOfRows; i++)
                pickupAppointmentJobPage.bulkSelect.clickActionButton(i,ACTION_SELECTED);
        });
    }

    @Then("Operator verifies Filter Job button is disabled on Pickup job page")
    public void operatorVerifiesFilterJobButtonDisabled(){
        pickupAppointmentJobPage.inFrame(() ->Assertions.assertThat(pickupAppointmentJobPage.filterJobByIDModal.confirmButton.
            getAttribute("disabled")).as("Filter Job button is disabled").isEqualTo("true"));
    }

    @Given("Operator fills the pickup job ID list below:")
    public void operatorFillsThePickupJobIDs(List<String> data){
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
    public void operatorVerifiesErrorMessage(String expectedResult){
        pickupAppointmentJobPage.inFrame(page ->{
            Assertions.assertThat(expectedResult).as("Message is the same").isEqualToIgnoringCase(page.getAntTopRightText());
        });
    }

    @Given("Operator clears the filter jobs list on Pickup Jobs Page")
    public void operatorClearsPickupJobsList(){
        pickupAppointmentJobPage.inFrame(() -> pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(
            Keys.chord(Keys.CONTROL, "a", Keys.DELETE)));
    }

    @Then("Operator verifies invalid pickup ID error message below on Pickup Jobs Page:")
    public void operatorVerifiesErrorMessageOnPickupJobsPage(String expectedMessage){
        pickupAppointmentJobPage.inFrame(() -> pickupAppointmentJobPage.filterJobByIDModal.verifyErrorMessages(expectedMessage));
    }

    @Given("Operator fill more than 1000 pickup jobs Id on Pickup Jobs Page:")
    public void addmore1000(String ID){
        String jobId = resolveValue(ID);
        Random random = new Random();
        int numberOfId = random.ints(1002, 1010)
            .findFirst()
            .getAsInt();
        pickupAppointmentJobPage.inFrame(page -> {
            for (int i=0;i<numberOfId;i++){
                pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(jobId);
                pickupAppointmentJobPage.filterJobByIDModal.inputJobId.sendKeys(Keys.ENTER);
            }
        });
    }

    @Then("Operator verifies the Table on Pickup Jobs Page")
    public void operatorVerifiesTableOnPickupJobsPage(){
        pickupAppointmentJobPage.inFrame(() -> pickupAppointmentJobPage.verifyPickupJobsTable());
    }

    @Then("Operator verifies Existing upcoming job page")
    public void operatorVerifiesExistingUpcomingJobPage(){
        pickupAppointmentJobPage.inFrame(() -> {
            pickupAppointmentJobPage.existingUpcomingJob.header.waitUntilVisible();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.header.isDisplayed()).as("Existing upcoming job header is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.title.isDisplayed()).as("Existing upcoming job title is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.startDate.isDisplayed()).as("Existing upcoming job Start date is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.endDate.isDisplayed()).as("Existing upcoming job end date is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.timeRange.isEnabled()).as("Existing upcoming job time range is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.useExistingTimeslot.isEnabled()).as("Existing upcoming job Apply existing time slots is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.pickupTag.isEnabled()).as("Existing upcoming job pickup tag is display").isTrue();
            Assertions.assertThat( pickupAppointmentJobPage.existingUpcomingJob.submit.getAttribute("disabled")).as("Existing upcoming job submit is disabled").isEqualTo("true");
        });
    }

    @Given("Operator selects time range {string} on Existing Upcoming Job page")
    public void operatorSelectsTimeRangeOnExistingJobpage(String timeRange){
        pickupAppointmentJobPage.inFrame(() -> {
            pickupAppointmentJobPage.existingUpcomingJob.timeRange.click();
            pickupAppointmentJobPage.selectItem(timeRange);});
    }

    @Given("Operator clicks Submit button on Existing Upcoming Job page")
    public  void operatorClicksSubmitOnExistingJobPage(){
        pickupAppointmentJobPage.inFrame(() -> {
            pickupAppointmentJobPage.existingUpcomingJob.submit.waitUntilClickable();
            pickupAppointmentJobPage.existingUpcomingJob.submit.click();
            pickupAppointmentJobPage.existingUpcomingJob.submit.waitUntilInvisible();
        });
    }

    @Given("Operator creates new PA Job on Existing Upcoming Job page:")
    public void operatorCreatesNewPaJobOnExistingJobPage(Map<String,String> data){
        Map<String,String> resolvedData = resolveKeyValues(data);
        pickupAppointmentJobPage.inFrame(page ->{
            if (resolvedData.get("startDate")!=null){
                page.existingUpcomingJob.startDate.click();
                page.existingUpcomingJob.startDate.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
                page.existingUpcomingJob.startDate.sendKeys(resolvedData.get("startDate"));
                page.existingUpcomingJob.startDate.sendKeys(Keys.ENTER);
            }
            if (resolvedData.get("endDate")!=null){
                page.existingUpcomingJob.endDate.click();
                page.existingUpcomingJob.endDate.sendKeys(Keys.chord(Keys.CONTROL, "a", Keys.DELETE));
                page.existingUpcomingJob.endDate.sendKeys(resolvedData.get("endDate"));
                page.existingUpcomingJob.endDate.sendKeys(Keys.ENTER);
            }
            if ((resolvedData.get("useExistingTimeslot")!=null) && (resolvedData.get("useExistingTimeslot").equalsIgnoreCase("true"))){
                page.existingUpcomingJob.useExistingTimeslot.click();
            } else {
                pickupAppointmentJobPage.existingUpcomingJob.timeRange.click();
                pickupAppointmentJobPage.selectItem(resolvedData.get("timeRange"));
            }
            if (resolvedData.get("pickupTag")!=null){
                page.existingUpcomingJob.pickupTag.click();
                pickupAppointmentJobPage.selectItem(resolvedData.get("pickupTag"));
            }
        });
    }

    @Then("Operator verifies job created success following data below:")
    public void operatorVerifiesJobCreatedSuccess(Map<String,String> data){
        Map<String,String> resolvedData = resolveKeyValues(data);
        pickupAppointmentJobPage.inFrame(() -> {
            pickupAppointmentJobPage.jobCreatedSuccess.title.waitUntilVisible();
            if (data.get("timeSlot")!=null){
                Assertions.assertThat(pickupAppointmentJobPage.jobCreatedSuccess.createdTime.getText()).as("Time slot is the same").isEqualToIgnoringCase(resolvedData.get("timeSlot"));
            }
            if (resolvedData.get("pickupTag")!=null){
                Assertions.assertThat(pickupAppointmentJobPage.isElementExist(f(pickupAppointmentJobPage.jobCreatedSuccess.COLUMN_DATA_XPATH,resolvedData.get("pickupTag")))).as("Job tag is the same").isTrue();
            }});
    }

}
