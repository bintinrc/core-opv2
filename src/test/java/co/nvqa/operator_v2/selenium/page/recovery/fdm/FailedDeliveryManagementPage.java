package co.nvqa.operator_v2.selenium.page.recovery.fdm;

import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class FailedDeliveryManagementPage extends
    SimpleReactPage<FailedDeliveryManagementPage> {

  @FindBy(css = "[data-testid='virtual-table.stats.header']")
  public PageElement fdmHeader;

  @FindBy(css = "[data-testid='apply-action-button']")
  public Button applyAction;

  @FindBy(css = "[data-testid='fdm.apply-action.download-csv-file']")
  public PageElement downloadCsvFileAction;

  public static String KEY_SELECTED_ROWS_COUNT = "KEY_SELECTED_ROWS_COUNT";
  public static final String FDM_CSV_FILENAME_PATTERN = "failed-delivery-list.csv";

  public FailedDeliveryManagementPage(WebDriver webDriver) {
    super(webDriver);
    fdmTable = new FailedDeliveryTable(webDriver);
  }

  public FailedDeliveryTable fdmTable;

  public static class FailedDeliveryTable extends AntTableV2<FailedDelivery> {

    @FindBy(xpath = "//button[@class='ant-btn ant-btn-sm ant-btn-icon-only']")
    public PageElement bulkSelectDropdown;
    @FindBy(xpath = "//div[@id='__next']//span[contains(text(),'Selected')]")
    public PageElement selectedRowCount;

    @FindBy(css = "[data-testid='virtual-table.select-all-shown']")
    public PageElement selectAll;

    @FindBy(css = "[data-testid='virtual-table.deselect-all-shown']")
    public PageElement deselectAll;

    @FindBy(css = "[data-testid='virtual-table.clear-current-selection']")
    public PageElement clearCurrentSelection;

    @FindBy(css = "[data-testid='virtual-table.show-only-selected']")
    public PageElement showOnlySelected;

    public static final String ACTION_SELECT = "Select row";

    public final String XPATH_TRACKING_ID_FILTER_INPUT = "//input[@data-testid='virtual-table.tracking_id.header.filter']";
    public final String XPATH_SHIPPER_NAME_FILTER_INPUT = "//input[@data-testid='virtual-table.shipper_name.header.filter']";


    public FailedDeliveryTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "//div[@role='gridcell'][@data-datakey='tracking_id']")
          .put("type", "//div[@role='gridcell'][@data-datakey='type']")
          .put("shipperName", "//div[@role='gridcell'][@data-datakey='shipper_name']")
          .put("lastAttemptTime", "//div[@role='gridcell'][@data-datakey='lastAttemptTimeDisplay']")
          .put("failureReasonComments",
              "//div[@role='gridcell'][@data-datakey='failureReasonCommentsDisplay']")
          .put("attemptCount", "//div[@role='gridcell'][@data-datakey='attempt_count']")
          .put("invalidFailureCount",
              "//div[@role='gridcell'][@data-datakey='invalidFailureCountDisplay']")
          .put("validFailureCount",
              "//div[@role='gridcell'][@data-datakey='validFailureCountDisplay']")
          .put("failureReasonCodeDescription",
              "//div[@role='gridcell'][@data-datakey='failureReasonCodeDescriptionsDisplay']")
          .put("daysSinceLastAttempt",
              "//div[@role='gridcell'][@data-datakey='daysSinceLastAttemptDisplay']")
          .put("priorityLevel", "//div[@role='gridcell'][@data-datakey='priorityLevelDisplay']")
          .put("lastScannedHubName",
              "//div[@role='gridcell'][@data-datakey='lastScannedHubNameDisplay']")
          .put("orderTags", "//div[@role='gridcell'][@data-datakey='tags']")
          .build()
      );
      setEntityClass(FailedDelivery.class);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_SELECT,
          "//input[@class='ant-checkbox-input']"));
    }

    public void filterTableByTID(String columName, String value) {
      filterTableByColumn(XPATH_TRACKING_ID_FILTER_INPUT, columName, value);
    }

    public void filterTableByShipperName(String columName, String value) {
      filterTableByColumn(XPATH_SHIPPER_NAME_FILTER_INPUT, columName, value);
    }

    public List<String> getFilteredValue() {
      final String FILTERED_TABLE_XPATH = "//div[contains(@class ,'BaseTable__row')]//div[@class='BaseTable__row-cell']";
      return findElementsByXpath(FILTERED_TABLE_XPATH).stream().map(WebElement::getText)
          .collect(Collectors.toList());
    }
    private void filterTableByColumn(String xPath, String columName, String value) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        findElementBy(By.xpath(f(xPath, columName))).sendKeys(
            value);
      }, 1000, 5);
    }
  }

  public void verifyBulkSelectResult() {
    String ShowingResults = fdmHeader.getText();
    String selectedRows = fdmTable.selectedRowCount.getText();
    char SPACE_CHAR = ' ';
    String numberOfSelectedRows = selectedRows.substring(0, selectedRows.lastIndexOf(SPACE_CHAR))
        .trim();
    Assertions.assertThat(ShowingResults).as("Number of selected rows are the same")
        .contains(numberOfSelectedRows);
    KEY_SELECTED_ROWS_COUNT = numberOfSelectedRows;
  }

}