package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.NinjaPackTidGeneratorPage;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Map;

@ScenarioScoped
public class NinjaPackTidGeneratorSteps extends AbstractSteps {

    private NinjaPackTidGeneratorPage ninjaPackTidGeneratorPage;

    public NinjaPackTidGeneratorSteps(){
    }

    @Override
    public void init() {
        ninjaPackTidGeneratorPage = new NinjaPackTidGeneratorPage(getWebDriver());
    }

    @And("^Operator generates tracking IDs using data below:$")
    public void operatorGeneratesTrackingIDsUsingDataBelow(Map<String, String> mapOfData) {
        String parcelSize = mapOfData.get("parcelSize");
        String serviceScope = mapOfData.get("serviceScope");
        String quantity = mapOfData.get("quantity");
        ninjaPackTidGeneratorPage.selectParcelSize(parcelSize);
        ninjaPackTidGeneratorPage.selectServiceScope(serviceScope);
        ninjaPackTidGeneratorPage.sendKeysToQuantity(quantity);
        ninjaPackTidGeneratorPage.clickGenerateButton();
        ninjaPackTidGeneratorPage.confirmPopGenerationInPopUp();
        ninjaPackTidGeneratorPage.verifyXlsx(parcelSize, serviceScope);
    }
}
