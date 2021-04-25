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
public class AntTable<T extends DataEntity<?>> extends AbstractTable<T> {

  @FindBy(xpath = "//div[contains(@class, 'footer-row')][.='No Results Found']")
  public PageElement noResultsFound;

  public AntTable(WebDriver webDriver) {
    super(webDriver);
    PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
  }

  @Override
  protected String getTextOnTable(int rowNumber, String columnDataClass) {
    String xpath = f(".//tbody/tr[%d]/td[contains(@class,'%s')]", rowNumber, columnDataClass);
    return getText(xpath);
  }

  @Override
  public void clickActionButton(int rowNumber, String actionId) {
    String xpath = getActionButtonsLocators().get(actionId);
    clickf(xpath, rowNumber);
  }

  @Override
  public int getRowsCount() {
    if (StringUtils.isNotBlank(tableLocator)) {
      return executeInContext(tableLocator, () -> getElementsCount(".//tbody/tr"));
    } else {
      return getElementsCount(".//tbody/tr");
    }
  }

  @Override
  public void selectRow(int rowNumber) {
    throw new UnsupportedOperationException("Not implemented yet");
  }

  @Override
  protected String getTableLocator() {
    return "//div[contains(@class,'nv-table')]";
  }

  @Override
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    String xpath = f("//th[contains(@class,'%s')]//input", columnId);
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
    String xpath = f("//tbody/tr[%d]/td[contains(@class,'%s')]", rowNumber,
        getColumnLocators().get(columnId));
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    click(xpath);
  }

  @Override
  public String getRowLocator(int index) {
    throw new UnsupportedOperationException();
  }
}
