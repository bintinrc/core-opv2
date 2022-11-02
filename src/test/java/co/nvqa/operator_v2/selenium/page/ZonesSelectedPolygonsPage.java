package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvAssertions;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.CheckSquare;
import co.nvqa.operator_v2.selenium.page.ZonesPage.AddZoneDialog;
import co.nvqa.operator_v2.selenium.page.ZonesPage.EditZoneDialog;
import com.epam.ta.reportportal.ws.model.Page;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ZonesSelectedPolygonsPage extends SimpleReactPage {

  private static final String POLYGON_VERTEX_COUNT_XPATH = "//span[@class='vertex-count']";
  private static final String POLYGON_ZONE_TOOLBAR_XPATH = "//div[@class='toolbar-content']//div[contains(@class,'%s')]";
  private static final String POLYGON_ZONE_ID_XPATH = "//div[@data-testid='zone-info-%d']";
  private static final String POLYGON_ZONE_NAME_XPATH = "//div[@title='%s']";
  private static final String POLYGON_CONFIRMATION_ZONES_XPATH = "//div[contains(@class,'edit-zone-save-confirmation')]//li";

  @FindBy(xpath = "//iframe")
  public PageElement pageFrame;

  @FindBy(className = "ant-modal-wrap")
  public EditZoneDialog setZoneCoordinateDialog;

  @FindBy(css = "div.ant-list:nth-of-type(1)")
  public ZonesPanel zonesPanel;

  @FindBy(css = "div.ant-list:nth-of-type(4)")
  public ZonesPanel zonesRTSPanel;

  @FindBy(css = "input[placeholder='Find zones by name']")
  public TextBox findZonesInput;

  @FindBy(css = "div.zone-selection-row")
  public List<ZoneSelectionRow> zoneSelectionRows;

  @FindBy(xpath = "//div[@class='toolbar']")
  public PageElement sideToolbar;

  @FindBy(xpath = "//strong[@data-testid='zone-drawing-title']")
  public PageElement zoneDrawingHeader;

  @FindBy(xpath = "//button[@data-testid='zone-drawing-save-button']")
  public Button saveZoneDrawingButton;

  @FindBy(xpath = "//div[@class='ant-modal-title' and text()='Save Confirmation']")
  public PageElement saveConfirmationDialog;

  @FindBy(xpath = "//div[@class='ant-modal-footer']//span[@aria-label='check']/parent::button")
  public PageElement saveConfirmationDialogSaveButton;

  @FindBy(xpath = ".//button[.//*[@data-icon='map-marker-alt']]")
  public PageElement setCoordinate;

  @FindBy(xpath = ".//button[.//*[@data-icon='plus']]")
  public Button createZonePolygon;

  @FindBy(xpath = "//span[@class='vertex-count']")
  public PageElement vertexcount;

  public ZonesSelectedPolygonsPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    inFrame((Runnable) this::waitUntilLoaded);
  }

  public boolean isKmlFileReadCorrectly() {
    List<WebElement> vertexCounts = findElementsByXpath(POLYGON_VERTEX_COUNT_XPATH);
    return vertexCounts.stream()
        .map(v -> v.getText().equals("0") ? 0 : 1)
        .reduce(0, Integer::sum)
        .equals(vertexCounts.size());
  }

  public boolean hasZonesListed(List<Long> ids, List<String> names) {
    for (int i = 0; i < ids.size(); i++) {
      boolean isRts = names.get(i).startsWith("RTS");
      String zoneInfoXpath = String.format(POLYGON_ZONE_ID_XPATH + POLYGON_ZONE_NAME_XPATH,
          ids.get(i), names.get(i));
      String completeZoneInfoXpath =
          String.format(POLYGON_ZONE_TOOLBAR_XPATH, isRts ? "rts" : "standard") + zoneInfoXpath;

      Assertions.assertThat(isElementExist(completeZoneInfoXpath))
          .as(String.format("Zone %s (id: %d) is listed in %s zones section", names.get(i),
              ids.get(i), isRts ? "RTS" : "Standard"))
          .isTrue();
    }

    return true;
  }

  public boolean hasZonesListedInSaveConfirmationDialog(List<String> names) {
    return findElementsByXpath(POLYGON_CONFIRMATION_ZONES_XPATH).stream()
        .map(WebElement::getText)
        .collect(Collectors.toList())
        .containsAll(names);
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
