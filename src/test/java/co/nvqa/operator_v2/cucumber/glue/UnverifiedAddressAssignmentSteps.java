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
    page.loadSelection.clickAndWaitUntilDone();
  }

  @Then("Operator verifies address on Unverified Address Assignment page:")
  public void operatorVerifiesAddress(Map<String, String> data) {
    TxnAddress expected = new TxnAddress(resolveKeyValues(data));
    page.txnAddressTable.filterByColumn(TxnAddressTable.COLUMN_ADDRESS, expected.getAddress());
    TxnAddress actual = page.txnAddressTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @Then("Operator assign address {string} to zone {string} on Unverified Address Assignment page")
  public void operatorAssignAddress(String address, String zone) {
    page.txnAddressTable.filterByColumn(TxnAddressTable.COLUMN_ADDRESS, resolveValue(address));
    page.txnAddressTable.selectRow(1);
    page.selectZone.selectValue(resolveValue(zone));
    page.assignButton.click();
  }


}
