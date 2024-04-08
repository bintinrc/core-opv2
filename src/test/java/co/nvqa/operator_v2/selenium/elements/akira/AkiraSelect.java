package co.nvqa.operator_v2.selenium.elements.akira;

import co.nvqa.operator_v2.exception.element.NvTestCoreElementNotFoundError;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.Locale;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.apache.commons.lang3.StringUtils.normalizeSpace;

public class AkiraSelect extends PageElement {


  private static final Logger LOGGER = LoggerFactory.getLogger(AkiraSelect.class);

  public AkiraSelect(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AkiraSelect(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public AkiraSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AkiraSelect(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  @FindBy(xpath = "//button[contains(@id,'headlessui-listbox-button')][@aria-expanded='true']")
  public PageElement searchInput;

  public void selectValue(String value) {
    if (!StringUtils.equals(value, getValue())) {
      clickMenuItem(value);
      pause500ms();
      closeMenu();
    }
  }

  public void selectValueWithoutClose(String value) {
    if (!StringUtils.equals(value, getValue())) {
      clickMenuItem(value);
      pause500ms();
    }
  }

  public void clickMenuItem(String value) {
    doWithRetry(() -> {
      try {
        getWebElement().click();
        String xpath = getItemEqualsLocator(value);
        if (isElementVisible(xpath, 1)) {
          click(xpath);
        } else {
          xpath = getItemIgnoreCaseLocator(value);
          if (isElementVisible(xpath, 1)) {
            click(xpath);
          } else {
            xpath = getItemContainsLocator(value);
            if (isElementVisible(xpath, 1)) {
              click(xpath);
            } else {
              xpath = getItemValueLocator(value);
              click(xpath);
            }
          }
        }
      } catch (Throwable t) {
        throw new NvTestCoreElementNotFoundError(t.getMessage());
      }
    }, getCurrentMethodName());
  }

  public void closeMenu() {
    String listBoxLocator = getListBoxLocator();
    try {
      waitUntilInvisibilityOfElementLocated(listBoxLocator, 1);
    } catch (Exception ignored) {
    }
    if (isElementVisible(listBoxLocator, 0)) {
      jsClick();
    }
    if (isElementVisible(listBoxLocator, 0)) {
      new Actions(getWebDriver()).sendKeys(Keys.ESCAPE).perform();
    }
    try {
      waitUntilInvisibilityOfElementLocated(listBoxLocator, 1);
    } catch (Exception ex) {
      LOGGER.error(ex.toString());
      throw new NvTestCoreElementNotFoundError(ex.getMessage());
    }
  }

  public List<String> getOptions() {
    try {
      getWebElement().click();
      List<String> options = findElementsByXpath(getListBoxLocator() + "//li//span")
          .stream()
          .map(WebElement::getText)
          .collect(Collectors.toList());

      closeMenu();

      return options;
    } catch (NoSuchElementException e) {
      LOGGER.error("No options found or list box not present: " + e.getMessage());
      throw new NvTestCoreElementNotFoundError();
    }
  }

  private String getItemEqualsLocator(String value) {
    return "//li[contains(@id,'headlessui-listbox-option')]//*[normalize-space(text())='"
        + normalizeSpace(
        value) + "']";
  }

  private String getItemValueLocator(String value) {
    return "//li[contains(@id,'headlessui-listbox-option')]//*[contains(text(), '"
        + value + "')]";
  }

  private String getItemContainsLocator(String value) {
    return "//li[contains(@id,'headlessui-listbox-option')]//*[contains(normalize-space(@title),'"
        + normalizeSpace(value) + "')]";
  }

  private String getItemIgnoreCaseLocator(String value) {
    return
        "//li[contains(@id,'headlessui-listbox-option')]//*[normalize-space(translate(@title, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))='"
            + normalizeSpace(value.toLowerCase(Locale.ROOT)) + "']";
  }

  private String getListBoxLocator() {
    String listId = searchInput.getAttribute("aria-controls");
    return "//ul[contains(@id,'" + listId + "')]";
  }
}
