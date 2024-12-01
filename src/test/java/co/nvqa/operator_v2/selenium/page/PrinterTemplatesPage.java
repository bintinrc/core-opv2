package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class PrinterTemplatesPage extends SimpleReactPage<PrinterTemplatesPage> {

  @FindBy(xpath = "//button[contains(@id,'headlessui-listbox-button')]")
  public Button selectTemplate;
  @FindBy(css = "[data-testid='label-template-section']")
  public PageElement labelTemplate;
  @FindBy(xpath = "//div[@data-testid='label-template-section']/following-sibling::div[2]")
  public PageElement labelTemplateContent;
  @FindBy(css = "[data-testid='template-fields-section']")
  public PageElement templatesFieldSection;
  @FindBy(css = "[data-testid='printer_x_offset-input']")
  public PageElement printerXOffset;
  @FindBy(css = "[data-testid='printer_y_offset-input']")
  public PageElement printerYOffset;
  @FindBy(css = "[data-testid='quantity-input']")
  public PageElement quantity;

  public PrinterTemplatesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectTemplate(String templateName) {
    selectTemplate.click();
    String templateValueXpath = "//li[@data-testid='select-template-item']//span[.='%s']";
    new PageElement(getWebDriver(), f(templateValueXpath, templateName)).click();
  }

  public void verifyTemplateIsLoadedAndAllNeededFieldsIsShownOnRightPanel() {
    Assertions.assertThat(labelTemplate).as("Label template not loaded.").isNotNull();
    Assertions.assertThat(templatesFieldSection).as("Label template not loaded.").isNotNull();
    Assertions.assertThat(printerYOffset.getAttribute("value")).as("printer y offset").isNotEmpty();
    Assertions.assertThat(printerXOffset.getAttribute("value")).as("printer x offset").isNotEmpty();
    Assertions.assertThat(quantity.getAttribute("value")).as("quantity input").isNotEmpty();
  }
}
