package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvTestRuntimeException;
import java.util.Date;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class CodReportPage extends OperatorV2SimplePage {

  private static final String CSV_FILENAME_PATTERN = "cod-report";

  private static final String NG_REPEAT = "cod in $data";
  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_CLASS_DATA_GRANULAR_STATUS = "granular_status";
  public static final String COLUMN_CLASS_DATA_SHIPPER_NAME = "shipper_name";
  public static final String COLUMN_CLASS_DATA_GOODS_AMOUNT = "goods_amount";

  public CodReportPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void filterCodReportBy(String mode, Date date) {
    clickToggleButton("ctrl.reportMode", mode);
    setMdDatepicker("ctrl.date", date);
    waitUntilInvisibilityOfElementLocated(
        "//md-card-content[contains(@ng-if, 'waiting')]/md-progress-circular");
  }

  public void verifyOrderIsExistWithCorrectInfo(Order order) {
    int indexOfOrderInTable = findOrderRowIndexInTable(order.getTrackingId());
    moveToElementWithXpath(
        String.format("//tr[@ng-repeat='%s'][%d]", NG_REPEAT, indexOfOrderInTable));

    String actualTrackingId = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_TRACKING_ID);
    String actualGranularStatus = getTextOnTable(indexOfOrderInTable,
        COLUMN_CLASS_DATA_GRANULAR_STATUS);
    String actualShipperName = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_SHIPPER_NAME);
    Double actualGoodsAmount = Double
        .parseDouble(getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_GOODS_AMOUNT));

    assertEquals("Tracking ID", order.getTrackingId(), actualTrackingId);
    assertThat("Granular Status", actualGranularStatus,
        Matchers.equalToIgnoringCase(order.getGranularStatus().replace("_", " ")));
    assertEquals("Shipper Name", order.getShipper().getName(), actualShipperName);
    assertEquals("COD Amount", order.getCod().getGoodsAmount(), actualGoodsAmount);
  }

  private int findOrderRowIndexInTable(String trackingId) {
    try {
      WebElement rowIndexWe = findElementByXpath(String.format(
          "//tr[@ng-repeat='%s']/td[contains(@class,'%s')][contains(text(), '%s')]/preceding-sibling::td",
          NG_REPEAT, COLUMN_CLASS_DATA_TRACKING_ID, trackingId));
      return Integer.parseInt(rowIndexWe.getText().trim());
    } catch (RuntimeException ex) {
      throw new NvTestRuntimeException(
          String.format("Tracking ID = '%s' not found on table.", trackingId));
    }
  }

  public void downloadCsvFile() {
    clickNvApiTextButtonByName("Download CSV File");
  }

  public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(Order order) {
    String trackingId = order.getTrackingId();
    String granularStatus = order.getGranularStatus().replace("_", " ").toLowerCase();
    String shipperName = order.getShipper().getName();
    String codAmount = NO_TRAILING_ZERO_DF.format(order.getCod().getGoodsAmount());
    String expectedText = f("\"%s\",\"%s\",\"%s\",%s", trackingId, granularStatus, shipperName,
        codAmount);
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN),
        expectedText, true);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }
}
