package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class VirtualSelect extends PageElement {

  public static final String ITEM_CONTAINS_LOCATOR = "//div[contains(@class, 'ant-select-dropdown')][not(contains(@class,'dropdown-hidden'))]//*[@class='BaseTable__row-cell-text'][.='%s']";
  public static final String CHECKBOX_ITEM_CONTAINS_LOCATOR = "//div[contains(@class, 'ant-select-dropdown')][not(contains(@class,'dropdown-hidden'))]//*[@class='checkbox-row'][.='%s']";
  public static final String ITEM_INDEX_LOCATOR = "//div[contains(@class, 'ant-select-dropdown')][not(contains(@class,'dropdown-hidden'))]//div[@data-rowindex='%d']";
  private Boolean isMultiSelect = false;

  public VirtualSelect(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public VirtualSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public VirtualSelect(WebDriver webDriver, SearchContext searchContext, String xpath,
      Boolean isMultiSelect) {
    super(webDriver, searchContext, xpath);
    this.isMultiSelect = isMultiSelect;
  }

  public VirtualSelect(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  @FindBy(className = "ant-select-selection-selected-value")
  public PageElement selectValueElement;

  @FindBy(css = "input.ant-select-search__field,input.ant-select-selection-search-input")
  public PageElement searchInput;

  @FindBy(className = "ant-select-clear-icon")
  public PageElement clearIcon;

  public void selectValue(String value) {
    enterSearchTerm(value);
    clickMenuItem(value);
  }

  public void selectValues(Iterable<String> values) {
    values.forEach(this::selectValue);
  }

  public void selectByIndex(int index) {
    openMenu();
    clickMenuItemByIndex(index);
  }

  public void selectValueWithoutSearch(String value) {
    openMenu();
    clickMenuItem(value);
  }

  public void clickMenuItem(String value) {
    if (!isMultiSelect) {
      clickf(ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value));
    } else {
      clickf(CHECKBOX_ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value));
    }

  }

  public void clickMenuItemByIndex(int index) {
    clickf(ITEM_INDEX_LOCATOR, index);
  }

  public void clearValue() {
    clearIcon.click();
  }

  private void openMenu() {
    waitUntilClickable();
    jsClick();
    pause1s();
  }

  public void enterSearchTerm(String value) {
    openMenu();
    searchInput.sendKeys(value);
    pause1s();
  }

  public void sendReturnButton() {
    searchInput.sendKeys(Keys.RETURN);
  }

  public String getValue() {
    return selectValueElement.isDisplayedFast() ?
        selectValueElement.getText() :
        null;
  }

  public boolean hasItem(String value) {
    openMenu();
    if (isMultiSelect) {
      return isElementExistFast(
          f(CHECKBOX_ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value)));
    }
    return isElementExistFast(f(ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value)));
  }
}