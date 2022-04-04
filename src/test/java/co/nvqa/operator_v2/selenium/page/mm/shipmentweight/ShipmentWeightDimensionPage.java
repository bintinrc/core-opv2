package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.mm.AntConfirmModal;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.stream.Stream;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class ShipmentWeightDimensionPage extends SimpleReactPage<ShipmentWeightDimensionPage> {

  // Add New Weight Dimension Section
  @FindBy(xpath = "//*[@class='ant-space-item'][1]/h4")
  public PageElement header;

  @FindBy(xpath = "//*[@class='ant-space-item'][2]/button")
  public AntButton newRecordBtn;

  // Load Shipments Weight Dimension Section
  @FindBy(xpath = "//h4[text()='Load Shipments Weight & Dimension']")
  public PageElement loadShipmentHeader;

  @FindBy(xpath = "//h4[text()='Select Search Filter']")
  public PageElement selectSearchFilter;

  @FindBy(xpath = "//h4[text()='Search by SID']")
  public PageElement searchBySID;

  @FindBy(xpath = "//div[@data-testid='shipmentCounter']")
  public PageElement shipmentCounter;

  @FindBy(xpath = "//button[@data-testid='search-by-sid-submit']")
  public Button searchButton;

  @FindBy(xpath = "//button[span[text()='Load Selection']]")
  public Button loadSelectionButton;

  @FindBy(id = "search-by-sid_searchIds")
  public PageElement sidsTextArea;

  @FindBy(id = "mawb")
  public PageElement mawbInput;

  @FindBy(className = "ant-modal-confirm")
  public AntConfirmModal searchErrorConfirmModal;

  public ShipmentWeightDimensionPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyAddNewWeightDimensionUI() {
    Assertions.assertThat(header.getText()).as("is header message correct").isEqualTo("Add New Weight & Dimension");
    Assertions.assertThat(newRecordBtn.isDisplayedFast()).as("is New Record button is visible").isTrue();
  }

  public void verifyLoadShipmentWeightUI(ShipmentWeightState uiState) {
    verifyLoadShipmentWeightUI(uiState, null);
  }

  public void verifyLoadShipmentWeightUI(ShipmentWeightState uiState, String numberOfShipments) {
    switch (uiState) {
      case INITIAL:
        Assertions.assertThat(loadShipmentHeader.isDisplayed()).as("Load Shipment Weight Dimension header is shown").isTrue();
        Assertions.assertThat(selectSearchFilter.isDisplayed()).as("Select Search Filter is shown").isTrue();
        Assertions.assertThat(searchBySID.isDisplayed()).as("Search by SID is shown").isTrue();
        Assertions.assertThat(sidsTextArea.isDisplayed()).as("Shipment ID text box is shown").isTrue();
        Assertions.assertThat(shipmentCounter.isDisplayed())
            .as("Shipment counter is shown ").isTrue();
        Assertions.assertThat(shipmentCounter.getText().trim()).as("Shipment counter show 0 entered").isEqualTo("0 entered");
        Assertions.assertThat(searchButton.isDisplayed()).as("Search button is shown").isTrue();
        Assertions.assertThat(searchButton.getAttribute("disabled")).as("Search button is disabled").isEqualTo("true");
        break;
      case SEARCH_VALID:
        Assertions.assertThat(shipmentCounter.getText().trim())
            .as("Shipment counter show %s entered", numberOfShipments)
            .isEqualTo("%s entered", numberOfShipments);
        Assertions.assertThat(searchButton.isEnabled()).as("Search button is enabled").isTrue();
        break;
      case DUPLICATE:
        Assertions.assertThat(shipmentCounter.getText().trim())
            .as("Shipment counter show %s entered (1 duplicate)", numberOfShipments)
            .isEqualTo("%s entered (1 duplicate)", numberOfShipments);
        Assertions.assertThat(searchButton.isEnabled()).as("Search button is enabled").isTrue();
    }
  }

  public void searchShipmentId(String shipmentId) {
    sidsTextArea.clear();
    sidsTextArea.sendKeys(shipmentId);
  }



  public ShipmentWeightDimensionAddPage openNewRecord() {
    newRecordBtn.click();
    ShipmentWeightDimensionAddPage addPage = new ShipmentWeightDimensionAddPage(this.webDriver);
    return addPage;
  }

  public enum ShipmentWeightState {
    INITIAL("initial"),
    SEARCH_VALID("search_valid"),
    DUPLICATE("duplicate"),
    ERROR("error");

    private final String value;

    ShipmentWeightState(String value) {
      this.value = value;
    }

    public static ShipmentWeightDimensionPage.ShipmentWeightState fromLabel(String label) {
      return Stream.of(ShipmentWeightDimensionPage.ShipmentWeightState.values())
          .filter(instance -> instance.value.equals(label))
          .findFirst()
          .orElse(INITIAL);
    }
  }

}
