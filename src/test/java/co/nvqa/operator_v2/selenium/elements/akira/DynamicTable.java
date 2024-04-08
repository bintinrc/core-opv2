package co.nvqa.operator_v2.selenium.elements.akira;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class DynamicTable<R> extends PageElement {

  public DynamicTable(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public DynamicTable(WebDriver webDriver, WebElement webElement, Class<?> genericType) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement, genericType), this);
  }

  public DynamicTable(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = "//div[@class='ant-row']")
  public PageElement actions;

  public void clickActionButton(String action) {
    actions.findElement(By.xpath(f("//*[contains(@data-testid,'%s-')]", action))).click();
  }

  @FindBy(xpath = "//tbody//tr")
  public List<R> rows;

  @FindBy(xpath = "//tbody//tr//td[not(div)]")
  public List<R> columns;

  public R getRow(int index) {
    return rows.get(index);
  }

  public static class DynamicRow extends PageElement {

    public DynamicRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public DynamicRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }
}
