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

public class AntSelect2 extends PageElement {

  public static final String ITEM_CONTAINS_LOCATOR = "//div[contains(@class, 'ant-select-dropdown')][not(contains(@class,'dropdown-hidden'))]//*[contains(normalize-space(text()), '%s')]";
  public static final String ITEM_EQUALS_LOCATOR = "//div[contains(@class, 'ant-select-dropdown')][not(contains(@class,'dropdown-hidden'))]//*[normalize-space(text())='%s']";
  public static final String ITEM_INDEX_LOCATOR = "//div[contains(@class, 'ant-select-dropdown')][not(contains(@class,'dropdown-hidden'))]//div[@data-rowindex='%d']";
  public static final String ITEM_FILTER_LOCATOR = "//div[@data-testid = 'filterInput.%s']";

  public AntSelect2(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSelect2(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public AntSelect2(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSelect2(WebDriver webDriver, SearchContext searchContext, String xpath) {
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

  public void selectValueV2(String column, String value) {
    SearchTermV2(column);
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
    String xpath = f(ITEM_EQUALS_LOCATOR, StringUtils.normalizeSpace(value));
    if (isElementVisible(xpath, 1)) {
      click(xpath);
    } else {
      clickf(ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value));
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

  public void SearchTermV2(String column) {
    openMenu();
    findElementByXpath(f(ITEM_FILTER_LOCATOR, column)).click();
    pause1s();
  }

  public void enterSearchTerm(String value) {
    openMenu();
    searchInput.clearAndSendKeys(value);
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
    return isElementExistFast(f(ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value)));
  }
}