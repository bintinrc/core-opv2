package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.AddressVerificationPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.interactions.Actions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class AddressVerificationSteps extends AbstractSteps {

  private AddressVerificationPage addressVerificationPage;

  public AddressVerificationSteps() {
  }

  @Override
  public void init() {
    addressVerificationPage = new AddressVerificationPage(getWebDriver());
  }

  @When("Address Verification page is loaded")
  public void movementManagementPageIsLoaded() {
    addressVerificationPage.switchTo();
    addressVerificationPage.waitUntilLoaded();
  }

  @When("Operator clicks on 'Verify Address' tab on Address Verification page")
  public void operatorClicksOnVerifyAddressTab() {
    addressVerificationPage.verifyAddressTab.click();
  }

  @When("Operator fetch addresses by {string} route group on Address Verification page")
  public void operatorFetchAddressesByRouteGroup(String routeGroup) {
    addressVerificationPage.routeGroup.selectValue(resolveValue(routeGroup));
    addressVerificationPage.fetchAddressByRouteGroup.clickAndWaitUntilDone();
  }

  @When("Operator verify fetched addresses are displayed on Address Verification page:")
  public void operatorVerifyFetchAddresses(List<String> expected) {
    expected = resolveValues(expected);
    List<String> actual = addressVerificationPage.fetchedAddresses.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    Assertions.assertThat(actual).as("List of fetched addresses").containsAll(expected);
  }

  @When("Operator clicks on 'Edit' button for {int} address on Address Verification page")
  public void operatorOpenEditAddressModal(Integer index) {
    if (index == -1) {
      index = addressVerificationPage.editLinks.size();
    }
    addressVerificationPage.editLinks.get(index - 1).click();
  }

  @When("Operator fills address parameters in Edit Address modal on Address Verification page:")
  public void operatorEnterAddressParameters(Map<String, String> data) {
    data = resolveKeyValues(data);
    String value = data.get("latitude");
    if (StringUtils.isNotBlank(value)) {
      double latitude = StringUtils.equalsIgnoreCase(value, "generated") ?
          TestUtils.generateLatitude() :
          Double.parseDouble(value);
      addressVerificationPage.editAddressModal.latitude.forceClear();
      addressVerificationPage.editAddressModal.latitude.setValue(latitude);
    }

    value = data.get("longitude");
    if (StringUtils.isNotBlank(value)) {
      double longitude = StringUtils.equalsIgnoreCase(value, "generated") ?
          TestUtils.generateLongitude() :
          Double.parseDouble(value);
      addressVerificationPage.editAddressModal.longitude.forceClear();
      addressVerificationPage.editAddressModal.longitude.setValue(longitude);
    }
  }

  @When("Operator clicks 'Save' button in Edit Address modal on Address Verification page:")
  public void operatorClickSaveButtonInEditAddressModal() {
    addressVerificationPage.editAddressModal.save.click();
  }

  @When("Operator archives {int} address on Address Verification page")
  public void operatorArchivesAddress(int index) {
    addressVerificationPage.moreLinks.get(index - 1).scrollIntoView(true);
    addressVerificationPage.moreLinks.get(index - 1).moveToElement();
    pause500ms();
    new Actions(getWebDriver())
        .moveToElement(addressVerificationPage.moreLinks.get(index - 1).getWebElement())
        .pause(500)
        .moveToElement(addressVerificationPage.archiveAddress.getWebElement())
        .pause(500)
        .click()
        .perform();
  }

  @When("Operator save {int} address on Address Verification page")
  public void operatorSaveAddress(int index) {
    addressVerificationPage.moreLinks.get(index - 1).scrollIntoView(true);
    addressVerificationPage.moreLinks.get(index - 1).moveToElement();
    pause500ms();
    new Actions(getWebDriver())
        .moveToElement(addressVerificationPage.moreLinks.get(index - 1).getWebElement())
        .pause(500)
        .moveToElement(addressVerificationPage.saveAddress.getWebElement())
        .pause(500)
        .click()
        .perform();
  }

  @When("Operator initialize address pool with all options checked in Address Verification page")
  public void operatorInitializeAddressPoolWithAllOptionsCheckedInAddressVerificationPage() {
    addressVerificationPage.isInboundOnlyCheckBox.check();
    addressVerificationPage.isSameDayOrdersCheckBox.check();
    addressVerificationPage.isPriorityOrdersCheckBox.check();
    addressVerificationPage.initializePoolButton.click();
  }

  @When("Operator fetch addresses from initialized pool from zone {string}")
  public void operatorFetchAddressesFromInitializedPoolFromZone(String zoneName) {
    addressVerificationPage.switchTo();
    addressVerificationPage.fetchAddressFromInitializedPool(resolveValue(zoneName));
  }

  @When("Operator assign {string} zone to the last address on Address Verification page")
  public void operatorAssignZoneToTheLastAddressOnAddressVerificationPage(String zoneName) {
    addressVerificationPage.assignZoneToLatestAddress(zoneName);
  }
}
