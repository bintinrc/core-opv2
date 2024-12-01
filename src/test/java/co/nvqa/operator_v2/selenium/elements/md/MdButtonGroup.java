package co.nvqa.operator_v2.selenium.elements.md;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class MdButtonGroup extends PageElement {

  public MdButtonGroup(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public MdButtonGroup(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  private static final String OPTION_LOCATOR = ".//button[normalize-space(@aria-label)=normalize-space('%s')]";

  @FindBy(css = "button.raised")
  public Button selectedOption;

  public void selectValue(String value) {
    WebElement optionButton = findElementBy(By.xpath(f(OPTION_LOCATOR, value)), webElement);
    optionButton.click();

  }

  public String getValue() {
    return selectedOption.getAttribute("aria-label");
  }
}