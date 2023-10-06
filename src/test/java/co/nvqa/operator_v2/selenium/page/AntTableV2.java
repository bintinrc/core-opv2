package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.AntTextBox;
import com.google.common.base.Preconditions;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class AntTableV2<T extends DataEntity<?>> extends AbstractTable<T> {

  private static final String CELL_LOCATOR_PATTERN = "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='%s']";
  private static final String ACTION_BUTTON_LOCATOR_PATTERN = "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='id']//button[@data-pa-label='%s']";
  private static final String COLUMN_TEXT_FILTER_LOCATOR_PATTERN = "//div[@role='gridcell'][@data-key='%s']//span[./input[@type='text']]";
  private static final String COLUMN_FILTER_LOCATOR_PATTERN_V2 = "//div[@role='gridcell'][@data-key='%s']//div[./input]";
  private static final String CELL_LOCATOR_PATTERN_V2 = "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][%d]";
  private static final String COLUMN_DROPDOWN_FILTER_LOCATOR_PATTERN = "//div[@role='gridcell'][@data-key='%s']//div[contains(@class,'ant-select')]";
  private static final String COLUMN_MULTISELECT_FILTER_LOCATOR_PATTERN = "//div[@role='gridcell'][@data-key='%s']//div[contains(@class,'FilterSelect')]";

  @FindBy(xpath = ".//div[contains(@class, 'footer-row')][.='No Results Found']")
  public PageElement noResultsFound;

  @FindBy(css = "div.caret-down-icon > button")
  public PageElement openMenu;
  @FindBy(css = ".ant-dropdown-trigger > button")
  public PageElement openMenu2;

  @FindBy(xpath = ".//span[.='Select All Shown']")
  public PageElement selectAllShown;

  public AntTableV2(WebDriver webDriver) {
    super(webDriver);
    PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
  }

  @Override
  protected String getTextOnTable(int rowNumber, String columnDataClass) {
    String xpath = columnDataClass.startsWith("/") ? f(columnDataClass, rowNumber)
        : f(CELL_LOCATOR_PATTERN, rowNumber, columnDataClass);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    if (isElementExistFast(xpath)) {
      scrollIntoView(xpath);
      return getText(xpath);
    } else {
      return null;
    }
  }

  @Override
  public void clickActionButton(int rowNumber, String actionId) {
    String actionButtonLocator = getActionButtonsLocators().get(actionId);
    String xpath = actionButtonLocator.startsWith("/") ? f(actionButtonLocator, rowNumber)
        : f(ACTION_BUTTON_LOCATOR_PATTERN, rowNumber, actionButtonLocator);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    new Button(getWebDriver(), xpath).click();
  }

  @Override
  public int getRowsCount() {
    if (StringUtils.isNotBlank(tableLocator)) {
      return executeInContext(tableLocator,
          () -> getElementsCount(".//div[@role='row'][contains(@class,'base-row')]"));
    } else {
      return getElementsCount(".//div[@role='row'][contains(@class,'base-row')]");
    }
  }

  @Override
  public void selectRow(int rowNumber) {
    String xpath = f(CELL_LOCATOR_PATTERN, rowNumber, "__checkbox__") + "//input";
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    new CheckBox(getWebDriver(), xpath).check();
  }

  public boolean isRowSelected(int rowNumber) {
    String xpath = f(CELL_LOCATOR_PATTERN, rowNumber, "__checkbox__") + "//input";
    return findElementByXpath(xpath).isSelected();
  }

  public boolean isButtonEnabled(int rowNumber, String actionId) {
    String actionButtonLocator = getActionButtonsLocators().get(actionId);
    String xpath = actionButtonLocator.startsWith("/") ? f(actionButtonLocator, rowNumber)
        : f(ACTION_BUTTON_LOCATOR_PATTERN, rowNumber, actionButtonLocator);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    return findElementByXpath(xpath).isEnabled();
  }

  @Override
  protected String getTableLocator() {
    return "//div[@class='virtual-table']";
  }

  @Override
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    String xpath = f(COLUMN_DROPDOWN_FILTER_LOCATOR_PATTERN, columnLocators.get(columnId));
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    if (isElementExistWait0Second(xpath)) {
      AntSelect2 select = new AntSelect2(getWebDriver(), xpath);
      select.selectValue(value);
    } else {
      xpath = f(COLUMN_TEXT_FILTER_LOCATOR_PATTERN, columnLocators.get(columnId));
      if (StringUtils.isNotBlank(tableLocator)) {
        xpath = tableLocator + xpath;
      }
      if (isElementExistWait0Second(xpath)) {
        AntTextBox input = new AntTextBox(getWebDriver(), xpath);
        input.scrollIntoView();
        input.setValue(value);
      } else {
        xpath = f(COLUMN_MULTISELECT_FILTER_LOCATOR_PATTERN, columnLocators.get(columnId));
        if (isElementExistWait0Second(xpath)) {
          click(xpath);
          new AntTextBox(getWebDriver(),
              "//*[./input[@placeholder='Search or Select']]").setValue(value + Keys.ENTER);
          click(xpath);
        }
      }

    }
    return this;
  }

  public AbstractTable<T> filterByColumnV2(String columnId, String value) {
    String xpath = f(COLUMN_DROPDOWN_FILTER_LOCATOR_PATTERN, columnLocators.get(columnId));
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    if (isElementExistWait0Second(xpath)) {
      AntSelect2 select = new AntSelect2(getWebDriver(), xpath);
      select.selectValueV2(columnId, value);
    } else {
      xpath = f(COLUMN_FILTER_LOCATOR_PATTERN_V2, columnLocators.get(columnId));
      if (StringUtils.isNotBlank(tableLocator)) {
        xpath = tableLocator + xpath;
      }
      AntTextBox input = new AntTextBox(getWebDriver(), xpath);
      input.scrollIntoView();
      input.setValue(value);
    }
    return this;
  }

  public void clearColumnFilters() {
    getColumnLocators().values().forEach(value -> {
      String xpath = f(COLUMN_TEXT_FILTER_LOCATOR_PATTERN, value);
      if (StringUtils.isNotBlank(tableLocator)) {
        xpath = tableLocator + xpath;
      }
      if (isElementExistWait0Second(xpath)) {
        AntTextBox input = new AntTextBox(getWebDriver(), xpath);
        input.clear();
      } else {
        xpath = f(COLUMN_MULTISELECT_FILTER_LOCATOR_PATTERN, columnLocators.get(value));
        if (isElementExistWait0Second(xpath)) {
          click(xpath);
          click("//ul//span[.='Clear All']");
          click(xpath);
        }
      }
    });
  }

  public AbstractTable<T> filterByColumn(String columnId, Object value) {
    return filterByColumn(columnId, String.valueOf(value));
  }

  @Override
  public boolean isEmpty() {
    return noResultsFound.isDisplayedFast();
  }

  @Override
  public void clickColumn(int rowNumber, String columnId) {
    String xpath = f(CELL_LOCATOR_PATTERN, rowNumber, getColumnLocators().get(columnId));
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    if (isElementExistFast(xpath + "//a")) {
      click(xpath + "//a");
    } else if (isElementExistWait0Second(xpath + "//input")) {
      click(xpath + "//input");
    } else {
      click(xpath);
    }
  }


  public void clickColumn(int rowNumber, int columnId) {
    String xpath = f(CELL_LOCATOR_PATTERN_V2, rowNumber, columnId);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    if (isElementExistFast(xpath + "//a")) {
      click(xpath + "//a");
    } else if (isElementExistWait0Second(xpath + "//input")) {
      click(xpath + "//input");
    } else {
      click(xpath);
    }
  }

  @Override
  public String getRowLocator(int index) {
    return f("//div[@class='BaseTable__body']//div[@role='row'][%d]", index);
  }

  public void selectAllShown() {
    if (!selectAllShown.isDisplayedFast()) {
      if (openMenu2.isDisplayedFast()) {
        openMenu2.click();
      } else {
        openMenu.click();
      }
      selectAllShown.click();
    }
  }

  public void sortColumn(String columnId, boolean ascending) {
    String headerLocator = f("div[data-headerkey='%s'] > div > div",
        getColumnLocators().get(columnId));
    String xpath = f(".//div[@data-headerkey='%s']//*[contains(@data-testid, 'sort-%s')]",
        getColumnLocators().get(columnId), ascending ? "up" : "down");
    Button button = new Button(getWebDriver(), findElementBy(By.cssSelector(headerLocator)));
    while (!isElementExistFast(xpath)) {
      button.click();
    }
  }

  @Override
  public void clearColumnFilter(String columnId) {
    Preconditions.checkArgument(StringUtils.isNotBlank(columnId),
        "'columnId' cannot be null or blank string.");
    String columnLocator = columnLocators.get(columnId);
    Preconditions.checkArgument(StringUtils.isNotBlank(columnLocator),
        "Locator for columnId [" + columnId + "] was not defined.");
    new TextBox(getWebDriver(),
        f(".//div[@data-headerkey='%s']//input", columnLocator)).forceClear();
  }

  public void waitIsNotEmpty(int timeoutInSeconds) {
    waitUntil(() -> !isEmpty(), timeoutInSeconds * 1000L, "Table is empty");
  }

  public PageElement getCell(String columnId, int index) {
    String columnDataClass = getColumnLocators().get(columnId);
    String xpath =
        columnDataClass.startsWith("/") ? f(columnDataClass, index) : f(CELL_LOCATOR_PATTERN, index, columnDataClass);
    return new PageElement(getWebDriver(), xpath);
  }
}
