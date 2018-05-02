package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import co.nvqa.operator_v2.selenium.page.ThirdPartyOrderManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ThirdPartyOrderManagementSteps extends AbstractSteps
{
    private ThirdPartyOrderManagementPage thirdPartyOrderManagementPage;

    @Inject
    public ThirdPartyOrderManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        thirdPartyOrderManagementPage = new ThirdPartyOrderManagementPage(getWebDriver());
    }

    @When("^Operator uploads new mapping$")
    public void operatorUploadsNewMapping()
    {
        ThirdPartyOrderMapping thirdPartyOrderMapping = new ThirdPartyOrderMapping();
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        thirdPartyOrderMapping.setTrackingId(trackingId);
        thirdPartyOrderMapping.setThirdPlTrackingId("3PL" + trackingId);
        thirdPartyOrderManagementPage.uploadSingleMapping(thirdPartyOrderMapping);
        getScenarioStorage().put(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS, thirdPartyOrderMapping);
    }

    @Then("^Operator verify the new mapping is created successfully$")
    public void operatorVerifyTheNewMappingIsCreatedSuccessfully()
    {
        ThirdPartyOrderMapping expectedOrderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        expectedOrderMapping.setStatus("Saved");
        thirdPartyOrderManagementPage.verifyOrderMappingCreatedSuccessfully(expectedOrderMapping);
    }

    @When("^Operator edit the new mapping with a new data$")
    public void operatorEditTheNewMappingWithANewData()
    {
        ThirdPartyOrderMapping orderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        orderMapping.setThirdPlTrackingId(orderMapping.getThirdPlTrackingId() + "UPD");
        thirdPartyOrderManagementPage.editOrderMapping(orderMapping);
    }

    @Then("^Operator verify the new edited data is updated successfully$")
    public void operatorVerifyTheNewEditedDataIsUpdatedSuccessfully()
    {
        ThirdPartyOrderMapping expectedOrderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyOrderMappingRecord(expectedOrderMapping);
    }

    @When("^Operator delete the new mapping$")
    public void operatorDeleteTheNewMapping()
    {
        ThirdPartyOrderMapping orderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.deleteThirdPartyOrderMapping(orderMapping);
    }

    @Then("^Operator verify the new mapping is deleted successfully$")
    public void operatorVerifyTheNewMappingIsDeletedSuccessfully()
    {
        ThirdPartyOrderMapping orderMapping = getScenarioStorage().get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyThirdPartyOrderMappingIsDeletedSuccessfully(orderMapping);
    }
}
