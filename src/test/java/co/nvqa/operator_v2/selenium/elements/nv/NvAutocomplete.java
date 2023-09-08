package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.Locale;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvAutocomplete extends PageElement {

  public NvAutocomplete(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvAutocomplete(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(xpath = ".//input")
  public PageElement inputElement;

  @FindBy(css = "md-progress-linear")
  public PageElement progressBar;

  @FindBy(css = "button[ng-click='$mdAutocompleteCtrl.clear()']")
  public Button clear;

  public void selectValue(String value) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        inputElement.clearAndSendKeys(value);
        pause500ms();
        progressBar.waitUntilInvisible();

        String suggestionsId = inputElement.getAttribute("aria-owns");
        String menuXpath = f("//ul[@id='%s']", suggestionsId);
        String itemXpath =
            menuXpath + f(
                "//li//span[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'%s') and not(starts-with(normalize-space(.),'No') and contains(.,'matching'))]",
                value.toLowerCase(Locale.ROOT));
        int count = 0;
        while (!isElementVisible(itemXpath, 1) && count < 5) {
          String lastItemXpath = menuXpath + "//li[last()]";
          scrollIntoView(lastItemXpath, true);
          count++;
        }
        click(itemXpath);
        pause200ms();
        if (isElementVisible(menuXpath, 0)) {
          inputElement.sendKeys(Keys.ESCAPE);
        }
      } catch (NoSuchElementException ex) {
        String noMatchingErrorText = f("\"%s\" were found.", value);
        String notFoundXpath = f("//span[contains(text(), '%s')]", noMatchingErrorText);
        String message = isElementVisible(notFoundXpath, WAIT_1_SECOND) ?
            getText(notFoundXpath) :
            f("Option [%s] was not found in NvSelect", value);
        throw new NvTestRuntimeException(message);
      }
    }, "Value was not found on NV Autocomplete", 500, 3);
  }

  public void strictlySelectValue(String value) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        inputElement.clearAndSendKeys(value);
        pause500ms();
        progressBar.waitUntilInvisible();

        String suggestionsId = inputElement.getAttribute("aria-owns");
        String menuXpath = f("//ul[@id='%s']", suggestionsId);
        String itemXpath =
            menuXpath + f(
                "//li//span[@md-highlight-text and normalize-space(.)=normalize-space('%s')]",
                value);
        click(itemXpath);
        pause200ms();
        if (isElementVisible(menuXpath, 0)) {
          inputElement.sendKeys(Keys.ESCAPE);
        }
      } catch (NoSuchElementException ex) {
        String noMatchingErrorText = f("\"%s\" were found.", value);
        String notFoundXpath = f("//span[contains(text(), '%s')]", noMatchingErrorText);
        String message = isElementVisible(notFoundXpath, WAIT_1_SECOND) ?
            getText(notFoundXpath) :
            f("Option [%s] was not found in NvSelect", value);
        throw new NvTestRuntimeException(message);
      }
    }, "Value was not found on NV Autocomplete", 500, 3);
  }

  public void selectValue(Object value) {
    selectValue(String.valueOf(value));
  }

  public void selectValues(Iterable<?> values) {
    values.forEach(this::selectValue);
  }

  public void clear() {
    if (StringUtils.isNotBlank(getValue())) {
      clear.click();
    }
  }

  public String getValue() {
    return getValue(inputElement.getWebElement());
  }
}