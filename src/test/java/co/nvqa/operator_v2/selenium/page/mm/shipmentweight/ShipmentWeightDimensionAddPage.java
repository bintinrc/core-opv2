package co.nvqa.operator_v2.selenium.page.mm.shipmentweight;

import co.nvqa.operator_v2.model.ShipmentWeightDimensionAddInfo;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.mm.AntInputText;
import co.nvqa.operator_v2.selenium.elements.mm.AntNotice;
import co.nvqa.operator_v2.selenium.elements.mm.InfoContainer;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.Optional;
import java.util.stream.Stream;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShipmentWeightDimensionAddPage extends SimpleReactPage<ShipmentWeightDimensionAddPage> {
  private static final Logger LOGGER = LoggerFactory.getLogger(ShipmentWeightDimensionAddPage.class);

  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='shipment_id'] ]")
  public AntInputText shipmentIdInput;
  @FindBy(id = "shipmentScanSubmit")
  public AntButton searchButton;
  @FindBy(xpath = "//button[span[text()='Submit']]")
  public AntButton submitButton;
  @FindBy(xpath = "//div[span[text()='Start Hub']]/parent::div")
  public InfoContainer startHubInfo;
  @FindBy(xpath = "//div[span[text()='End Hub']]/parent::div")
  public InfoContainer endHubInfo;
  @FindBy(xpath = "//div[span[text()='No. of Parcels']]/parent::div")
  public InfoContainer noOfParcelsInfo;
  @FindBy(xpath = "//div[span[text()='Status']]/parent::div")
  public InfoContainer statusInfo;
  @FindBy(xpath = "//div[span[text()='Comments']]/parent::div")
  public InfoContainer commentsInfo;
  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;
  @FindBy(css = ".ant-spin-spinning")
  public PageElement loadingSpinner;
  @FindBy(xpath = "//form[contains(@class, 'ant-form-vertical')]/div[2]//span")
  public PageElement formErrorMessage;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='weight'] ]")
  public AntInputText weightInput;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='length'] ]")
  public AntInputText lengthInput;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='width'] ]")
  public AntInputText widthInput;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='height'] ]")
  public AntInputText heightInput;
  @FindBy(xpath = "//div[@class='ant-message-notice'][last()]")
  public AntNotice notice;

  @FindBy(className = "ant-modal-content")
  public OverWeightModal overWeightModal;


  public ShipmentWeightDimensionAddPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyUI(String state, String message, ShipmentWeightDimensionAddInfo uiInfo) {
    Assertions.assertThat(shipmentIdInput.isDisplayed()).as("Shipment ID Input is visible")
        .isTrue();
    Assertions.assertThat(searchButton.isDisplayed()).as("Search button is visible").isTrue();
    Assertions.assertThat(startHubInfo.isDisplayed()).as("Start Hub Info is visible").isTrue();
    Assertions.assertThat(endHubInfo.isDisplayed()).as("End Hub Info is visible").isTrue();
    Assertions.assertThat(noOfParcelsInfo.isDisplayed()).as("No of parcels is visible").isTrue();
    Assertions.assertThat(statusInfo.isDisplayed()).as("Status is visible").isTrue();
    Assertions.assertThat(commentsInfo.isDisplayed()).as("Comments is visible").isTrue();

    ShipmentWeightAddState shipmentWeightAddStateEnum = ShipmentWeightAddState.fromLabel(state);
    switch (shipmentWeightAddStateEnum) {
      case ERROR:
        Assertions.assertThat(shipmentIdInput.isError()).as("Shipment ID Input is show error").isTrue();
        Assertions.assertThat(shipmentIdInput.getErrorText()).as("Shipment ID input error message is correct")
            .isEqualTo(message);
        break;
      case CANCELLEDCOMPLETED:
        Assertions.assertThat(formErrorMessage.isDisplayed()).as("Form show error message").isTrue();
        Assertions.assertThat(formErrorMessage.getText()).as(f("Form showing correct error message as %s",message))
            .isEqualTo(message);
        break;
      case INITIAL:
      case VALID:
      case HAS_DIMENSION:
        loadingSpinner.waitUntilInvisible();
        LOGGER.info(f("Validating UI State : %s", shipmentWeightAddStateEnum.value));
        Assertions.assertThat(startHubInfo.getInfoText()).as(f("Start Hub show %s", uiInfo.getStartHub()))
            .isEqualTo(uiInfo.getStartHub());
        Assertions.assertThat(endHubInfo.getInfoText()).as(f("End Hub show %s", uiInfo.getEndHub()))
            .isEqualTo(uiInfo.getEndHub());
        Assertions.assertThat(noOfParcelsInfo.getInfoText())
            .as(f("No of Parcels show %s", uiInfo.getNoOfParcels()))
            .isEqualTo(uiInfo.getNoOfParcels());
        Assertions.assertThat(statusInfo.getInfoText()).as(f("Status show %s", uiInfo.getStatus()))
            .isEqualTo(uiInfo.getStatus());
        Assertions.assertThat(commentsInfo.getInfoText()).as(f("Comments show %s", uiInfo.getComment()))
            .isEqualTo(uiInfo.getComment());
        if (shipmentWeightAddStateEnum.equals(ShipmentWeightAddState.HAS_DIMENSION)) {
          Assertions.assertThat(Double.parseDouble(weightInput.getValue()))
              .as("Shipment weight is: " + uiInfo.getWeight())
              .isEqualTo(uiInfo.getWeight());

          Assertions.assertThat(Double.parseDouble(heightInput.getValue()))
              .as("Shipment height is: " + uiInfo.getHeight())
              .isEqualTo(uiInfo.getHeight());

          Assertions.assertThat(Double.parseDouble(widthInput.getValue()))
              .as("Shipment width is: " + uiInfo.getWidth())
              .isEqualTo(uiInfo.getWidth());

          Assertions.assertThat(Double.parseDouble(lengthInput.getValue()))
              .as("Shipment length is: " + uiInfo.getLength())
              .isEqualTo(uiInfo.getLength());
        }
        break;
    }
  }

  public void enterShipmentId(String shipmentId) {
    shipmentIdInput.clear();
    shipmentIdInput.setValue(shipmentId);
  }

  public void checkMessage(String message) {
    Assertions.assertThat(notice.getNoticeMessage()).as("Notification contains correct message :" + message)
        .isEqualTo(message);
    pause4s();// duration to wait ant message closed
  }

  public void checkNotificationMessage(String message) {
    antNotificationMessage.waitUntilVisible();
    Assertions.assertThat(
        this.noticeNotifications.stream().anyMatch((x) -> x.message.getText().equalsIgnoreCase(message)))
        .as("Notification contains correct message :" + message)
        .isTrue();
  }
  
  public void enterDimensionInfo(String weight, String length, String width, String height) {
    Optional.ofNullable(weight).ifPresent((val) -> {
      if (val.equalsIgnoreCase("null")) {
        weightInput.forceClear();
      } else {
        weightInput.setValue(val);
      }
    });
    Optional.ofNullable(length).ifPresent((val) -> {
      if (val.equalsIgnoreCase("null")) {
        lengthInput.forceClear();
      } else {
        lengthInput.setValue(val);
      }
    });
    Optional.ofNullable(width).ifPresent((val) -> {
      if (val.equalsIgnoreCase("null")) {
        widthInput.forceClear();
      } else {
        widthInput.setValue(val);
      }
    });

    Optional.ofNullable(height).ifPresent((val) -> {
      if (val.equalsIgnoreCase("null")) {
        heightInput.forceClear();
      } else {
        heightInput.setValue(val);
      }
    });
  }

  public void submitWeightData() {
    submitButton.click();
  }

  public void verifyDimensionFieldError(String fieldName, String errorMessage) {
    retryIfAssertionErrorOccurred(() -> {
      if (fieldName.equalsIgnoreCase("weight")) {
        Assertions.assertThat(weightInput.isError()).as("Weight input is error").isTrue();
        Assertions.assertThat(weightInput.getErrorText()).as("Weight input show correct error message "+ errorMessage)
            .isEqualTo(errorMessage);
      }
    }, "verifyDimensionFieldError", 500, 5);
  }

  public void verifyOverWeightDialog() {
    overWeightModal.verifyModalUI();
  }

  public void confirmOverWeightDialog() {
    overWeightModal.confirm();
  }

  public void cancelOverWeightDialog() {
    overWeightModal.cancel();
  }

  public static class OverWeightModal extends AntModal {

    @FindBy(css = ".ant-modal-body")
    private PageElement modalBody;
    @FindBy(id = "overweightModalConfirm")
    private AntButton confirmButton;
    @FindBy(id = "overweightModalCancel")
    private AntButton cancelButton;

    public OverWeightModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public OverWeightModal(WebDriver webDriver, SearchContext searchContext,
        WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void verifyModalUI() {
      Assertions.assertThat(title.getText()).as("Modal title is correct")
          .isEqualTo("Over Weight?");
      Assertions.assertThat(modalBody.getText()).as("Modal body is correct")
          .isEqualTo("Please double check. Is this shipment weight more than 100 kg?");
      Assertions.assertThat(confirmButton.isDisplayedFast()).as("Confirm button is visible").isTrue();
      Assertions.assertThat(confirmButton.getText()).as("Confirm button text is correct").isEqualTo("Yes, I Confirm");
      Assertions.assertThat(cancelButton.isDisplayedFast()).as("Cancel button is visible").isTrue();
      Assertions.assertThat(cancelButton.getText()).as("Cancel button text is correct").isEqualTo("No, go back");
    }

    public void cancel() {
      this.cancelButton.click();
    }

    public void confirm() {
      this.confirmButton.click();
    }
  }



  public enum ShipmentWeightAddState {
    INITIAL("initial"),
    VALID("valid"),
    ERROR("error"),
    CANCELLEDCOMPLETED("cancelled_completed"),
    HAS_DIMENSION("has dimension");


    private final String value;

    ShipmentWeightAddState(String value) {
      this.value = value;
    }

    public static ShipmentWeightAddState fromLabel(String label) {
      return Stream.of(ShipmentWeightAddState.values())
          .filter(instance -> instance.value.equals(label))
          .findFirst()
          .orElse(INITIAL);
    }
  }

}
