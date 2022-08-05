package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.addressing.Address;
import co.nvqa.operator_v2.model.Addressing;
import co.nvqa.operator_v2.selenium.page.AddressDatasourcePage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

@ScenarioScoped
public class AddressDatasourceSteps extends AbstractSteps {

  private AddressDatasourcePage addressDatasourcePage;

  public AddressDatasourceSteps() {
  }

  private final String KEY_KECAMATAN = "kecamatan";
  private final String KEY_KOTA = "kota";
  private final String KEY_PROVINCE = "province";
  private final String KEY_BARANGAY = "barangay";
  private final String KEY_MUNICIPALITY = "municipality";
  private final String KEY_HUB = "hub";
  private final String KEY_ZONE = "zone";
  private final String KEY_LATITUDE = "latitude";
  private final String KEY_LONGITUDE = "longitude";
  private final String KEY_LATLONG = "latlong";
  private final String SYS_ID = "id";
  private final String SYS_PH = "ph";

  @Override
  public void init() {
    addressDatasourcePage = new AddressDatasourcePage(getWebDriver());
  }

  @When("^Operator clicks on Add a Row Button on Address Datasource Page$")
  public void clickAddRowButton() {
    addressDatasourcePage.switchTo();
    addressDatasourcePage.clickAddRowButton();
  }

  @Then("^Operator verifies Add Button is Disabled$")
  public void verifiesAddButtonDisabled() {
    Assertions.assertThat(addressDatasourcePage.add.isEnabled()).as("Add button is disabled")
        .isFalse();
  }

  @Then("^Operator verifies invalid latlong message$")
  public void verifiesInvalidLatlongMessage() {
    Assertions.assertThat(addressDatasourcePage.invalidLatlong.getText()).as("invalid Latlong")
        .isEqualToIgnoringCase("Latitude must be at minimum 5 decimal places");
  }

  @When("^Operator fills address parameters in Add a Row modal on Address Datasource page:$")
  public void operatorFillsAddressDatasource(Map<String, String> data) {
    data = resolveKeyValues(data);
    String latlong = data.get(KEY_LATLONG);
    String province = data.get(KEY_PROVINCE);
    String kota = data.get(KEY_KOTA);
    String kecamatan = data.get(KEY_KECAMATAN);
    String municipality = data.get(KEY_MUNICIPALITY);
    String barangay = data.get(KEY_BARANGAY);
    Addressing addressing = new Addressing();

    if (StringUtils.isNotBlank(latlong) && StringUtils.equalsIgnoreCase(latlong, "generated")) {
      Double latitude = TestUtils.generateLatitude();
      Double longitude = TestUtils.generateLongitude();
      String latlongValue = latitude + "," + longitude;
      addressDatasourcePage.latlong.setValue(latlongValue);
      addressing.setLatitude(latitude);
      addressing.setLongitude(longitude);
    } else if (StringUtils.isNotBlank(latlong) && !StringUtils
        .equalsIgnoreCase(latlong, "generated")) {
      String latitude = latlong.split(",")[0];
      String longitude = latlong.split(",")[1];

      addressDatasourcePage.latlong.setValue(latlong);
      addressing.setLatitude(Double.valueOf(latitude));
      addressing.setLongitude(Double.valueOf(longitude));
    }
    if (StringUtils.isNotBlank(province)) {
      addressDatasourcePage.province.setValue(province);
      addressing.setProvince(province);
    }
    if (StringUtils.isNotBlank(kota)) {
      addressDatasourcePage.kota.setValue(kota);
      addressing.setCity(kota);
    }
    if (StringUtils.isNotBlank(kecamatan)) {
      addressDatasourcePage.kecamatan.setValue(kecamatan);
      addressing.setDistrict(kecamatan);
    }
    if (StringUtils.isNotBlank(municipality)) {
      addressDatasourcePage.municipality.setValue(municipality);
      addressing.setCity(municipality);
    }
    if (StringUtils.isNotBlank(barangay)) {
      addressDatasourcePage.barangay.setValue(barangay);
      addressing.setDistrict(barangay);
    }

    put(KEY_CREATED_ADDRESSING, addressing);
  }

  @When("^Operator clicks on Add Button in Add a Row modal on Address Datasource page$")
  public void operatorClickAddButton() {
    addressDatasourcePage.add.waitUntilClickable();
    addressDatasourcePage.add.click();
  }

  @When("^Operator clicks on Proceed Button in Row Details modal on Address Datasource page$")
  public void operatorClickProceedButton() {
    addressDatasourcePage.proceed.waitUntilClickable();
    addressDatasourcePage.proceed.click();
  }

