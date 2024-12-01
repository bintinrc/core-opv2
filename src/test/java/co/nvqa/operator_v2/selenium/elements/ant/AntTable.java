package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AbstractTable;
import com.google.common.base.Preconditions;
import org.apache.commons.lang3.StringUtils;
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
    String xpath = f(".//tbody/tr[%d]/td[@class='%s']", rowNumber, columnDataClass);
    if (!isElementVisible(xpath, 1)) {
      xpath = f(".//tbody/tr[%d]/td[contains(@class,'%s')]", rowNumber, columnDataClass);
    }
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
      return executeInContext(tableLocator,
          () -> getElementsCount(".//tr[contains(@class,'ant-table-row')]"));
    } else {
      return getElementsCount("//tr[contains(@class,'ant-table-row')]");
    }
  }

  @Override
  public void selectRow(int rowNumber) {
    clickf("//tr[%d]/td[contains(@class,'_checkbox')]//input", rowNumber);
  }

  @Override
  protected String getTableLocator() {
    return "//div[contains(@class,'nv-table')]";
  }

  @Override
  public AbstractTable<T> filterByColumn(String columnId, String value) {
    ForceClearTextBox textBox = getHeaderInput(columnId);
    String currentValue = textBox.getValue();
    if (!currentValue.equals(value)) {
      textBox.setValue(value);
      pause400ms();
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

  @Override
  public void clearColumnFilter(String columnId) {
    Preconditions.checkArgument(StringUtils.isNotBlank(columnId),
        "'columnId' cannot be null or blank string.");
    getHeaderInput(columnId).forceClear();
    pause400ms();
  }

  private ForceClearTextBox getHeaderInput(String columnId) {
    String xpath = f("//th[contains(@class,' %s')]//input", getColumnLocators().get(columnId));
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    if (isElementVisible(xpath, 0)) {
      return new ForceClearTextBox(getWebDriver(), xpath);
    }

    xpath = f("//th[contains(@class,'%s')]//input", getColumnLocators().get(columnId));
    if (StringUtils.isNotBlank(tableLocator)) {
      xpath = tableLocator + xpath;
    }
    return new ForceClearTextBox(getWebDriver(), xpath);
  }
}
