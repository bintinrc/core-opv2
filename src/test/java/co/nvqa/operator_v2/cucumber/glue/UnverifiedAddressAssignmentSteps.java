package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.TxnAddress;
import co.nvqa.operator_v2.selenium.page.UnverifiedAddressAssignmentPage;
import co.nvqa.operator_v2.selenium.page.UnverifiedAddressAssignmentPage.TxnAddressTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import java.util.Map;

public class UnverifiedAddressAssignmentSteps extends AbstractSteps {

  private UnverifiedAddressAssignmentPage page;

  public UnverifiedAddressAssignmentSteps() {
  }

  @Override
  public void init() {
    page = new UnverifiedAddressAssignmentPage(getWebDriver());
  }

  @And("Operator clicks Load Selection on Unverified Address Assignment page")
  public void operatorClicksLoadSelection() {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.loadSelection.clickAndWaitUntilDone(180);
    });
  }

  @Then("Operator verifies address on Unverified Address Assignment page:")
  public void operatorVerifiesAddress(Map<String, String> data) {
    TxnAddress expected = new TxnAddress(resolveKeyValues(data));
    page.inFrame(() -> {
      page.txnAddressTable.filterByColumn(TxnAddressTable.COLUMN_ADDRESS, expected.getAddress());
      TxnAddress actual = page.txnAddressTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @Then("Operator assign address {value} to zone {value} on Unverified Address Assignment page")
  public void operatorAssignAddress(String address, String zone) {
    page.inFrame(() -> {
      page.txnAddressTable.filterByColumn(TxnAddressTable.COLUMN_ADDRESS, address);
      page.txnAddressTable.selectRow(1);
      page.selectZone.selectValue(zone);
      page.assignButton.click();
    });
  }


}
