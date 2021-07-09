package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.AddressDownloadFilteringType;
import co.nvqa.operator_v2.selenium.page.AddressingDownloadPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.Keys;

public class AddressingDownloadSteps extends AbstractSteps {

  private AddressingDownloadPage addressingDownloadPage;

  private static final String FILTER_SHOWN_XPATH = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]";

  public AddressingDownloadSteps() {
  }

  @Override
  public void init() {
    addressingDownloadPage = new AddressingDownloadPage(getWebDriver());
  }

  @Then("Operator verifies that the page is fully loaded")
  public void operatorVerifiesThatThePageIsFullyLoaded() {
    addressingDownloadPage.switchToIframe();
    addressingDownloadPage.verifiesPageIsFullyLoaded();
  }

  @When("Operator clicks on the ellipses")
  public void operatorClicksOnTheEllipses() {
    addressingDownloadPage.ellipses.click();
    addressingDownloadPage.verifiesOptionIsShown();
  }

  @And("Operator clicks on {string} Preset Option on the Address Download Page")
  public void clicksOnOptionOnTheAddressDownloadPage(String option) {
    final String CREATE = "create";
    final String EDIT = "edit";

    if (CREATE.equalsIgnoreCase(option)) {
      addressingDownloadPage.createNewPreset.click();
    } else if (EDIT.equalsIgnoreCase(option)) {
      addressingDownloadPage.editPreset.click();
    }
    addressingDownloadPage.verifiesModalIsShown();
  }

  @And("Operator creates a preset using {string} filter")
  public void operatorCreatesAPresetUsingFilter(String filter) {
    AddressDownloadFilteringType filterType = AddressDownloadFilteringType.fromString(filter);
    String presetName =
        "AUTO-" + StandardTestConstants.COUNTRY_CODE.toUpperCase() + "-" + RandomUtil
            .randomString(7);

    addressingDownloadPage.inputPresetName.sendKeys(presetName);

    retryIfAssertionErrorOccurred(() -> {
          addressingDownloadPage.filterButton.click();
          pause1s();
          addressingDownloadPage.selectPresetFilter(filterType);
          assertTrue(addressingDownloadPage.isElementExistFast(FILTER_SHOWN_XPATH));
        },
        "Clicking Filter for Preset");

    addressingDownloadPage.setPresetFilter(filterType);
    addressingDownloadPage.mainPresetButtonInModal.click();
    put(KEY_CREATED_ADDRESS_PRESET_NAME, presetName);
  }

  @Then("Operator verifies that there will be success preset creation toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetCreationToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Created");
  }

  @And("Operator verifies that the created preset is existed")
  public void operatorVerifiesThatTheCreatedPresetIsExisted() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.verifiesPresetIsExisted(presetName);
  }

  @When("Operator deletes the created preset")
  public void operatorDeletesTheCreatedPreset() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.ellipses.click();
    addressingDownloadPage.verifiesOptionIsShown();
    addressingDownloadPage.editPreset.click();
    addressingDownloadPage.verifiesModalIsShown();
    addressingDownloadPage.selectPresetEditModal.click();
    addressingDownloadPage.selectPresetEditModal.sendKeys(presetName);
    addressingDownloadPage.selectPresetEditModal.sendKeys(Keys.ENTER);
    addressingDownloadPage.deletePresetButton.click();
    addressingDownloadPage.mainPresetButtonInModal.click();
  }

  @Then("Operator verifies that there will be success preset deletion toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetDeletionToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Deleted");
  }

  @And("Operator verifies that the created preset is deleted")
  public void operatorVerifiesThatTheCreatedPresetIsDeleted() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.verifiesPresetIsNotExisted(presetName);
  }

  @And("Operator edits the created preset")
  public void operatorEditsTheCreatedPreset() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.selectPresetEditModal.click();
    addressingDownloadPage.selectPresetEditModal.sendKeys(presetName);
    addressingDownloadPage.selectPresetEditModal.sendKeys(Keys.ENTER);

    String newPresetName =
        "AUTO-" + StandardTestConstants.COUNTRY_CODE.toUpperCase() + "-" + RandomUtil
            .randomString(7);
    pause2s();
    addressingDownloadPage.inputPresetName.sendKeys(newPresetName);
    addressingDownloadPage.mainPresetButtonInModal.click();
    put(KEY_CREATED_ADDRESS_PRESET_NAME, presetName + newPresetName);
  }

  @Then("Operator verifies that there will be success preset edit toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetEditToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Edited");
  }

  @When("Operator clicks on Load Tracking IDs Button")
  public void operatorClicksOnLoadTrackingIDsButton() {
    addressingDownloadPage.loadTrackingIds.click();
    addressingDownloadPage.verifiesModalIsShown();
  }

  @And("Operator fills the {string} Tracking ID textbox with {string} separation")
  public void operatorFillsTheTrackingIDTextboxWithSeparation(String trackingIdType,
      String separation) {
    // Tracking ID type
    final String VALID = "valid";
    final String HALF = "half";

    // Separation
    final String COMMA = "comma";
    final String SPACE = "space";
    final String NEW_LINE = "new_line";
    final String MIXED = "mixed";

    pause5s();

    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    if (VALID.equalsIgnoreCase(trackingIdType)) {
      if (COMMA.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(",", trackingIds));
      } else if (SPACE.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(" ", trackingIds));
      } else if (NEW_LINE.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join("\n", trackingIds));
      } else if (MIXED.equalsIgnoreCase(separation)) {
        for (int i = 0; i < trackingIds.size(); i++) {
          if (i == 0) {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingIds.get(i) + ",");
          } else if (i > 0 && i % 2 == 0) {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingIds.get(i) + " ");
          } else {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingIds.get(i) + "\n");
          }
        }
      }
      else {
          NvLogger.warn("Separation is not found!");
      }
    } else if (HALF.equalsIgnoreCase(trackingIdType)) {
      final String invalidTrackingId = "AUTOTEST" + RandomUtil.randomString(5);
      trackingIds.add(invalidTrackingId);
      addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(",", trackingIds));
    } else {
      NvLogger.warn("Automation only covered VALID and HALF VALID HALF INVALID types");
    }
  }

  @And("Operator clicks on Next Button on Address Download Load Tracking ID modal")
  public void operatorClicksOnNextButtonOnAddressDownloadLoadTrackingIDModal() {
    pause1s();
    addressingDownloadPage.nextButtonLoadTrackingId.click();
  }

  @Then("Operator verifies that the Address Download Table Result is shown up")
  public void operatorVerifiesThatTheAddressDownloadTableResultIsShownUp() {
    addressingDownloadPage.addressDownloadTableResult.isDisplayed();
  }

  @Then("Operator verifies that the Address Download Table Result for bulk tracking ids is shown up")
  public void operatorVerifiesThatTheAddressDownloadTableResultForBulkTrackingIdsIsShownUp() {
    if (addressingDownloadPage.trackingIdNotFound.isDisplayed()) {
      addressingDownloadPage.nextButtonLoadTrackingId.click();
    }
    operatorVerifiesThatTheAddressDownloadTableResultIsShownUp();
  }

  @When("Operator clicks on download csv button on Address Download Page")
  public void operatorClicksOnDownloadCsvButtonOnAddressDownloadPage() {
    addressingDownloadPage.downloadCsv.click();
  }

  @Then("Operator verifies that the downloaded csv file details of Address Download is right")
  public void operatorVerifiesThatTheDownloadedCsvFileDetailsOfAddressDownloadIsRight() {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    addressingDownloadPage.csvDownloadSuccessfullyAndContainsTrackingId(orders);
  }

  @Then("Operator verifies there will be error dialog shown and clicks on next button")
  public void operatorVerifiesThereWillBeErrorDialogShownAndClicksOnNextButton() {
    addressingDownloadPage.verifiesModalIsShown();
    addressingDownloadPage.trackingIdNotFound.isDisplayed();
    addressingDownloadPage.nextButtonLoadTrackingId.click();
  }

  @And("Operator verifies that the RTS order is identified")
  public void operatorVerifiesThatTheRTSOrderIsIdentified() {
    addressingDownloadPage.rtsOrderIsIdentified();
  }

  @Then("Operator verifies that newly created order is not written in the textbox")
  public void operatorVerifiesThatNewlyCreatedOrderIsNotWrittenInTheTextbox() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    addressingDownloadPage.trackingIdtextArea.sendKeys("," + trackingId);
    String trackingIdsListed = addressingDownloadPage.trackingIdtextArea.getText();
    assertTrue(!(trackingIdsListed.contains("," + trackingId)));
  }
}
