package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.operator_v2.model.CodInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.NgRepeatTable;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class CodReportPage extends OperatorV2SimplePage {

  private static final String CSV_FILENAME_PATTERN = "cod-report";

  public CodTable codTable;

  @FindBy(css = "button[aria-label='Get CODs For A Day']")
  public Button getCodsForADay;

  @FindBy(css = "button[aria-label='Get Driver CODs For A Route Day']")
  public Button getDriverCodsForARouteDay;

  @FindBy(name = "Download CSV File")
  public NvApiTextButton downloadCsv;

  @FindBy(css = "md-datepicker")
  public MdDatepicker date;

  public CodReportPage(WebDriver webDriver) {
    super(webDriver);
    codTable = new CodTable(webDriver);
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

  public static class CodTable extends NgRepeatTable<CodInfo> {

    public CodTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat("cod in $data");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking_id")
          .put("granularStatus", "granular_status")
          .put("shipperName", "shipper_name")
          .put("collectedAt", "collection_at")
          .put("codAmount", "goods_amount")
          .put("shippingAmount", "shipping_amount")
          .put("collectedSum", "collected_sum")
          .put("collected", "collected")
          .build());
      setEntityClass(CodInfo.class);
    }

    public int findRow(String trackingId) {
      int count = getRowsCount();
      for (int i = 1; i <= count; i++) {
        String value = getColumnText(i, "trackingId");
        if (StringUtils.equals(value, trackingId)) {
          return i;
        }
      }
      return -1;
    }
  }
}