package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commonsort.constants.SortScenarioStorageKeys;
import co.nvqa.commonsort.model.addressing.Address;
import co.nvqa.operator_v2.selenium.page.AddressDatasourcePage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

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
  private final String KEY_POSTCODE = "postcode";
  private final String KEY_DISTRICT = "district";
  private final String KEY_WARD = "ward";
  private final String KEY_SUBDISTRICT = "subdistrict";
  private final String KEY_HUB = "hub";
  private final String KEY_ZONE = "zone";
  private final String KEY_LATITUDE = "latitude";
  private final String KEY_LONGITUDE = "longitude";
  private final String KEY_LATLONG = "latlong";
  private final String SYS_ID = "id";
  private final String SYS_PH = "ph";
  private final String KEY_WHITELISTED = "whitelisted";

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
    String district = data.get(KEY_DISTRICT);
    String ward = data.get(KEY_WARD);
    String subdistrict = data.get(KEY_SUBDISTRICT);
    String postcode = data.get(KEY_POSTCODE);
    String whitelisted = data.get(KEY_WHITELISTED);
    Address addressing = new Address();

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
    if (StringUtils.isNotBlank(ward)) {
      addressDatasourcePage.kecamatan.setValue(ward);
      addressing.setSubDistrict(ward);
    }
    if (StringUtils.isNotBlank(municipality)) {
      addressDatasourcePage.municipality.setValue(municipality);
      addressing.setCity(municipality);
    }
    if (StringUtils.isNotBlank(barangay)) {
      addressDatasourcePage.barangay.setValue(barangay);
      addressing.setDistrict(barangay);
    }
    if (StringUtils.isNotBlank(district)) {
      addressDatasourcePage.municipality.setValue(district);
      addressing.setDistrict(district);
    }
    if (StringUtils.isNotBlank(subdistrict)) {
      addressDatasourcePage.barangay.setValue(subdistrict);
      addressing.setSubDistrict(subdistrict);
    }
    if (StringUtils.isNotBlank(postcode)) {
      addressDatasourcePage.postcode.setValue(postcode);
      addressing.setPostcode(postcode);
    }
    if (StringUtils.isNotBlank(whitelisted)) {
      addressDatasourcePage.whitelisted.selectValue(whitelisted);
    }

    put(SortScenarioStorageKeys.KEY_SORT_CREATED_ADDRESS, addressing);
  }

  @When("^Operator clicks on Add Button in Add a Row modal on Address Datasource page$")
  public void operatorClickAddButton() {
    addressDatasourcePage.add.waitUntilClickable();
    addressDatasourcePage.add.click();
    addressDatasourcePage.loadingIcon.waitUntilInvisible();
  }

  @When("^Operator clicks on Proceed Button in Row Details modal on Address Datasource page$")
  public void operatorClickProceedButton() {
    addressDatasourcePage.proceed.waitUntilClickable();
    addressDatasourcePage.proceed.click();
    addressDatasourcePage.loadingIcon.waitUntilInvisible();
  }

  @When("^Operator clicks on Replace Button in Row Details modal on Address Datasource page$")
  public void operatorClickReplacrButton() {
    addressDatasourcePage.replace.waitUntilClickable();
    addressDatasourcePage.replace.click();
    addressDatasourcePage.confirmReplace.waitUntilVisible();
    addressDatasourcePage.confirmReplace.click();
  }

  @When("^Operator clicks on Delete Button in Row Details modal on Address Datasource page$")
  public void operatorClickDeleteButton() {
    addressDatasourcePage.delete.waitUntilClickable();
    addressDatasourcePage.delete.click();
    addressDatasourcePage.confirmReplace.waitUntilVisible();
    addressDatasourcePage.confirmReplace.click();
  }

  @Then("^Operator verifies the address datasource details in Row Details modal:$")
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
    if (StringUtils.isNotBlank(data.get(KEY_DISTRICT))) {
      Assertions.assertThat(addressDatasourcePage.districtAddRow.getText())
          .as("District")
          .isEqualToIgnoringCase(data.get(KEY_DISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_SUBDISTRICT))) {
      Assertions.assertThat(addressDatasourcePage.subdistrictAddRow.getText())
          .as("Subdistrict")
          .isEqualToIgnoringCase(data.get(KEY_SUBDISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_WARD))) {
      Assertions.assertThat(addressDatasourcePage.wardAddRow.getText())
          .as("Ward")
          .isEqualToIgnoringCase(data.get(KEY_WARD));
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
    if (StringUtils.isNotBlank(data.get(KEY_POSTCODE))) {
      Assertions.assertThat(addressDatasourcePage.zoneAddPostcode.getText())
          .as("postcode")
          .isEqualToIgnoringCase(data.get(KEY_POSTCODE));
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

  @And("Operator verify the data source toast disappears")
  public void operatorVerifyTheDataSourceToastDisappears() {
    addressDatasourcePage.notification.message.waitUntilInvisible();
  }

  @Then("^Operator verifies new address datasource is added:$")
  public void operatorVerifiesNewAddressDatasource(Map<String, String> data) {
    data = resolveKeyValues(data);
    Address address = new Address();
    address.setId(addressDatasourcePage.createdRawId.getText());
    put(SortScenarioStorageKeys.KEY_SORT_CREATED_ADDRESS, address);

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
    if (StringUtils.isNotBlank(data.get(KEY_DISTRICT))) {
      Assertions.assertThat(addressDatasourcePage.createdKota.getText())
          .as("Created District " + addressDatasourcePage.createdKota.getText())
          .isEqualToIgnoringCase(data.get(KEY_DISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_WARD))) {
      Assertions.assertThat(addressDatasourcePage.createdKecamatan.getText())
          .as("Created Ward " + addressDatasourcePage.createdKecamatan.getText())
          .isEqualToIgnoringCase(data.get(KEY_WARD));
    }
    if (StringUtils.isNotBlank(data.get(KEY_SUBDISTRICT))) {
      Assertions.assertThat(addressDatasourcePage.createdKecamatan.getText())
          .as("Created subdistrict " + addressDatasourcePage.createdKecamatan.getText())
          .isEqualToIgnoringCase(data.get(KEY_SUBDISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_POSTCODE))) {
      Assertions.assertThat(addressDatasourcePage.createdPostcode.getText())
          .as("Created Postcode " + addressDatasourcePage.createdPostcode.getText())
          .isEqualToIgnoringCase(data.get(KEY_POSTCODE));
    }
    if (StringUtils.isNotBlank(data.get(KEY_WHITELISTED))) {
      Assertions.assertThat(addressDatasourcePage.createdWhitelisted.getText())
          .as("Whitelisted " + addressDatasourcePage.createdWhitelisted.getText())
          .isEqualToIgnoringCase(data.get(KEY_WHITELISTED));
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
    } else if (data.containsKey(KEY_WARD)) {
      addressDatasourcePage.provinceTextBox.sendKeys(data.get(KEY_PROVINCE));
      addressDatasourcePage.kotaTextBox.sendKeys(data.get(KEY_DISTRICT));
      addressDatasourcePage.kecamatanTextBox.sendKeys(data.get(KEY_WARD));
    } else if (data.containsKey(KEY_BARANGAY)) {
      addressDatasourcePage.provinceTextBox.sendKeys(data.get(KEY_PROVINCE));
      addressDatasourcePage.kotaTextBox.sendKeys(data.get(KEY_MUNICIPALITY));
      addressDatasourcePage.kecamatanTextBox.sendKeys(data.get(KEY_BARANGAY));
    } else if (data.containsKey(KEY_POSTCODE)) {
      addressDatasourcePage.postcodeTextBox.sendKeys(data.get(KEY_POSTCODE));
    }
    addressDatasourcePage.searchButton.click();
    addressDatasourcePage.loadingIcon.waitUntilInvisible();
  }

  @Then("^Operator verify search field lable:$")
  public void operatorVerifySearchField(Map<String, String> data) {
    data = resolveKeyValues(data);
    addressDatasourcePage.switchTo();

    String expectedL1 = data.get("l1");
    String expectedL2 = data.get("l2");
    String expectedL3 = data.get("l3");
    String expectedL4 = data.get("l4");

    if (StringUtils.isNotBlank(expectedL1) && expectedL1.equals("province")) {
      Assertions.assertThat(addressDatasourcePage.provinceTextField.getText())
          .as("L1 text field" + addressDatasourcePage.provinceTextField.getText())
          .isEqualToIgnoringCase(expectedL1);
    } else if (StringUtils.isNotBlank(expectedL1) && expectedL1.equals("postcode")) {
      Assertions.assertThat(addressDatasourcePage.postcodeTextField.getText())
          .as("L1 text field" + addressDatasourcePage.postcodeTextField.getText())
          .isEqualToIgnoringCase(expectedL1);
    }
    if (StringUtils.isNotBlank(expectedL2) && (expectedL2.equals("Kota/Kabupaten")
        || expectedL2.equals("Municipality") || expectedL2.equals("District"))) {
      Assertions.assertThat(addressDatasourcePage.cityTextField.getText())
          .as("L2 text field" + addressDatasourcePage.cityTextField.getText())
          .isEqualToIgnoringCase(expectedL2);
    }
    if (StringUtils.isNotBlank(expectedL3) && (expectedL3.equals("Kecamatan") || expectedL3
        .equals("Barangay") || expectedL3.equals(""
        + ""))) {
      Assertions.assertThat(addressDatasourcePage.districtTextField.getText())
          .as("L3 text field" + addressDatasourcePage.districtTextField.getText())
          .isEqualToIgnoringCase(expectedL3);
    }
    if (StringUtils.isNotBlank(expectedL4) && (expectedL4.equals("Postcode"))) {
      Assertions.assertThat(addressDatasourcePage.postcodeTextField.getText())
          .as("L4 text field" + addressDatasourcePage.postcodeTextField.getText())
          .isEqualToIgnoringCase(expectedL4);
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
    doWithRetry(() -> {
      if (!addressDatasourcePage.findMatch.isDisplayed()) {
        addressDatasourcePage.refreshPage();
      }
    }, "refresh the page until element is displayed");

    addressDatasourcePage.waitUntilPageLoaded();
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
    if (StringUtils.isNotBlank(data.get(KEY_DISTRICT))) {
      addressDatasourcePage.districtTextBox.sendKeys(data.get(KEY_DISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_WARD))) {
      addressDatasourcePage.kecamatanTextBox.sendKeys(data.get(KEY_WARD));
    }
    if (StringUtils.isNotBlank(data.get(KEY_SUBDISTRICT))) {
      addressDatasourcePage.subdistrictTextBox.sendKeys(data.get(KEY_SUBDISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_POSTCODE))) {
      addressDatasourcePage.postcodeTextBox.waitUntilVisible();
      addressDatasourcePage.postcodeTextBox.sendKeys(data.get(KEY_POSTCODE));
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
    Assertions.assertThat(addressDatasourcePage.noResultsFound.isDisplayed())
        .as("No result found on Address Datasource page Displayed!").isTrue();
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
    String latlong = data.get(KEY_LATLONG);
    String province = data.get(KEY_PROVINCE);
    String kota = data.get(KEY_KOTA);
    String kecamatan = data.get(KEY_KECAMATAN);
    String ward = data.get(KEY_WARD);
    String municipality = data.get(KEY_MUNICIPALITY);
    String barangay = data.get(KEY_BARANGAY);
    String district = data.get(KEY_DISTRICT);
    String subdistrict = data.get(KEY_SUBDISTRICT);
    String postcode = data.get(KEY_POSTCODE);
    String whitelisted = data.get(KEY_WHITELISTED);
    Address addressing = new Address();

    if (StringUtils.isNotBlank(latlong)) {
      Double latitude = TestUtils.generateLatitude();
      Double longitude = TestUtils.generateLongitude();
      String latlongValue = latitude + "," + longitude;
      addressDatasourcePage.latlong.forceClear();
      addressDatasourcePage.latlong.sendKeys(latlong);
      addressing.setLatitude(latitude);
      addressing.setLongitude(longitude);
    }
    if (StringUtils.isNotBlank(province)) {
      if (province.contains("EMPTY")) {
        addressDatasourcePage.province.forceClear();
      } else {
        addressDatasourcePage.province.forceClear();
        addressDatasourcePage.province.sendKeys(province);
      }
      addressing.setProvince(province);
    }
    if (StringUtils.isNotBlank(kota)) {
      if (kota.contains("EMPTY")) {
        addressDatasourcePage.kota.forceClear();
      } else {
        addressDatasourcePage.kota.forceClear();
        addressDatasourcePage.kota.sendKeys(kota);
      }
      addressing.setCity(kota);
    }
    if (StringUtils.isNotBlank(kecamatan)) {
      if (kecamatan.contains("EMPTY")) {
        addressDatasourcePage.kecamatan.forceClear();
      } else {
        addressDatasourcePage.kecamatan.forceClear();
        addressDatasourcePage.kecamatan.sendKeys(kecamatan);
      }
      addressing.setDistrict(kecamatan);
    }
    if (StringUtils.isNotBlank(ward)) {
      if (ward.contains("EMPTY")) {
        addressDatasourcePage.kecamatan.forceClear();
      } else {
        addressDatasourcePage.kecamatan.forceClear();
        addressDatasourcePage.kecamatan.sendKeys(ward);
      }
      addressing.setDistrict(kecamatan);
    }
    if (StringUtils.isNotBlank(barangay)) {
      if (barangay.contains("EMPTY")) {
        addressDatasourcePage.barangay.forceClear();
      } else {
        addressDatasourcePage.barangay.forceClear();
        addressDatasourcePage.barangay.sendKeys(barangay);
      }
      addressing.setDistrict(barangay);
    }
    if (StringUtils.isNotBlank(municipality)) {
      if (municipality.contains("EMPTY")) {
        addressDatasourcePage.municipality.forceClear();
      } else {
        addressDatasourcePage.municipality.forceClear();
        addressDatasourcePage.municipality.sendKeys(municipality);
      }
      addressing.setDistrict(municipality);
    }
    if (StringUtils.isNotBlank(subdistrict)) {
      if (subdistrict.contains("EMPTY")) {
        addressDatasourcePage.barangay.forceClear();
      } else {
        addressDatasourcePage.barangay.forceClear();
        addressDatasourcePage.barangay.sendKeys(subdistrict);
      }
      addressing.setDistrict(subdistrict);
    }
    if (StringUtils.isNotBlank(district)) {
      if (district.contains("EMPTY")) {
        addressDatasourcePage.municipality.forceClear();
      } else {
        addressDatasourcePage.municipality.forceClear();
        addressDatasourcePage.municipality.sendKeys(district);
      }
      addressing.setDistrict(district);
    }
    if (StringUtils.isNotBlank(postcode)) {
      if (postcode.contains("EMPTY")) {
        addressDatasourcePage.postcode.forceClear();
      } else {
        addressDatasourcePage.postcode.forceClear();
        addressDatasourcePage.postcode.sendKeys(postcode);
      }
      addressing.setPostcode(postcode);
    }
    if (StringUtils.isNotBlank(whitelisted)) {
      addressDatasourcePage.whitelisted.selectValue(whitelisted);
    }

    put(SortScenarioStorageKeys.KEY_SORT_CREATED_ADDRESS, addressing);
    addressDatasourcePage.loadingIcon.waitUntilInvisible();
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
    String latlong = data.get("latlong");
    String hub = data.get("hub");
    String zone = data.get("zone");
    doWithRetry(() -> {
      if (StringUtils.isNotBlank(latlong)) {
        Assertions.assertThat(addressDatasourcePage.viewHubAndZoneLatlong.getText())
            .as("latlong")
            .isEqualToIgnoringCase(latlong);
      }
      if (StringUtils.isNotBlank(hub)) {
        Assertions.assertThat(addressDatasourcePage.viewHubAndZoneHub.getText())
            .as("hub")
            .isEqualToIgnoringCase(hub);
      }
      if (StringUtils.isNotBlank(zone)) {
        Assertions.assertThat(addressDatasourcePage.viewHubAndZoneZone.getText())
            .as("zone")
            .isEqualToIgnoringCase(zone);
      }
    }, "Verifying Zone and Hub Lat Long");

  }

  @And("Operator verify the latlong error alert:")
  public void operatorVerifyTheLatlongErrorAlert(Map<String, String> data) {
    data = resolveKeyValues(data);
    String latlongError = data.get("latlongError");
    Assertions.assertThat(addressDatasourcePage.invalidLatlong.getText()).as("invalid Latlong")
        .isEqualToIgnoringCase(latlongError);
  }

  @And("Operator verifies empty field error shows up in address datasource page")
  public void operatorVerifiesEmptyFieldErrorShowsUpInAddressDatasourcePage() {
    Assertions.assertThat(addressDatasourcePage.emptyFieldError.isDisplayed())
        .as("Empty field error shows up")
        .isTrue();
  }

  @Then("^Operator verifies the address datasource details in Edit A Row modal:$")
  public void operatorVerifiesDetailsInEditRowModal(Map<String, String> data) {
    data = resolveKeyValues(data);
    if (StringUtils.isNotBlank(data.get(KEY_PROVINCE))) {
      Assertions.assertThat(addressDatasourcePage.province.getValue())
          .as("Province")
          .isEqualToIgnoringCase(data.get(KEY_PROVINCE));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KOTA))) {
      Assertions.assertThat(addressDatasourcePage.kota.getValue())
          .as("Kota")
          .isEqualToIgnoringCase(data.get(KEY_KOTA));
    }
    if (StringUtils.isNotBlank(data.get(KEY_KECAMATAN))) {
      Assertions.assertThat(addressDatasourcePage.kecamatan.getValue())
          .as("kecamatan")
          .isEqualToIgnoringCase(data.get(KEY_KECAMATAN));
    }
    if (StringUtils.isNotBlank(data.get(KEY_DISTRICT))) {
      Assertions.assertThat(addressDatasourcePage.kota.getValue())
          .as("District")
          .isEqualToIgnoringCase(data.get(KEY_DISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_SUBDISTRICT))) {
      Assertions.assertThat(addressDatasourcePage.kecamatan.getValue())
          .as("Subdistrict")
          .isEqualToIgnoringCase(data.get(KEY_SUBDISTRICT));
    }
    if (StringUtils.isNotBlank(data.get(KEY_MUNICIPALITY))) {
      Assertions.assertThat(addressDatasourcePage.municipality.getValue())
          .as("Municipality")
          .isEqualToIgnoringCase(data.get(KEY_MUNICIPALITY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_BARANGAY))) {
      Assertions.assertThat(addressDatasourcePage.barangay.getValue())
          .as("Barangay")
          .isEqualToIgnoringCase(data.get(KEY_BARANGAY));
    }
    if (StringUtils.isNotBlank(data.get(KEY_POSTCODE))) {
      Assertions.assertThat(addressDatasourcePage.postcode.getValue())
          .as("postcode")
          .isEqualToIgnoringCase(data.get(KEY_POSTCODE));
    }
  }
}