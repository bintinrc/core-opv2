package co.nvqa.operator_v2.selenium.elements.akira;

import co.nvqa.operator_v2.exception.element.NvTestCoreComboBoxException;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.Locale;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import static org.apache.commons.lang3.StringUtils.normalizeSpace;

public class AkiraComboBox extends PageElement {

  public AkiraComboBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AkiraComboBox(WebDriver webDriver, String xpath) {
    super(webDriver, xpath);
  }

  public AkiraComboBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AkiraComboBox(WebDriver webDriver, SearchContext searchContext, String xpath) {
    super(webDriver, searchContext, xpath);
  }

  public void selectValue(String value) {
    doWithRetry(() -> {
      try {
        clickMenuItem(value);
        pause500ms();
      } catch (Throwable t) {
        throw new NvTestCoreComboBoxException(t.getMessage());
      }
    }, getCurrentMethodName());

  }

  public void clickMenuItem(String value) {
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
  }

  private String getItemEqualsLocator(String value) {
    return "//li[contains(@id,'headlessui-combobox-option')]//*[normalize-space(text())='"
        + normalizeSpace(
        value) + "']";
  }

  private String getItemValueLocator(String value) {
    return "//li[contains(@id,'headlessui-combobox-option')]//*[contains(text(), '"
        + value + "')]";
  }

  private String getItemContainsLocator(String value) {
    return "//li[contains(@id,'headlessui-combobox-option')]//*[contains(normalize-space(@title),'"
        + normalizeSpace(value) + "')]";
  }

  private String getItemIgnoreCaseLocator(String value) {
    return
        "//li[contains(@id,'headlessui-combobox-option')]//*[normalize-space(translate(@title, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))='"
            + normalizeSpace(value.toLowerCase(Locale.ROOT)) + "']";
  }

  public void fillSearchTermAndEnter(String value) {
    getWebElement().sendKeys(value + Keys.ENTER);
  }

}
