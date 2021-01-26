package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class MdAutocomplete extends PageElement {

  public MdAutocomplete(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public MdAutocomplete(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = ".//input")
  public PageElement inputElement;

  public void selectValue(String value) {
    enterSearchTerm(value);
    selectItem(value);
  }

  public void enterSearchTerm(String value) {
    inputElement.waitUntilClickable();
    inputElement.moveAndClick();
    inputElement.clearAndSendKeys(value);
  }

  public void closeSuggestions() {
    inputElement.sendKeys(Keys.ESCAPE);
  }

  public void selectItem(String value) {
    try {
      click(
          f("//ul[contains(@class,'md-autocomplete-suggestions')]/li[contains(normalize-space(.),'%s')]",
              StringUtils.normalizeSpace(value)));
    } catch (NoSuchElementException ex) {
      throw new NoSuchElementException(
          f("Could not select value [%s] in md-autocomplete - Not Matched", value), ex);
    }
  }
}