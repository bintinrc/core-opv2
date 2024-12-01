package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import com.google.common.base.Preconditions;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class MdVirtualRepeatTable<T extends DataEntity<?>> extends AbstractTable<T> {

  @FindBy(css = "th.column-checkbox md-menu")
  public MdMenu selectionMenu;

  @FindBy(css = "div.no-result")
  public PageElement noResults;

  private String nvTableParam;
  private String mdVirtualRepeat = "data in getTableData()";

  public MdVirtualRepeatTable(WebDriver webDriver) {
    super(webDriver);
    PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
  }

  public String getMdVirtualRepeat() {
    return mdVirtualRepeat;
  }

  public void setMdVirtualRepeat(String mdVirtualRepeat) {
    this.mdVirtualRepeat = mdVirtualRepeat;
  }

  public void setNvTableParam(String nvTableParam) {
    this.nvTableParam = nvTableParam;
  }

  public void selectAllShown() {
    selectionMenu.selectOption("Select All Shown");
  }

  @Override
  protected String getTextOnTable(int rowNumber, String columnDataClass) {
    if (StringUtils.startsWithAny(columnDataClass, "/", "./")) {
      String xpath = f(columnDataClass, rowNumber);
      return getText(xpath);
    } else {
      return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat,
          nvTableParam);
    }
  }

  @Override
  public void clickActionButton(int rowNumber, String actionId) {
    String actionButtonLocator = actionButtonsLocators.get(actionId);
    Preconditions.checkArgument(StringUtils.isNotBlank(actionButtonLocator),
        "Unknown action [" + actionId + "]");

    if (StringUtils.startsWith(actionButtonLocator, "/")) {
      clickCustomActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonLocator,
          mdVirtualRepeat);
    } else {
      clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonLocator, mdVirtualRepeat);
    }
  }

  @Override
  public int getRowsCount() {
    return getRowsCountOfTableWithMdVirtualRepeat(mdVirtualRepeat, nvTableParam);
  }

  @Override
  public void selectRow(int rowNumber) {
    String xpath = f(
        ".//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]//md-checkbox",
        mdVirtualRepeat, rowNumber);
    new CheckBox(getWebDriver(), xpath).check();
  }

  public MdCheckbox getCheckbox(int rowNumber) {
    return new MdCheckbox(getWebDriver(), findElementByXpath(
        f(".//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]//md-checkbox",
            mdVirtualRepeat, rowNumber)));
  }

  public Button getActionButton(String buttonName, int rowNumber) {
    return new Button(getWebDriver(), findElementByXpath(
        f(".//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'actions')]//button[@aria-label='%s']",
            mdVirtualRepeat, rowNumber, buttonName)));
  }

  @Override
  protected String getTableLocator() {
    return StringUtils.isNotBlank(nvTableParam) ? f(
        ".//nv-table[@param='%s'][.//tr[@md-virtual-repeat='%s']]", nvTableParam, mdVirtualRepeat)
        : f(".//nv-table[.//tr[@md-virtual-repeat='%s']]", mdVirtualRepeat);
  }

  @Override
  public void clickColumn(int rowNumber, String columnId) {
    String xpath = f(
        "%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]/td[normalize-space(@class)='%s']",
        getTableLocator(), mdVirtualRepeat, rowNumber, getColumnLocators().get(columnId));
    if (isElementExistFast(xpath + "//a")) {
      click(xpath + "//a");
    } else {
      click(xpath);
    }
  }

  public void sortColumn(String columnId, boolean ascending) {
    String headerLocator = f("th.%s span", getColumnLocators().get(columnId));
    String xpath = f("//th[contains(@class,'%s')]/md-icon[contains(@md-svg-src,'%s')]",
        getColumnLocators().get(columnId), ascending ? "asc" : "desc");
    Button button = new Button(getWebDriver(), findElementBy(By.cssSelector(headerLocator)));
    while (!isElementExistFast(xpath)) {
      button.click();
    }
  }

  @Override
  public String getRowLocator(int index) {
    return f("%s//tr[@md-virtual-repeat='%s'][not(contains(@class, 'last-row'))][%d]",
        getTableLocator(), mdVirtualRepeat, index);
  }

  public PageElement getCell(String columnId, int index) {
    String xpath =
        getRowLocator(index) + f("/td[contains(@class, '%s')]", getColumnLocators().get(columnId));
    return new PageElement(getWebDriver(), xpath);
  }

  @Override
  public boolean isEmpty() {
    return noResults.isDisplayedFast();
  }
}
