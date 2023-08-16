package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.commons.model.core.hub.Shipment;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.Locale;
import java.util.stream.Stream;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShipmentWeightDimensionTablePage extends
    SimpleReactPage<ShipmentWeightDimensionTablePage> {

  private static final Logger LOGGER = LoggerFactory
      .getLogger(ShipmentWeightDimensionTablePage.class);
  @FindBy(xpath = "//button[strong[text()='Back to Main']]")
  public Button backButton;

  @FindBy(xpath = "//button[@data-testid='back-to-main-button']")
  public Button backToMainButton;

  @FindBy(xpath = "//button[span[contains(text(),'Sum up')]]")
  public Button sumUpButton;

  @FindBy(xpath = "//button[span[contains(text(),'Update Billing Number')]]")
  public Button updateBillingNumberButton;
  @FindBy(xpath = "//div[contains(@class,'ant-table-body')]//table")
  public NvTable<ShipmentWeightRow> shipmentWeightNvTable;
  @FindBy(xpath = "//div/b[contains(text(), 'Showing')]")
  public PageElement resultCounterText;

  @FindBy(xpath = "//input[@aria-label='input-shipment_id']")
  public PageElement shipmentIdFilter;
  @FindBy(xpath = "//input[@aria-label='input-status']")
  public PageElement statusFilter;
  @FindBy(xpath = "//input[@aria-label='input-destination_hub_name']")
  public PageElement endHubFilter;
  @FindBy(xpath = "//input[@aria-label='input-_createdAt']")
  public PageElement shipmentCreationDateTimeFilter;
  @FindBy(xpath = "//input[@aria-label='input-_billing_number']")
  public PageElement billingNumberFilter;
  @FindBy(xpath = "//input[@aria-label='input-_comments']")
  public PageElement commentsFilter;
  @FindBy(xpath = "//input[@aria-label='input-origin_hub_name']")
  public PageElement startHubFilter;
  @FindBy(xpath = "//input[@aria-label='input-shipment_type']")
  public PageElement shipmentTypeFilter;
  @FindBy(xpath = "//th[contains(@class,'selection')]//input")
  public CheckBox selectAllCheckbox;


  public ShipmentWeightDimensionTablePage(WebDriver webDriver) {
    super(webDriver);
  }

  private PageElement filterColumn(Column filterColumn) {
    PageElement pe = null;
    switch (filterColumn) {
      case SHIPMENT_ID:
        pe = shipmentIdFilter;
        break;
      case STATUS:
        pe = statusFilter;
        break;
      case END_HUB:
        pe = endHubFilter;
        break;
      case CREATION_DATE:
        pe = shipmentCreationDateTimeFilter;
        break;
      case COMMENTS:
        pe = commentsFilter;
        break;
      case START_HUB:
        pe = startHubFilter;
        break;
      case BILLING_NUMBER:
        pe = billingNumberFilter;
        break;
      case SHIPMENT_TYPE:
        pe = shipmentTypeFilter;
        break;
    }
    return pe;
  }

  private String getFilterValueByColumn(Column col, co.nvqa.common.mm.model.Shipment shipmentData) {
    String filterValue = "";
    switch (col) {
      case BILLING_NUMBER:
        filterValue = shipmentData.getMawb();
        break;
      case STATUS:
        filterValue = shipmentData.getStatus().toUpperCase(Locale.ROOT);
        break;
      case END_HUB:
        filterValue = shipmentData.getDestHubName();
        break;
      case START_HUB:
        filterValue = shipmentData.getOrigHubName();
        break;
      case SHIPMENT_ID:
        filterValue = shipmentData.getId().toString();
        break;
      case COMMENTS:
        filterValue = shipmentData.getComments();
        break;
      case SHIPMENT_TYPE:
        filterValue = shipmentData.getShipmentType();
        break;
      case CREATION_DATE:
        filterValue = DateUtil.displayOperatorTime(shipmentData.getCreatedAt(), true);
        LOGGER.debug("Filter value is: " + filterValue);
        break;
    }
    return filterValue;
  }

  private String getFilterValueByColumn(Column col, Shipment shipmentData) {
    String filterValue = "";
    switch (col) {
      case BILLING_NUMBER:
        filterValue = shipmentData.getMawb();
        break;
      case STATUS:
        filterValue = shipmentData.getStatus().toUpperCase(Locale.ROOT);
        break;
      case END_HUB:
        filterValue = shipmentData.getDestHubName();
        break;
      case START_HUB:
        filterValue = shipmentData.getOrigHubName();
        break;
      case SHIPMENT_ID:
        filterValue = shipmentData.getId().toString();
        break;
      case COMMENTS:
        filterValue = shipmentData.getComments();
        break;
      case SHIPMENT_TYPE:
        filterValue = shipmentData.getShipmentType();
        break;
      case CREATION_DATE:
        filterValue = DateUtil.displayOperatorTime(shipmentData.getCreatedAt(), true);
        LOGGER.debug("Filter value is: " + filterValue);
        break;
    }
    return filterValue;
  }

  public void filterColumn(Column col, Shipment shipmentData) {
    String filterValue = getFilterValueByColumn(col, shipmentData);
    if (filterValue != null && !filterValue.isEmpty()) {
      filterColumn(col, filterValue);
    }
  }

  public void filterColumn(Column col, co.nvqa.common.mm.model.Shipment shipmentData) {
    String filterValue = getFilterValueByColumn(col, shipmentData);
    if (filterValue != null && !filterValue.isEmpty()) {
      filterColumn(col, filterValue);
    }
  }

  public void filterColumn(Column col, String filterValue) {
    PageElement pe = filterColumn(col);
    scrollAndClear(pe);
    pe.sendKeys(filterValue);
  }

  public void clearFilterColumn(Column col) {
    PageElement pe = filterColumn(col);
    scrollAndClear(pe);
  }

  public void clearFilters() {
    scrollAndClear(shipmentIdFilter);
    scrollAndClear(statusFilter);
    scrollAndClear(endHubFilter);
    scrollAndClear(shipmentCreationDateTimeFilter);
    scrollAndClear(billingNumberFilter);
    scrollAndClear(commentsFilter);
    scrollAndClear(startHubFilter);
    scrollAndClear(shipmentTypeFilter);
  }

  public void selectSomeRows(int numOfRows) {
    if (numOfRows > shipmentWeightNvTable.rows.size()-1) {
      throw new NvTestRuntimeException("Number of rows less than the requested");
    }

    shipmentWeightNvTable.rows.subList(0, numOfRows).forEach( row -> {
      row.selectCheckbox.check();
    });
  }

  /**
   * alternative method for table filter clear
   *
   * @param p PageElement
   */
  private void scrollAndClear(PageElement p) {
    p.scrollIntoView();
    p.sendKeys(Keys.chord(TestUtils.getControlKeyByPlatform(), "a"));
    p.sendKeys(Keys.BACK_SPACE);
  }

  public enum Column {
    COMMENTS("comments"),
    CREATION_DATE("creation_date"),
    END_HUB("end_hub"),
    BILLING_NUMBER("billing_number"),
    SHIPMENT_ID("shipment_id"),
    SHIPMENT_TYPE("shipment_type"),
    STATUS("status"),
    START_HUB("start_hub"),
    VENDOR("vendor"),
    ORIGIN_PORT("origin_port"),
    DESTINATION_PORT("destination_port");

    private final String value;

    Column(String value) {
      this.value = value;
    }

    public static ShipmentWeightDimensionTablePage.Column fromLabel(String label) {
      return Stream.of(ShipmentWeightDimensionTablePage.Column.values())
          .filter(instance -> instance.value.equals(label))
          .findFirst()
          .orElse(SHIPMENT_ID);
    }
  }

  public static class ShipmentWeightRow extends NvTable.NvRow {

    @FindBy(xpath = "./td[contains(@class,'ant-table-cell index')]")
    public PageElement index;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell shipment-id')]")
    public PageElement shipmentId;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell status')]")
    public PageElement status;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell destination-hub-name')]")
    public PageElement destinationHub;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell created-at')]")
    public PageElement createdAt;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell mawb')]")
    public PageElement mawb;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell weight')]")
    public PageElement weight;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell length')]")
    public PageElement length;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell width')]")
    public PageElement width;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell height')]")
    public PageElement height;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell kgv')]")
    public PageElement kgv;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell no-of-parcels')]")
    public PageElement noOfParcels;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell comments')]")
    public PageElement comments;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell origin-hub-name')]")
    public PageElement originHubName;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell shipmentType')]")
    public PageElement shipmentType;
    @FindBy(xpath = "./td[contains(@class,'ant-table-cell selection')]//input")
    public CheckBox selectCheckbox;
    @FindBy(css = ".actions .edit-dimension-btn")
    public Button editButton;

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
