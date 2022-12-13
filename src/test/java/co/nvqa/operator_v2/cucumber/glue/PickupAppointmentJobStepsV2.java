package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.pickupAppointment.PickupAppointmentJobPageV2;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
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

    @Then("Operator verify there is Edit button in job with id = {string}")
    public void verifyEditButtonIsDisplayed(String JobId) {
        String jobId = resolveValue(JobId);
        pickupAppointmentJobPage.inFrame(page->{
            Assertions.assertThat(page.createOrEditJobPage
                            .isEditButtonByJobIdDisplayed(jobId))
                    .as("Delete Button in Job with id = " + jobId + " displayed").isTrue();
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

    }


}
