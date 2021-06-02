package co.nvqa.operator_v2.selenium.elements.ant.v4;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * Created on 30/10/20.
 *
 * @author refoilmiya
 */
public class AntCalendarPicker extends PageElement {

  private static final String CAL_ITEM_XPATH= "//div[not(contains(@class, 'ant-picker-dropdown-hidden'))][contains(@class,'ant-picker-dropdown')]//td[@title='%s']";
  private static final String CLEAR_XPATH = ".//span[contains(@class,'ant-picker-clear')]";

  public AntCalendarPicker(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntCalendarPicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = ".//div[@class='ant-picker-input']/input")
  public TextBox pickerInput;

  @FindBy(xpath = CLEAR_XPATH)
  public PageElement clear;

  public void sendDate(String value) {
    if (isElementExist(CLEAR_XPATH)) {
      clear.click();
    }
    pickerInput.sendKeys(value);
    pause1s();
    clickf(CAL_ITEM_XPATH, value);
  }
}