package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.util.CoreDateUtil;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Controller for ant-time-picker component
 *
 * @author Sergey Mishanin
 */
public class AntCalendarPicker extends PageElement {

  public AntCalendarPicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntCalendarPicker(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(css = ".ant-calendar-picker-input")
  public TextBox input;

  @FindBy(xpath = "//input[contains(@class,'ant-calendar-input')]")
  public TextBox panelInput;

  public void setValue(String value) {
    input.click();
    panelInput.sendKeys(StringUtils.repeat(Keys.BACK_SPACE.toString(), 10));
    panelInput.setValue(value);
    input.jsClick();
  }

  public void setValue(Date value) {
    setValue(CoreDateUtil.SDF_YYYY_MM_DD.format(value));
  }
}