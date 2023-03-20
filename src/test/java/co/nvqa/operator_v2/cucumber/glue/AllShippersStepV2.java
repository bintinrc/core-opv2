package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.all_shippers.AllShippersPageV2;
import co.nvqa.operator_v2.selenium.page.all_shippers.ShipperCreatePageV2;
import io.cucumber.java.en.When;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AllShippersStepV2 extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersStepV2.class);
  AllShippersPageV2 allShippersPage;
  ShipperCreatePageV2 shipperCreatePage;


  @Override
  public void init() {
    allShippersPage = new AllShippersPageV2(getWebDriver());
    shipperCreatePage = new ShipperCreatePageV2(getWebDriver());
  }

  public AllShippersStepV2() {

  }

  @When("Operator click create new shipper button")
  public void operatorClickCreateNewShipper() {
    allShippersPage.createShipper.click();
  }

  @When("Operator switch to create new shipper tab")
  public void switchToCreateShipperTab() {
    String currentWindowHandle = allShippersPage.switchToNewWindow();
    getWebDriver().switchTo().window(currentWindowHandle);
  }

  @When("Operator select Fixed prefix type in shipper settings page")
  public void selectFixedPrefixType() {

  }

}
