package co.nvqa.operator_v2.selenium.elements.nv;

import java.text.DecimalFormat;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class NvIntFilterNumberBox extends NvFilterNumberBox {

  private static final DecimalFormat DF = new DecimalFormat("#");

  public NvIntFilterNumberBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvIntFilterNumberBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @Override
  protected String format(double value) {
    return DF.format(value);
  }

}