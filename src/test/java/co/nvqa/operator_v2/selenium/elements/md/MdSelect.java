package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

public class MdSelect extends PageElement {

  public MdSelect(PageElement parent, String xpath) {
    super(parent, xpath);
  }

  public MdSelect(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public MdSelect(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "md-select-value")
  public PageElement selectValueElement;

  @FindBy(css = "md-select-value")
  public PageElement currentValueElement;

  @FindBy(xpath = "//div[contains(@class,'md-active md-clickable')]//input[@ng-model='searchTerm']")
  public PageElement searchInput;

  @FindBy(xpath = ".//md-option[@selected='selected']")
  public PageElement selectedOption;

  @FindBy(xpath = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option")
  public PageElement option;

  @FindBy(xpath = "//div[contains(@class,'md-select-menu-container')][@aria-hidden='false']//md-option")
  public List<PageElement> options;

  private static final String MD_OPTION_LOCATOR = "//div[@id='%s']//md-option[.//div[contains(normalize-space(.), '%s')]]";
  private static final String MD_OPTION_LOCATOR_2 = "//div[@id='%s']//md-option[.//div[contains(normalize-space(.), \"%s\")]]";
  private static final String MD_OPTION_BY_VALUE_LOCATOR = "//div[@id='%s']//md-option[@value='%s']";

  public void searchValue(String value) {
    enterSearchTerm(value);
  }

  public void searchAndSelectValue(String value) {
    if (!StringUtils.equals(value, StringUtils.trim(getValue()))) {
      enterSearchTerm(value);
      value = escapeValue(value);
      try {
        click(f(MD_OPTION_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
      } catch (NoSuchElementException ex) {
        throw new NvTestRuntimeException(f("Could not select option [%s] in md-select", value), ex);
      }
    }
  }

  public void searchAndSelectValues(Iterable<String> values) {
    openMenu();
    values.forEach(value ->
        {
          searchInput.sendKeys(value);
          pause500ms();
          value = escapeValue(value);
          click(f(MD_OPTION_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
        }
    );
    closeMenu();
  }

  public void searchAndSelectValues(String[] values) {
    searchAndSelectValues(Arrays.asList(values));
  }

  public void selectValue(String value) {
    openMenu();
    String locator = value.contains("'") ? MD_OPTION_LOCATOR_2 : MD_OPTION_LOCATOR;
    click(f(locator, getMenuId(), StringUtils.normalizeSpace(value)));
  }

  public void setValue(String value) {
    selectValue(value);
  }

  public void selectValues(Iterable<String> values) {
    openMenu();
    String menuId = getMenuId();
    values.forEach(value ->
    {
      String locator = value.contains("'") ? MD_OPTION_LOCATOR_2 : MD_OPTION_LOCATOR;
      click(f(locator, menuId, StringUtils.normalizeSpace(value)));
    });
    closeMenu();
  }

  public boolean isValueExist(String value) {
    return isElementExist(f(MD_OPTION_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
  }

  public boolean isValueDisabled(String value) {
    String disabledValue = findElementByXpath(f(MD_OPTION_BY_VALUE_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value))).getAttribute("disabled");
    if (disabledValue != null)
      return true;
    else return false;

  }

  public void selectByValue(String value) {
    openMenu();
    value = escapeValue(value);
    click(f(MD_OPTION_BY_VALUE_LOCATOR, getMenuId(), StringUtils.normalizeSpace(value)));
  }

  private void openMenu() {
    selectValueElement.waitUntilClickable();
    selectValueElement.scrollIntoView();
    selectValueElement.jsClick();
    pause500ms();
  }

  private String getMenuId() {
    //Menu ID cannot be cached, because for some controls it's changing
    return getAttribute("aria-owns");
  }

  public void closeMenu() {
    Actions actions = new Actions(getWebDriver());
    actions.sendKeys(Keys.ESCAPE).perform();
  }

  private void enterSearchTerm(String value) {
    openMenu();
    searchInput.sendKeys(value);
    pause500ms();
  }

  public List<String> getOptions() {
    openMenu();
    List<String> opt = options.stream().map(PageElement::getText).collect(Collectors.toList());
    options.get(0).sendKeys(Keys.ESCAPE);
    return opt;
  }

  public String getValue() {
    return currentValueElement.getTextContent();
  }

  public String getSelectedValueAttribute() {
    return selectedOption.getAttribute("value");
  }

  @Override
  public boolean isEnabled() {
    return StringUtils.equals(getAttribute("aria-disabled"), "false");
  }

  public void waitUntilEnabled(int timeoutInSeconds) {
    waitUntil(this::isEnabled, timeoutInSeconds * 1000);
  }
}