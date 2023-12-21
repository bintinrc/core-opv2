package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;


/**
 * Created on 30/10/20.
 *
 * @author Sergey Mishanin
 */
public class AntRangePicker extends PageElement {

  private static final SimpleDateFormat DATE_CELL_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
  private static final String DATE_CELL_LOCATOR = "//td[contains(@class,'ant-picker-cell-in-view')][@title='%s']";

  public AntRangePicker(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntRangePicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(css = "input[placeholder='Start date']")
  public TextBox valueFrom;

  @FindBy(css = "input[placeholder='End date']")
  public TextBox valueTo;

  @FindBy(css = ".ant-picker-clear")
  public PageElement clear;

  public void setFrom(String from) {
    if (!StringUtils.equals(from, getValueFrom())) {
      valueFrom.click();
      valueFrom.forceClear();
      valueFrom.setValue(from + Keys.ENTER);
    }
  }

  public void setTo(String to) {
    if (!StringUtils.equals(to, getValueTo())) {
      valueTo.click();
      valueTo.forceClear();
      valueTo.setValue(to + Keys.ENTER);
    }
  }

  public void setInterval(String from, String to) {
    setFrom(from);
    setTo(to);
  }

  public void fairSetInterval(Date from, Date to) {
    valueFrom.click();
    String xpath = f(DATE_CELL_LOCATOR, DATE_CELL_FORMAT.format(from));
    new PageElement(getWebDriver(), xpath).click();
    xpath = f(DATE_CELL_LOCATOR, DATE_CELL_FORMAT.format(to));
    new PageElement(getWebDriver(), xpath).click();
  }

  public void fairSetInterval(String from, String to) {
    fairSetInterval(DataEntity.toDateTime(from), DataEntity.toDateTime(to));
  }

  public String getValueFrom() {
    return valueFrom.getValue();
  }

  public String getValueTo() {
    return valueTo.getValue();
  }
}
