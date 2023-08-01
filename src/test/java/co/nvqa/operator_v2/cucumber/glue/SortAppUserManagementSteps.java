package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.SortAppUser;
import co.nvqa.operator_v2.selenium.page.SortAppUserManagementPage;
import co.nvqa.operator_v2.util.KeyConstants;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.assertj.core.api.Assertions;

/**
 * @author Tristania Siagian
 */
public class SortAppUserManagementSteps extends AbstractSteps {

  private SortAppUserManagementPage sortAppUserManagementPage;

  public SortAppUserManagementSteps() {
  }

  @Override
  public void init() {
    sortAppUserManagementPage = new SortAppUserManagementPage(getWebDriver());
  }

  @When("Operator create new Sort App User with detailsV2:")
  public void operatorCreateNewSortAppUserV2(Map<String, String> data) {
    String firstName = data.get("firstName");
    String lastName = data.get("lastName");
    String contact = data.get("contact");
    String username = data.get("username");
    String password = data.get("password");
    String employmentType = data.get("employmentType");
    String primaryHub = data.get("primaryHub");
    String warehouseTeamFormation = data.get("warehouseTeamFormation");
    String position = data.get("position");
    String comments = data.get("comments");
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter calFormatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    sortAppUserManagementPage.clickAddSortAppUserButton();
    sortAppUserManagementPage.fillFirstName(firstName);
    sortAppUserManagementPage.fillLastName(lastName);
    sortAppUserManagementPage.fillContact(contact);
    sortAppUserManagementPage.fillUsername(username);
    sortAppUserManagementPage.fillPassword(password);
    sortAppUserManagementPage.selectEmploymentType(employmentType);
    sortAppUserManagementPage.selectEmploymentStartDate(calFormatter.format(today));
    sortAppUserManagementPage.selectPrimaryHubForSortAppUser(primaryHub);
    sortAppUserManagementPage.fillWareHouseTeamFormation(warehouseTeamFormation);
    sortAppUserManagementPage.fillPosition(position);
    sortAppUserManagementPage.fillComments(comments);
    sortAppUserManagementPage.switchTo();
    sortAppUserManagementPage.confirmButton.click();

  }

