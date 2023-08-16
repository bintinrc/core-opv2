package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.GroupAddressesPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.assertj.core.api.Assertions;

@ScenarioScoped
public class GroupAddressesSteps extends AbstractSteps{

  private GroupAddressesPage groupAddressesPage;


  public GroupAddressesSteps() {
  }

  @Override
  public void init() {
    groupAddressesPage = new GroupAddressesPage(getWebDriver());
  }

  @When("Operator loads Group Addresses page")
  public void operatorLoadsGroupAddressespage() {
    groupAddressesPage.loadGroupAddressesPage();
  }

  @When("Operator search address {string} on Group Addresses page")
  public void inputSearchAddress(String address) {
    groupAddressesPage.inFrame(page ->{
      groupAddressesPage.searchAddress(address);
    });
  }

  @When("Operator select zone {string} on Group Addresses page")
  public void inputZone(String zone) {
    groupAddressesPage.inFrame(page ->{
      groupAddressesPage.searchZone(zone);
    });
  }

  @Then("Operator verify that address {string} is displayed on pickup address column")
  public void verifyPickupAddress(String address) {
    groupAddressesPage.inFrame(page ->{
      Assertions.assertThat(groupAddressesPage.getTextCellPickupAddress()).as("Pickup Address contains string").contains(address);
    });
  }

  @Then("Operator verify search result is displayed on list of pickup addresses")
  public void verifyListOfPickupAddress() {
    groupAddressesPage.inFrame(page ->{
      Assertions.assertThat(groupAddressesPage.isCellGroupAddressDisplayed()).as("Group Address is displayed").isTrue();
      Assertions.assertThat(groupAddressesPage.isCellPickupAddressDisplayed()).as("Pickup Address is displayed").isTrue();
      Assertions.assertThat(groupAddressesPage.isCellShipperIdDisplayed()).as("Shipper Id is displayed").isTrue();
      Assertions.assertThat(groupAddressesPage.isCellShipperNameDisplayed()).as("Shipper Name is displayed").isTrue();
      Assertions.assertThat(groupAddressesPage.isCellLatestPickupDateDisplayed()).as("Latest Pickup is displayed").isTrue();
    });
  }

  @And("Operator clicks on the load selection button on Group Addresses page")
  public void operatorClicksOnTheLoadSelectionButton() {
    groupAddressesPage.inFrame(page ->{
      groupAddressesPage.clickLoadSelection();
    });
  }

  @When("Operator select {string} on Grouping option")
  public void selectGrouping(String grouping) {
    groupAddressesPage.inFrame(page -> {
      groupAddressesPage.selectGrouping(grouping);
    });
  }

  @And("Operator chooses start and end date on Address PickUp date using the following data:")
  public void operatorChoosesStartAndEndDateOnAddressCreationDateUsingTheFollowingData(
      Map<String, String> addressCreationDate) {
          addressCreationDate = resolveKeyValues(addressCreationDate);
          String startDate = addressCreationDate.get("From");
          String endDate = addressCreationDate.get("To");
        groupAddressesPage.inFrame(page -> {
            groupAddressesPage.selectDateRange(startDate,
                endDate);
          });
    takesScreenshot();
  }

  @And("Operator chooses start and end date for Address Creation date on group address page using the following data:")
  public void operatorChoosesStartAndEndDateOnAddressCreationDateOnGroupAddressPageUsingTheFollowingData(
      Map<String, String> addressCreationDate) {
    addressCreationDate = resolveKeyValues(addressCreationDate);
    String startDate = addressCreationDate.get("From");
    String endDate = addressCreationDate.get("To");
    groupAddressesPage.inFrame(page -> {
      groupAddressesPage.selectDateRangeForAddressCreation(startDate,
          endDate);
    });
    takesScreenshot();
  }

  @Then("Operator filter the column {string} with {string} on group address page")
  public void operator_Searches_By(String filterBy, String filterValue) {
    filterValue = resolveValue(filterValue);
    String finalFilterValue = filterValue;
    groupAddressesPage.inFrame(page -> {
    Runnable filterColumn = () -> {
      groupAddressesPage.filterBy(filterBy, finalFilterValue);
    };
    doWithRetry(filterColumn, "Operator filter column");
    });
    takesScreenshot();
  }

  @When("Operator select address from the list on group address page with Id {string}")
  public void operatorSelectMultipleAddressesThatHasNoGroupUsingBelowData(String addressId) {
    addressId = resolveValue(addressId);
    String finalAddressId = addressId;
    groupAddressesPage.inFrame(page -> {
    Runnable selectAddress = () -> {
      groupAddressesPage.clickOnAddressToGroup(finalAddressId);
    };
    doWithRetry(selectAddress, "Select Address from List");
    });
  }

  @Then("Operator verify modal with below data:")
  public void operatorVerifyModalWithBelowData(Map<String, String> data) {
    data = resolveKeyValues(data);
    String firstTitle = data.get("title");
    String secondTitle = data.get("title2");
    String pickupAddress = data.get("pickup_Address");
    String firstAddress = data.get("address1");
    groupAddressesPage.inFrame(page -> {
          Runnable verifyModal = () -> {
            groupAddressesPage.verifyGroupAddressModal(firstTitle, secondTitle,
                pickupAddress, firstAddress);
          };
          doWithRetry(verifyModal, "verify Modal");
        });
    takesScreenshot();
  }

  @Then("Operator verify current group text with below data:")
  public void operatorVerifyCurrentGroupModalWithBelowData(Map<String, String> data) {
    data = resolveKeyValues(data);
    String firstAddress = data.get("address1");
    groupAddressesPage.inFrame(page -> {
      Runnable verifyModal = () -> {
        groupAddressesPage.verifyCurrentGroupAddressModal(firstAddress);
      };
      doWithRetry(verifyModal, "verify Modal");
    });
    takesScreenshot();
  }

  @When("Operator select radio checkbox for address from the list with Id {string}")
  public void operatorSelectRadioThatHasNoGroupUsingBelowData(String addressId) {
    addressId = resolveValue(addressId);
    String finalAddressId = addressId;
    groupAddressesPage.inFrame(page -> {
      Runnable clickRadioBox = () -> {
        groupAddressesPage.clickOnRadioCheckBoxForAddressToGroup(finalAddressId);
      };
      doWithRetry(clickRadioBox, "Click Radio Box");
    });
  }

  @Then("Operator verify success message is displayed")
  public void operatorVerifySuccessMessageIsDisplayed() {
    groupAddressesPage.inFrame(page -> {
      groupAddressesPage.verifySuccessMessage();
    });
  }

  @Then("Verify that the Group Address for Id {string} is showing with text {string}")
  public void verifyThatTheGroupAddressForIdIsShowingWithText(String addressId, String addressText) {
    addressId = resolveValue(addressId);
    String finalAddressId = addressId;
    groupAddressesPage.inFrame(page -> {
      groupAddressesPage.verifyGroupAddressIsShown(finalAddressId, addressText);
        });
    takesScreenshot();
  }

  @Then("Operator verify {string} message is displayed")
  public void operatorVerifySuccessMessageIsDisplayed(String message) {
    message = resolveValue(message);
    String finalMessage = message;
    groupAddressesPage.inFrame(page -> {
      groupAddressesPage.verifyMessage(finalMessage);
    });
    takesScreenshot();
  }
}
