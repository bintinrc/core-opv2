package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.MiddleMileHomepagePage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * @author Indah Puspita
 */

public class MiddleMileHomepageSteps extends AbstractSteps {

    private static final Logger LOGGER = LoggerFactory.getLogger(MiddleMileHomepageSteps.class);

    private MiddleMileHomepagePage middleMileHomepagePage;

    @Override
    public void init() {
        middleMileHomepagePage = new MiddleMileHomepagePage(getWebDriver());
    }

    @Then("Operator verifies Middle Mile Homepage is opened")
    public void operatorVerifiesMiddleMileHomepageIsOpened() {
        middleMileHomepagePage.switchTo();
        middleMileHomepagePage.verifyMiddleMileHomepagePageItems();
        pause2s();
    }

    @And("Operator selects hub from hubs dropdown list on Middle Mile Homepage")
    public void operatorSelectsHubFromHubsDropdownListOnMiddleMileHomepage(Map<String, String> mapOfData) {
        Map<String, String> resolvedData = resolveKeyValues(mapOfData);
        middleMileHomepagePage.fillMyHub(resolvedData);
    }

    @When("Operator clicks {string} button on Middle Mile Homepage")
    public void operatorClicksButtonOnMiddleMileHomepage(String actionButton) {
        switch (actionButton) {
            case "Set My Hub":
                middleMileHomepagePage.setMyHub.click();
                middleMileHomepagePage.verifySetMyHubPopUpIsShown();
                break;
            case "Confirm":
                middleMileHomepagePage.hubSelectionConfirmButton.click();
                break;
        }
    }

    @Then("Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage")
    public void operatorVerifiesShipmentsInMyHubSectionIsShownOnMiddleMileHomepage() {
        middleMileHomepagePage.verifiesShipmentsInMyHubSectionIsShown();
    }
}