  @When("Operator create new Sort App User with details:")
  public void operatorCreateNewSortAppUser(List<SortAppUser> sortAppUsers) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter calFormatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    DateTimeFormatter dataFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    for (SortAppUser sortAppUser : sortAppUsers) {
      sortAppUserManagementPage.clickAddSortAppUserButton();
      sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
      sortAppUserManagementPage.fillLastName(sortAppUser.getLastName());
      sortAppUserManagementPage.fillContact(sortAppUser.getContact());

      if ("DUPLICATED".equalsIgnoreCase(sortAppUser.getUsername())) {
        sortAppUserManagementPage.fillUsername(get(KEY_EXISTED_SORT_APP_USERNAME));
        put(KeyConstants.KEY_IS_INVALID, true);
      } else if ("RANDOM".equalsIgnoreCase(sortAppUser.getUsername())) {
        String username = "AUTO" + StandardTestUtils.generateRequestedTrackingNumber();
        sortAppUser.setUsername(username);
        sortAppUserManagementPage.fillUsername(username);
        put(KeyConstants.KEY_IS_INVALID, false);
      }

      sortAppUserManagementPage.fillPassword(sortAppUser.getPassword());
      sortAppUserManagementPage.selectEmploymentType(sortAppUser.getEmploymentType());

      sortAppUser.setEmploymentStartDate(dataFormatter.format(today));
      sortAppUserManagementPage.selectEmploymentStartDate(calFormatter.format(today));

      sortAppUserManagementPage.selectPrimaryHubForSortAppUser(sortAppUser.getPrimaryHub());
      if (sortAppUser.getAdditionalHub() != null) {
        sortAppUserManagementPage.selectAdditionalHubForSortAppUser(sortAppUser.getAdditionalHub());
      }
      sortAppUserManagementPage.fillWareHouseTeamFormation(sortAppUser.getWarehouseTeamFormation());
      sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
      sortAppUserManagementPage.fillComments(sortAppUser.getComments());
      sortAppUserManagementPage.clickCreateEditHubUserButton(get(KeyConstants.KEY_IS_INVALID));
    }
    if (sortAppUsers.size() > 1) {
      for (SortAppUser sortAppUser : sortAppUsers) {
        put(KEY_LIST_OF_CREATED_SORT_APP_DETAILS, sortAppUser);
        put(KEY_LIST_OF_CREATED_SORT_APP_USERNAME, sortAppUser.getUsername());
      }
    } else {
      put(KEY_CREATED_SORT_APP_DETAILS, sortAppUsers);
      put(KEY_CREATED_SORT_APP_USERNAME, sortAppUsers.get(0).getUsername());
    }
  }

  @When("Operator create new Sort App User with negative scenarios using details:")
  public void operatorCreateNewSortAppUserNegativeScenario(List<SortAppUser> sortAppUsers) {
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter calFormatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    DateTimeFormatter dataFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    for (SortAppUser sortAppUser : sortAppUsers) {
      sortAppUserManagementPage.clickAddSortAppUserButton();
      sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
      sortAppUserManagementPage.fillLastName(sortAppUser.getLastName());
      sortAppUserManagementPage.fillContact(sortAppUser.getContact());

      if ("RANDOM".equalsIgnoreCase(sortAppUser.getUsername())) {
        sortAppUserManagementPage.fillUsername("AUTO" + StandardTestUtils.generateRequestedTrackingNumber());
      }

      sortAppUserManagementPage.fillPassword(sortAppUser.getPassword());
      sortAppUserManagementPage.selectEmploymentType(sortAppUser.getEmploymentType());

      if (!("".equalsIgnoreCase(sortAppUser.getEmploymentStartDate()))) {
        sortAppUser.setEmploymentStartDate(dataFormatter.format(today));
        sortAppUserManagementPage.selectEmploymentStartDate(calFormatter.format(today));
      }

      if (!("".equalsIgnoreCase(sortAppUser.getPrimaryHub()))) {
        sortAppUserManagementPage.selectPrimaryHubForSortAppUser(sortAppUser.getPrimaryHub());
      }

      sortAppUserManagementPage.fillWareHouseTeamFormation(sortAppUser.getWarehouseTeamFormation());
      sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
      sortAppUserManagementPage.fillComments(sortAppUser.getComments());
      sortAppUserManagementPage.clickCreateEditHubUserButton(true);
    }
  }

  @And("Operator Load all the Sort App User")
  public void operatorLoadAllTheSortAppUser() {
    navigateRefresh();
    pause2s();
    sortAppUserManagementPage.clickAllSortAppUser();
    sortAppUserManagementPage.loadingIcon.waitUntilInvisible();

  }

  @Then("Operator verifies that the newly created Sort App User will be shown")
  public void operatorVerifiesThatTheNewlyCreatedSortAppUserWillBeShown() {
    pause2s();
    if (get(KEY_LIST_OF_CREATED_SORT_APP_DETAILS) == null) {
      List<SortAppUser> sortAppUser = get(KEY_CREATED_SORT_APP_DETAILS);
      sortAppUserManagementPage.checkTheSortAppUserIsCreated(sortAppUser.get(0));
    } else {
      List<SortAppUser> sortAppUsersToList = get(KEY_LIST_OF_CREATED_SORT_APP_DETAILS);
      for (SortAppUser sortAppUser : sortAppUsersToList) {
        sortAppUserManagementPage.checkTheSortAppUserIsCreated(sortAppUser);
      }
    }
  }

  @Then("Operator verifies that there will be a duplication error toast shown")
  public void operatorVerifiesThatThereWillBeADuplicationErrorToastShown() {
    String existedUsername = get(KEY_EXISTED_SORT_APP_USERNAME);
    sortAppUserManagementPage.verifiesDuplicationErrorToastShown(existedUsername);
  }

  @Then("Operator verifies that there will be UI error of empty field of {string} shown")
  public void operatorVerifiesThatThereWillBeUIErrorOfEmptyFieldOfShown(String errorMessage) {
    sortAppUserManagementPage.emptyErrorMessage(errorMessage);
  }

  @When("Operator fills the {string} filter and select the value based on created Sort App User")
  public void operatorFillsTheFilterAndSelectTheValueBasedOnCreatedSortAppUser(String filterName) {
    List<SortAppUser> sortAppUser = get(KEY_CREATED_SORT_APP_DETAILS);
    sortAppUserManagementPage.selectFilter(filterName, sortAppUser.get(0));
  }

  @When("Operator fills the filter without creating Sort App User")
  public void operatorFillsTheFilterWithoutCreatingSortAppUser() {
    sortAppUserManagementPage.selectFilterWithoutCreatingSortAppUser();
  }

  @And("Operator clicks on the clear filter button on the Sort App User Management Page")
  public void operatorClicksOnTheClearFilterButtonOnTheSortAppUserManagementPage() {
    sortAppUserManagementPage.clickClearFilters();
  }

  @Then("Operator verifies that the filter is blank")
  public void operatorVerifiesThatTheFilterIsBlank() {
    sortAppUserManagementPage.verifiesUnselectedFilter();
  }

  @And("Operator edits the existed Sort App User with details:")
  public void operatorEditsTheExistedSortAppUserWithDetails(List<SortAppUser> sortAppUsers) {
    List<SortAppUser> existedSortAppUser = get(KEY_CREATED_SORT_APP_DETAILS);
    sortAppUsers.get(0).setUsername(existedSortAppUser.get(0).getUsername());
    sortAppUsers.get(0).setEmploymentStartDate(existedSortAppUser.get(0).getEmploymentStartDate());

    for (SortAppUser sortAppUser : sortAppUsers) {
      sortAppUserManagementPage.clickEditSortAppUser();

      pause1s();
      sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
      sortAppUserManagementPage.fillLastName(sortAppUser.getLastName());
      if (sortAppUser.getLastName() == null || "".equalsIgnoreCase(sortAppUser.getLastName())) {
        sortAppUser.setLastName(null);
      }
      sortAppUserManagementPage.fillContact(sortAppUser.getContact());
      sortAppUserManagementPage.fillPassword(sortAppUser.getPassword());

      sortAppUserManagementPage.selectEmploymentType(sortAppUser.getEmploymentType());
      sortAppUserManagementPage.selectEmploymentActivity(sortAppUser.getEmploymentStatus());

      sortAppUserManagementPage.selectPrimaryHubForSortAppUser(sortAppUser.getPrimaryHub());
      sortAppUserManagementPage.fillWareHouseTeamFormation(sortAppUser.getWarehouseTeamFormation());
      sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
      sortAppUserManagementPage.fillComments(sortAppUser.getComments());
      sortAppUserManagementPage.clickCreateEditHubUserButton(true, true);
    }
    if (sortAppUsers.size() > 1) {
      for (SortAppUser sortAppUser : sortAppUsers) {
        put(KEY_LIST_OF_CREATED_SORT_APP_DETAILS, sortAppUser);
      }
    } else {
      put(KEY_CREATED_SORT_APP_DETAILS, sortAppUsers);
    }
  }

  @And("Operator edits the existed Sort App User with negative scenario using details:")
  public void operatorEditsTheExistedSortAppUserWithNegativeScenarioUsingDetails(
      List<SortAppUser> sortAppUsers) {
    for (SortAppUser sortAppUser : sortAppUsers) {
      sortAppUserManagementPage.clickEditSortAppUser();

      pause1s();
      sortAppUserManagementPage.fillFirstName(sortAppUser.getFirstName());
      sortAppUserManagementPage.fillPosition(sortAppUser.getPosition());
    }
  }

  @When("Operator search sort app user by {string} with {string}")
  public void operatorSearchSortAppUserByWith(String searchBar, String value) {
    sortAppUserManagementPage.waitUntilPageLoaded();
    sortAppUserManagementPage.switchTo();
    String xpath = "(//input[@class='ant-input'])[1]";
    switch (searchBar) {

      case "User ID":
        xpath = "(//input[@class='ant-input'])[1]";
        sortAppUserManagementPage.findElementByXpath(xpath).sendKeys(value);
        break;
      case "Hub":
        xpath = "(//input[@class='ant-input'])[2]";
        sortAppUserManagementPage.findElementByXpath(xpath).sendKeys(value);
        break;
      case "Position":
        xpath = "(//input[@class='ant-input'])[3]";
        sortAppUserManagementPage.findElementByXpath(xpath).sendKeys(value);
        break;
      case "Employment Type":
        xpath = "(//input[@class='ant-input'])[4]";
        sortAppUserManagementPage.findElementByXpath(xpath).sendKeys(value);
        break;
      case "First Name":
        xpath = "(//input[@class='ant-input'])[5]";
        sortAppUserManagementPage.findElementByXpath(xpath).sendKeys(value);
        break;
      case "Last Name":
        xpath = "(//input[@class='ant-input'])[6]";
        sortAppUserManagementPage.findElementByXpath(xpath).sendKeys(value);
        break;
      default:
        // code block
    }
  }

  @When("Operator edit the top searched user with data below:")
  public void operatorEditTheTopSearchedUserWithDataBelow(Map<String, String> data) {
    String firstName = data.get("firstName");
    String lastName = data.get("lastName");
    String contact = data.get("contact");
    String employmentType = data.get("employmentType");
    String primaryHub = data.get("primaryHub");
    String warehouseTeamFormation = data.get("warehouseTeamFormation");
    String position = data.get("position");
    LocalDateTime today = LocalDateTime.now();
    DateTimeFormatter calFormatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    sortAppUserManagementPage.editButton.click();
    sortAppUserManagementPage.fillEdit("contact", contact);
    sortAppUserManagementPage.fillEdit("first-name", firstName);
    sortAppUserManagementPage.fillEdit("last-name", lastName);
    sortAppUserManagementPage.fillEdit("position", position);
    sortAppUserManagementPage.confirmButton.click();
//    sortAppUserManagementPage.confirmButton.click();
  }

  @Then("Make sure {string} notification pop up with {string}")
  public void makeSureNotificationPopUpWith(String notifTitle, String notifDescription) {
    sortAppUserManagementPage.waitUntilNoticeMessage(notifTitle);
    Assertions.assertThat(sortAppUserManagementPage.notifTitle.getText()).as("Notification Title Match")
        .containsIgnoringCase(notifTitle);
    Assertions.assertThat(sortAppUserManagementPage.notifDescription.getText()).as("Notification Description Match")
        .containsIgnoringCase(notifDescription);
  }
}
