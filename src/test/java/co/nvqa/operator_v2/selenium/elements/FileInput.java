package co.nvqa.operator_v2.selenium.elements;

import java.io.File;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

public class FileInput extends PageElement {

  public FileInput(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public FileInput(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public void setValue(String value) {
    sendKeys(value);
  }

  public void setValue(File file) {
    sendKeys(file.getAbsolutePath());
  }

  public String getValue() {
    return getValue(webElement);
  }
}