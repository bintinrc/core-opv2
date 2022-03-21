package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sathish
 */


@SuppressWarnings("WeakerAccess")
public class StationUserManagementPage extends OperatorV2SimplePage {

  private static final String STATION_HOME_URL_PATH = "/station-homepage";
  private static final String STATION_HUB_URL_PATH = "/station-homepage/hubs/%s";

  private static final String MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH = "//*[contains(text(),'%s')]/ancestor::div//div[text()='%s']/parent::div[@class='th']//input";
  private static final String ERROR_MESSAGE = "//*[contains(text(),'Could not add user due to duplicate entry or other unknown error for %s!')]";
  private static final String ADD_USER_SUCCESS_MESSAGE = "//*[contains(text(),'Successfully added user for %s!')]";
  private static final String REMOVE_USER_SUCCESS_MESSAGE = "//*[contains(text(),'Successfully removed user %s!')]";
  private static final String FILTER_RESULT_IN_LIST_OF_USERS = "//div[@data-datakey='email']//mark[contains(text(),'%s')]";
  private static final String STATION_USER_MANAGEMENT_PAGE_TITLE = "//h4[text()='%s']";
  private static final String TABLE_FIRST_ROW_VALUE_BY_COLUMN = "//div[@class='BaseTable__row base-row'][1]//div[@data-datakey='%s']";

  public StationUserManagementPage(WebDriver webDriver) {
    super(webDriver);
  }


  @FindAll(@FindBy(xpath = "//div[starts-with(@class,'th')]/*[1]"))
  private List<PageElement> columnNames;

  @FindBy(css = "div[class*='selected-value']")
  private PageElement headerHubValue;

  @FindBy(xpath = "//span[contains(text(),'View Users')]")
  private PageElement viewUsersButton;

  @FindBy(xpath = "//*[contains(text(),'Email')]/ancestor::div//div[text()='Email']/parent::div[@class='th']//input")
  private PageElement searchEmailTextBox;

  @FindBy(xpath = "//*[contains(text(),'Add User')]")
  private PageElement addUserButton;

  @FindBy(xpath = "//input[@placeholder='Enter Email Address']")
  private PageElement enterEmailAddress;

  @FindBy(xpath = "//*[contains(text(),'Confirm User')]/ancestor::button")
  private PageElement confirmUserButton;

  @FindAll(@FindBy(xpath = "//*[contains(text(),'Remove user')]/ancestor::button"))
  private List<PageElement> removeUserButton;

  @FindBy(xpath = "//*[contains(text(),'Back to List of Users')]/ancestor::button")
  private PageElement backToListOfUsersButton;

  @FindBy(xpath = "//div[@data-datakey='hubId']//span[@class]")
  private PageElement hubID;

  @FindBy(xpath = "//div[@data-datakey='count']//span[@class]")
  private PageElement noOfUsers;

  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;

  @FindBy(xpath = "//div[@class='BaseTable__row base-row'][1]")
  private List<PageElement> firstRowOfTable;

  @FindBy(xpath = "//*[contains(text(),'No. of users')]/ancestor::div//div[text()='No. of users']/following-sibling::span//input")
  private PageElement noOfUsersFilter;


  public void validateStationUserManagementTitle(String pageTitle) {
    switchToStationUserManagementFrame();
    String pageTitleXpath = f(STATION_USER_MANAGEMENT_PAGE_TITLE, pageTitle);
    Assert.assertTrue("Overview of Stations page title is not displayed",
        getWebDriver().findElement(By.xpath(pageTitleXpath)).isDisplayed());
  }

  public void switchToStationUserManagementFrame() {
    refreshPage_v1();
    pause10s();
    waitWhilePageIsLoading();
    if (pageFrame.size() > 0) {
      WebElement frame = pageFrame.get(0).getWebElement();
      waitUntilVisibilityOfElementLocated(frame, 15);
      getWebDriver().switchTo().frame(frame);
    }
  }

  public void enterEmail(String userName) {
    enterEmailAddress.clear();
    enterEmailAddress.sendKeys(userName);
  }

