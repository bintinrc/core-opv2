package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.GlobalSettingsPage;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;

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

  @And("^Operator save inbound settings from Global Settings page$")
  public void operatorSaveWeightToleranceValueFromGlobalSettingsPage() {
    put(KEY_WEIGHT_TOLERANCE_VALUE,
        Double.valueOf(globalSettingsPage.inputWeightTolerance.getValue()));
    put(KEY_MAX_WEIGHT_LIMIT_VALUE,
        Double.valueOf(globalSettingsPage.inputMaxWeightLimit.getValue()));
  }

  @And("^Operator set Weight Tolerance value to \"([^\"]*)\" on Global Settings page$")
  public void operatorSetWeightToleranceValueToOnGlobalSettingsPage(String weightTolerance) {
    globalSettingsPage.inputWeightTolerance.setValue(weightTolerance);
  }

  @And("Operator verifies Weight Tolerance value is {string} on Global Settings page")
  public void operatorVerifiesWeightToleranceValue(String expected) {
    assertEquals("Weight Tolerance", Double.valueOf(resolveValue(expected)),
        Double.valueOf(globalSettingsPage.inputWeightTolerance.getValue()));
  }

  @And("Operator verifies Weight Limit value is {string} on Global Settings page")
  public void operatorVerifiesWeightLimitValue(String expected) {
    assertEquals("Weight Limit", Double.valueOf(resolveValue(expected)),
        Double.valueOf(globalSettingsPage.inputMaxWeightLimit.getValue()));
  }

  @And("^Operator save Inbound settings on Global Settings page$")
  public void operatorSaveInboundSettingsOnGlobalSettingsPage() {
    globalSettingsPage.updateWeightTolerance.clickAndWaitUntilDone();
  }

  @And("^Operator save Weight Tolerance settings on Global Settings page$")
  public void operatorSaveWeightToleranceSettingsOnGlobalSettingsPage() {
    globalSettingsPage.updateWeightTolerance.clickAndWaitUntilDone();
  }

  @And("^Operator set Weight Limit value to \"([^\"]*)\" on Global Settings page$")
  public void operatorSetWeightLimitValueToOnGlobalSettingsPage(String weightLimit) {
    globalSettingsPage.inputMaxWeightLimit.setValue(weightLimit);
  }

  @And("^Operator save Weight Limit settings on Global Settings page$")
  public void operatorSaveWeightLimitOnGlobalSettingsPage() {
    globalSettingsPage.updateMaxWeightLimit.clickAndWaitUntilDone();
  }
}
