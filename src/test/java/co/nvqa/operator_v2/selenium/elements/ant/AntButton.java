package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntButton extends PageElement {

  public AntButton(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AntButton(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(css = ".anticon-loading")
  public PageElement spinner;

  public void click() {
    waitUntilClickable();
    super.click();
  }

  public void clickAndWaitUntilDone() {
    click();
    if (spinner.waitUntilVisible(1)) {
      spinner.waitUntilInvisible();
    }
  }

  public void clickAndWaitUntilDone(int timeoutInSeconds) {
    click();
    if (spinner.waitUntilVisible(1)) {
      spinner.waitUntilInvisible(timeoutInSeconds);
    }
  }

  @Override
  public boolean isEnabled() {
    return !StringUtils.containsIgnoreCase(getAttribute("class"), "disabled");
  }
}