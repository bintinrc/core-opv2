package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.stream.Stream;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShipmentWeightDimensionTablePage extends SimpleReactPage<ShipmentWeightDimensionTablePage> {

  private static final Logger LOGGER = LoggerFactory
      .getLogger(ShipmentWeightDimensionTablePage.class);
  @FindBy(xpath = "//button[strong[text()='Back to Main']]")
  public Button backButton;
  @FindBy(xpath = "//button[span[contains(text(),'Sum up')]]")
  public Button sumUpButton;
  @FindBy(xpath = "//div[contains(@class,'ant-table-body')]//table")
  public NvTable<ShipmentWeightRow> shipmentWeightNvTable;

  @FindBy(xpath = "//input[@aria-label='input-shipment_id']")
  public PageElement shipmentIdFilter;
  @FindBy(xpath = "//input[@aria-label='input-status']")
  public PageElement statusFilter;
  @FindBy(xpath = "//input[@aria-label='input-destination_hub_name']")
  public PageElement endHubFilter;
  @FindBy(xpath = "//input[@aria-label='input-_createdAt']")
  public PageElement shipmentCreationDateTimeFilter;
  @FindBy(xpath = "//input[@aria-label='input-_mawb']")
  public PageElement mawbFilter;
  @FindBy(xpath = "//input[@aria-label='input-_comments']")
  public PageElement commentsFilter;
  @FindBy(xpath = "//input[@aria-label='input-origin_hub_name']")
  public PageElement startHubFilter;
  @FindBy(xpath = "//input[@aria-label='input-shipment_type']")
  public PageElement shipmentTypeFilter;

  public enum Column {
    INITIAL("initial"),
    SEARCH_VALID("search_valid"),
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



  public ShipmentWeightDimensionTablePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void filterColumn()


  public static class ShipmentWeightRow extends NvTable.NvRow {

    @FindBy(xpath = "//td[contains(@class,'ant-table-cell index')]")
    public PageElement index;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell shipment-id')]")
    public PageElement shipmentId;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell status')]")
    public PageElement status;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell destination-hub-name')]")
    public PageElement destinationHub;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell created-at')]")
    public PageElement createdAt;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell mawb')]")
    public PageElement mawb;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell weight')]")
    public PageElement weight;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell length')]")
    public PageElement length;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell width')]")
    public PageElement width;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell height')]")
    public PageElement height;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell kgv')]")
    public PageElement kgv;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell no-of-parcels')]")
    public PageElement noOfParcels;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell comments')]")
    public PageElement comments;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell origin-hub-name')]")
    public PageElement originHubName;
    @FindBy(xpath = "//td[contains(@class,'ant-table-cell shipmentType')]")
    public PageElement shipmentType;

    public ShipmentWeightRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public ShipmentWeightRow(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }


  }
}
