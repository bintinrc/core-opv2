package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.page.FailedDeliveryManagementPageV2;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;

public class FailedDeliveryManagementStepsV2 extends AbstractSteps {

  private FailedDeliveryManagementPageV2 failedDeliveryManagementReactPage;

  public FailedDeliveryManagementStepsV2() {
  }

  @Override
  public void init() {
    failedDeliveryManagementReactPage = new FailedDeliveryManagementPageV2(getWebDriver());
  }

  @When("Recovery User - Search failed orders by trackingId = {string}")
  public void doFilterByTrackingId(String trackingId) {
    failedDeliveryManagementReactPage.waitUntilHeaderShown();
    failedDeliveryManagementReactPage.inFrame(page -> {
      page.fdmTable.filterTableByTID("trackingId", resolveValue(trackingId));
    });
  }

  @When("Recovery User - Search failed orders by shipperName = {string}")
  public void doFilterByShipperId(String shipperName) {
    failedDeliveryManagementReactPage.waitUntilHeaderShown();
    failedDeliveryManagementReactPage.inFrame(page -> {
      page.fdmTable.filterTableByShipperName("shipperName", resolveValue(shipperName));
    });
  }

  @Then("Operator verify failed delivery table on FDM page:")
  public void verifyPickupJobsTable(Map<String, String> dataTable) {
    FailedDelivery expected = new FailedDelivery(resolveKeyValues(dataTable));

    failedDeliveryManagementReactPage.inFrame(page -> {
      page.waitUntilLoaded(1);
      List<String> actual = page.fdmTable.getFilteredValue();

      Assertions.assertThat(actual.get(1)).as("TrackingId is Match")
          .isEqualTo(expected.getTrackingId());
      Assertions.assertThat(actual.get(3)).as("Shipper Name is Match")
          .isEqualTo(expected.getShipperName());
      Assertions.assertThat(actual.get(5)).as("Failure Comments is Match")
          .isEqualTo(expected.getFailureReasonComments());
    });
  }
}
