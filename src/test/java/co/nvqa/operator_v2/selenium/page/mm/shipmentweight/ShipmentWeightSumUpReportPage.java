package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.elements.mm.AntConfirmModal;
import co.nvqa.operator_v2.selenium.elements.mm.AntNotice;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class ShipmentWeightSumUpReportPage extends SimpleReactPage<ShipmentWeightSumUpReportPage> {

  @FindBy(css = "[data-testid='sumup-report-title']")
  public PageElement sumUpReportTitle;

  @FindBy(css = "[data-testid='download-full-report-button']")
  public Button downloadFullReportBtn;

  @FindBy(xpath = "//button[.//span[contains(text(), 'Update Billing Number')]]")
  public Button updateBillingNumberBtn;

  @FindBy(xpath = "//div[contains(text(),'What type of billing number to update')]")
  public PageElement selectBillingNumberTypeDialog;

  @FindBy(xpath = "//input[@type='radio' and @value='MAWB']")
  public CheckBox mawbBillingNumberRadio;

  @FindBy(xpath = "//input[@type='radio' and @value='SWB']")
  public CheckBox swbBillingNumberRadio;

  @FindBy(xpath = "//input[@type='radio' and @value='BOTH']")
  public CheckBox bothBillingNumberRadio;

  @FindBy(xpath = "//button[@data-testid='continue-update-billing']")
  public Button continueUpdateBillingBtn;

  @FindBy(css = "[data-testid='back-to-all-records-button']")
  public Button backToAllRecordsBtn;

  @FindBy(css = "[data-testid='showing-x-report-section']")
  public PageElement showingXReportText;

  @FindBy(xpath = "//div[@class='ant-message-notice']")
  public AntNotice notice;


  @FindBy(css = ".ant-modal-confirm")
  public AntConfirmModal confirmDeleteModal;

  @FindBy(css = "[data-testid='select-all']")
  public CheckBox selectAllCheckbox;

  @FindBy(xpath = "//span[@data-testid='column-title-selection']//input")
  public CheckBox selectAllOnTableCheckbox;

  @FindBy(xpath = "//div[contains(@class,'ant-table-body')]//table")
  public NvTable<ShipmentSumUpReport> shipmentSumUpReportNvTable;

  @FindBy(xpath = "//div[contains(@data-testid, '-detail-section')]//div[contains(@class, 'ant-col')][1]")
  public PageElement endHubSection;

  @FindBy(xpath = "//div[contains(@data-testid, '-detail-section')]//div[contains(@class, 'ant-col')][2]")
  public PageElement totalShipmentSection;

  @FindBy(xpath = "//div[contains(@data-testid, '-detail-section')]//div[contains(@class, 'ant-col')][3]")
  public PageElement totalWeightSection;

  @FindBy(xpath = "//div[contains(@data-testid, '-detail-section')]//div[contains(@class, 'ant-col')][4]")
  public PageElement totalKgvSection;

  @FindBy(xpath = "//div[contains(@data-testid, '-detail-section')]//div[contains(@class, 'ant-col')][5]")
  public PageElement totalParcelsSection;


  public ShipmentWeightSumUpReportPage(WebDriver webDriver) {
    super(webDriver);
  }

  public String findValueFromSection(PageElement section) {
    return section.findElement(By.xpath("./strong")).getText();
  }

  public static class ShipmentSumUpReport extends NvTable.NvRow {


    @FindBy(xpath = "./td[contains(@class,'ant-table-cell remove')]")
    public PageElement remove;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell shipment-id')]")
    public PageElement shipmentId;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell weight')]")
    public PageElement weight;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell kgv')]")
    public PageElement kgv;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell length')]")
    public PageElement length;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell height')]")
    public PageElement height;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell no-of-parcels')]")
    public PageElement noOfParcels;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell status')]")
    public PageElement status;

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell billing-number')]")
    public PageElement mawb;

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell billing-number')]")
    public PageElement billingNumber;

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell vendor-name')]")
    public PageElement vendor;

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell origin-port')]")
    public PageElement originPort;

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell destination-port')]")
    public PageElement destinationPort;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell comments')]")
    public PageElement comments;

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell selection')]")
    public PageElement selection;

    public ShipmentSumUpReport(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public ShipmentSumUpReport(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
    }
  }


}
