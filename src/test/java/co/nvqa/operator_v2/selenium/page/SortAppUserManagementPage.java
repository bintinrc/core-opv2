package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.SortAppUser;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

/**
 * @author Tristania Siagian
 */
public class SortAppUserManagementPage extends OperatorV2SimplePage {

  private static final String ADD_SORT_USER_BUTTON_XPATH = "//button[@id='btnAddUser']";
  private static final String FILTER_XPATH = "//div[@id='%s']";
  private static final String EMPLOYMENT_START_DATE_FILTER_XPATH = "//span[@id='employmentStartDate']";
  private static final String START_DATE_INPUT_XPATH = "//div[contains(@class,'calendar-range-left')]//td[@title='%s']";
  private static final String ACTIVE_EMPLOYMENT_FILTER_XPATH = "//li[text()='ACTIVE']";
  private static final String INACTIVE_EMPLOYMENT_FILTER_XPATH = "//li[text()='INACTIVE']";
  private static final String UNSELECTABLE_FILTER = "//div[@id='%s']//span[@unselectable='on']";

  private static final String ADD_EDIT_SORT_USER_DIALOG_XPATH = "//div[contains(@id,'rcDialogTitle')]";
  private static final String EMPLOYMENT_TYPE_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='employmentType']";
  private static final String FULL_TIME_EMPLOYMENT_TYPE_XPATH = "//li[text()='FULL_TIME']";
  private static final String PART_TIME_EMPLOYMENT_TYPE_XPATH = "//li[text()='PART_TIME']";
  private static final String PRIMARY_HUB_SELECTION_XPATH = "(//li[text()='%s'])[1]";
  private static final String ADDITIONAL_HUB_SELECTION_XPATH = "(//li[text()='%s'])[2]";
  private static final String EMPLOYMENT_START_DATE_XPATH = "//div[contains(@class,'ant-card-bordered')]//span[@id='employmentStartDate']";
  private static final String RECENT_MONTH_XPATH = "//a[contains(@class,'month-select')]";
  private static final String PRIMARY_HUB_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='hubId']";
  private static final String ADDITIONAL_HUB_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='additionalHubs[0]']";
  private static final String CREATE_UPDATE_BUTTON_ADD_HUB_DIALOG_XPATH = "//div[@class='ant-modal-footer']//button[contains(@class,'ant-btn-primary')]";
  private static final String CLOSE_BUTTON_MODAL_XPATH = "//button[@aria-label='Close']";
  private static final String EDIT_LINK_TEXT_XPATH = "//a[contains(@class, 'edit-user')]";
  private static final String STATUS_COMBOBOX_XPATH = "//form[contains(@class,'StyledForm')]//div[@id='isActive']";

  private static final String CLEAR_FILTERS_BUTTON_XPATH = "//button[span[text()='Clear Filters']]";
  private static final String IFRAME_XPATH = "//iframe[contains(@src,'sort-app-user-management')]";
  private static final String LOAD_ALL_SORT_APP_USER_BUTTON_XPATH = "//button[span[text()='Load Users']]";
  private static final String USERNAME_TABLE_FILTER_XPATH = "//th[contains(@class,'username')]//input";
  private static final String TABLE_RESULT_XPATH = "//td[contains(@class,'%s')]/span/%s";
  private static final String TOAST_SORT_APP_USER_CREATED_XPATH = "//div[contains(@class,'notification-notice-content')]//div[contains(text(),'Sort App User has been created')]";
  private static final String TOAST_SORT_APP_USER_UPDATED_XPATH = "//div[contains(@class,'notification-notice-content')]//div[contains(text(),'Sort App User has been updated')]";
  private static final String ERROR_TOAST_DUPLICATION_USERNAME_XPATH = "//div[contains(@class,'notification-notice-message') and (contains(text(),'username %s already exists'))]";
  private static final String ERROR_TOAST_DUPLICATION_CLOSE_XPATH = "//a[contains(@class,'notification-notice-close')]";
  private static final String ERROR_MESSAGE_EMPTY_FIELD_XPATH = "//div[@class='ant-form-explain']/span[text()='%s']";
  private static final String TEST_CALENDAR = "//td[@title='%s']/div";

  private static final String FIRST_NAME_ID = "firstName";
  private static final String LAST_NAME_ID = "lastName";
  private static final String CONTACT_DETAIL_ID = "contactDetails";
  private static final String USERNAME_ID = "username";
  private static final String PASSWORD_ID = "password";
  private static final String WAREHOUSE_TEAM_FORMATION_ID = "team";
  private static final String POSITION_ID = "position";
  private static final String COMMENT_ID = "comment";
  private static final String STATUS_ID = "isActive";

  private static final String USERNAME_CLASS = "username";
  private static final String HUB_CLASS = "hubId";
  private static final String POSITION_CLASS = "position";
  private static final String EMPLOYMENT_TYPE_CLASS = "employmentType";
  private static final String FIRST_NAME_CLASS = "firstName";
  private static final String LAST_NAME_CLASS = "lastName";
  private static final String EMPLOYMENT_START_DATE_CLASS = "employmentStartDate";

  public SortAppUserManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddSortAppUserButton() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    waitUntilVisibilityOfElementLocated(LOAD_ALL_SORT_APP_USER_BUTTON_XPATH);
    click(ADD_SORT_USER_BUTTON_XPATH);
    waitUntilVisibilityOfElementLocated(ADD_EDIT_SORT_USER_DIALOG_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void fillFirstName(String firstName) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (firstName == null || "".equalsIgnoreCase(firstName)) {
      sendKeysById(FIRST_NAME_ID, "a");
      findElementByXpath(f("//input[@id='%s']", FIRST_NAME_ID)).sendKeys(Keys.BACK_SPACE);
    } else {
      sendKeysById(FIRST_NAME_ID, firstName);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void fillLastName(String lastName) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (lastName == null || "".equalsIgnoreCase(lastName)) {
      sendKeysById(LAST_NAME_ID, "a");
      findElementByXpath(f("//input[@id='%s']", LAST_NAME_ID)).sendKeys(Keys.BACK_SPACE);
    } else {
      sendKeysById(LAST_NAME_ID, lastName);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void fillContact(String contact) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (contact == null || "".equalsIgnoreCase(contact)) {
      sendKeysById(CONTACT_DETAIL_ID, "a");
      findElementByXpath(f("//input[@id='%s']", CONTACT_DETAIL_ID)).sendKeys(Keys.BACK_SPACE);
    } else {
      sendKeysById(CONTACT_DETAIL_ID, contact);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void fillUsername(String username) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    sendKeysById(USERNAME_ID, username);
    getWebDriver().switchTo().parentFrame();
  }

  public void fillPassword(String password) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    sendKeysById(PASSWORD_ID, password);
    getWebDriver().switchTo().parentFrame();
  }

  public void selectEmploymentType(String employmentType) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(EMPLOYMENT_TYPE_COMBOBOX_XPATH);
    if ("FULL_TIME".equalsIgnoreCase(employmentType)) {
      waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
      click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
    } else if ("PART_TIME".equalsIgnoreCase(employmentType)) {
      waitUntilVisibilityOfElementLocated(PART_TIME_EMPLOYMENT_TYPE_XPATH);
      click(PART_TIME_EMPLOYMENT_TYPE_XPATH);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void selectEmploymentStartDate(String startDate) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(EMPLOYMENT_START_DATE_XPATH);
    waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
    click(f(TEST_CALENDAR, startDate));
//        sendKeys(RECENT_MONTH_XPATH, startDate);
//        sendKeys(RECENT_MONTH_XPATH, Keys.ENTER);
    getWebDriver().switchTo().parentFrame();
  }

  public void selectEmploymentActivity(String employmentActivity) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(STATUS_COMBOBOX_XPATH);
    if ("ACTIVE".equalsIgnoreCase(employmentActivity)) {
      waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
      click(ACTIVE_EMPLOYMENT_FILTER_XPATH);
    } else if ("INACTIVE".equalsIgnoreCase(employmentActivity)) {
      waitUntilVisibilityOfElementLocated(INACTIVE_EMPLOYMENT_FILTER_XPATH);
      click(INACTIVE_EMPLOYMENT_FILTER_XPATH);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void selectPrimaryHubForSortAppUser(String hubName) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(PRIMARY_HUB_COMBOBOX_XPATH);
    waitUntilVisibilityOfElementLocated(f(PRIMARY_HUB_SELECTION_XPATH, hubName));
    pause1s();
    click(f(PRIMARY_HUB_SELECTION_XPATH, hubName));
    getWebDriver().switchTo().parentFrame();
  }

  public void selectAdditionalHubForSortAppUser(String hubName) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(ADDITIONAL_HUB_COMBOBOX_XPATH);
    waitUntilVisibilityOfElementLocated(f(ADDITIONAL_HUB_SELECTION_XPATH, hubName));
    pause1s();
    click(f(ADDITIONAL_HUB_SELECTION_XPATH, hubName));
    getWebDriver().switchTo().parentFrame();
  }

  public void fillWareHouseTeamFormation(String warehouseTeamFormation) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (warehouseTeamFormation == null || "".equalsIgnoreCase(warehouseTeamFormation)) {
      sendKeysById(WAREHOUSE_TEAM_FORMATION_ID, "a");
      findElementByXpath(f("//input[@id='%s']", WAREHOUSE_TEAM_FORMATION_ID))
          .sendKeys(Keys.BACK_SPACE);
    } else {
      sendKeysById(WAREHOUSE_TEAM_FORMATION_ID, warehouseTeamFormation);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void fillPosition(String position) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (position == null || "".equalsIgnoreCase(position)) {
      sendKeysById(POSITION_ID, "a");
      findElementByXpath(f("//input[@id='%s']", POSITION_ID)).sendKeys(Keys.BACK_SPACE);
    } else {
      sendKeysById(POSITION_ID, position);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void fillComments(String comments) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (comments == null || "".equalsIgnoreCase(comments)) {
      sendKeysById(COMMENT_ID, "a");
      findElementByXpath(f("//input[@id='%s']", COMMENT_ID)).sendKeys(Keys.BACK_SPACE);
    } else {
      sendKeysById(COMMENT_ID, comments);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void clickCreateEditHubUserButton(boolean isInvalid, boolean isUpdated) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(CREATE_UPDATE_BUTTON_ADD_HUB_DIALOG_XPATH);
    waitUntilInvisibilityOfElementLocated("//md-dialog");
    if (isUpdated) {
      waitUntilVisibilityOfElementLocated(TOAST_SORT_APP_USER_UPDATED_XPATH);
      waitUntilInvisibilityOfElementLocated(TOAST_SORT_APP_USER_UPDATED_XPATH);
    }
    if (!isInvalid) {
      waitUntilVisibilityOfElementLocated(TOAST_SORT_APP_USER_CREATED_XPATH);
      waitUntilInvisibilityOfElementLocated(TOAST_SORT_APP_USER_CREATED_XPATH);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void clickCreateEditHubUserButton(boolean isInvalid) {
    clickCreateEditHubUserButton(isInvalid, false);
  }

  public void clickAllSortAppUser() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(LOAD_ALL_SORT_APP_USER_BUTTON_XPATH);
    waitUntilVisibilityOfElementLocated("//tbody//td[@class='hubId']");
    getWebDriver().switchTo().parentFrame();
  }

  public void clickClearFilters() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(CLEAR_FILTERS_BUTTON_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void selectFilter(String filterName, SortAppUser sortAppUser) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

    switch (filterName) {
      case "hub":
        click(f(FILTER_XPATH, HUB_CLASS));
        waitUntilVisibilityOfElementLocated(
            f(PRIMARY_HUB_SELECTION_XPATH, sortAppUser.getPrimaryHub()));
        click(f(PRIMARY_HUB_SELECTION_XPATH, sortAppUser.getPrimaryHub()));
        break;

      case "employment type":
        click(f(FILTER_XPATH, EMPLOYMENT_TYPE_CLASS));
        waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
        click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
        break;

      case "employment start date":
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);

        click(EMPLOYMENT_START_DATE_FILTER_XPATH);
        waitUntilVisibilityOfElementLocated(f(START_DATE_INPUT_XPATH, formatter.format(today)));
        click(f(START_DATE_INPUT_XPATH, formatter.format(today)));
        click(f(START_DATE_INPUT_XPATH, formatter.format(today)));
        break;

      case "status":
        click(f(FILTER_XPATH, STATUS_ID));
        waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
        click(ACTIVE_EMPLOYMENT_FILTER_XPATH);
        break;

      case "multiple":
        click(f(FILTER_XPATH, HUB_CLASS));
        waitUntilVisibilityOfElementLocated(
            f(PRIMARY_HUB_SELECTION_XPATH, sortAppUser.getPrimaryHub()));
        click(f(PRIMARY_HUB_SELECTION_XPATH, sortAppUser.getPrimaryHub()));

        pause1s();
        click(f(FILTER_XPATH, EMPLOYMENT_TYPE_CLASS));
        waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
        click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);

        pause1s();
        click(f(FILTER_XPATH, STATUS_ID));
        waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
        click(ACTIVE_EMPLOYMENT_FILTER_XPATH);
        break;
    }

    getWebDriver().switchTo().parentFrame();
  }

  public void selectFilterWithoutCreatingSortAppUser() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

    pause1s();
    click(f(FILTER_XPATH, EMPLOYMENT_TYPE_CLASS));
    waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
    click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);

    pause1s();
    click(f(FILTER_XPATH, STATUS_ID));
    waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
    click(ACTIVE_EMPLOYMENT_FILTER_XPATH);

    getWebDriver().switchTo().parentFrame();
  }

  public void verifiesDuplicationErrorToastShown(String existedUsername) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    waitUntilVisibilityOfElementLocated(ERROR_TOAST_DUPLICATION_USERNAME_XPATH, existedUsername);
    getWebDriver().switchTo().parentFrame();
  }

  public void emptyErrorMessage(String errorMessage) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    waitUntilVisibilityOfElementLocated(f(ERROR_MESSAGE_EMPTY_FIELD_XPATH, errorMessage));
    click(CLOSE_BUTTON_MODAL_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void checkTheSortAppUserIsCreated(SortAppUser sortAppUser) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    sendKeys(USERNAME_TABLE_FILTER_XPATH, sortAppUser.getUsername());
    waitUntilVisibilityOfElementLocated(f(TABLE_RESULT_XPATH, USERNAME_CLASS, "mark"));

    String actualUsernameShown = getText(f(TABLE_RESULT_XPATH, USERNAME_CLASS, "mark"));
    assertEquals("Username is different : ", sortAppUser.getUsername(), actualUsernameShown);

    String actualPrimaryHubShown = getText(f(TABLE_RESULT_XPATH, HUB_CLASS, "span"));
    assertEquals("Primary Hub is different : ", sortAppUser.getPrimaryHub(), actualPrimaryHubShown);

    String actualPositionShown = getText(f(TABLE_RESULT_XPATH, POSITION_CLASS, "span"));
    assertEquals("Position is different : ", sortAppUser.getPosition(), actualPositionShown);

    String actualEmploymentTypeShown = getText(
        f(TABLE_RESULT_XPATH, EMPLOYMENT_TYPE_CLASS, "span"));
    assertEquals("Employment Type is different : ", sortAppUser.getEmploymentType(),
        actualEmploymentTypeShown);

    String actualFirstNameShown = getText(f(TABLE_RESULT_XPATH, FIRST_NAME_CLASS, "span"));
    assertEquals("First Name is different : ", sortAppUser.getFirstName(), actualFirstNameShown);

    String actualLastNameShown = getText(f(TABLE_RESULT_XPATH, LAST_NAME_CLASS, "span"));
    assertEquals("Last Name is different : ", sortAppUser.getLastName(), actualLastNameShown);

    String actualEmploymentStartDateShown = getText(
        f(TABLE_RESULT_XPATH, EMPLOYMENT_START_DATE_CLASS, "span"));
    assertEquals("Employment Start Date is different : ", sortAppUser.getEmploymentStartDate(),
        actualEmploymentStartDateShown);

    getWebDriver().switchTo().parentFrame();
  }

  public void verifiesUnselectedFilter() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    isElementExistFast(f(UNSELECTABLE_FILTER, HUB_CLASS));
    isElementExistFast(f(UNSELECTABLE_FILTER, EMPLOYMENT_TYPE_CLASS));
    isElementExistFast(f(UNSELECTABLE_FILTER, STATUS_ID));
    getWebDriver().switchTo().parentFrame();
  }

  public void clickEditSortAppUser() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(EDIT_LINK_TEXT_XPATH);
    waitUntilVisibilityOfElementLocated(ADD_EDIT_SORT_USER_DIALOG_XPATH);
    getWebDriver().switchTo().parentFrame();
  }
}
