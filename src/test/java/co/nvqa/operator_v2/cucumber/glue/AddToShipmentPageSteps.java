package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.mm.AntNotice;
import co.nvqa.operator_v2.selenium.page.AddToShipmentPage;
import com.google.common.collect.ImmutableMap;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class AddToShipmentPageSteps extends AbstractSteps {

  private AddToShipmentPage addToShipmentPage;

  public AddToShipmentPageSteps() {
  }

  @Override
  public void init() {
    addToShipmentPage = new AddToShipmentPage(getWebDriver());
  }

  @When("^Operator scan order to shipment on Add to Shipment page:$")
  public void operatorScanOrderToShipment(Map<String, String> data) {
    operatorSelectValuesShipment(data);
    Map<String, String> finalData = resolveKeyValues(data);
    addToShipmentPage.inFrame(page -> {
      page.addParcelToShipment.click();
      page.addTrackingIdInput.setValue(finalData.get("barcode") + Keys.ENTER);
      page.waitUntilLoaded();
    });
  }

  @When("^Operator verifies tags are displayed on Add to Shipment page:$")
  public void verifyTags(List<String> data) {
    addToShipmentPage.inFrame(page -> {
      Assertions.assertThat(page.tags.stream().map(PageElement::getNormalizedText).collect(
              Collectors.toList()))
          .as("List of displayed tags")
          .containsExactlyInAnyOrderElementsOf(resolveValues(data));
    });
  }

  @When("^Operator select values on Add to Shipment page:$")
  public void operatorSelectValuesShipment(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    addToShipmentPage.inFrame(page -> {
      page.waitUntilLoaded();
      String value = finalData.get("originHub");
      if (StringUtils.isNotBlank(value)) {
        page.originHub.selectValue(value);
      }
      value = finalData.get("destinationHub");
      if (StringUtils.isNotBlank(value)) {
        page.destinationHub.selectValue(value);
      }
      value = finalData.get("shipmentType");
      if (StringUtils.isNotBlank(value)) {
        page.shipmentType.selectValueWithoutSearch(value);
      }
      value = finalData.get("shipmentId");
      if (StringUtils.isNotBlank(value)) {
        page.shipmentId.waitUntilEnabled();
        page.shipmentId.selectValue(finalData.get("shipmentId"));
      }
    });
  }

  @When("^Operator close shipment on Add to Shipment page$")
  public void closeShipment() {
    addToShipmentPage.inFrame(page -> {
      page.closeShipment.click();
      page.confirmCloseShipmentModal.waitUntilVisible();
      page.confirmCloseShipmentModal.closeShipment.click();
    });
  }

  @When("Operator verifies shipment label settings are {value} on Add to Shipment page")
  public void setShipmentLabelSticker(String value) {
    addToShipmentPage.inFrame(page -> {
      Assertions.assertThat(page.currentPrintCriteriaTitle.getNormalizedText())
          .as("Current print criteria title")
          .isEqualToIgnoringCase(value);
    });
  }

  @When("^Operator set shipment label sticker settings on Add to Shipment page:$")
  public void setShipmentLabelSticker(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    addToShipmentPage.inFrame(page -> {
      page.editPrintCriteriaLink.click();
      page.shipmentLabelStickerModal.waitUntilVisible();
      String value = finalData.get("version");
      if (StringUtils.equalsIgnoreCase(value, "single")) {
        page.shipmentLabelStickerModal.single.click();
      } else if (StringUtils.equalsIgnoreCase(value, "folded")) {
        page.shipmentLabelStickerModal.folded.click();
      }
      value = finalData.get("size");
      if (StringUtils.startsWithIgnoreCase(value, "70 x 50")) {
        page.shipmentLabelStickerModal.size70x50.click();
      } else if (StringUtils.startsWithIgnoreCase(value, "100 x 150")) {
        page.shipmentLabelStickerModal.size100x150.click();
      }
      value = finalData.get("printWhenClose");
      if (StringUtils.equalsIgnoreCase(value, "true")) {
        page.shipmentLabelStickerModal.isPrintWhenClose.check();
      } else if (StringUtils.equalsIgnoreCase(value, "false")) {
        page.shipmentLabelStickerModal.isPrintWhenClose.uncheck();
      }
      page.shipmentLabelStickerModal.saveLabelSettings.click();
      page.shipmentLabelStickerModal.waitUntilInvisible();
    });
  }

  @When("^Operator clicks Create Shipment on Add to Shipment page$")
  public void clickCreateShipment() {
    addToShipmentPage.inFrame(page -> {
      page.waitUntilLoaded(3);
      page.createShipment.click();
    });
  }

  @When("^Operator verifies fields in Create Shipment modal on Add to Shipment page:$")
  public void verifyCreateShipmentFields(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      SoftAssertions assertions = new SoftAssertions();
      String value = finalData.get("originHub");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.createShipmentModal.originHub.getValue())
            .as("Origin Hub")
            .isEqualTo(value);
      }
      value = finalData.get("destinationHub");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.createShipmentModal.destinationHub.getValue())
            .as("Destination Hub")
            .isEqualTo(value);
      }
      value = finalData.get("shipmentType");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.createShipmentModal.shipmentType.getValue())
            .as("Shipment Type")
            .isEqualTo(value);
      }
      value = finalData.get("comments");
      if (StringUtils.isNotBlank(value)) {
        assertions.assertThat(page.createShipmentModal.comments.getValue())
            .as("Comments")
            .isEqualTo(value);
      }
      assertions.assertAll();
    });
  }

  @When("^Operator set values in Create Shipment modal on Add to Shipment page:$")
  public void setCreateShipmentFields(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      page.createShipmentModal.originHub.waitUntilEnabled();

      String value = finalData.get("originHub");
      if (StringUtils.isNotBlank(value)) {
        page.createShipmentModal.originHub.selectValue(value);
      }
      value = finalData.get("destinationHub");
      if (StringUtils.isNotBlank(value)) {
        page.createShipmentModal.destinationHub.selectValue(value);

      }
      value = finalData.get("shipmentType");
      if (StringUtils.isNotBlank(value)) {
        page.createShipmentModal.shipmentType.selectValueWithoutSearch(value);
      }
      value = finalData.get("comments");
      if (StringUtils.isNotBlank(value)) {
        page.createShipmentModal.comments.setValue(value);
      }
    });
  }

  @When("Operator verifies {value} Origin Hub is not shown in Create Shipment modal on Add to Shipment page")
  public void verifyInvalidOriginHub(String value) {
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      page.createShipmentModal.originHub.waitUntilEnabled();
      Assertions.assertThatExceptionOfType(NoSuchElementException.class)
          .as("Error expected for %s Origin Hub value", value)
          .isThrownBy(() -> page.createShipmentModal.originHub.selectValue(value));
    });
  }

  @When("Operator verifies {value} Destination Hub is not shown in Create Shipment modal on Add to Shipment page")
  public void verifyInvalidDestinationHub(String value) {
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      page.createShipmentModal.destinationHub.waitUntilEnabled();
      Assertions.assertThatExceptionOfType(NoSuchElementException.class)
          .as("Error expected for %s Destination Hub value", value)
          .isThrownBy(() -> page.createShipmentModal.destinationHub.selectValue(value));
    });
  }

  @When("^Operator verifies mandatory fields in Create Shipment modal on Add to Shipment page$")
  public void verifyMandatoryFieldsInCreateShipmentModal() {
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      page.createShipmentModal.originHub.waitUntilEnabled();
      Assertions.assertThat(page.createShipmentModal.originHubLabel.getAttribute("class"))
          .as("Class of Origin Hub label")
          .contains("ant-form-item-required");
      Assertions.assertThat(page.createShipmentModal.destinationHubLabel.getAttribute("class"))
          .as("Class of Destination Hub label")
          .contains("ant-form-item-required");
      Assertions.assertThat(page.createShipmentModal.shipmentTypeLabel.getAttribute("class"))
          .as("Class of Shipment Type label")
          .contains("ant-form-item-required");

      page.createShipmentModal.originHub.selectByIndex(1);
      page.createShipmentModal.originHub.clearValue();
      Assertions.assertThat(page.createShipmentModal.originHubAlert.isDisplayedFast())
          .as("Origin Hub mandatory field alert is displayed")
          .isTrue();
      Assertions.assertThat(page.createShipmentModal.originHubAlert.getText())
          .as("Origin Hub mandatory field alert text")
          .isEqualTo("Please enter Origin Hub");

      page.createShipmentModal.destinationHub.selectByIndex(1);
      page.createShipmentModal.destinationHub.clearValue();
      Assertions.assertThat(page.createShipmentModal.destinationHubAlert.isDisplayedFast())
          .as("Destination Hub mandatory field alert is displayed")
          .isTrue();
      Assertions.assertThat(page.createShipmentModal.destinationHubAlert.getText())
          .as("Destination Hub mandatory field alert text")
          .isEqualTo("Please enter Destination Hub");
    });
  }

  @When("^Operator verifies same hubs alert in Create Shipment modal on Add to Shipment page$")
  public void verifySameHubsAlertInCreateShipmentModal() {
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      String alert = "Origin Hub and Destination Hub cannot be the same";
      Assertions.assertThat(page.createShipmentModal.originHubAlert.isDisplayedFast())
          .as("Origin Hub mandatory field alert is displayed")
          .isTrue();
      Assertions.assertThat(page.createShipmentModal.originHubAlert.getText())
          .as("Origin Hub mandatory field alert text")
          .isEqualTo(alert);

      Assertions.assertThat(page.createShipmentModal.destinationHubAlert.isDisplayedFast())
          .as("Destination Hub mandatory field alert is displayed")
          .isTrue();
      Assertions.assertThat(page.createShipmentModal.destinationHubAlert.getText())
          .as("Destination Hub mandatory field alert text")
          .isEqualTo(alert);
    });
  }

  @When("^Operator clicks Create Shipment in Create Shipment modal on Add to Shipment page$")
  public void clickCreateShipmentInModal() {
    addToShipmentPage.inFrame(page -> {
      page.createShipmentModal.waitUntilVisible();
      page.createShipmentModal.createShipment.click();
    });
  }

  @When("^Operator verifies Create Shipment button is disabled in Create Shipment modal on Add to Shipment page$")
  public void verifyCreateShipmentIsDisabled() {
    addToShipmentPage.inFrame(page -> {
      Assertions.assertThat(page.createShipmentModal.createShipment.isEnabled())
          .as("Create shipment button is enabled")
          .isFalse();
    });
  }

  @And("Operator verifies that Created new shipment notification displayed")
  public void operatorVerifySuccessCreateShipmentToastDisplayed() {
    String text = operatorVerifySuccessReactToast(
        ImmutableMap.of("top", "^Created new shipment.*"));
    Long shipmentId = Long.valueOf(text.substring(text.lastIndexOf(" ")).trim());
    put(KEY_CREATED_SHIPMENT_ID, shipmentId);
    putInList(KEY_LIST_OF_CREATED_SHIPMENT_IDS, shipmentId);
    putInList(KEY_LIST_OF_CREATED_SHIPMENT_ID, shipmentId);
  }

  @And("Operator verifies that notification displayed:")
  public String operatorVerifySuccessReactToast(Map<String, String> data) {
    return addToShipmentPage.returnFromFrame(page -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean
          .parseBoolean(finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotice toastInfo;
      do {
        toastInfo = page.notices.stream()
            .filter(toast -> {
              String actualTop = toast.getNoticeMessage();
              String value = finalData.get("top");
              if (StringUtils.isNotBlank(value)) {
                if (value.startsWith("^")) {
                  return actualTop.matches(value);
                } else {
                  return StringUtils.equalsIgnoreCase(value, actualTop);
                }
              }
              return true;
            })
            .findFirst()
            .orElse(null);
      } while (toastInfo == null && new Date().getTime() - start < 20000);
      Assertions.assertThat(toastInfo)
          .as("Toast " + finalData + " is displayed")
          .isNotNull();
      String text = toastInfo.getNoticeMessage();
      if (waitUntilInvisible) {
        toastInfo.waitUntilInvisible();
      }
      return text;
    });
  }

}