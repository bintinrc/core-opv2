package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.selenium.elements.mm.AntConfirmModal;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
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

  @FindBy(css = "[data-testid='bill-number-update-button']")
  public Button updateMawbBtn;

  @FindBy(xpath = "//div[contains(@class,'ant-table-body')]//table")
  public NvTable<ShipmentWeightUpdateMawbTableRow> shipmentWeightNvTable;

  @FindBy(css = ".ant-modal-confirm")
  public AntConfirmModal confirmSameMawbDialog;


  public static class ShipmentWeightUpdateMawbTableRow extends NvTable.NvRow {

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell index')]")
    public PageElement index;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell shipment-id')]")
    public PageElement shipmentId;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell weight')]")
    public PageElement weight;

    //not capturing all columns


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
