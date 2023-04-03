package co.nvqa.operator_v2.selenium.page.all_shippers;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.PricingAndBillingForm;
import co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.SubShippersDefaultSettingsForm;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class ShipperCreatePageV2 extends SimpleReactPage<ShipperCreatePageV2> {

  static Logger LOGGER = getLogger(ShipperCreatePageV2.class);

  public ShipperCreatePageV2(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(name = "ctrl.basicForm")
  public BasicSettingsForm basicSettingsForm;

  @FindBy(name = "ctrl.marketplaceForm")
  public SubShippersDefaultSettingsForm subShippersDefaultSettingsForm;

  @FindBy(xpath = "//md-content[./form[@name='ctrl.billingForm']]")
  public PricingAndBillingForm pricingAndBillingForm;


  public static class BasicSettingsForm extends PageElement {

    public OperationalSettings operationalSettings;

    public BasicSettingsForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      operationalSettings = new OperationalSettings(webDriver, webElement);
    }

    public static String inputErrorMessageXpath = "//md-input-container[@name='%s']//div[contains(@class,'md-input-messages-animation')]//div";

    public static class OperationalSettings extends PageElement {

      public OperationalSettings(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
      }

      @FindBy(name = "trackingType")
      public MdSelect trackingType;
      @FindBy(id = "shipper-prefix")
      public TextBox shipperPrefix;


      public String getShipperPrefixError() {
        return getWebDriver().findElement(
            By.xpath(f(inputErrorMessageXpath, "shipper-prefix"))).getText();
      }

      public String getShipperPrefixError(String index) {
        return getWebDriver().findElement(
            By.xpath(f(inputErrorMessageXpath, f("shipper-prefix-%s", index)))).getText();
      }

      public TextBox getShipperPrefix(String index) {
        WebElement shipperPrefixWebElement = getWebDriver().findElement(
            By.id(f("shipper-prefix-%s", index)));
        return new TextBox(webDriver, shipperPrefixWebElement);
      }
    }


  }
}
