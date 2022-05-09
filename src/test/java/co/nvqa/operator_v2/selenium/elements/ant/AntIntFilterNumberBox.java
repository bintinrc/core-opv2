package co.nvqa.operator_v2.selenium.elements.ant;

import java.text.DecimalFormat;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class AntIntFilterNumberBox extends AntFilterNumberBox {

  private static final DecimalFormat DF = new DecimalFormat("#");

  public AntIntFilterNumberBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public AntIntFilterNumberBox(WebDriver webDriver, SearchContext searchContext,
      WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @Override
  protected String format(double value) {
    return DF.format(value);
  }

}