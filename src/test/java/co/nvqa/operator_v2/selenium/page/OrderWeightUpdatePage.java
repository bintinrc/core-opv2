package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.apache.commons.lang3.StringUtils.trimToEmpty;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OrderWeightUpdatePage extends OperatorV2SimplePage {

  @FindBy(name = "container.order-weight-update.upload-selected")
  public NvIconTextButton upload;

  @FindBy(name = "container.order-weight-update.find-orders-with-csv")
  public NvIconTextButton findOrdersWithCsv;

  @FindBy(css = "md-dialog")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  private static final String NG_REPEAT = "row in $data";
  private static final String CSV_FILENAME_PATTERN = "sample_csv";

  public static final String COLUMN_CLASS_DATA_STATUS = "status";
  public static final String COLUMN_CLASS_DATA_MESSAGE = "message";
  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_CLASS_DATA_ORDER_REF_NO = "order_ref_no";
  public static final String GET_WEIGHT_VALUE = "//label[text()='Weight']/following-sibling::p";

  public OrderWeightUpdatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }

  private File buildCreateOrderUpdateCsv(String OrderTrackingNo, Map<String, String> map) {
    Double weight = Double.parseDouble(map.get("new-weight-in-double-format"));

    StringBuilder orderAsSb = new StringBuilder()
        .append(trimToEmpty(OrderTrackingNo)).append(',')
        .append('"').append(trimToEmpty(String.valueOf(weight))).append('"');

    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-order-update_%s.csv", generateDateUniqueString()));

      PrintWriter pw = new PrintWriter(new FileOutputStream(file));
      pw.write(orderAsSb.toString());
      pw.write(System.lineSeparator());
      pw.close();

      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  private File buildMultiCreateOrderUpdateCsv(List<String> trackIds, List<String> listWeight) {

    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-mutli-order-update_%s.csv", generateDateUniqueString()));

      PrintWriter pw = new PrintWriter(new FileOutputStream(file));

      for (int i = 0; i < trackIds.size(); i++) {
        String orderAsSb = trimToEmpty(trackIds.get(i)) + ',' +
            '"' + trimToEmpty(listWeight.get(i)) + '"';
        pw.write(orderAsSb);
        pw.write(System.lineSeparator());

      }
      pause(2000);

      pw.close();

      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  public void uploadOrderUpdateCsv(String OrderTrackingNo, Map<String, String> map) {
    findOrdersWithCsv.click();
    File createOrderUpdateCsv = buildCreateOrderUpdateCsv(OrderTrackingNo, map);
    findOrdersWithCsvDialog.uploadFile(createOrderUpdateCsv);
  }

  public void uploadMultiOrderUpdateCsv(List<String> trackId, List<String> listWeight) {
    findOrdersWithCsv.click();
    File createOrderUpdateCsv = buildMultiCreateOrderUpdateCsv(trackId, listWeight);
    findOrdersWithCsvDialog.uploadFile(createOrderUpdateCsv);
  }

  public static class FindOrdersWithCsvDialog extends MdDialog {

    @FindBy(css = "[label='Select File']")
    public NvButtonFilePicker chooseButton;

    @FindBy(name = "commons.upload")
    public NvApiTextButton upload;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    @FindBy(xpath = ".//a[text()='here']")
    public Button downloadSample;

    public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      waitUntilVisible();
      chooseButton.setValue(file);
      upload.clickAndWaitUntilDone();
    }
  }
}