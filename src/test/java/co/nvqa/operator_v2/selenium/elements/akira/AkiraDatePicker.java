package co.nvqa.operator_v2.selenium.elements.akira;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AkiraDatePicker extends PageElement {

  private static final Logger LOGGER = LoggerFactory.getLogger(AkiraDatePicker.class);

  public AkiraDatePicker(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public AkiraDatePicker(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  @FindBy(xpath = "//*[contains(@id,'headlessui-popover-panel')]")
  public PageElement datePanel;

  public void setDate(String value) {
    final String day = String.valueOf(Integer.parseInt(value.substring(8, 10)));
    final String DATE_PICKER_XPATH = "//time[text()='%s']";
    List<WebElement> datePicker = findElementsByXpath(f(DATE_PICKER_XPATH, day));

    if (!datePicker.isEmpty()) {
      WebElement lastElement = datePicker.get(datePicker.size() - 1);
      lastElement.click();
      LOGGER.info("Date selected " + value);
    }
  }

}
