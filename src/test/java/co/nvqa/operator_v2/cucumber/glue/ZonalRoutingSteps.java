package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ZonalRoutingPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ZonalRoutingSteps extends AbstractSteps {

  private ZonalRoutingPage page;

  public ZonalRoutingSteps() {
  }

  @Override
  public void init() {
    page = new ZonalRoutingPage(getWebDriver());
  }

  @When("Operator verify waypoint is displayed on Edit Routes page:")
  public void verifyEditOrders(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      String routeId = finalData.get("routeId");
      var routePanel = page.routePanels.stream()
          .filter(panel -> StringUtils.contains(panel.title.getText(), routeId))
          .findFirst()
          .orElseThrow(() -> new AssertionError("Route " + routeId + " is not displayed"));
      String waypointId = finalData.get("waypointId");
      routePanel.orderPanels.stream()
          .filter(panel -> StringUtils.contains(panel.wpId.getText(), waypointId))
          .findFirst()
          .orElseThrow(() -> new AssertionError("Waypoint " + waypointId + " is not displayed"));
    });
  }

  @When("Operator move waypoint {value} to route {value} on Edit Routes page")
  public void moveWaypoint(String waypointId, String routeId) {
    page.inFrame(() -> {
      var routePanel = page.routePanels.stream()
          .filter(panel -> StringUtils.contains(panel.title.getText(), routeId))
          .findFirst()
          .orElseThrow(() -> new AssertionError("Route " + routeId + " is not displayed"));
      var orderPanel = page.routePanels.stream()
          .flatMap(rp -> rp.orderPanels.stream())
          .filter(panel -> StringUtils.contains(panel.wpId.getText(), waypointId))
          .findFirst()
          .orElseThrow(() -> new AssertionError("Waypoint " + waypointId + " is not displayed"));
      orderPanel.unrouteWaypoint.click();
      routePanel.addNps.click();
    });
  }

  @When("Operator click Update Routes on Edit Routes page")
  public void clickUpdateRoutes() {
    page.inFrame(() -> page.updateRoutes.click());
  }

  @When("Confirm changes on Edit Routes page")
  public void confirmChanges() {
    page.inFrame(() -> {
      page.resequencedTrueYes.click();
      page.saveChanges.click();
    });
  }

}