package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.UpdateDeliveryAddressRecord;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class UpdateDeliveryAddressWithCsvPage extends OperatorV2SimplePage {

  @FindBy(name = "container.order-delivery-update.update-address-with-csv")
  public NvIconTextButton updateAddressWithCsvButton;

  @FindBy(name = "container.order-delivery-update.confirm-updates")
  public NvIconTextButton confirmUpdatesButton;

  @FindBy(css = "md-dialog")
  public UpdateAddressWithCsvDialog updateAddressWithCsvDialog;

  @FindBy(css = "md-dialog")
  public ConfirmUpdatesDialog confirmUpdatesDialog;

  @FindBy(css = ".table-description")
  public PageElement tableDescription;

  public AddressesTable addressesTable;

  public UpdateDeliveryAddressWithCsvPage(WebDriver webDriver) {
    super(webDriver);
    addressesTable = new AddressesTable(webDriver);
  }

  public static class UpdateAddressWithCsvDialog extends MdDialog {

    @FindBy(css = "nv-button-file-picker[label='Select File']")
    public NvButtonFilePicker selectFile;

    @FindBy(name = "commons.upload")
    public NvApiTextButton uploadButton;

    public UpdateAddressWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ConfirmUpdatesDialog extends MdDialog {

    @FindBy(css = "[aria-label='Proceed']")
    public Button proceedButton;

    @FindBy(css = "[aria-label='Close']")
    public Button closeButton;

    public ConfirmUpdatesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class AddressesTable extends NgRepeatTable<UpdateDeliveryAddressRecord> {

    public static final String NG_REPEAT = "row in ctrl.ordersTableData";
    public static final String COLUMN_VALIDATION = "validation";
    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String COLUMN_NAME = "toName";
    public static final String COLUMN_EMAIL = "toEmail";
    public static final String COLUMN_CONTACT = "toPhoneNumber";
    public static final String COLUMN_ADDRESS1 = "toAddressAddress1";
    public static final String COLUMN_ADDRESS2 = "toAddressAddress2";
    public static final String COLUMN_POSTCODE = "toAddressPostcode";
    public static final String COLUMN_CITY = "toAddressCity";
    public static final String COLUMN_COUNTRY = "toAddressCountry";
    public static final String COLUMN_STATE = "toAddressState";
    public static final String COLUMN_DISTRICT = "toAddressDistrict";
    public static final String COLUMN_LATITUDE = "toAddressLatitude";
    public static final String COLUMN_LONGITUDE = "toAddressLongitude";

    public AddressesTable(WebDriver webDriver) {
      super(webDriver);
      setNgRepeat(NG_REPEAT);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_VALIDATION, "validation-or-update")
          .put(COLUMN_TRACKING_ID, "tracking-id")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_EMAIL, "email")
          .put(COLUMN_CONTACT, "contact")
          .put(COLUMN_ADDRESS1, "address1")
          .put(COLUMN_ADDRESS2, "address2")
          .put(COLUMN_POSTCODE, "postcode")
          .put(COLUMN_CITY, "city")
          .put(COLUMN_COUNTRY, "country")
          .put(COLUMN_STATE, "state")
          .put(COLUMN_DISTRICT, "district")
          .put(COLUMN_LATITUDE, "latitude")
          .put(COLUMN_LONGITUDE, "longitude")

          .build());
      setEntityClass(UpdateDeliveryAddressRecord.class);
    }
  }

}
