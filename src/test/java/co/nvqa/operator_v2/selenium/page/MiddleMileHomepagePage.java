package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.mm.model.persisted_class.HubShipmentSummaries;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Indah Puspita
 */

public class MiddleMileHomepagePage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(MiddleMileHomepagePage.class);

  public MiddleMileHomepagePage(WebDriver webDriver) {
    super(webDriver);
  }

  private static final String MY_HUB_TEXT_XPATH = "//div[contains(text(),'My Hub')]";
  private static final String CURRENT_HUB_VALUE_TEXT_XPATH = "//div[contains(@data-testid,'current-hub-value')]";
  private static final String SET_MY_HUB_BUTTON_XPATH = "//button[.='Set My Hub']";
  private static final String SET_MY_HUB_POPUP_XPATH = "//div[@class='ant-modal-title' and contains(text(),'Set My Hub')]";
  private static final String TO_START_TEXT_XPATH = "//span[contains(text(),'To start, please select your hub')]";
  private static final String VIEW_MM_HOMEPAGE_TRAINING_DOCS_TEXT_XPATH = "//u[contains(text(),'View Middle Mile Homepage Training Doc')]";
  private static final String GLOBAL_DIV_CONTAINS_TEXT_XPATH = "//div[.='%s']";
  private static final String COLUMN_HEADER_XPATH = "//table//th[contains(@class,'%s')]";
  private static final String COLUMN_HEADER_CARET_DOWN_XPATH = "%s//span[@aria-label='caret-down' and contains(@class,'active')]";
  private static final String TABLE_DISPLAY_VALUE_XPATH = "//tr[@data-row-key='%d']/td[contains(@class,'%s')]";
  private static final String TABLE_DISPLAY_VALUE_BUTTON_XPATH = "//tr[@data-row-key='%d']/td[contains(@class,'%s')]//button";

  @FindBy(xpath = "//button[.='Set My Hub']")
  public Button setMyHub;

  @FindBy(xpath = "//input[@id='currentHub']")
  public TextBox selectHub;

  @FindBy(xpath = "//button[@data-testid='hub-selection-modal-confirm-button']/span")
  public Button hubSelectionConfirmButton;

  @FindBy(xpath = "//button[.='Manual Update']")
  public Button manualUpdate;

  @FindBy(xpath = "//button[.='Show Shipments']")
  public Button showShipments;

  @FindBy(xpath = "//div[text()='Total']/following-sibling::div")
  public PageElement shipmentTotalText;

  public void verifyMiddleMileHomepagePageItems() {
    waitUntilVisibilityOfElementLocated(SET_MY_HUB_BUTTON_XPATH);
    Assertions.assertThat(isElementVisible(MY_HUB_TEXT_XPATH, 5))
        .as("Set My Hub text appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(CURRENT_HUB_VALUE_TEXT_XPATH, 5))
        .as("Current Hub Value text appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(SET_MY_HUB_BUTTON_XPATH, 5))
        .as("Set My Hub button appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(TO_START_TEXT_XPATH, 5))
        .as("To start, please select your hub text appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(VIEW_MM_HOMEPAGE_TRAINING_DOCS_TEXT_XPATH, 5))
        .as("View Middle Mile Homepage Training Doc text appear in Middle Mile Homepage").isTrue();
  }

  public void verifySetMyHubPopUpIsShown() {
    waitUntilVisibilityOfElementLocated(SET_MY_HUB_POPUP_XPATH);
    Assertions.assertThat(isElementVisible(SET_MY_HUB_POPUP_XPATH, 5))
        .as("Set My Hub popup appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(selectHub.isDisplayed())
        .as("Select My Hub appear in Middle Mile Homepage popup").isTrue();
  }

  public void fillMyHub(Map<String, String> mapOfData) {
    String myHub = mapOfData.get("myHub");

    selectHub.click();
    selectHub.sendKeys(myHub);
    pause(1000);
    selectHub.sendKeys(Keys.ENTER);
  }

  public void verifiesShipmentsInMyHubSectionIsShown() {
    waitUntilVisibilityOfElementLocated(f(GLOBAL_DIV_CONTAINS_TEXT_XPATH, "Shipments in My Hub"));
    Assertions.assertThat(isElementVisible(MY_HUB_TEXT_XPATH, 5))
        .as("Set My Hub text appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(SET_MY_HUB_BUTTON_XPATH, 5))
        .as("Set My Hub button appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(manualUpdate.isDisplayed())
        .as("Manual Update button appear in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(f(GLOBAL_DIV_CONTAINS_TEXT_XPATH,
            "* Only shipments closed / at-transit in my hub in last 30 days."), 5))
        .as("Only shipments closed / at-transit in my hub in last 30 days. text is shown in Middle Mile Homepage")
        .isTrue();
    Assertions.assertThat(
            isElementVisible(f(GLOBAL_DIV_CONTAINS_TEXT_XPATH, "in-hub shipments to"), 5))
        .as("in-hub shipments to text is shown in Middle Mile Homepage").isTrue();
    Assertions.assertThat(isElementVisible(f(GLOBAL_DIV_CONTAINS_TEXT_XPATH,
            "Select Crossdock or Destination hubs (Max 100 selections)"), 5))
        .as("Select Crossdock or Destination hubs (Max 100 selections) text is shown in Middle Mile Homepage")
        .isTrue();
    Assertions.assertThat(showShipments.isDisplayed())
        .as("Show Shipments button appear in Middle Mile Homepage").isTrue();
  }

  public void verifyShipmentTotal(long dbShipmentsTotal) {
    Assertions.assertThat(Long.valueOf(shipmentTotalText.getText().trim()))
        .as(f("Shipment total is CORRECT: %d", dbShipmentsTotal))
        .isEqualTo(dbShipmentsTotal);
  }

  public void verifySortedDataByColumn(String column, List<HubShipmentSummaries> orderedHubShipmentSummaries) {
    String resolvedColumn;
    switch (column) {
      case "shipments_24h_48h_count" :
        resolvedColumn = "shipments-24-h-48-h-count";
        break;
      case "shipments_over_48h_count" :
        resolvedColumn = "shipments-over-48-h-count";
        break;
      default: resolvedColumn = column.replace("_", "-");
    }
    String columnXpath = f(COLUMN_HEADER_XPATH, resolvedColumn);
    String columnActiveCaretDownXpath = f(COLUMN_HEADER_CARET_DOWN_XPATH, columnXpath);

    while (true) {
      click(columnXpath);
      if(isElementExistFast(columnActiveCaretDownXpath)) {
        Assertions.assertThat(isElementExistFast(columnActiveCaretDownXpath))
            .as(f("Able to sort by %s", column))
            .isTrue();
        break;
      }
      pause(500);
    }
  }
}
