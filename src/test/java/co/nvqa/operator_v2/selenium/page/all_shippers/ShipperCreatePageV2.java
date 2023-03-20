package co.nvqa.operator_v2.selenium.page.all_shippers;

import co.nvqa.operator_v2.selenium.page.SimpleReactPage;

import org.openqa.selenium.WebDriver;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class ShipperCreatePageV2 extends SimpleReactPage<ShipperCreatePageV2> {

  static Logger LOGGER = getLogger(ShipperCreatePageV2.class);

  public ShipperCreatePageV2(WebDriver webDriver) {
    super(webDriver);
  }

}
