package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class NinjaDashPage extends OperatorV2SimplePage {

  @FindBy(css = "span[class*='AccountButton__AccountName']")
  public PageElement accountName;

  public NinjaDashPage(WebDriver webDriver) {
    super(webDriver);
  }

}