package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.Addressing;
import co.nvqa.operator_v2.selenium.page.AddressingPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Tristania Siagian
 */
@ScenarioScoped
public class AddressingSteps extends AbstractSteps {
    private AddressingPage addressingPage;

    @Inject
    public AddressingSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage) {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init() {
        addressingPage = new AddressingPage(getWebDriver());
    }

    @When("^Operator clicks on Add Address Button on Addressing Page$")
    public void clickAddAddressButton() {
        addressingPage.clickAddAddressButton();
    }

    @And("^Operator creates new address on Addressing Page$")
    public void addNewAddress() {
        String uniqueCode = generateDateUniqueString();
        long uniqueCoordinate = System.currentTimeMillis();

        Addressing addressing = new Addressing();
        addressing.setPostcode("112233");
        addressing.setStreetName(TestUtils.randomInt(10, 99)+" Test Street");
        addressing.setBuildingName("Test Building");
        addressing.setBuildingNo(uniqueCode);
        addressing.setLatitude(Double.parseDouble("1."+uniqueCoordinate));
        addressing.setLongitude(Double.parseDouble("103."+uniqueCoordinate));
        addressing.setAddressType("Standard");

        addressingPage.addNewAddress(addressing);
        put("addressing", addressing);
    }

    @And("^Operator searches the address that has been made on Addressing Page$")
    public void searchAddress() {
        Addressing addressing = get("addressing");
        addressingPage.searchAddress(addressing);
    }

    @Then("^Operator verifies the address exists on Addressing Page$")
    public void verifyAddressExist() {
        Addressing addressing = get("addressing");
        addressingPage.verifyAddressExistAndInfoIsCorrect(addressing);
    }

    @When("^Operator delete the address that has been made on Addressing Page$")
    public void deleteAddress() {
        addressingPage.deleteAddress();
    }

    @Then("^Operator verifies the address does not exist anymore on Addressing Page$")
    public void verifyDelete() {
        Addressing addressing = get("addressing");
        addressingPage.verifyDelete(addressing);
    }

    @When("^Operator edits the address on Addressing Page$")
    public void editAddress() {
        Addressing addressing = get("addressing");

        long uniqueCoordinate = System.currentTimeMillis();

        Addressing addressingEdited = new Addressing();
        addressingEdited.setPostcode(addressing.getPostcode());
        addressingEdited.setStreetName(addressing.getStreetName()+" EDITED");
        addressingEdited.setBuildingName(addressing.getBuildingName()+" EDITED");
        addressingEdited.setBuildingNo(addressing.getBuildingNo());
        addressingEdited.setLatitude(Double.parseDouble("1."+uniqueCoordinate));
        addressingEdited.setLongitude(Double.parseDouble("103."+uniqueCoordinate));
        addressingEdited.setAddressType(addressing.getAddressType());

        put("addressingEdited", addressingEdited);
        addressingPage.editAddress(addressing, addressingEdited);
    }

    @And("^Operator searches the address that has been edited on Addressing Page$")
    public void searchEditedAddress() {
        Addressing addressingEdited = get("addressingEdited");
        addressingPage.searchAddress(addressingEdited);
    }

    @Then("^Operator verifies the address has been changed$")
    public void verifyAddressEdited() {
        Addressing addressingEdited = get("addressingEdited");
        addressingPage.verifyAddressExistAndInfoIsCorrect(addressingEdited);
    }
}
