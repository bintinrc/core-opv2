package co.nvqa.operator_v2.selenium.page.all_shippers;

import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class AllShippersPageV2 extends SimpleReactPage<AllShippersPageV2> {

  static Logger LOGGER = getLogger(ShipperCreatePageV2.class);

  public AllShippersPageV2(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(name = "container.shippers.create-shipper")
  public NvIconTextButton createShipper;
}

