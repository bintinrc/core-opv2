package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.mm.model.persisted_class.HubShipmentSummary;
import co.nvqa.operator_v2.selenium.page.MiddleMileHomepagePage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_HUB_SHIPMENTS_SUMMARIES;
import static co.nvqa.common.mm.cucumber.MiddleMileScenarioStorageKeys.KEY_LIST_OF_ORDERED_HUB_SHIPMENTS_SUMMARIES;

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

    @Then("Operator verifies total shipment count in Shipments in My Hub section is correct")
    public void operatorVerifiesTotalShipmentCountInShipmentsInMyHubSectionIsCorrect() {
        List<HubShipmentSummary> hubShipmentSummaries = getList(KEY_LIST_OF_HUB_SHIPMENTS_SUMMARIES, HubShipmentSummary.class);
        long shipmentsTotal = hubShipmentSummaries.stream().map(HubShipmentSummary::getShipmentsCount).reduce(
            Long::sum).get();

        middleMileHomepagePage.verifyShipmentTotal(shipmentsTotal);
    }

    @Then("Operator verifies can sort data in Middle Mile Homepage by column {string}")
    public void operatorVerifiesCanSortDataInMiddleMileHomepageByColumn(String column) {
        middleMileHomepagePage.switchTo();
        List<HubShipmentSummary> orderedHubShipmentSummaries = get(KEY_LIST_OF_ORDERED_HUB_SHIPMENTS_SUMMARIES);

        middleMileHomepagePage.verifySortedDataByColumn(column, orderedHubShipmentSummaries);
    }
}
