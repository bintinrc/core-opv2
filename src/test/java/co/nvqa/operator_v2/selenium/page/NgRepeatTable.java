package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

/**
 * @author Sergey Mishanin
 */
public class NgRepeatTable<T extends DataEntity<?>> extends AbstractTable<T> {

  private String ngRepeat;

  public NgRepeatTable(WebDriver webDriver) {
    super(webDriver);
  }

  public String getNgRepeat() {
    return ngRepeat;
  }

  public void setNgRepeat(String ngRepeat) {
    this.ngRepeat = ngRepeat;
  }

  public void waitUntilVisibility() {
    String xpath = String.format("//tr[@ng-repeat='%s']", ngRepeat);
    waitUntilVisibilityOfElementLocated(xpath);
  }

  @Override
  protected String getTextOnTable(int rowNumber, String columnDataClass) {
    if (StringUtils.startsWithAny(columnDataClass, "/", "./")) {
      return getTextOnTableWithNgRepeatAndCustomCellLocator(rowNumber, columnDataClass, ngRepeat);
    } else {
      return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, ngRepeat);
    }
  }

  @Override
  public void clickActionButton(int rowNumber, String actionId) {
    clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonsLocators.get(actionId), ngRepeat);
  }

  @Override
  public int getRowsCount() {
    return getRowsCountOfTableWithNgRepeat(ngRepeat);
  }

  @Override
  public void selectRow(int rowNumber) {
    throw new UnsupportedOperationException("Not implemented yet");
  }

  @Override
  protected String getTableLocator() {
    return f("//nv-table[.//tr[@ng-repeat='%s']]", ngRepeat);
  }

  @Override
  public void clickColumn(int rowNumber, String columnId) {
    throw new UnsupportedOperationException();
  }

  @Override
  public String getRowLocator(int index) {
    return f(
        "%s//tr[@ng-repeat='%s'][not(contains(@class, 'last-row'))][%d]",
        getTableLocator(), ngRepeat, index);
  }
}
