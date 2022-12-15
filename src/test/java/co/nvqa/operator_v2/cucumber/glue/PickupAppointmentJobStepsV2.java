package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.HashMap;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

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



}
