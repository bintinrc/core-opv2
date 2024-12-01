package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public abstract class NvFilterNumberBox extends AbstractFilterBox {

  private static final Pattern RANGE_PATTERN = Pattern.compile(
      "\\s*(\\d*\\.?\\d*)\\s*:\\s*(\\d*\\.?\\d*)\\s*");
  private static final Pattern VALUE_PATTERN = Pattern.compile(
      "\\s*([<>=]{1,2})\\s*(\\d*\\.?\\d*)\\s*");
  private static final Pattern SIMPLE_VALUE_PATTERN = Pattern.compile("\\s*(\\d*\\.?\\d*)\\s*");

  public NvFilterNumberBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvFilterNumberBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(css = "md-select[placeholder='Type']")
  public MdSelect type;

  @FindBy(css = "md-select[placeholder='OP']")
  public MdSelect op;

  @FindBy(css = "input[aria-label='from']")
  public TextBox from;

  @FindBy(css = "input[aria-label='to']")
  public TextBox to;

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
    type.selectValue("Range");
    this.from.setValue(format(from));
    this.to.setValue(format(to));
  }

  public void selectValue(String op, double to) {
    type.selectValue("Value");
    this.op.selectValue(op);
    this.to.setValue(format(to));
  }

  protected abstract String format(double value);

}