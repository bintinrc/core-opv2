package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commonsort.constants.SortScenarioStorageKeys;
import co.nvqa.commonsort.model.addressing.Addressing;
import co.nvqa.operator_v2.selenium.page.AddressingPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

import static org.apache.commons.lang3.StringUtils.isNotBlank;

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
    addressingPage.inFrame(pahe -> addressingPage.clickAddAddressButton());
  }

  @And("^Operator creates new address on \"([^\"]*)\" Addressing Page$")
  public void addNewAddress(String country) {
    String uniqueCode = StandardTestUtils.generateDateUniqueString();
    long uniqueCoordinate = System.currentTimeMillis();
    Addressing addressing = new Addressing();

    switch (country) {
      case "Indonesia":
        addressing.setProvince("Jakarta");
        addressing.setCity("Jakarta Barat");
        addressing.setDistrict("Tanjung Duren");
        addressing.setCommunity("Jakbar");
        break;
      case "Thailand":
        addressing.setProvince("Loei");
        addressing.setDistrict("Tha Li District");
        addressing.setSubdistrict("A Hi");
        break;
      case "Vietnam":
        addressing.setCity("Hanoi");
        addressing.setDistrict("Hanoi");
        addressing.setWard("Ba dinh district");
        break;
      case "Malaysia":
        addressing.setCity("Kuala lumpur");
        addressing.setState("Selangor");
        addressing.setArea("Batu caves");
        break;
      case "Philippines":
        addressing.setProvince("Manila");
        addressing.setCity("Manila city");
        addressing.setDistrict("Capital District");
        addressing.setSubdivision("Metro Manila");
        break;
    }

    addressing.setPostcode("112233");
    addressing.setStreetName(TestUtils.randomInt(10, 99) + " Test Street");
    addressing.setBuildingName("Test Building");
    addressing.setBuildingNo(uniqueCode);
    addressing.setLatitude(Double.parseDouble("1." + uniqueCoordinate));
    addressing.setLongitude(Double.parseDouble("103." + uniqueCoordinate));
    addressing.setAddressType("Standard");

    addressingPage.inFrame(page -> page.addNewAddress(addressing));
//    put(KEY_CREATED_ADDRESSING, addressing);
    put(SortScenarioStorageKeys.KEY_SORT_CREATED_ADDRESSING, addressing);
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
    addressingPage.inFrame(page -> Assertions.assertThat(page.emptyListText.isDisplayed())
        .as("No address found is displayed")
        .isTrue());
  }

  @When("^Operator edits the address on Addressing Page$")
  public void editAddress() {
    Addressing addressing = get(SortScenarioStorageKeys.KEY_SORT_CREATED_ADDRESSING);

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

  @Then("^Operator verifies address on Addressing Page:")
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
      if (isNotBlank(expected.getProvince())) {
        assertions.assertThat(page.addressCards.get(0).province.getValue())
            .as("Province")
            .isEqualTo(expected.getProvince());
      }
      if (isNotBlank(expected.getCity())) {
        assertions.assertThat(page.addressCards.get(0).city.getValue())
            .as("City")
            .isEqualTo(expected.getCity());
      }
      if (isNotBlank(expected.getDistrict())) {
        assertions.assertThat(page.addressCards.get(0).district.getValue())
            .as("District")
            .isEqualTo(expected.getDistrict());
      }
      if (isNotBlank(expected.getCommunity())) {
        assertions.assertThat(page.addressCards.get(0).community.getValue())
            .as("Community")
            .isEqualTo(expected.getCommunity());
      }
      if (isNotBlank(expected.getSubdistrict())) {
        assertions.assertThat(page.addressCards.get(0).subdistrict.getValue())
            .as("Subdistrict")
            .isEqualTo(expected.getSubdistrict());
      }
      if (isNotBlank(expected.getWard())) {
        assertions.assertThat(page.addressCards.get(0).ward.getValue())
            .as("Ward")
            .isEqualTo(expected.getWard());
      }
      if (isNotBlank(expected.getArea())) {
        assertions.assertThat(page.addressCards.get(0).area.getValue())
            .as("Area")
            .isEqualTo(expected.getArea());
      }
      if (isNotBlank(expected.getSubdivision())) {
        assertions.assertThat(page.addressCards.get(0).subdivision.getValue())
            .as("Subdivision")
            .isEqualTo(expected.getSubdivision());
      }
      assertions.assertAll();
    });
  }

  @Then("Operator verifies address on Addressing Page to Return Default Value:")
  public void operatorVerifiesAddressOnAddressingPageToReturnDefaultValue(
      Map<String, String> data) {
    Addressing expected = new Addressing(resolveKeyValues(data));
    addressingPage.inFrame(page -> {
      page.addressCardBtn.get(0).click();
      SoftAssertions assertions = new SoftAssertions();
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
      if (isNotBlank(expected.getProvince())) {
        assertions.assertThat(page.addressCards.get(0).province.getValue())
            .as("Province")
            .isEqualTo(expected.getProvince());
      }
      if (isNotBlank(expected.getCity())) {
        assertions.assertThat(page.addressCards.get(0).city.getValue())
            .as("City")
            .isEqualTo(expected.getCity());
      }
      if (isNotBlank(expected.getAddressType())) {
        assertions.assertThat(page.addressCards.get(0).addresstype.getValue())
            .as("AddressType")
            .isEqualTo(expected.getAddressType());
      }
      if (isNotBlank(expected.getSource())) {
        assertions.assertThat(page.addressCards.get(0).source.getValue())
            .as("Source")
            .isEqualTo(expected.getSource());
      }
      if (isNotBlank(expected.getScore())) {
        assertions.assertThat(page.addressCards.get(0).score.getValue())
            .as("Score")
            .isEqualTo(expected.getSource());
      }
      assertions.assertAll();
    });
  }
}
