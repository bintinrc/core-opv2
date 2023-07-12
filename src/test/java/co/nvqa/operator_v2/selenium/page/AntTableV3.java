package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class AntTableV3<T extends DataEntity<?>> extends AbstractTable<T> {

  private String actionButtonLocatorTemplate = ACTION_BUTTON_LOCATOR_PATTERN;
  private static final String CELL_LOCATOR_PATTERN = "//tbody//tr[not(@aria-hidden='true')][%1$d]/td[contains(@class, '%2$s')] | //tr[not(@aria-hidden='true')][contains(@class,'ant-table-row')][%1$d]/td[%2$s]";
  private static final String ACTION_BUTTON_LOCATOR_PATTERN = "(//tbody//tr[contains(@class,'ant-table-row')][%d]//td[contains(@class,'ant-table-cell-fix-right')]//button)[%s]";

  private static final String CHECKBOX_LOCATOR_PATTERN = "//tbody//tr[%1$d]/td[contains(@class, '_checkbox')]//input";

  public void setActionButtonLocatorTemplate(String actionButtonLocatorTemplate) {
    this.actionButtonLocatorTemplate = actionButtonLocatorTemplate;
  }

  @FindBy(className = "ant-empty-description")
  public PageElement noResultsFound;

  public AntTableV3(WebDriver webDriver) {
    super(webDriver);
    PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
  }

  @Override
  protected String getTextOnTable(int rowNumber, String columnDataClass) {
    String xpath = f(CELL_LOCATOR_PATTERN, rowNumber, columnDataClass);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    return getText(xpath);
  }

  @Override
  public void clickActionButton(int rowNumber, String actionId) {
    getActionButton(rowNumber, actionId).click();
  }

  public Button getActionButton(int rowNumber, String actionId) {
    String actionButtonLocator = getActionButtonsLocators().get(actionId);
    String xpath = actionButtonLocator.startsWith("/") ?
        f(actionButtonLocator, rowNumber) :
        f(actionButtonLocatorTemplate, rowNumber, actionButtonLocator);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    return new Button(getWebDriver(), xpath);
  }

  @Override
  public int getRowsCount() {
    if (StringUtils.isNotBlank(getTableLocator())) {
      return executeInContext(getTableLocator(),
          () -> getElementsCount(".//tbody/tr[not(@aria-hidden='true')]"));
    } else {
      return getElementsCount(
          "//tbody//tr[not(@aria-hidden='true')][contains(@class,'ant-table-row')]");
    }
  }

  @Override
  public void selectRow(int rowNumber) {
    String xpath = f(CHECKBOX_LOCATOR_PATTERN, rowNumber);
    new CheckBox(getWebDriver(), xpath).check();
  }

  public boolean isRowSelected(int rowNumber) {
    throw new UnsupportedOperationException("Not implemented yet");
  }

  @Override
  protected String getTableLocator() {
    return StringUtils.isNotBlank(tableLocator) ? tableLocator
        : "//div[contains(@class,'ant-table') or contains(@class,'table-container')]//table";
  }

  public void clearFilterColumn(String columnId) {
    String xpath = f(
        "//div[@class='ant-space-item']/input[@dataindex='%s' and contains(@class,'ant-input')]",
        columnId);
    while (!(getValue(xpath).isEmpty() || getText(xpath).isEmpty())) {
      sendKeys(xpath, Keys.BACK_SPACE);
    }
  }

  @Override
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    String xpath =
        getTableLocator() + f(
            "//thead//th[contains(@class,'%1$s')]//input|//thead//th[%1$s]//input",
            columnLocators.get(columnId));
    String currentValue = getValue(xpath);
    if (StringUtils.isNotEmpty(currentValue) && !currentValue.equals(value)) {
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < currentValue.length(); i++) {
        sb.append(Keys.BACK_SPACE);
      }
      sb.append(value);
      sendKeys(xpath, sb.toString());
    } else if (StringUtils.isEmpty(currentValue)) {
      sendKeys(xpath, value);
    }
    pause3s();
    return this;
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
    } else {
      click(xpath);
    }
  }

  @Override
  public String getRowLocator(int index) {
    throw new UnsupportedOperationException();
  }
}