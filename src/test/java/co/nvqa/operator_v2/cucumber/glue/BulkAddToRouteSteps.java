package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.RouteGroup;
import co.nvqa.operator_v2.selenium.page.BulkAddToRoutePage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebElement;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class BulkAddToRouteSteps extends AbstractSteps {

  private BulkAddToRoutePage bulkAddToRoutePage;

  public BulkAddToRouteSteps() {
  }

  @Override
  public void init() {
    bulkAddToRoutePage = new BulkAddToRoutePage(getWebDriver());
  }

  @When("^Operator choose route group, select tag \"([^\"]*)\" and submit$")
  public void submitOnAddParcelToRoute(String tag) {
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);
    takesScreenshot();
    bulkAddToRoutePage.selectCurrentDate();
    takesScreenshot();
    bulkAddToRoutePage.selectRouteGroup(routeGroup.getName());
    takesScreenshot();
    bulkAddToRoutePage
        .unselectTag("FLT"); //Un-select tag FLT. Tag FLT is default tag on this page on QA - SG.
    takesScreenshot();
    bulkAddToRoutePage.selectTag(tag);
    takesScreenshot();
    bulkAddToRoutePage.clickSubmit();
    takesScreenshot();
  }

  @Then("^Operator verify parcel added to route$")
  public void verifyParcelAddedToRoute() {
    String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String xpath = f("//td[contains(@class, 'tracking_id') and contains(text(), '%s')]",
        expectedTrackingId);
    takesScreenshot();
    WebElement actualTrackingId = bulkAddToRoutePage.findElementByXpath(xpath);
    Assertions.assertThat(actualTrackingId.getText()).as("Order did not added to route.")
        .isEqualTo(expectedTrackingId);
  }
}
