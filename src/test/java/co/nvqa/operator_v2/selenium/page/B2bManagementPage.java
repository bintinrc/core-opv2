package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;

/**
 * @author Lanang Jati
 */
public class B2bManagementPage extends OperatorV2SimplePage {

  private final B2bShipperTable masterShipperTable;
  private final B2bShipperTable subShipperTable;

  private static final String LAST_URL_PATH = "/b2b-management";
  private static final String IFRAME_XPATH = "//iframe[contains(@src,'b2b-management')]";
  private static final String ADD_SUB_SHIPPER_BUTTON_XPATH = "//button[descendant::*[text()='Add Sub-shipper']]";
  private static final String CREATE_SUB_SHIPPER_BUTTON_XPATH = "//button[descendant::*[text()='Create Sub-shipper Account(s)']]";
  private static final String PREV_PAGE_XPATH = "//li[contains(@class,'ant-pagination-prev')]";
  private static final String NEXT_PAGE_XPATH = "//li[contains(@class,'ant-pagination-next')]";
  private static final String BRANCH_ID_ID = "branchId";
  private static final String NAME_ID = "name";
  private static final String EMAIL_ID = "email";
  private static final String ERROR_MSG_CREATE_SUB_SHIPPER_XPATH = "//div[contains(@class,'ant-form-item-control')]//div[contains(@class,'ant-form-explain')]";
  public static final String ID_COLUMN_MASTER_SHIPPER_LOCATOR_KEY = "id";
  public static final String ID_COLUMN_SUB_SHIPPER_LOCATOR_KEY = "externalRef";
  public static final String NAME_COLUMN_LOCATOR_KEY = "name";
  public static final String EMAIL_COLUMN_LOCATOR_KEY = "email";
  public static final int MASTER_SHIPPER_VIEW_SUB_SHIPPER_ACTION_BUTTON_INDEX = 3;
  public static final int SUB_SHIPPER_EDIT_ACTION_BUTTON_INDEX = 2;
  public static final String XPATH_SUB_SHIPPER_BACK = "//*[@class='ant-page-header-back-icon']";

  public B2bManagementPage(WebDriver webDriver) {
    super(webDriver);
    masterShipperTable = new B2bShipperTable(webDriver);
    subShipperTable = new B2bShipperTable(webDriver, ID_COLUMN_SUB_SHIPPER_LOCATOR_KEY,
        NAME_COLUMN_LOCATOR_KEY, EMAIL_COLUMN_LOCATOR_KEY);
  }

  public void onDisplay() {
    super.waitUntilPageLoaded();
    getWebDriver().switchTo().parentFrame();
    assertTrue(getWebDriver().getCurrentUrl().endsWith(LAST_URL_PATH));
    assertTrue(isElementExist(IFRAME_XPATH));
    getWebDriver().switchTo().parentFrame();
  }

  public B2bShipperTable getMasterShipperTable() {
    return masterShipperTable;
  }

  public B2bShipperTable getSubShipperTable() {
    return subShipperTable;
  }

  public void clickAddSubShipperButton() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(ADD_SUB_SHIPPER_BUTTON_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void clickCreateSubShipperButton() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(CREATE_SUB_SHIPPER_BUTTON_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void fillBranchId(String branchId) {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    sendKeysById(BRANCH_ID_ID, branchId);
    getWebDriver().switchTo().parentFrame();
  }

  public void fillName(String name) {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    sendKeysById(NAME_ID, name);
    getWebDriver().switchTo().parentFrame();
  }

  public void fillEmail(String email) {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    sendKeysById(EMAIL_ID, email);
    getWebDriver().switchTo().parentFrame();
  }

  public boolean isPrevPageButtonDisable() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    boolean disabled = findElementByXpath(PREV_PAGE_XPATH).getAttribute("class")
        .contains("disabled");
    getWebDriver().switchTo().parentFrame();
    return disabled;
  }

  public boolean isNextPageButtonDisable() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    boolean disabled = findElementByXpath(NEXT_PAGE_XPATH).getAttribute("class")
        .contains("disabled");
    getWebDriver().switchTo().parentFrame();
    return disabled;
  }

