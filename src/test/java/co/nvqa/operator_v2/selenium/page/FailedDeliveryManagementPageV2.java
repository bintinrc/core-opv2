package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class FailedDeliveryManagementPageV2 extends
    SimpleReactPage<FailedDeliveryManagementPageV2> {

  @FindBy(css = "[data-testid='virtual-table.stats.header']")
  public PageElement loadFdmHeader;

  public FailedDeliveryManagementPageV2(WebDriver webDriver) {
    super(webDriver);
    fdmTable = new FailedDeliveryTable(webDriver);
  }

  public FailedDeliveryTable fdmTable;

  public void waitUntilHeaderShown() {
    loadFdmHeader.waitUntilVisible(30);
  }

  public static class FailedDeliveryTable extends AntTableV2<FailedDelivery> {

    public final String XPATH_TRACKING_ID_FILTER_INPUT = "//input[@data-testid='virtual-table.tracking_id.header.filter']";
    public final String XPATH_SHIPPER_NAME_FILTER_INPUT = "//input[@data-testid='virtual-table.shipper_name.header.filter']";

    public static final String COLUMN_TRACKING_ID = "tracking_od";
    public static final String COLUMN_SHIPPER = "shipper_name";


    public FailedDeliveryTable(WebDriver webDriver) {
      super(webDriver);
      PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TRACKING_ID, "tracking_id")
          .put("type", "type")
          .put(COLUMN_SHIPPER, "shipper_name")
          .put("lastAttemptTime", "lastAttemptTimeDisplay")
          .put("failureReasonCommentsDisplay", "failureReasonCommentsDisplay")
          .put("attemptCount", "attempt_count")
          .put("invalidFailureCount", "invalidFailureCountDisplay")
          .put("validFailureCount", "validFailureCountDisplay")
          .put("failureReasonCodeDescription", "failureReasonCodeDescriptionsDisplay")
          .put("daysSinceLastAttempt", "daysSinceLastAttemptDisplay")
          .put("priorityLevel", "priorityLevelDisplay")
          .put("lastScannedHubNameDisplay", "lastScannedHubNameDisplay")
          .put("String", "tags")
          .build()
      );
      setEntityClass(FailedDelivery.class);
    }

    public void filterTableByTID(String columName, String value) {
      filterTableByColumn(XPATH_TRACKING_ID_FILTER_INPUT, columName, value);
    }

    public void filterTableByShipperName(String columName, String value) {
      filterTableByColumn(XPATH_SHIPPER_NAME_FILTER_INPUT, columName, value);
    }

    public List<String> getFilteredValue() {
      final String FAILED_DELIVERY_TABLE_XPATH = "//div[contains(@class ,'BaseTable__row')]//div[@class='BaseTable__row-cell']";

      return findElementsByXpath(FAILED_DELIVERY_TABLE_XPATH).stream().map(WebElement::getText)
          .collect(Collectors.toList());
    }

    private void filterTableByColumn(String xPath, String columName, String value) {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        findElementBy(By.xpath(f(xPath, columName))).sendKeys(
            value);
      }, 1000, 5);
    }
  }
}
