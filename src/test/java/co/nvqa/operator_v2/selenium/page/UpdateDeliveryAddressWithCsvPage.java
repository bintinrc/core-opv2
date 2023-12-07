package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.UpdateDeliveryAddressRecord;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTableV2;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class UpdateDeliveryAddressWithCsvPage extends
    SimpleReactPage<UpdateDeliveryAddressWithCsvPage> {

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button updateAddressWithCsvButton;

  @FindBy(css = "[data-testid='confirm-updates-button']")
  public Button confirmUpdatesButton;

  @FindBy(css = ".ant-modal")
  public UpdateAddressWithCsvDialog updateAddressWithCsvDialog;

  @FindBy(css = ".ant-modal")
  public ConfirmUpdatesDialog confirmUpdatesDialog;

  @FindBy(css = ".table-description")
  public PageElement tableDescription;

  public AddressesTable addressesTable;

  public UpdateDeliveryAddressWithCsvPage(WebDriver webDriver) {
    super(webDriver);
    addressesTable = new AddressesTable(webDriver);
  }

  public static class UpdateAddressWithCsvDialog extends AntModal {

    @FindBy(css = "[data-testid='upload-dragger']")
    public FileInput selectFile;

    @FindBy(css = "[data-testid='upload-button']")
    public Button uploadButton;

    public UpdateAddressWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class ConfirmUpdatesDialog extends AntModal {

    @FindBy(css = "[data-testid='confirm-update-dialog-submit-button']")
    public Button proceedButton;

    @FindBy(css = "[data-testid='confirm-update-dialog-cancel-button']")
    public Button cancel;

    @FindBy(css = "[data-testid='close-button']")
    public Button close;

    public ConfirmUpdatesDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }

  public static class AddressesTable extends AntTableV2<UpdateDeliveryAddressRecord> {

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
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_VALIDATION, "validationErrors")
          .put(COLUMN_TRACKING_ID, "tracking_id")
          .put(COLUMN_NAME, "to.name")
          .put(COLUMN_EMAIL, "to.email")
          .put(COLUMN_CONTACT, "to.phone_number")
          .put(COLUMN_ADDRESS1, "to.address.address1")
          .put(COLUMN_ADDRESS2, "to.address.address2")
          .put(COLUMN_POSTCODE, "to.address.postcode")
          .put(COLUMN_CITY, "to.address.city")
          .put(COLUMN_COUNTRY, "to.address.country")
          .put(COLUMN_STATE, "to.address.state")
          .put(COLUMN_DISTRICT, "to.address.district")
          .put(COLUMN_LATITUDE, "to.address.latitude")
          .put(COLUMN_LONGITUDE, "to.address.longitude")

          .build());
      setEntityClass(UpdateDeliveryAddressRecord.class);
    }
  }

}
