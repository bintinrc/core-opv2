package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OrderWeightUpdatePage extends SimpleReactPage<OrderWeightUpdatePage> {

  @FindBy(css = "[data-testid='upload-button']")
  public Button upload;

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button findOrdersWithCsv;

  @FindBy(css = ".ant-modal")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  public WeighUpdateTable weighUpdateTable;

  private static final String NG_REPEAT = "row in $data";
  private static final String CSV_FILENAME_PATTERN = "sample_csv";

  public static final String COLUMN_CLASS_DATA_STATUS = "status";
  public static final String COLUMN_CLASS_DATA_MESSAGE = "message";
  public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
  public static final String COLUMN_CLASS_DATA_ORDER_REF_NO = "order_ref_no";
  public static final String GET_WEIGHT_VALUE = "//label[text()='Weight']/following-sibling::p";

  public OrderWeightUpdatePage(WebDriver webDriver) {
    super(webDriver);
    weighUpdateTable = new WeighUpdateTable(webDriver);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }

  private File buildCreateOrderUpdateCsv(List<Map<String, String>> list) {

    List<String> rows = list.stream()
        .map(e -> "\"" + e.get("trackingId") + "\",\"" + e.get("weigh") + "\"")
        .collect(Collectors.toList());

    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-order-update_%s.csv", generateDateUniqueString()));
      FileUtils.writeLines(file, rows);
      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }

  public static class FindOrdersWithCsvDialog extends AntModal {

    @FindBy(css = "[data-testid='upload-dragger']")
    public FileInput chooseButton;

    @FindBy(css = "[data-testid='upload-button']")
    public Button upload;

    @FindBy(css = "[data-testid='cancel-button']")
    public Button cancel;

    @FindBy(css = "[data-testid='download-sample-file-button']")
    public Button downloadSample;

    public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      waitUntilVisible();
      chooseButton.setValue(file);
      upload.click();
    }
  }

  public static class WeighUpdateTable extends AntTableV2<WeighUpdateRecord> {

    public WeighUpdateTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put("id", "id")
              .put("trackingId", "trackingId")
              .put("stampId", "stampId")
              .put("status", "status")
              .put("newWeight", "newWeight")
              .put("isValid", "isValid")
              .build());
      setEntityClass(WeighUpdateRecord.class);
    }
  }

  public static class WeighUpdateRecord extends DataEntity<WeighUpdateRecord> {

    private String id;
    private String trackingId;
    private String stampId;
    private String status;
    private String newWeight;
    private String isValid;

    public WeighUpdateRecord() {
    }

    public WeighUpdateRecord(Map<String, ?> data) {
      super(data);
    }

    public String getId() {
      return id;
    }

    public WeighUpdateRecord setId(String id) {
      this.id = id;
      return this;
    }

    public String getTrackingId() {
      return trackingId;
    }

    public WeighUpdateRecord setTrackingId(String trackingId) {
      this.trackingId = trackingId;
      return this;
    }

    public String getStampId() {
      return stampId;
    }

    public WeighUpdateRecord setStampId(String stampId) {
      this.stampId = stampId;
      return this;
    }

    public String getStatus() {
      return status;
    }

    public WeighUpdateRecord setStatus(String status) {
      this.status = status;
      return this;
    }

    public String getNewWeight() {
      return newWeight;
    }

    public WeighUpdateRecord setNewWeight(String newWeight) {
      this.newWeight = newWeight;
      return this;
    }

    public String getIsValid() {
      return isValid;
    }

    public WeighUpdateRecord setIsValid(String isValid) {
      this.isValid = isValid;
      return this;
    }
  }

}