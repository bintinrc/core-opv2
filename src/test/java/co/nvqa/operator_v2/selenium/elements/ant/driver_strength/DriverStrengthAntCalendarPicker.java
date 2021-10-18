package co.nvqa.operator_v2.selenium.elements.ant.driver_strength;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntCalendarPicker;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class DriverStrengthAntCalendarPicker extends AntCalendarPicker {

  public DriverStrengthAntCalendarPicker(WebDriver webDriver,
      WebElement webElement) {
    super(webDriver, webElement);
  }

  public DriverStrengthAntCalendarPicker(WebDriver webDriver,
      SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(id = "startDate")
  public TextBox input;

  @Override
  public void setValue(String value){
    input.click();
    input.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10));
    input.setValue(value);
    input.jsClick();
  }
}
