package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class MdCheckbox extends PageElement {

  public MdCheckbox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdCheckbox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  public boolean isChecked() {
    return StringUtils.equalsIgnoreCase(webElement.getAttribute("aria-checked"), "true");
  }

  @Override
  public boolean isEnabled() {
    return StringUtils.equalsIgnoreCase(webElement.getAttribute("aria-disabled"), "false");
  }

  public void check() {
    if (!isChecked()) {
      click();
    }
  }

  public void uncheck() {
    if (isChecked()) {
      click();
    }
  }

  public void setValue(boolean checked) {
    if (checked) {
      check();
    } else {
      uncheck();
    }
  }
}