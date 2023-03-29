package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.selenium.elements.mm.AntConfirmModal;
import co.nvqa.operator_v2.selenium.elements.mm.AntDateTimeRangePicker;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.time.ZonedDateTime;
import java.util.stream.Stream;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class ShipmentWeightDimensionPage extends SimpleReactPage<ShipmentWeightDimensionPage> {

  // Add New Weight Dimension Section
  @FindBy(xpath = "//*[@class='ant-space-item'][1]/h4")
  public PageElement header;

  @FindBy(xpath = "//button[span[.=' New Record']]")
  public AntButton newRecordBtn;

  // Load Shipments Weight Dimension Section
  @FindBy(xpath = "//h4[text()='Load Shipments Weight & Dimension']")
  public PageElement loadShipmentHeader;

  @FindBy(xpath = "//h4[.='Select Search Filter']")
  public PageElement selectSearchFilter;

  @FindBy(xpath = "//h4[.='Search by SID']")
  public PageElement searchBySID;

  @FindBy(css = "[data-testid='shipmentCounter']")
  public PageElement shipmentCounter;

  @FindBy(css = "[data-testid='search-by-sid-submit']")
  public Button searchButton;

  @FindBy(xpath = "//button[span[.='Load Selection']]")
  public Button loadSelectionButton;

  @FindBy(css = "[data-testid='enter-new-filter-button']")
  public Button newFilterToggleButton;

  @FindBy(css = "[data-testid='search-by-billing-number-button']")
  public Button searchByBillinNumberButton;

  @FindBy(id = "search-by-sid_searchIds")
  public PageElement sidsTextArea;

  @FindBy(id = "mawb")
  public PageElement mawbInput;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='presetFilter']]")
  public AntSelect presetFilterSelect;

  @FindBy(css = ".ant-picker.ant-picker-range")
  public AntDateTimeRangePicker creationDateTimeRange;

  @FindBy(css = ".ant-modal-confirm")
  public AntConfirmModal searchErrorConfirmModal;
  
  @FindBy(xpath = "//div[contains(@class, 'ant-form-item-explain-error')]")
  public PageElement duplicateNamePresetFilters;

  @FindBy(xpath = "//div[contains(@class, 'ant-message-custom-content ant-message-warning')]/span[2]")
  public PageElement clearPresetFilterPopup;

  // new filter
  @FindBy(css = "[data-testid='preset-clear-and-close-button']")
  public Button clearAndCloseButton;

  @FindBy(css = "[data-testid='preset-filter-delete-button']")
  public Button deletePresetButton;

  @FindBy(css = "[data-testid='preset-shipment-type-select']")
  public AntSelect shipmentTypeSelect;

  @FindBy(css = "[data-testid='preset-start-hub-select']")
  public AntSelect startHubSelect;

  @FindBy(css = "[data-testid='preset-end-hub-select']")
  public AntSelect endHubSelect;

  @FindBy(css = "[data-testid='preset-shipment-status-select']")
  public AntSelect shipmentStatusSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='shipment_type']]")
  public AntSelect disabledShipmentTypeSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='origin_hub']]")
  public AntSelect disabledStartHubSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='destination_hub']]")
  public AntSelect disabledEndHubSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='shipment_status']]")
  public AntSelect disabledShipmentStatusSelect;

  @FindBy(id = "is_create_new_filter")
  public CheckBox saveAsPresetCb;

  @FindBy(id = "new_preset_name")
  public PageElement presetName;

  @FindBy(xpath = "//div[@class=\"ant-empty-description\"]")
  public PageElement emptyDescription;

  @FindBy(xpath = "//input[@data-testid='column-search-field-shipment-id']")
  public TextBox shipmentIdSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-status']")
  public TextBox shipmentStatusSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-destination-hub-name']")
  public TextBox endHubSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-created-at']")
  public TextBox shipmentCreationDateTimeSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-comments']")
  public TextBox commentsSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-origin-hub-name']")
  public TextBox startHubSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-shipment-type']")
  public TextBox shipmentTypeSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-vendor-name']")
  public TextBox vendorSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-origin-port']")
  public TextBox originPortSearchField;

  @FindBy(xpath = "//input[@data-testid='column-search-field-destination-port']")
  public TextBox destinationPortSearchField;

  public ShipmentWeightDimensionPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyAddNewWeightDimensionUI() {
    Assertions.assertThat(header.getText()).as("is header message correct")
        .isEqualTo("Add New Weight & Dimension");
    Assertions.assertThat(newRecordBtn.isDisplayedFast()).as("is New Record button is visible")
        .isTrue();
  }

  public void verifyLoadShipmentWeightUI(ShipmentWeightState uiState) {
    verifyLoadShipmentWeightUI(uiState, null);
  }

  public void verifyLoadShipmentWeightUI(ShipmentWeightState uiState, String numberOfShipments) {
    switch (uiState) {
      case INITIAL:
        Assertions.assertThat(loadShipmentHeader.isDisplayed())
            .as("Load Shipment Weight Dimension header is shown").isTrue();
        Assertions.assertThat(selectSearchFilter.isDisplayed()).as("Select Search Filter is shown")
            .isTrue();
        Assertions.assertThat(searchBySID.isDisplayed()).as("Search by SID is shown").isTrue();
        Assertions.assertThat(sidsTextArea.isDisplayed()).as("Shipment ID text box is shown")
            .isTrue();
        Assertions.assertThat(shipmentCounter.isDisplayed())
            .as("Shipment counter is shown ").isTrue();
        Assertions.assertThat(shipmentCounter.getText().trim())
            .as("Shipment counter show 0 entered").isEqualTo("0 entered");
        Assertions.assertThat(searchButton.isDisplayed()).as("Search button is shown").isTrue();
        Assertions.assertThat(searchButton.getAttribute("disabled")).as("Search button is disabled")
            .isEqualTo("true");
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

  public void fillLoadShipmentFilter(String filterName, ZonedDateTime from,
      ZonedDateTime to) {
    if (filterName != null) {
      presetFilterSelect.selectValue(filterName);
    }

    if (from != null && to != null) {
      creationDateTimeRange.setDateRange(from, to);
    } else {
      creationDateTimeRange.clear();
    }
  }

  public void openNewRecord() {
    newRecordBtn.click();
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

  public void verifyAddNewWeightDimensionNewUI() {
    Assertions.assertThat(header.getText()).as("is header message correct")
            .isEqualTo("Add New Weight & Dimension");
    Assertions.assertThat(loadShipmentHeader.getText()).as("Load Shipments Weight & Dimension is shown")
            .isEqualTo("Load Shipments Weight & Dimension");
    Assertions.assertThat(selectSearchFilter.getText()).as("Select Search Filter is shown")
            .isEqualTo("Select Search Filter");
    Assertions.assertThat(searchBySID.getText()).as("Search by SID is shown")
            .isEqualTo("Search by SID");
    Assertions.assertThat(loadSelectionButton.getText()).as("Load Selection is shown")
            .isEqualTo("Load Selection");
    Assertions.assertThat(newRecordBtn.isDisplayed()).as("is New Record button is visible")
            .isTrue();
    Assertions.assertThat(shipmentCounter.isDisplayed()).as("Shipment counter is shown")
            .isTrue();
    Assertions.assertThat(searchButton.isDisplayed()).as("Search button is shown")
            .isTrue();
    Assertions.assertThat(newFilterToggleButton.isDisplayed()).as("New filter toggle button is shown")
            .isTrue();
    Assertions.assertThat(searchByBillinNumberButton.isDisplayed()).as("Search by Billing Number button is shown")
            .isTrue();
    Assertions.assertThat(sidsTextArea.isDisplayed()).as("SID text area is shown")
            .isTrue();
  }

}
