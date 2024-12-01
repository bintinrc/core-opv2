package co.nvqa.operator_v2.selenium.elements.akira;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class AkiraCheckBox extends PageElement {

  public AkiraCheckBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AkiraCheckBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
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
      jsClick();
    }
  }

  public void uncheck() {
    if (isChecked()) {
      jsClick();
    }
  }
}
