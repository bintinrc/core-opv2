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
public class AntTableV2<T extends DataEntity<?>> extends AbstractTable<T> {

  private static final String CELL_LOCATOR_PATTERN = "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='%s']";

  @FindBy(xpath = ".//div[contains(@class, 'footer-row')][.='No Results Found']")
  public PageElement noResultsFound;

  public AntTableV2(WebDriver webDriver) {
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
    throw new UnsupportedOperationException("Not implemented yet");
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
    click(xpath);
  }

  public boolean isRowSelected(int rowNumber) {
    String xpath = f(CELL_LOCATOR_PATTERN, rowNumber, "__checkbox__") + "//input";
    return findElementByXpath(xpath).isSelected();
  }

  @Override
  protected String getTableLocator() {
    return "//div[@class='virtual-table']";
  }

  @Override
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    String xpath = f("//div[@role='gridcell'][@data-key='%s']//input", columnId);
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
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
    click(xpath);
  }
}