  public void clickAddUserButton() {
    waitUntilVisibilityOfElementLocated(addUserButton.getWebElement());
    addUserButton.click();
  }

  public void filterValue(String filterName, String filterValue) {

    String stationNameSearchXpath = f(MODAL_TABLE_SEARCH_BY_TABLE_NAME_XPATH, filterName,
        filterName);
    WebElement searchBox = getWebDriver().findElement(By.xpath(stationNameSearchXpath));
    waitUntilVisibilityOfElementLocated(searchBox);
    searchBox.clear();
    searchBox.sendKeys(filterValue);
  }

  public void searchBy(String filterCriteria, String filterValue) {
    switchToStationUserManagementFrame();
    filterValue(filterCriteria, filterValue);
  }

  public void clickViewUsersButton() {
    waitUntilVisibilityOfElementLocated(viewUsersButton.getWebElement());
    viewUsersButton.click();
  }

  public void addUserToHub(String userName) {
    removeUserFromHub(userName);
    clickAddUserButton();
    waitUntilVisibilityOfElementLocated(enterEmailAddress.getWebElement());
    enterEmail(userName);
    pause2s();
    confirmUserButton.click();
  }

  public void searchEmail(String userName) {
    waitUntilVisibilityOfElementLocated(searchEmailTextBox.getWebElement());
    searchEmailTextBox.click();
    searchEmailTextBox.sendKeys(Keys.chord(Keys.CONTROL, "a"));
    searchEmailTextBox.sendKeys(Keys.BACK_SPACE);
    searchEmailTextBox.sendKeys(userName);
  }

  public void validateUserInList(String userName) {
    pause3s();
    searchEmail(userName);
    String addedUserXpath = f(FILTER_RESULT_IN_LIST_OF_USERS, userName);
    Assert.assertTrue("Added user is available in the list of Users",
        getWebDriver().findElement(By.xpath(addedUserXpath)).isDisplayed());
  }

  public void
  removeUserFromHub(String userName) {
    searchEmailTextBox.sendKeys(userName);
    if (removeUserButton.size() > 0) {
      pause2s();
      removeUserButton.get(0).click();
      pause2s();
      removeUserButton.get(1).click();
    }
  }

  public void validateConfirmUserButtonIsDisabled() {
    waitWhilePageIsLoading();
    Assert.assertTrue("Assert that the Confirm User button is disabled",
        !confirmUserButton.isEnabled());
  }

  public void validateErrorMessageIsDisplayed(String hubName) {
    String errorMessageXpath = f(ERROR_MESSAGE, hubName);
    Assert.assertTrue("Error Message is not displayed",
        getWebDriver().findElement(By.xpath(errorMessageXpath)).isDisplayed());
  }

  public void validateAddUserSuccessMessage(String hubName) {
    String addUserSuccessMessageXpath = f(ADD_USER_SUCCESS_MESSAGE, hubName);
    Assert.assertTrue("Add User Success Message is not displayed",
        getWebDriver().findElement(By.xpath(addUserSuccessMessageXpath)).isDisplayed());
  }

  public void validateRemoveUserSuccessMessageIsDisplayed(String userName) {
    String removeUserSuccessMessageXpath = f(REMOVE_USER_SUCCESS_MESSAGE, userName);
    Assert.assertTrue("Remove User Success Message is not displayed",
        getWebDriver().findElement(By.xpath(removeUserSuccessMessageXpath)).isDisplayed());
  }

  public void validateFilter(String columnName, String expectedValue) {
    String valueXpath = f(TABLE_FIRST_ROW_VALUE_BY_COLUMN, columnName);
    Assert.assertTrue("Table values are not Filtered",
        getWebDriver().findElement(By.xpath(valueXpath)).getText().equalsIgnoreCase(expectedValue));
  }

  public void searchNoOfUsers(String filterValue) {
    switchToStationUserManagementFrame();
    pause10s();
    noOfUsersFilter.click();
    noOfUsersFilter.sendKeys(filterValue);
  }

}
