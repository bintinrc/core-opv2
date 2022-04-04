package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationUserManagementPage;

import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;


/**
 * @author Sathish
 */

@SuppressWarnings("unused")
@ScenarioScoped
public class StationUserManagementSteps extends AbstractSteps {

  private StationUserManagementPage stationUserManagementPage;

  public StationUserManagementSteps() {
  }

  @Override
  public void init() {
    stationUserManagementPage = new StationUserManagementPage(getWebDriver());
  }

  @SuppressWarnings("unchecked")

  @Then("Operator searches by {string}: {string}")
  public void operator_Searches_By(String filterBy, String filterValue) {
    stationUserManagementPage.searchBy(filterBy, filterValue);
    takesScreenshot();
  }

  @And("Operator clicks on the view Users button")
  public void operator_Clicks_On_The_ViewUser_Button() {
    stationUserManagementPage.clickViewUsersButton();
  }

  @And("Operator adds the user {string} to the hub")
  public void operator_Add_The_User_To_The_Hub(String userName) {
    stationUserManagementPage.addUserToHub(userName);

  }

  @Then("Operator verifies the success message is displayed on adding user to Hub : {string}")
  public void operator_Verifies_The_Success_Message_Is_Displayed_On_Adding_User_To_Hub(
      String hubName) {
    stationUserManagementPage.validateAddUserSuccessMessage(hubName);
    takesScreenshot();
  }

  @And("operator verifies the newly added user {string} is available in the list")
  public void operator_Verifies_TheNewly_Added_User_Is_Available_In_The_List(String userName) {
    stationUserManagementPage.validateUserInList(userName);
    takesScreenshot();
  }

  @When("Operator input email {string} to Email Address field")
  public void operator_Input_Email_To_Email_Address_Field(String userName) {
    stationUserManagementPage.enterEmail(userName);
  }

  @And("Operator clicks on the add user button")
  public void operator_Clicks_On_The_AddUser_Button() {
    stationUserManagementPage.clickAddUserButton();
  }

  @Then("Operator verifies confirm user button is disabled")
  public void operator_Verifies_Confirm_User_Button_Is_Disabled() {
    stationUserManagementPage.validateConfirmUserButtonIsDisabled();
    takesScreenshot();
  }

  @Then("operator verifies the error message displayed on adding same user again to Hub:{string}")
  public void operatorVerifiesTheErrorMessageDisplayedOnAddingSameUserAgainToHub(String hubName) {
    stationUserManagementPage.validateErrorMessageIsDisplayed(hubName);
    takesScreenshot();
  }

  @And("Operator removes the user {string} from the hub")
  public void operatorRemovesTheUserFromTheHub(String userName) {
    stationUserManagementPage.removeUserFromHub(userName);
  }

  @Then("Operator verifies the success message is displayed on removing user to Hub : {string}")
  public void operatorVerifiesTheSuccessMessageIsDisplayedOnRemovingUserToHub(String userName) {
    stationUserManagementPage.validateRemoveUserSuccessMessageIsDisplayed(userName);
    takesScreenshot();
  }

  @And("Operator verifies {string} title is displayed")
  public void operatorVerifiesTitleIsDisplayed(String titleText) {
    stationUserManagementPage.validateStationUserManagementTitle(titleText);
  }

  @And("Operator verifies table is filtered {string} based on input in {string}")
  public void operatorVerifiesTableIsFilteredBasedOnInputIn(String filterBy, String filterValue) {
    stationUserManagementPage.validateFilter(filterBy, filterValue);
    takesScreenshot();
  }

  @Then("Operator searches by No of users with filter value {string}")
  public void operatorSearchesByNoOfUsersWithFilterValue(String filterValue) {
    stationUserManagementPage.searchNoOfUsers(filterValue);
    takesScreenshot();
  }

  @Then("Operator searches by {string}: {string} without refresh")
  public void operatorSearchesByWithoutRefresh(String filterBy, String filterValue) {
    stationUserManagementPage.filterValue(filterBy, filterValue);
  }

  @And("Operator removes user {string}  from the list of hub")
  public void operatorRemovesUserFromTheListOfHub(String userName) {
    stationUserManagementPage.removeUserFromHub(userName);
  }
}