  @When("^Operator clicks on Replace Button in Row Details modal on Address Datasource page$")
  public void operatorClickReplacrButton() {
    addressDatasourcePage.replace.waitUntilClickable();
    addressDatasourcePage.replace.click();
    addressDatasourcePage.confirmReplace.waitUntilVisible();
    addressDatasourcePage.confirmReplace.click();
  }

  @Then("^Operator verifies the address datasorce details in Row Details modal:$")
  public void operatorVerifiesDetailsInRowDetailsModal(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (StringUtils.isNotBlank(data.get(KEY_PROVINCE))) {
      Assertions.assertThat(addressDatasourcePage.provinceAddRow.getText())
          .as("Province")
          .isEqualToIgnoringCase(data.get(KEY_PROVINCE));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KOTA))) {
      Assertions.assertThat(addressDatasourcePage.kotaAddRow.getText())
          .as("Kota")
          .isEqualToIgnoringCase(data.get(KEY_KOTA));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KECAMATAN))) {
      Assertions.assertThat(addressDatasourcePage.kecamatanAddRow.getText())
          .as("kecamatan")
          .isEqualToIgnoringCase(data.get(KEY_KECAMATAN));
    }
    if (StringUtils.isNotBlank(data.get(KEY_MUNICIPALITY))) {
      Assertions.assertThat(addressDatasourcePage.municipalityAddRow.getText())
          .as("Municipality")
          .isEqualToIgnoringCase(data.get(KEY_MUNICIPALITY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_BARANGAY))) {
      Assertions.assertThat(addressDatasourcePage.barangayAddRow.getText())
          .as("Barangay")
          .isEqualToIgnoringCase(data.get(KEY_BARANGAY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_HUB))) {
      Assertions.assertThat(addressDatasourcePage.hubAddRow.getText())
          .as("hub")
          .isEqualToIgnoringCase(data.get(KEY_HUB));
    }
    if (StringUtils.isNotBlank(data.get(KEY_ZONE))) {
      Assertions.assertThat(addressDatasourcePage.zoneAddRow.getText())
          .as("zone")
          .isEqualToIgnoringCase(data.get(KEY_ZONE));
    }
  }

  @Then("Operator verify the data source toast:")
  public void operatorVerifyAddDataSourceToast(Map<String, String> data) {
    data = resolveKeyValues(data);
    addressDatasourcePage.notification.message.waitUntilVisible();
    String header = addressDatasourcePage.notification.message.getText();
    String body = addressDatasourcePage.notification.description.getText();

    Assertions.assertThat(header)
        .as("show correct header message :" + data.get("top"))
        .isEqualTo(data.get("top"));

    Assertions.assertThat(body)
        .as("Message: " + data.get("body"))
        .isEqualTo(data.get("body"));
  }

  @Then("^Operator verifies new address datasource is added:$")
  public void operatorVerifiesNewAddressDatasource(Map<String, String> data) {
    data = resolveKeyValues(data);
    Address address = new Address();
    address.setId(addressDatasourcePage.createdRawId.getText());
    put(KEY_CREATED_ADDRESS, address);

    if (StringUtils.isNotBlank(data.get(KEY_PROVINCE))) {
      Assertions.assertThat(addressDatasourcePage.createdProvince.getText())
          .as("Created province " + addressDatasourcePage.createdProvince.getText())
          .isEqualToIgnoringCase(data.get(KEY_PROVINCE));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KOTA))) {
      Assertions.assertThat(addressDatasourcePage.createdKota.getText())
          .as("Created Kota " + addressDatasourcePage.createdKota.getText())
          .isEqualToIgnoringCase(data.get(KEY_KOTA));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KECAMATAN))) {
      Assertions.assertThat(addressDatasourcePage.createdKecamatan.getText())
          .as("Created kecamatan " + addressDatasourcePage.createdKecamatan.getText())
          .isEqualToIgnoringCase(data.get(KEY_KECAMATAN));
    }
    if (StringUtils.isNotBlank(data.get(KEY_MUNICIPALITY))) {
      Assertions.assertThat(addressDatasourcePage.createdMunicipality.getText())
          .as("Created Municipality " + addressDatasourcePage.createdMunicipality.getText())
          .isEqualToIgnoringCase(data.get(KEY_MUNICIPALITY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_BARANGAY))) {
      Assertions.assertThat(addressDatasourcePage.createdBarangay.getText())
          .as("Created Barangay " + addressDatasourcePage.createdBarangay.getText())
          .isEqualToIgnoringCase(data.get(KEY_BARANGAY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_LATITUDE)) && StringUtils
        .isNotBlank(data.get(KEY_LONGITUDE))) {
      Assertions.assertThat(addressDatasourcePage.createdLatlong.getText())
          .as("Created LatLong " + addressDatasourcePage.createdLatlong.getText())
          .isEqualToIgnoringCase(data.get(KEY_LATITUDE) + ", " + data.get(KEY_LONGITUDE));
    }
  }

  @When("^Operator search the created address datasource:$")
  public void operatorSearchCreatedAddressDatasource(Map<String, String> data) {
    data = resolveKeyValues(data);
    addressDatasourcePage.notification.message.waitUntilVisible();
    pause2s();
    if (data.containsKey(KEY_KECAMATAN)) {
      addressDatasourcePage.provinceTextBox.sendKeys(data.get(KEY_PROVINCE));
      addressDatasourcePage.kotaTextBox.sendKeys(data.get(KEY_KOTA));
      addressDatasourcePage.kecamatanTextBox.sendKeys(data.get(KEY_KECAMATAN));
    } else if (data.containsKey(KEY_BARANGAY)) {
      addressDatasourcePage.provinceTextBox.sendKeys(data.get(KEY_PROVINCE));
      addressDatasourcePage.kotaTextBox.sendKeys(data.get(KEY_MUNICIPALITY));
      addressDatasourcePage.kecamatanTextBox.sendKeys(data.get(KEY_BARANGAY));
    }
    addressDatasourcePage.searchButton.click();
  }

  @Then("^Operator verify search field lable:$")
  public void operatorVerifySearchField(Map<String, String> data) {
    data = resolveKeyValues(data);
    addressDatasourcePage.switchTo();

    if (StringUtils.isNotBlank(data.get("l1")) && data.get("l1").equals("province")) {
      Assertions.assertThat(addressDatasourcePage.provinceTextField.getText())
          .as("L1 text field" + addressDatasourcePage.provinceTextField.getText())
          .isEqualToIgnoringCase(data.get("l1"));
    }
    if (StringUtils.isNotBlank(data.get("l2")) && (data.get("l2").equals("Kota/Kabupaten") || data.get("l2").equals("Municipality"))) {
      Assertions.assertThat(addressDatasourcePage.cityTextField.getText())
          .as("L2 text field" + addressDatasourcePage.cityTextField.getText())
          .isEqualToIgnoringCase(data.get("l2"));
    }
    if (StringUtils.isNotBlank(data.get("l3")) && (data.get("l3").equals("Kecamatan") || data.get("l3").equals("Barangay"))) {
      Assertions.assertThat(addressDatasourcePage.districtTextField.getText())
          .as("L3 text field" + addressDatasourcePage.districtTextField.getText())
          .isEqualToIgnoringCase(data.get("l3"));
    }
  }

  @Then("^Operator verifies search button is disabled$")
  public void verifiesSearchButtonDisabled() {
    addressDatasourcePage.switchTo();
    Assertions.assertThat(addressDatasourcePage.searchButton.isEnabled())
        .as("Search button is disabled")
        .isFalse();
  }

  @When("^Operator search the existing address datasource:$")
  public void operatorSearchExistingAddressDatasource(Map<String, String> data) {
    addressDatasourcePage.switchTo();
    data = resolveKeyValues(data);

    if (StringUtils.isNotBlank(data.get(KEY_PROVINCE))) {
      addressDatasourcePage.provinceTextBox.sendKeys(data.get(KEY_PROVINCE));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KOTA))) {
      addressDatasourcePage.kotaTextBox.sendKeys(data.get(KEY_KOTA));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KECAMATAN))) {
      addressDatasourcePage.kecamatanTextBox.sendKeys(data.get(KEY_KECAMATAN));
    }
    if (StringUtils.isNotBlank(data.get(KEY_MUNICIPALITY))) {
      addressDatasourcePage.municipalityTextBox.sendKeys(data.get(KEY_MUNICIPALITY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_BARANGAY))) {
      addressDatasourcePage.barangayTextBox.sendKeys(data.get(KEY_BARANGAY));
    }
    addressDatasourcePage.searchButton.click();
  }

  @When("^Operator verifies search box not affected by the scroll$")
  public void operatorVerifiesSearchBox() {
    String sysId = "";
    if (addressDatasourcePage.kecamatanTextBox.isDisplayed()) {
      sysId = SYS_ID;
    } else if (addressDatasourcePage.barangayTextBox.isDisplayed()) {
      sysId = SYS_PH;
    }
    addressDatasourcePage.tableRow.scrollIntoView(true);
    if (sysId.equalsIgnoreCase(SYS_ID)) {
      addressDatasourcePage.provinceTextBox.isDisplayed();
      addressDatasourcePage.kotaTextBox.isDisplayed();
      addressDatasourcePage.kecamatanTextBox.isDisplayed();
    } else if (sysId.equalsIgnoreCase(SYS_PH)) {
      addressDatasourcePage.provinceTextBox.isDisplayed();
      addressDatasourcePage.municipalityTextBox.isDisplayed();
      addressDatasourcePage.barangayTextBox.isDisplayed();
    }
    addressDatasourcePage.searchButton.isEnabled();
  }

  @Then("^Operator verifies no result found on Address Datasource page$")
  public void operatorVerifiesNoResult() {
    assertTrue("No result found on Address Datasource page Displayed!",
        addressDatasourcePage.noResultsFound.isDisplayed());
  }

  @When("Operator clicks on Edit Button on Address Datasource Page")
  public void operatorClicksOnEditButtonOnAddressDatasourcePage() {
    pause2s();
    addressDatasourcePage.editButton.waitUntilClickable();
    addressDatasourcePage.editButton.click();
  }

  @And("Operator fills address parameters in Edit Address modal on Address Datasource page:")
  public void operatorFillsAddressParametersInEditAddressModalOnAddressDatasourcePage(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    String latlong = data.get("latlong");
    String province = data.get("province");
    String kota = data.get("kota");
    String kecamatan = data.get("kecamatan");
    Addressing addressing = new Addressing();
    if (StringUtils.isNotBlank(latlong) && StringUtils.equalsIgnoreCase(latlong, "generated")) {
      Double latitude = TestUtils.generateLatitude();
      Double longitude = TestUtils.generateLongitude();
      String latlongValue = latitude + "," + longitude;
      addressDatasourcePage.latlong.setValue(latlong);
      addressDatasourcePage.latlong.sendKeys(Keys.COMMAND + "a");
      addressDatasourcePage.latlong.sendKeys(latlong);
      addressing.setLatitude(latitude);
      addressing.setLongitude(longitude);
    } else if (StringUtils.isNotBlank(latlong) && !StringUtils
        .equalsIgnoreCase(latlong, "generated")) {
      String latitude = latlong.split(",")[0];
      String longitude = latlong.split(",")[1];
      addressDatasourcePage.latlong.setValue(latlong);
      addressDatasourcePage.latlong.sendKeys(Keys.COMMAND + "a");
      addressDatasourcePage.latlong.sendKeys(latlong);
      addressing.setLatitude(Double.valueOf(latitude));
      addressing.setLongitude(Double.valueOf(longitude));
    }
    if (StringUtils.isNotBlank(province)) {
      addressDatasourcePage.province.setValue(province);
      addressing.setProvince(province);
    }
    if (StringUtils.isNotBlank(kota)) {
      addressDatasourcePage.kota.setValue(kota);
      addressing.setCity(kota);
    }
    if (StringUtils.isNotBlank(kecamatan)) {
      addressDatasourcePage.kecamatan.setValue(kecamatan);
      addressing.setDistrict(kecamatan);
    }

    put(KEY_CREATED_ADDRESSING, addressing);
  }

  @When("Operator clicks on Save Button in Edit a Row modal on Address Datasource page")
  public void operatorClicksOnSaveButtonInEditARowModalOnAddressDatasourcePage() {
    addressDatasourcePage.add.waitUntilClickable();
    addressDatasourcePage.add.click();
    pause5s();
  }

  @When("^Operator clicks on View Zone and Hub Match Button on Address Datasource Page$")
  public void operatorViewZoneAndHub() {
    addressDatasourcePage.viewZoneAndHubButton.waitUntilClickable();
    addressDatasourcePage.viewZoneAndHubButton.click();
  }

  @Then("^Operator verifies the zone and hub details in View Zone and Hub Match modal:")
  public void operatorVerifiesZoneAndHub(Map<String, String> data) {
    data = resolveKeyValues(data);

    if (StringUtils.isNotBlank(data.get("latlong"))) {
      Assertions.assertThat(addressDatasourcePage.viewHubAndZoneLatlong.getText())
          .as("latlong")
          .isEqualToIgnoringCase(data.get("latlong"));
    }
    if (StringUtils.isNotBlank(data.get("hub"))) {
      Assertions.assertThat(addressDatasourcePage.viewHubAndZoneHub.getText())
          .as("hub")
          .isEqualToIgnoringCase(data.get("hub"));
    }
    if (StringUtils.isNotBlank(data.get("zone"))) {
      Assertions.assertThat(addressDatasourcePage.viewHubAndZoneZone.getText())
          .as("zone")
          .isEqualToIgnoringCase(data.get("zone"));
    }
  }
}