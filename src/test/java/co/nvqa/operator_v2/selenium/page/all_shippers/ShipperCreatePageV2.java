package co.nvqa.operator_v2.selenium.page.all_shippers;

import co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.BasicSettingsForm;
import co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.PricingAndBillingForm;
import co.nvqa.operator_v2.selenium.page.AllShippersCreateEditPage.SubShippersDefaultSettingsForm;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
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
}
