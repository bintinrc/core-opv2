package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.CheckSquare;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ZonesSelectedPolygonsPage extends SimpleReactPage {

  @FindBy(css = "div.ant-list:nth-of-type(1)")
  public ZonesPanel zonesPanel;

  @FindBy(css = "input[placeholder='Find zones by name']")
  public TextBox findZonesInput;

  @FindBy(css = "div.zone-selection-row")
  public List<ZoneSelectionRow> zoneSelectionRows;

  public ZonesSelectedPolygonsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    inFrame((Runnable) this::waitUntilLoaded);
  }

  public static class ZonesPanel extends PageElement {

    @FindBy(xpath = ".//button[.//*[@data-icon='times']]")
    public Button clearAll;

    @FindBy(css = "li.ant-list-item")
    public List<PanelItem> zones;

    public ZonesPanel(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class PanelItem extends PageElement {

    @FindBy(css = "div.name")
    public PageElement name;

    @FindBy(xpath = ".//button[.//*[@data-icon='times']]")
    public Button delete;

    public PanelItem(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }
  }

  public static class ZoneSelectionRow extends PageElement {

    @FindBy(css = "div:nth-of-type(1) > svg")
    public CheckSquare checkbox;

    @FindBy(css = "div:nth-of-type(2)")
    public PageElement name;

    public ZoneSelectionRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
