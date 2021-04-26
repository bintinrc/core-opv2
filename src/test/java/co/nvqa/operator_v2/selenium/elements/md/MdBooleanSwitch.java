package co.nvqa.operator_v2.selenium.elements.md;

import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class MdBooleanSwitch extends MdButtonGroup {

  public MdBooleanSwitch(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdBooleanSwitch(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  public void selectValue(Boolean value) {
    super.selectValue(BooleanUtils.isTrue(value) ? "Yes" : "No");
  }

  public boolean isOn() {
    return StringUtils.equalsIgnoreCase(getValue(), "Yes");
  }

  public boolean isOff() {
    return !isOn();
  }

  public String getValue() {
    return selectedOption.getAttribute("aria-label");
  }
}