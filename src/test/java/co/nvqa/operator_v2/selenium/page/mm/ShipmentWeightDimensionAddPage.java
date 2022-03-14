package co.nvqa.operator_v2.selenium.page.mm;

import co.nvqa.operator_v2.cucumber.glue.mm.ShipmentWeightDimensionSteps;
import co.nvqa.operator_v2.model.ShipmentWeightDimensionAddInfo;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.mm.AntInputText;
import co.nvqa.operator_v2.selenium.elements.mm.InfoContainer;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.stream.Stream;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ShipmentWeightDimensionAddPage extends SimpleReactPage<ShipmentWeightDimensionAddPage> {
  private static final Logger LOGGER = LoggerFactory.getLogger(ShipmentWeightDimensionAddPage.class);

  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='shipment_id'] ]")
  public AntInputText shipmentIdInput;
  @FindBy(id = "shipmentScanSubmit")
  public AntButton searchButton;
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
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='weight'] ]")
  public AntInputText weightInput;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='length'] ]")
  public AntInputText lengthInput;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='width'] ]")
  public AntInputText widthInput;
  @FindBy(xpath = "//div[contains(@class,' ant-form-item-control') and .//input[@id='height'] ]")
  public AntInputText heightInput;



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

  public void checkNotificationMessage(String message) {
    antNotificationMessage.waitUntilVisible();
    Assertions.assertThat(
        this.noticeNotifications.stream().anyMatch((x) -> x.message.getText().equalsIgnoreCase(message)))
        .as("Notification contains correct message :" + message)
        .isTrue();
  }


  public enum ShipmentWeightAddState {
    INITIAL("initial"),
    VALID("valid"),
    ERROR("error"),
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
