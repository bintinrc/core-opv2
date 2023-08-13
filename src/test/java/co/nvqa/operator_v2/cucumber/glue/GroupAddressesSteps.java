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
}
