package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.AddressDownloadFilteringType;
import co.nvqa.operator_v2.selenium.page.AddressingDownloadPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.openqa.selenium.Keys;

public class AddressingDownloadSteps extends AbstractSteps {

  private AddressingDownloadPage addressingDownloadPage;

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
    addressingDownloadPage.filterButton.click();
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
}
