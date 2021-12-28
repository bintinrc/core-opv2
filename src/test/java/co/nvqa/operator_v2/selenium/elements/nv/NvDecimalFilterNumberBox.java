package co.nvqa.operator_v2.selenium.elements.nv;

import java.text.DecimalFormat;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class NvDecimalFilterNumberBox extends NvFilterNumberBox {

  private static final DecimalFormat DF = new DecimalFormat("#.00");

  public NvDecimalFilterNumberBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvDecimalFilterNumberBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @Override
  protected String format(double value) {
    return DF.format(value);
  }

}