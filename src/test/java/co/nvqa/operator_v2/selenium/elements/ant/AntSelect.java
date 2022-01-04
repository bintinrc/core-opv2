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

public class AntSelect extends PageElement {

  public static final String ITEM_CONTAINS_LOCATOR = "//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[contains(normalize-space(text()), '%s')]";
  public static final String ITEM_INDEX_LOCATOR = "//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[@data-rowindex='%d']";

  public AntSelect(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntSelect(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  @FindBy(className = "ant-select-selection-selected-value")
  public PageElement selectValueElement;

  @FindBy(xpath = "//input[contains(@class,'ant-select-search__field') or contains(@class,'ant-select-selection-search-input')]")
  public PageElement searchInput;

  @FindBy(className = "ant-select-clear-icon")
  public PageElement clearIcon;

  public void selectValue(String value) {
    enterSearchTerm(value);
    clickMenuItem(value);
  }

  public void selectValue(String value, WebElement element) {
    enterSearchTerm(value, element);
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
    clickf(ITEM_CONTAINS_LOCATOR, StringUtils.normalizeSpace(value));
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

  public void enterSearchTerm(String value, WebElement element) {
    openMenu();
    element.sendKeys(value);
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