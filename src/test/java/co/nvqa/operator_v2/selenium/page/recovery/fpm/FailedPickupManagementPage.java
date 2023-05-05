package co.nvqa.operator_v2.selenium.page.recovery.fpm;
import co.nvqa.operator_v2.model.FailedPickup;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;
import java.util.stream.Collectors;

public class FailedPickupManagementPage extends
        SimpleReactPage<FailedPickupManagementPage> {
  @FindBy(css = "[data-testid='virtual-table.stats.header']")
  public PageElement fpmHeader;

  @FindBy(css = "[data-testid='apply-action-button']")
  public Button applyAction;

  @FindBy(css = "[data-testid='fpm.apply-action.download-csv-file']")
  public PageElement downloadCsvFileAction;

  public FailedPickupTable fpmTable;

  public static String KEY_SELECTED_ROWS_COUNT = "KEY_SELECTED_ROWS_COUNT";
  public static final String FPM_CSV_FILENAME_PATTERN = "failed-pickup-list.csv";

  public FailedPickupManagementPage(WebDriver webDriver) {
    super(webDriver);
    fpmTable = new FailedPickupTable(webDriver);
  }

  public static class FailedPickupTable extends AntTableV2<FailedPickup> {

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
    public static final String ACTION_RESCHEDULE = "Reschedule next day";

    public FailedPickupTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
              .put("trackingId", "tracking_id")
              .put("shipperName", "shipper_name")
              .put("lastAttemptTime", "lastAttemptTimeDisplay")
              .put("failureReasonComments", "failureReasonCommentsDisplay")
              .put("attemptCount", "attempt_count")
              .put("invalidFailureCount", "invalidFailureCountDisplay")
              .put("validFailureCount", "validFailureCountDisplay")
              .put("failureReasonCodeDescription", "failureReasonCodeDescriptionsDisplay")
              .put("daysSinceLastAttempt", "daysSinceLastAttemptDisplay")
              .put("priorityLevel", "priorityLevelDisplay")
              .build()
      );
      setEntityClass(FailedPickup.class);
      setActionButtonsLocators(ImmutableMap.of(
              ACTION_SELECT, "//input[@class='ant-checkbox-input']",
              ACTION_RESCHEDULE, "//button[contains(@data-testid,'single-reschedule-icon')]"
      ));
    }

    public List<String> getFilteredValue() {
      final String FILTERED_TABLE_XPATH = "//div[contains(@class ,'BaseTable__row')]//div[@class='BaseTable__row-cell']";
      return findElementsByXpath(FILTERED_TABLE_XPATH).stream().map(WebElement::getText)
              .collect(Collectors.toList());
    }
  }

  public void verifyBulkSelectResult() {
    String ShowingResults = fpmHeader.getText();
    String selectedRows = fpmTable.selectedRowCount.getText();
    char SPACE_CHAR = ' ';
    String numberOfSelectedRows = selectedRows.substring(0, selectedRows.lastIndexOf(SPACE_CHAR))
            .trim();
    Assertions.assertThat(ShowingResults).as("Number of selected rows are the same")
            .contains(numberOfSelectedRows);
    KEY_SELECTED_ROWS_COUNT = numberOfSelectedRows;
  }
}