  public void clickPrevPageButton() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(PREV_PAGE_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void clickNextPageButton() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(NEXT_PAGE_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void backToSubShipperTable() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    if (isElementExistFast(XPATH_SUB_SHIPPER_BACK)) {
      click(XPATH_SUB_SHIPPER_BACK);
    }
    getWebDriver().switchTo().parentFrame();
  }

  public void goToFirstPage() {
    while (!isPrevPageButtonDisable()) {
      clickPrevPageButton();
    }
  }

  public void shipperDetailsDisplayed(String shipperName) {
    switchToNewWindow();
    String actualShipperName = getInputValueById("shipper-name");

    assertEquals("Check corporate sub shipper", shipperName, actualShipperName);
  }

  public String getErrorMessage() {
    getWebDriver().switchTo().parentFrame();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    String errorMsg = findElementByXpath(ERROR_MSG_CREATE_SUB_SHIPPER_XPATH).getText();
    getWebDriver().switchTo().parentFrame();
    return errorMsg;
  }

  public static class B2bShipperTable extends AntTable<Shipper> {

    private static final String NAME_SEARCH_XPATH = "//th[contains(@class, 'name')]//input";
    private static final String EMAIL_SEARCH_XPATH = "//th[contains(@class, 'email')]//input";
    private static final String ROWS_XPATH = "//tbody/tr";
    private static final String ACTION_BUTTON_BY_COLUMN_VALUE_XPATH = "//tr[td[contains(@class,'%s') and descendant::*[contains(text(),'%s')]]]//button[%d]";


    public B2bShipperTable(WebDriver webDriver) {
      this(webDriver, ID_COLUMN_MASTER_SHIPPER_LOCATOR_KEY, NAME_COLUMN_LOCATOR_KEY,
          EMAIL_COLUMN_LOCATOR_KEY);
    }

    public B2bShipperTable(WebDriver webDriver, String idLocator, String nameLocator,
        String emailLocator) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(idLocator, "id")
          .put(nameLocator, "name")
          .put(emailLocator, "email")
          .build()
      );
      setEntityClass(Shipper.class);
    }

    @Override
    public int getRowsCount() {
      getWebDriver().switchTo().parentFrame();
      getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
      int rowCount = getElementsCount(ROWS_XPATH);
      getWebDriver().switchTo().parentFrame();
      return rowCount;
    }

    @Override
    protected String getTextOnTable(int rowNumber, String columnDataClass) {
      String text;
      getWebDriver().switchTo().parentFrame();
      getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
      String xpath = f(".//tr[%d]/td[contains(@class,'%s')]", rowNumber, columnDataClass);
      text = findElementByXpath(xpath).getText();
      getWebDriver().switchTo().parentFrame();
      return text;
    }

    public void clickActionButton(String columnLocatorKey, String value, int actionButtonIndex) {
      String columnLocator = columnLocators.get(columnLocatorKey);
      String xpath = f(ACTION_BUTTON_BY_COLUMN_VALUE_XPATH, columnLocator, value,
          actionButtonIndex);
      getWebDriver().switchTo().parentFrame();
      getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
      click(xpath);
      getWebDriver().switchTo().parentFrame();
    }

    public void searchByName(String searchValue) {
      getWebDriver().switchTo().parentFrame();
      getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
      doubleClick(NAME_SEARCH_XPATH);
      sendKeys(NAME_SEARCH_XPATH, searchValue);
      getWebDriver().switchTo().parentFrame();
    }

    public void searchByEmail(String searchValue) {
      getWebDriver().switchTo().parentFrame();
      getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
      doubleClick(EMAIL_SEARCH_XPATH);
      sendKeys(EMAIL_SEARCH_XPATH, searchValue);
      getWebDriver().switchTo().parentFrame();
    }
  }
}
