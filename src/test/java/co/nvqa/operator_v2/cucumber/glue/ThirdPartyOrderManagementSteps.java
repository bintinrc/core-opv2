package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.ThirdPartyOrderManagementPage;
import com.google.inject.Inject;
import cucumber.api.PendingException;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ThirdPartyOrderManagementSteps extends AbstractSteps
{
    private MainPage mainPage;
    private ThirdPartyOrderManagementPage thirdPartyOrderManagementPage;

    @Inject
    public ThirdPartyOrderManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        mainPage = new MainPage(getWebDriver());
        thirdPartyOrderManagementPage = new ThirdPartyOrderManagementPage(getWebDriver());
    }

    @Given("^Operator open page Third Party Order Management$")
    public void operatorOpenPageThirdPartyOrderManagement() {
        mainPage.clickNavigation("Cross Border & 3PL", "Third Party Order Management", "third-party-order");
    }

    @When("^Operator uploads new mapping$")
    public void operatorUploadsNewMapping() throws Throwable {
        ThirdPartyOrderMapping thirdPartyOrderMapping = new ThirdPartyOrderMapping();
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        thirdPartyOrderMapping.setTrackingId(trackingId);
        thirdPartyOrderMapping.setThirdPlTrackingId("3PL" + trackingId);
        thirdPartyOrderManagementPage.uploadSingleMapping(thirdPartyOrderMapping);
        getScenarioStorage().put(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS, thirdPartyOrderMapping);
    }

    @Then("^Operator verify the new mapping is created successfully$")
    public void operatorVerifyTheNewMappingIsCreatedSuccessfully() throws Throwable {
        ThirdPartyOrderMapping expectedOrderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        expectedOrderMapping.setStatus("Saved");
        thirdPartyOrderManagementPage.verifyOrderMappingCreatedSuccessfully(expectedOrderMapping);
    }

    @When("^Operator edit the new mapping with a new data$")
    public void operatorEditTheNewMappingWithANewData() {
        ThirdPartyOrderMapping orderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        orderMapping.setThirdPlTrackingId(orderMapping.getThirdPlTrackingId() + "UPD");
        thirdPartyOrderManagementPage.editOrderMapping(orderMapping);
    }

    @Then("^Operator verify the new edited data is updated successfully$")
    public void operatorVerifyTheNewEditedDataIsUpdatedSuccessfully(){
        ThirdPartyOrderMapping expectedOrderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyOrderMappingRecord(expectedOrderMapping);
    }

    @When("^Operator delete the new mapping$")
    public void operatorDeleteTheNewMapping() {
        ThirdPartyOrderMapping orderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.deleteThirdPartyOrderMapping(orderMapping);
    }

    @Then("^Operator verify the new mapping is deleted successfully$")
    public void operatorVerifyTheNewMappingIsDeletedSuccessfully(){
        ThirdPartyOrderMapping orderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyThirdPartyOrderMappingIsDeletedSuccessfully(orderMapping);
    }

    @When("^Operator uploads bulk mapping$")
    public void operatorUploadsBulkMapping() {
        List<String> trackingIds = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_IDS);
        List<ThirdPartyOrderMapping> thirdPartyOrderMappings =
                trackingIds.stream()
                .map(trackingId -> {
                    ThirdPartyOrderMapping thirdPartyOrderMapping = new ThirdPartyOrderMapping();
                    thirdPartyOrderMapping.setTrackingId(trackingId);
                    thirdPartyOrderMapping.setThirdPlTrackingId("3PL" + trackingId);
                    return thirdPartyOrderMapping;
                })
                .collect(Collectors.toList());
        thirdPartyOrderManagementPage.uploadBulkMapping(thirdPartyOrderMappings);
    }
}
