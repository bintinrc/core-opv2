package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.selenium.elements.mm.AntConfirmModal;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class ShipmentWeightDimensionUpdateMawbPage  extends SimpleReactPage<ShipmentWeightDimensionUpdateMawbPage> {

  public ShipmentWeightDimensionUpdateMawbPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "[data-testid='go-back-button']")
  public Button backButton;

  @FindBy(xpath = "//*[@class='ant-table-footer']//h4")
  public PageElement pageTitle;

  @FindBy(css="[data-testid='airway-bill-number']")
  public PageElement mawbInput;

  @FindBy(xpath = "//div[.//input[@data-testid='airway-bill-number'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement mawbErrorInfo;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='UpdateBillNumberForm_airhaul_vendor_id']]")
  public AntSelect vendorSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='UpdateBillNumberForm_origin_airport_id']]")
  public AntSelect originAirportSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='UpdateBillNumberForm_destination_airport_id']]")
  public AntSelect destAirportSelect;

  @FindBy(css = "[data-testid='seaway-bill-number']")
  public PageElement swbInput;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='UpdateBillNumberForm_seahaul_vendor_id']]")
  public AntSelect seahaulVendorSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='UpdateBillNumberForm_origin_seaport_id']]")
  public AntSelect originSeaportSelect;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='UpdateBillNumberForm_destination_seaport_id']]")
  public AntSelect destinationSeaportSelect;

  @FindBy(xpath = "//div[.//input[@data-testid='seaway-bill-number'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement swbErrorInfo;

  @FindBy(xpath = "//div[.//input[@id='UpdateBillNumberForm_seahaul_vendor_id'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement emptySeaportVendorErrorInfo;

  @FindBy(xpath = "//div[.//input[@id='UpdateBillNumberForm_origin_seaport_id'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement emptyOriginSeaportErrorInfo;

  @FindBy(xpath = "//div[.//input[@id='UpdateBillNumberForm_destination_seaport_id'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement emptyDestinationSeaportErrorInfo;

  @FindBy(xpath = "//div[@data-testid='seahaul-vendor-select']//span[@class='ant-select-clear']")
  public Button clearSeahaulVendorButton;

  @FindBy(xpath = "//div[@data-testid='origin-seaport-select']//span[@class='ant-select-clear']")
  public Button clearOriginSeaportButton;

  @FindBy(xpath = "//div[@data-testid='destination-seaport-select']//span[@class='ant-select-clear']")
  public Button clearDestinationSeaportButton;

  @FindBy(xpath = "//div[@data-testid='airhaul-vendor-select']//span[@class='ant-select-clear']")
  public Button clearAirhaulVendorButton;

  @FindBy(xpath = "//div[@data-testid='origin-airport-select']//span[@class='ant-select-clear']")
  public Button clearOriginAirportButton;

  @FindBy(xpath = "//div[@data-testid='destination-airport-select']//span[@class='ant-select-clear']")
  public Button clearDestinationAirportButton;

  @FindBy(css = "[data-testid='bill-number-update-button']")
  public Button updateMawbBtn;

  @FindBy(xpath = "//div[contains(@class,'ant-table-body')]//table")
  public NvTable<ShipmentWeightUpdateMawbTableRow> shipmentWeightNvTable;

  @FindBy(css = ".ant-modal-confirm")
  public AntConfirmModal confirmSameMawbDialog;

  private static final String UPDATE_BILL_NUMBER_INPUT_FIELD = ".//input[@data-testid='%s']";
  private static final String UPDATE_BILL_NUMBER_DROPDOWN_FIELD = "//div[contains(@class, ' ant-select')][.//input[@id='%s']]";

  public void hoverUpdateBillNumberField(String billNumberField) {
    switch (billNumberField) {
      case "SWB Number":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_INPUT_FIELD, "seaway-bill-number"));
        break;
      case "Sea Haul Vendor":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_DROPDOWN_FIELD, "UpdateBillNumberForm_seahaul_vendor_id"));
        break;
      case "Origin Seaport":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_DROPDOWN_FIELD, "UpdateBillNumberForm_origin_seaport_id"));
        break;
      case "Destination Seaport":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_DROPDOWN_FIELD, "UpdateBillNumberForm_destination_seaport_id"));
        break;
      case "MAWB Number":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_INPUT_FIELD, "airway-bill-number"));
        break;
      case "Air Haul Vendor":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_DROPDOWN_FIELD, "UpdateBillNumberForm_airhaul_vendor_id"));
        break;
      case "Origin Airport":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_DROPDOWN_FIELD, "UpdateBillNumberForm_origin_airport_id"));
        break;
      case "Destination Airport":
        moveToElementWithXpath(f(UPDATE_BILL_NUMBER_INPUT_FIELD, "UpdateBillNumberForm_destination_airport_id"));
        break;
    }
  }

  public static class ShipmentWeightUpdateMawbTableRow extends NvTable.NvRow {

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell index')]")
    public PageElement index;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell shipment-id')]")
    public PageElement shipmentId;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell weight')]")
    public PageElement weight;



    public ShipmentWeightUpdateMawbTableRow(WebDriver webDriver,
        WebElement webElement) {
      super(webDriver, webElement);
    }

    public ShipmentWeightUpdateMawbTableRow(WebDriver webDriver,
        SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }
  }






}
