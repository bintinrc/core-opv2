package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.all_shippers.AllShippersPageV2;
import co.nvqa.operator_v2.selenium.page.all_shippers.ShipperCreatePageV2;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AllShippersStepV2 extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersStepV2.class);
  AllShippersPageV2 allShippersPage;
  ShipperCreatePageV2 shipperCreatePage;


  @Override
  public void init() {
    allShippersPage = new AllShippersPageV2(getWebDriver());
    shipperCreatePage = new ShipperCreatePageV2(getWebDriver());
  }

  public AllShippersStepV2() {

  }

  @When("Operator click create new shipper button")
  public void operatorClickCreateNewShipper() {
    allShippersPage.createShipper.click();
  }

  @When("Operator switch to create new shipper tab")
  public void switchToCreateShipperTab() {
    allShippersPage.switchToOtherWindowAndWaitWhileLoading("/shippers/create");
  }

  @When("Operator select tracking type = {string} in shipper settings page")
  public void selectFixedPrefixType(String trackingType) {
    shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.scrollIntoView();
    shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.selectValue(
        resolveValue(trackingType));
  }

  @When("Operator fill shipper prefix with = {string} in shipper settings page")
  public void operatorFillInShipperPrefixSettingsPage(String value) {
    shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.forceClear();
    shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.type(resolveValue(value));
  }

  @When("Operator fill multi shipper prefix {string} with = {string} in shipper settings page")
  public void operatorFillInShipperMultiPrefixSettingsPage(String index, String value) {
    shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefix(index)
        .forceClear();
    shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefix(index)
        .type(resolveValue(value));
  }

  @When("Operator check error message in shipper prefix input is {string}")
  public void operatorCheckErrorInShipperPrefix(String value) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      String expectedError = resolveValue(value);
      String currentMessage = shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefixError();
      Assertions.assertThat(currentMessage)
          .as(f("check shipper prefix error is: %s", expectedError))
          .isEqualTo(expectedError);
    }, 2000, 3);
  }

  @When("Operator check error message in multi shipper prefix {string} input is {string}")
  public void operatorCheckErrorInShipperPrefix(String index, String value) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      String expectedError = resolveValue(value);
      String currentMessage = shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefixError(
          index);
      Assertions.assertThat(currentMessage)
          .as(f("check shipper prefix error is: %s", expectedError))
          .isEqualTo(expectedError);
    }, 2000, 3);
  }

}
