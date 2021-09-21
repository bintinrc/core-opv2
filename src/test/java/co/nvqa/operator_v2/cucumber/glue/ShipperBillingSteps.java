package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.ShipperBillingRecord;
import co.nvqa.operator_v2.selenium.page.ShipperBillingPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ShipperBillingSteps extends AbstractSteps {

  private ShipperBillingPage shipperBillingPage;

  public ShipperBillingSteps() {
  }

  @Override
  public void init() {
    shipperBillingPage = new ShipperBillingPage(getWebDriver());
  }


  @When("Operator add amount on Shipper Billing page using data below:")
  public void operatorAddAmountOnShipperBillingPageUsingDataBelow(Map<String, String> mapOfData) {
    updateShipperBilling(mapOfData, "Add");
  }

  @When("Operator deduct amount on Shipper Billing page using data below:")
  public void operatorDeductAmountOnShipperBillingPageUsingDataBelow(
      Map<String, String> mapOfData) {
    updateShipperBilling(mapOfData, "Deduct");
  }

  private void updateShipperBilling(Map<String, String> mapOfData, String type) {
    Map<String, String> mapOfTokens = createDefaultTokens();
    mapOfTokens.put("unique-id", TestUtils.generateDateUniqueString());
    mapOfData = replaceDataTableTokens(mapOfData, mapOfTokens);

    ShipperBillingRecord billingRecord = new ShipperBillingRecord();
    billingRecord.fromMap(mapOfData);
    billingRecord.setType(type);

    shipperBillingPage.updateShipperBilling(billingRecord);
    put(KEY_SHIPPER_BILLING_RECORD, billingRecord);
  }
}
