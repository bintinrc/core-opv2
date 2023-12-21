package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import co.nvqa.operator_v2.selenium.page.ThirdPartyOrderManagementPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ThirdPartyOrderManagementSteps extends AbstractSteps {
  private ThirdPartyOrderManagementPage thirdPartyOrderManagementPage;

  public ThirdPartyOrderManagementSteps() {
  }

  @Override
  public void init() {
    thirdPartyOrderManagementPage = new ThirdPartyOrderManagementPage(getWebDriver());
  }

  @When("Operator uploads new mapping")
  public void operatorUploadsNewMapping(Map<String, String> dataTableAsMap) {
    ThirdPartyOrderMapping thirdPartyOrderMapping = new ThirdPartyOrderMapping();
    String trackingId = resolveValue(dataTableAsMap.get("trackingId"));

    String shipperName = dataTableAsMap.get("3plShipperName");
    String shipperId = dataTableAsMap.get("3plShipperId");

    thirdPartyOrderMapping.setTrackingId(trackingId);
    thirdPartyOrderMapping.setThirdPlTrackingId("3PL" + trackingId);
    thirdPartyOrderMapping.setShipperName(shipperName);
    thirdPartyOrderMapping.setShipperId(shipperId);
    thirdPartyOrderManagementPage.uploadSingleMapping(thirdPartyOrderMapping);
    put(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS, thirdPartyOrderMapping);
  }

  @Then("Operator verify the new mapping is created successfully")
  public void operatorVerifyTheNewMappingIsCreatedSuccessfully() {
    ThirdPartyOrderMapping expectedOrderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage.verifyOrderMappingCreatedSuccessfully(expectedOrderMapping);
  }

  @Then("Operator verify upload results on Third Party Order Management page:")
  public void operatorVerifyUploadResults(Map<String, String> data) {
    ThirdPartyOrderMapping expected = new ThirdPartyOrderMapping(resolveKeyValues(data));
    thirdPartyOrderManagementPage.uploadSingleMappingDialog.waitUntilVisible();
    pause2s();
    Assertions.assertThat(
        thirdPartyOrderManagementPage.uploadSingleMappingDialog.uploadResultsTable.getRowsCount())
        .as("Number of Upload Results records").isEqualTo(1);
    ThirdPartyOrderMapping actual = thirdPartyOrderManagementPage.uploadSingleMappingDialog.uploadResultsTable
        .readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("Operator edit the new mapping with a new data")
  public void operatorEditTheNewMappingWithANewData() {
    ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    orderMapping.setThirdPlTrackingId(orderMapping.getThirdPlTrackingId() + "UPD");
    thirdPartyOrderManagementPage.editOrderMapping(orderMapping);
  }

  @Then("Operator verify the new edited data is updated successfully")
  public void operatorVerifyTheNewEditedDataIsUpdatedSuccessfully() {
    ThirdPartyOrderMapping expectedOrderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage.verifyOrderMappingRecord(expectedOrderMapping);
  }

  @When("Operator delete the new mapping")
  public void operatorDeleteTheNewMapping() {
    ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage.deleteThirdPartyOrderMapping(orderMapping);
  }

  @Then("Operator verify the new mapping is deleted successfully")
  public void operatorVerifyTheNewMappingIsDeletedSuccessfully() {
    ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage.verifyThirdPartyOrderMappingWasRemoved(
        orderMapping,
        f("Fail to delete Third Party Order Mapping (Tracking ID = %s).",
            orderMapping.getTrackingId())
    );
  }

  @When("Operator uploads bulk mapping for tracking ids:")
  public void operatorUploadsBulkMapping(List<String> trackingIdsDataTable) {
    List<String> trackingIds = resolveValues(trackingIdsDataTable);
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
    put(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS, thirdPartyOrderMappings);
  }

  @Then("Operator verify multiple new mapping is created successfully")
  public void operatorVerifyMultipleNewMappingIsCreatedSuccessfully() {
    List<ThirdPartyOrderMapping> expectedThirdPartyOrderMappings = get(
        KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage
        .verifyMultipleOrderMappingCreatedSuccessfully(expectedThirdPartyOrderMappings);
  }

  @When("Operator complete the new mapping order")
  public void operatorCompleteTheNewMappingOrder() {
    ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage.completeThirdPartyOrder(orderMapping);
  }

  @Then("Operator verify the new mapping order is completed")
  public void operatorVerifyTheNewMappingOrderIsCompleted() {
    ThirdPartyOrderMapping orderMapping = get(KEY_CREATED_THIRD_PARTY_ORDER_MAPPING_PARAMS);
    thirdPartyOrderManagementPage.verifyThirdPartyOrderMappingWasRemoved(
        orderMapping,
        f("Fail to complete Third Party Order (Tracking ID = %s).", orderMapping.getTrackingId())
    );
  }

  @When("Operator download CSV file on Third Party Order Management page")
  public void operatorDownloadCsvFile() {
    thirdPartyOrderManagementPage.downloadCsvFile.click();
  }

  @Then("3pl-orders CSV file is downloaded successfully")
  public void ordersCsvFileIsDownloadedSuccessfully() {
    thirdPartyOrderManagementPage.verifyFileDownloadedSuccessfully("3pl-orders.csv",
        "\"Tracking ID\",\"3PL Provider\",\"3PL Tracking ID\",\"Transferred to 3PL date\",\"Working days since transferred\",\"NV Order Status\"");
  }
}
