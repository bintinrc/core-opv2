package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.ImplantedManifestOrder;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Map;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Kateryna Skakunova
 */
public class ImplantedManifestPage extends SimpleReactPage<ImplantedManifestPage> {

  private static final String CSV_FILENAME_FORMAT = "implanted-manifest-%s.csv";

  @FindBy(xpath = ".//div[contains(@class,'ant-card')][./div/div/div[.='Scan Barcode']]//input[@data-testid='barcode-input-field']")
  public ForceClearTextBox scanBarcodeInput;

  @FindBy(xpath = ".//div[contains(@class,'ant-card')][./div/div/div[.='Remove order by scan']]//input[@data-testid='barcode-input-field']")
  public ForceClearTextBox removeOrderByScanInput;

  @FindBy(css = ".//div[contains(@class,'ant-card')][./div/div/div[.='Scan Barcode']]//button[@data-testid='scan-field.set-prefix-button']")
  public Button addPrefix;

  @FindBy(css = "[data-testid='download-csv-button']")
  public Button downloadCsvFile;

  @FindBy(css = ".//div[contains(@class,'ant-card')][./div/div/div[.='Remove order by scan']]//button[@data-testid='scan-field.set-prefix-button']")
  public Button removeOrderByScanInputAddPrefix;

  @FindBy(css = "[data-testid='single-select']")
  public AntSelect3 hubSelect;

  @FindBy(css = "[data-testid='submit.create-manifest']")
  public Button createManifest;

  @FindBy(css = "[data-testid='create-manifest-button']")
  public Button bigCreateManifest;

  @FindBy(css = "[data-testid='remove-all-button']")
  public Button removeAll;

  @FindBy(css = "[data-testid='alert-dialog.confirm-button']")
  public Button confirmRemoveAll;

  @FindBy(css = "div.rack-sector-card h2")
  public PageElement rackSector;

  @FindBy(css = "div.rack-sector-card h2 + div")
  public PageElement rackSectorStamp;

  @FindBy(css = ".ant-modal")
  public CreateManifestDialog createManifestDialog;

  @FindBy(css = "md-dialog")
  public SetPrefixDialog setPrefixDialog;

  public ImplantedManifestOrderTable implantedManifestOrderTable;

  public ImplantedManifestPage(WebDriver webDriver) {
    super(webDriver);
    implantedManifestOrderTable = new ImplantedManifestOrderTable(webDriver);
  }

  /**
   * Accessor for Manifest table
   */
  public static class ImplantedManifestOrderTable extends AntTableV2<ImplantedManifestOrder> {

    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_SCANNED_AT = "scannedAt";
    public static final String COLUMN_DESTINATION = "destination";
    public static final String COLUMN_ADDRESSEE = "addressee";
    public static final String COLUMN_RACK_SECTOR = "rackSector";
    public static final String COLUMN_DELIVERY_BY = "deliveryBy";
    public static final String ACTION_REMOVE = "remove";

    private ImplantedManifestOrderTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(
          ImmutableMap.<String, String>builder()
              .put(COLUMN_TRACKING_ID, "trackingId")
              .put(COLUMN_SCANNED_AT, "scannedAt")
              .put(COLUMN_DESTINATION, "destination")
              .put(COLUMN_ADDRESSEE, "addressee")
              .put(COLUMN_RACK_SECTOR, "rackSector")
              .put(COLUMN_DELIVERY_BY, "deliveryBy")
              .build());
      setActionButtonsLocators(ImmutableMap.of(ACTION_REMOVE, "//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='isValid']//button"));
      setEntityClass(ImplantedManifestOrder.class);
    }
  }

  public void clickActionXForRow(int rowNumber) {
    implantedManifestOrderTable.clickActionButton(rowNumber, "close");
  }

  public void clickCreateManifestButtonToInitiateCreation() {
    waitUntilInvisibilityOfElementLocated(
        "//button[@aria-label='container.implanted-manifest.create-manifest' and @disabled='disabled']");
    clickNvApiTextButtonByNameAndWaitUntilDone("container.implanted-manifest.create-manifest");
  }

  public void csvDownloadSuccessfullyAndContainsOrderInfo(String trackingId, String address,
      String rackSector, String toName, String hubName) {
    String csvFileName = f(CSV_FILENAME_FORMAT, hubName);

    verifyFileDownloadedSuccessfully(csvFileName, trackingId);

    String expectedText = f("\"%s\",\"%s\",\"%s\"", address, toName, rackSector);
    verifyFileDownloadedSuccessfully(csvFileName, expectedText);
  }

  public void selectHub(String destinationHub) {
    pause2s();
    selectValueFromMdSelectWithSearch("model", destinationHub);
  }

  public static class CreateManifestDialog extends AntModal {

    @FindBy(css = "[data-testid='job-id-input-field']")
    public ForceClearTextBox reservationId;

    @FindBy(css = "[data-testid='create-manifest-dialog.confirm-button']")
    public Button createManifestButton;

    public CreateManifestDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class SetPrefixDialog extends MdDialog {

    @FindBy(id = "container.global-inbound.prefix")
    public TextBox prefix;

    @FindBy(id = "saveButtonPrefix")
    public NvIconTextButton save;

    public SetPrefixDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
