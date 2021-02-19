package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.NinjaPackTrackingIdGeneratorPage;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Map;

@ScenarioScoped
public class NinjaPackTrackingIdGeneratorSteps extends AbstractSteps {

  private NinjaPackTrackingIdGeneratorPage ninjaPackTrackingIdGeneratorPage;

  public NinjaPackTrackingIdGeneratorSteps() {
  }

  @Override
  public void init() {
    ninjaPackTrackingIdGeneratorPage = new NinjaPackTrackingIdGeneratorPage(getWebDriver());
  }

  @And("^Operator generates tracking IDs using data below:$")
  public void operatorGeneratesTrackingIDsUsingDataBelow(Map<String, String> mapOfData) {
    String parcelSize = mapOfData.get("parcelSize");
    String serviceScope = mapOfData.get("serviceScope");
    String quantity = mapOfData.get("quantity");
    ninjaPackTrackingIdGeneratorPage.selectParcelSize(parcelSize);
    ninjaPackTrackingIdGeneratorPage.selectServiceScope(serviceScope);
    ninjaPackTrackingIdGeneratorPage.sendKeysToQuantity(quantity);
    ninjaPackTrackingIdGeneratorPage.clickGenerateButton();
    ninjaPackTrackingIdGeneratorPage.confirmPopGenerationInPopUp();
    ninjaPackTrackingIdGeneratorPage.verifyXlsx(parcelSize, serviceScope);
  }
}
