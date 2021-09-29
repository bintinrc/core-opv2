package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
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

  private static final String CELL_LOCATOR_PATTERN = "//tr[contains(@class,'ant-table-row')][%d]/td[%s]";
  private static final String ACTION_BUTTON_LOCATOR_PATTERN = "(//tr[contains(@class,'ant-table-row')][%d]//td[contains(@class,'ant-table-cell-fix-right')]//button)[%s]";

  @FindBy(css = "p.ant-empty-description")
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
    String actionButtonLocator = getActionButtonsLocators().get(actionId);
    String xpath = actionButtonLocator.startsWith("/") ?
        f(actionButtonLocator, rowNumber) :
        f(ACTION_BUTTON_LOCATOR_PATTERN, rowNumber, actionButtonLocator);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    click(xpath);
  }

  @Override
  public int getRowsCount() {
    if (StringUtils.isNotBlank(tableLocator)) {
      return executeInContext(tableLocator,
          () -> getElementsCount(".//tr[contains(@class,'ant-table-row')]"));
    } else {
      return getElementsCount("//tr[contains(@class,'ant-table-row')]");
    }
  }

  @Override
  public void selectRow(int rowNumber) {
    throw new UnsupportedOperationException("Not implemented yet");
  }

  public boolean isRowSelected(int rowNumber) {
    throw new UnsupportedOperationException("Not implemented yet");
  }

  @Override
  protected String getTableLocator() {
    return StringUtils.isNotBlank(tableLocator) ? tableLocator
        : "//div[contains(@class,'ant-table')]//table";
  }

  @Override
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    String xpath = getTableLocator() + f("//thead//th[%s]//input", columnLocators.get(columnId));
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