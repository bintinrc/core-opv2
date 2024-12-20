package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commonsort.constants.SortScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.GlobalSettingsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class GlobalSettingsSteps extends AbstractSteps {

  private GlobalSettingsPage globalSettingsPage;

  public GlobalSettingsSteps() {
  }

  @Override
  public void init() {
    globalSettingsPage = new GlobalSettingsPage(getWebDriver());
  }

  @And("Operator save inbound settings from Global Settings page")
  public void operatorSaveWeightToleranceValueFromGlobalSettingsPage() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.waitUntilPageLoaded();
      put(SortScenarioStorageKeys.KEY_SORT_WEIGHT_TOLERANCE_VALUE,
          Double.valueOf(globalSettingsPage.inputWeightTolerance.getValue()));
      put(SortScenarioStorageKeys.KEY_SORT_MAX_WEIGHT_LIMIT_VALUE,
          Double.valueOf(globalSettingsPage.inputMaxWeightLimit.getValue()));
    });
  }

  @And("Operator set Weight Tolerance value to {string} on Global Settings page")
  public void operatorSetWeightToleranceValueToOnGlobalSettingsPage(String weightTolerance) {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.inputWeightTolerance.setValue(weightTolerance);
    });
  }

  @And("Operator verifies Weight Tolerance value is {string} on Global Settings page")
  public void operatorVerifiesWeightToleranceValue(String expected) {
    globalSettingsPage.inFrame(() -> {
      Assertions.assertThat(Double.valueOf(globalSettingsPage.inputWeightTolerance.getValue()))
          .as("Weight Tolerance").isEqualTo(Double.valueOf(resolveValue(expected)));
    });
  }

  @And("Operator verifies Weight Limit value is {string} on Global Settings page")
  public void operatorVerifiesWeightLimitValue(String expected) {
    globalSettingsPage.inFrame(() -> {
      Assertions.assertThat(Double.valueOf(globalSettingsPage.inputMaxWeightLimit.getValue()))
          .as("Weight Limit").isEqualTo(Double.valueOf(resolveValue(expected)));
    });
  }

  @And("Operator save Inbound settings on Global Settings page")
  public void operatorSaveInboundSettingsOnGlobalSettingsPage() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.updateWeightTolerance.click();
    });
  }

  @And("Operator save Weight Tolerance settings on Global Settings page")
  public void operatorSaveWeightToleranceSettingsOnGlobalSettingsPage() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.updateWeightTolerance.click();
    });
  }

  @And("Operator set Weight Limit value to {string} on Global Settings page")
  public void operatorSetWeightLimitValueToOnGlobalSettingsPage(String weightLimit) {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.inputMaxWeightLimit.setValue(weightLimit);
    });
  }

  @And("Operator save Weight Limit settings on Global Settings page")
  public void operatorSaveWeightLimitOnGlobalSettingsPage() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.updateMaxWeightLimit.click();
    });
  }

  @And("Operator check 'Enable Van Inbound SMS Shipper Ids' checkbox on Global Settings page")
  public void checkEnableVanInboundSMSShipperIdsCheckbox() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.enableVanInboundSms.check();
    });
  }

  @And("Operator check 'Enable Return Pickup SMS Shipper Ids' checkbox on Global Settings page")
  public void checkEnableReturnPickupSmsShipperIdsCheckbox() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.enableVanInboundSms.check();
    });
  }

  @And("Operator add {string} shipper to Exempted Shippers from Van Inbound SMS on Global Settings page")
  public void addShipperToExemptedShippersFromVanInboundSms(String shipper) {
    globalSettingsPage.inFrame((page) -> {
      page.exemptedShippersFromVanInboundSms.sendKeys(resolveValue(shipper));
      page.vanInboundShipperValue.click();
    });
  }

  @And("Operator add {string} shipper to Exempted Shippers from Return Pickup SMS on Global Settings page")
  public void addShipperToExemptedShippersFromReturnPickupSms(String shipper) {
    globalSettingsPage.inFrame((page) -> {
      page.exemptedShippersFromReturnPickupSms.sendKeys(resolveValue(shipper));
      page.returnPickupShipperValue.click();
    });
  }

  @And("Operator clicks 'Update SMS Settings' button on Global Settings page")
  public void clickUpdateSmsSettingsButton() {
    globalSettingsPage.inFrame(() -> {
      globalSettingsPage.updateSmsSettings.click();
    });
  }

  @And("Operator verifies that Exempted Shippers from Van Inbound SMS contains {string} shipper on Global Settings page")
  public void verifyShipperToExemptedShippersFromVanInboundSms(String shipper) {
    globalSettingsPage.inFrame(() -> {
      pause2s();
      String expected = resolveValue(shipper);
      retryIfAssertionErrorOccurred(() ->
              globalSettingsPage.selectedVanInboundShippers.stream()
                  .filter(
                      element -> StringUtils.equalsIgnoreCase(expected, element.getText()))
                  .findFirst()
                  .orElseThrow(() -> new AssertionError(
                      "Exempted Shippers from Van Inbound SMS list doesn't contain [" + expected
                          + "] shipper")), "Check Exempted Shippers from Van Inbound SMS list", 1000,
          5);
    });
  }

  @And("Operator verifies that Exempted Shippers from Return Pickup SMS contains {string} shipper on Global Settings page")
  public void verifyShipperToExemptedShippersFromReturnPickupSms(String shipper) {
    globalSettingsPage.inFrame(() -> {
      pause2s();
      String expected = resolveValue(shipper);
      retryIfAssertionErrorOccurred(() ->
              globalSettingsPage.selectedReturnPickupShipper.stream()
                  .filter(
                      element -> StringUtils.equalsIgnoreCase(expected, element.getText()))
                  .findFirst()
                  .orElseThrow(() -> new AssertionError(
                      "Exempted Shippers from Return Pickup SMS list doesn't contain [" + expected
                          + "] shipper")), "Check Exempted Shippers from Return Pickup SMS list", 1000,
          5);
    });
  }

  @Then("Operator verifies success toast displayed with message {string}")
  public void successToast(String message) {
    globalSettingsPage.inFrame((page) -> {
      page.waitUntilInvisibilityOfNotification("Updated", false);
    });
  }
}
