package co.nvqa.operator_v2.selenium.page.mm;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.mm.AntInputText;
import co.nvqa.operator_v2.selenium.elements.mm.InfoContainer;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.stream.Stream;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class ShipmentWeightDimensionAddPage extends SimpleReactPage<ShipmentWeightDimensionAddPage> {

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

  public ShipmentWeightDimensionAddPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyUI(String state, String message) {
    Assertions.assertThat(shipmentIdInput.isDisplayed()).as("Shipment ID Input is visible")
        .isTrue();
    Assertions.assertThat(searchButton.isDisplayed()).as("Search button is visible").isTrue();
    Assertions.assertThat(startHubInfo.isDisplayed()).as("Start Hub Info is visible").isTrue();
    Assertions.assertThat(endHubInfo.isDisplayed()).as("End Hub Info is visible").isTrue();
    Assertions.assertThat(noOfParcelsInfo.isDisplayed()).as("No of parcels is visible").isTrue();
    Assertions.assertThat(statusInfo.isDisplayed()).as("Status is visible").isTrue();
    Assertions.assertThat(commentsInfo.isDisplayed()).as("Comments is visible").isTrue();

    State stateEnum = State.fromLabel(state);
    switch (stateEnum) {
      case ERROR:
        Assertions.assertThat(shipmentIdInput.isError()).as("Shipment ID Input is show error").isTrue();
        Assertions.assertThat(shipmentIdInput.getErrorText()).as("Shipment ID input is correct")
            .isEqualTo(message);
        break;
      case INITIAL:
        Assertions.assertThat(startHubInfo.getInfoText()).as("Start Hub show -- on initial load")
            .isEqualTo("--");
        Assertions.assertThat(endHubInfo.getInfoText()).as("End Hub show -- on initial load")
            .isEqualTo("--");
        Assertions.assertThat(noOfParcelsInfo.getInfoText())
            .as("No of Parcels show -- on initial load")
            .isEqualTo("--");
        Assertions.assertThat(statusInfo.getInfoText()).as("Status show -- on initial load")
            .isEqualTo("--");
        Assertions.assertThat(commentsInfo.getInfoText()).as("Comments show -- on initial load")
            .isEqualTo("--");
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
        .as("Notification contains correct message")
        .isTrue();
  }


  public enum State {
    INITIAL("initial"),
    ERROR("error");

    private final String value;

    State(String value) {
      this.value = value;
    }

    public static State fromLabel(String label) {
      return Stream.of(State.values())
          .filter(instance -> instance.value.equals(label))
          .findFirst()
          .orElse(INITIAL);
    }
  }

}
