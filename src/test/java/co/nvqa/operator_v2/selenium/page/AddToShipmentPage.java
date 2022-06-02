package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class AddToShipmentPage extends SimpleReactPage<AddToShipmentPage> {

  @FindBy(css = "[data-testid='origin-hub-select']")
  public AntSelect3 originHub;

  @FindBy(css = "[data-testid='destination-hub-select']")
  public AntSelect3 destinationHub;

  @FindBy(css = "[data-testid='shipment-type-select']")
  public AntSelect3 shipmentType;

  @FindBy(css = "[data-testid='shipment-id-select']")
  public AntSelect3 shipmentId;

  @FindBy(css = "[data-testid='add-parcel-to-shipment-button']")
  public Button addParcelToShipment;

  @FindBy(css = "[data-testid='create-shipment-button']")
  public Button createShipment;

  @FindBy(css = "[data-testid='close-shipment-buton']")
  public Button closeShipment;

  @FindBy(css = "[data-testid='current-print-criteria-title']")
  public Button currentPrintCriteriaTitle;

  @FindBy(css = "[data-testid='edit-print-criteria-link']")
  public Button editPrintCriteriaLink;

  @FindBy(id = "toAddTrackingId")
  public TextBox addTrackingIdInput;

  @FindBy(id = "toRemoveTrackingId")
  public TextBox removeTrackingIdInput;

  @FindBy(xpath = "//div[@class='ant-modal-content'][.//div[.='Confirm Close Shipment']]")
  public ConfirmCloseShipmentModal confirmCloseShipmentModal;

  @FindBy(css = ".ant-modal")
  public ShipmentLabelStickerModal shipmentLabelStickerModal;

  @FindBy(css = ".ant-modal")
  public CreateShipmentModal createShipmentModal;


  public AddToShipmentPage(WebDriver webDriver) {
    super(webDriver);
  }


  public static class ConfirmCloseShipmentModal extends AntModal {

    public ConfirmCloseShipmentModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='confirm-close-shipment-button']")
    public Button closeShipment;
  }

  public static class ShipmentLabelStickerModal extends AntModal {

    public ShipmentLabelStickerModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[@id='printLabelCriteriaForm_version']//*[.='Single']")
    public Button single;

    @FindBy(xpath = ".//div[@id='printLabelCriteriaForm_version']//*[.='Folded']")
    public Button folded;

    @FindBy(xpath = ".//div[@id='printLabelCriteriaForm_size']//*[.='70 x 50 mm']")
    public Button size70x50;

    @FindBy(xpath = ".//div[@id='printLabelCriteriaForm_size']//*[.='100 x 150 mm']")
    public Button size100x150;

    @FindBy(id = "printLabelCriteriaForm_isPrintWhenClose")
    public CheckBox isPrintWhenClose;

    @FindBy(css = "[data-testid='save-label-setting-button']")
    public Button saveLabelSettings;
  }

  public static class CreateShipmentModal extends AntModal {

    public CreateShipmentModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='create-shipment-origin-hub-select']")
    public AntSelect3 originHub;

    @FindBy(css = "label[for='orig_hub_id']")
    public PageElement originHubLabel;

    @FindBy(xpath = ".//div[contains(@class,'ant-form-item')][.//label[.='Origin Hub']]//div[@role='alert']")
    public PageElement originHubAlert;

    @FindBy(css = "[data-testid='create-shipment-destination-hub-select']")
    public AntSelect3 destinationHub;

    @FindBy(css = "label[for='dest_hub_id']")
    public PageElement destinationHubLabel;

    @FindBy(xpath = ".//div[contains(@class,'ant-form-item')][.//label[.='Destination Hub']]//div[@role='alert']")
    public PageElement destinationHubAlert;

    @FindBy(css = "[data-testid='create-shipment-type-select']")
    public AntSelect3 shipmentType;

    @FindBy(css = "label[for='shipment_type']")
    public PageElement shipmentTypeLabel;

    @FindBy(css = "[data-testid='create-shipment-comment-input']")
    public TextBox comments;

    @FindBy(css = "[data-testid='confirm-create-shipment-button']")
    public Button createShipment;
  }

}
