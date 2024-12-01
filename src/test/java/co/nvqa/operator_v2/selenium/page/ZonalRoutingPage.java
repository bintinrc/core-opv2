package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ZonalRoutingPage extends SimpleReactPage<ZonalRoutingPage> {

  @FindBy(css = "[data-testid='edit-routes-testid.update-routes']")
  public Button updateRoutes;

  @FindBy(css = "[data-testid='edit-routes-testid.res-flag.true']")
  public Button resequencedTrueYes;

  @FindBy(css = "[data-testid='edit-routes-testid.save-changes-button']")
  public Button saveChanges;

  @FindBy(xpath = "//div[./div/div/span[contains(.,'Route ')]]")
  public List<RoutePanel> routePanels;

  public ZonalRoutingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class RoutePanel extends PageElement {

    @FindBy(xpath = ".//span[contains(.,'Route ')]")
    public PageElement title;

    @FindBy(css = "[data-testid*='edit-routes-testid.add-nps']")
    public Button addNps;

    @FindBy(css = "div[draggable]")
    public List<OrderPanel> orderPanels;

    public RoutePanel(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public RoutePanel(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }
  }

  public static class OrderPanel extends PageElement {

    @FindBy(xpath = ".//label[contains(.,'WP ID')]")
    public PageElement wpId;

    @FindBy(css = "[data-pa-label='Unroute Waypoint']")
    public PageElement unrouteWaypoint;

    public OrderPanel(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public OrderPanel(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }

  }
}