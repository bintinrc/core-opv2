package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import co.nvqa.operator_v2.selenium.page.ThirdPartyOrderManagementPage;
import com.google.inject.Inject;
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
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        thirdPartyOrderMapping.setTrackingId(trackingId);
        thirdPartyOrderMapping.setThirdPlTrackingId("3PL" + trackingId);
        thirdPartyOrderManagementPage.uploadSingleMapping(thirdPartyOrderMapping);
        put(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS, thirdPartyOrderMapping);
    }

    @Then("^Operator verify the new mapping is created successfully$")
    public void operatorVerifyTheNewMappingIsCreatedSuccessfully()
    {
        ThirdPartyOrderMapping expectedOrderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyOrderMappingCreatedSuccessfully(expectedOrderMapping);
    }

    @When("^Operator edit the new mapping with a new data$")
    public void operatorEditTheNewMappingWithANewData()
    {
        ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        orderMapping.setThirdPlTrackingId(orderMapping.getThirdPlTrackingId() + "UPD");
        thirdPartyOrderManagementPage.editOrderMapping(orderMapping);
    }

    @Then("^Operator verify the new edited data is updated successfully$")
    public void operatorVerifyTheNewEditedDataIsUpdatedSuccessfully()
    {
        ThirdPartyOrderMapping expectedOrderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyOrderMappingRecord(expectedOrderMapping);
    }

    @When("^Operator delete the new mapping$")
    public void operatorDeleteTheNewMapping()
    {
        ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.deleteThirdPartyOrderMapping(orderMapping);
    }

    @Then("^Operator verify the new mapping is deleted successfully$")
    public void operatorVerifyTheNewMappingIsDeletedSuccessfully()
    {
        ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyThirdPartyOrderMappingWasRemoved(
                orderMapping,
                f("Fail to delete Third Party Order Mapping (Tracking ID = %s).", orderMapping.getTrackingId())
        );
    }

    @When("^Operator uploads bulk mapping$")
    public void operatorUploadsBulkMapping()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        ThirdPartyOrderMapping shipperInfo = new ThirdPartyOrderMapping();
        thirdPartyOrderManagementPage.adjustAvailableThirdPartyShipperData(shipperInfo);
        List<ThirdPartyOrderMapping> thirdPartyOrderMappings =
                trackingIds.stream()
                .map(trackingId ->
                {
                    ThirdPartyOrderMapping thirdPartyOrderMapping = new ThirdPartyOrderMapping();
                    thirdPartyOrderMapping.setTrackingId(trackingId);
                    thirdPartyOrderMapping.setThirdPlTrackingId("3PL" + trackingId);
                    thirdPartyOrderMapping.setShipperId(shipperInfo.getShipperId());
                    thirdPartyOrderMapping.setShipperName(shipperInfo.getShipperName());
                    return thirdPartyOrderMapping;
                })
                .collect(Collectors.toList());
        thirdPartyOrderManagementPage.uploadBulkMapping(thirdPartyOrderMappings);
        put(KEY_LIST_OF_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS, thirdPartyOrderMappings);
    }

    @Then("^Operator verify multiple new mapping is created successfully$")
    public void operatorVerifyMultipleNewMappingIsCreatedSuccessfully()
    {
        List<ThirdPartyOrderMapping> expectedThirdPartyOrderMappings = get(KEY_LIST_OF_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyMultipleOrderMappingCreatedSuccessfully(expectedThirdPartyOrderMappings);
    }

    @When("^Operator complete the new mapping order$")
    public void operatorCompleteTheNewMappingOrder()
    {
        ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.completeThirdPartyOrder(orderMapping);
    }

    @Then("^Operator verify the new mapping order is completed$")
    public void operatorVerifyTheNewMappingOrderIsCompleted()
    {
        ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
        thirdPartyOrderManagementPage.verifyThirdPartyOrderMappingWasRemoved(
                orderMapping,
                f("Fail to complete Third Party Order (Tracking ID = %s).", orderMapping.getTrackingId())
        );
    }
}
