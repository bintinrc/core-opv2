package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.Addressing;
import co.nvqa.operator_v2.selenium.page.AddressingPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class AddressingSteps extends AbstractSteps {

  private AddressingPage addressingPage;

  public AddressingSteps() {
  }

  @Override
  public void init() {
    addressingPage = new AddressingPage(getWebDriver());
  }

  @When("^Operator clicks on Add Address Button on Addressing Page$")
  public void clickAddAddressButton() {
    addressingPage.inFrame(pahe -> {
      addressingPage.clickAddAddressButton();
    });
  }

  @And("^Operator creates new address on Addressing Page$")
  public void addNewAddress() {
    String uniqueCode = generateDateUniqueString();
    long uniqueCoordinate = System.currentTimeMillis();

    Addressing addressing = new Addressing();
    addressing.setPostcode("112233");
    addressing.setStreetName(TestUtils.randomInt(10, 99) + " Test Street");
    addressing.setBuildingName("Test Building");
    addressing.setBuildingNo(uniqueCode);
    addressing.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    addressing.setLongitude(Double.parseDouble("103." + uniqueCoordinate));
    addressing.setAddressType("Standard");

    addressingPage.inFrame(page -> {
      page.addNewAddress(addressing);
    });
    put(KEY_CREATED_ADDRESSING, addressing);
  }

  @When("^Operator delete address on Addressing Page$")
  public void deleteAddress() {
    addressingPage.inFrame(page -> {
      page.addressCardBtn.get(0).click();
      page.addressCards.get(0).deleteAddress.click();
      page.confirmDeleteModal.waitUntilVisible();
      page.confirmDeleteModal.delete.click();
    });
  }

  @Then("^Operator verifies the address does not exist on Addressing Page$")
  public void verifyDelete() {
    addressingPage.inFrame(page -> {
      Assertions.assertThat(page.emptyListText.isDisplayed())
          .as("No address found is displayed")
          .isTrue();
    });
  }

  @When("^Operator edits the address on Addressing Page$")
  public void editAddress() {
    Addressing addressing = get(KEY_CREATED_ADDRESSING);

    long uniqueCoordinate = System.currentTimeMillis();

    Addressing addressingEdited = new Addressing();
    addressingEdited.setPostcode(addressing.getPostcode());
    addressingEdited.setStreetName(addressing.getStreetName() + " EDITED");
    addressingEdited.setBuildingName(addressing.getBuildingName() + " EDITED");
    addressingEdited.setBuildingNo(addressing.getBuildingNo());
    addressingEdited.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    addressingEdited.setLongitude(Double.parseDouble("103." + uniqueCoordinate));
    addressingEdited.setAddressType(addressing.getAddressType());

    put(KEY_EDITED_ADDRESSING, addressingEdited);
    addressingPage.inFrame(page -> {
      page.searchAddress(addressing);
      page.addressCardBtn.get(0).click();
      page.addressCards.get(0).editAddress.click();
      page.editAddressModal.waitUntilVisible();
      page.editAddressModal.fill(addressingEdited);
      page.editAddressModal.editAddress.click();
    });
  }

  @And("Operator searches {value} address on Addressing Page")
  public void searchAddress(String input) {
    addressingPage.inFrame(page -> {
      page.searchInput.forceClear();
      pause1s();
      page.searchInput.setValue(input);
      pause1s();
    });
  }

  @Then("^Operator verifies address on Addressing Page:$")
  public void verifyAddressEdited(Map<String, String> data) {
    Addressing expected = new Addressing(resolveKeyValues(data));
    addressingPage.inFrame(page -> {
      page.addressCardBtn.get(0).click();
      SoftAssertions assertions = new SoftAssertions();
      assertions.assertThat(page.addressCards.get(0).buildingNo.getValue())
          .as("Building No")
          .isEqualTo(expected.getBuildingNo());
      assertions.assertThat(page.addressCards.get(0).street.getValue())
          .as("Street Name")
          .isEqualTo(expected.getStreetName());
      assertions.assertThat(page.addressCards.get(0).postcode.getValue())
          .as("Postcode")
          .isEqualTo(expected.getPostcode());
      assertions.assertThat(page.addressCards.get(0).latitude.getValue())
          .as("Latitude")
          .isEqualTo(expected.getLatitude().toString());
      assertions.assertThat(page.addressCards.get(0).longitude.getValue())
          .as("Longitude")
          .isEqualTo(expected.getLongitude().toString());
      assertions.assertAll();
    });
  }
}
