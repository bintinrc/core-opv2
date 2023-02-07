package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public abstract class AntFilterNumberBox extends AntAbstractFilterBox {

  private static final Pattern RANGE_PATTERN = Pattern.compile(
      "\\s*(\\d*\\.?\\d*)\\s*:\\s*(\\d*\\.?\\d*)\\s*");
  private static final Pattern VALUE_PATTERN = Pattern.compile(
      "\\s*([<>=]{1,2})\\s*(\\d*\\.?\\d*)\\s*");
  private static final Pattern SIMPLE_VALUE_PATTERN = Pattern.compile("\\s*(\\d*\\.?\\d*)\\s*");

  public AntFilterNumberBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntFilterNumberBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(xpath = ".//label[.='Range']")
  public Button range;

  @FindBy(xpath = ".//label[.='Value']")
  public Button value;

  @FindBy(css = "div.ant-select")
  public AntSelect3 op;

  @FindBy(xpath = "(.//input[contains(@class,'ant-input-number-input')])[1]")
  public ForceClearTextBox from;

  @FindBy(xpath = "(.//input[contains(@class,'ant-input-number-input')])[2]")
  public ForceClearTextBox to;

  @Override
  public void setValue(String... values) {
    selectFilter(values[0]);
  }

  public void selectFilter(String value) {
    Matcher m = RANGE_PATTERN.matcher(value);
    if (m.matches()) {
      selectRange(Double.parseDouble(m.group(1)), Double.parseDouble(m.group(2)));
    } else {
      m = VALUE_PATTERN.matcher(value);
      if (m.matches()) {
        selectValue(m.group(1), Double.parseDouble(m.group(2)));
      } else {
        m = SIMPLE_VALUE_PATTERN.matcher(value);
        if (m.matches()) {
          selectValue("==", Double.parseDouble(m.group(2)));
        } else {
          throw new IllegalArgumentException("Unsupported format of value " + value);
        }
      }
    }
  }

  public void selectRange(double from, double to) {
    if (value.isDisplayedFast()) {
      value.click();
    }
    this.from.setValue(format(from));
    this.to.setValue(format(to));
  }

  public void selectValue(String op, double to) {
    if (range.isDisplayedFast()) {
      range.click();
    }
    this.op.selectValue(op);
    this.from.setValue(format(to));
  }

  protected abstract String format(double value);

}