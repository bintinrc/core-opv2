package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.addressing.Address;
import co.nvqa.operator_v2.model.Addressing;
import co.nvqa.operator_v2.selenium.page.AddressDatasourcePage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
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

  @When("^Operator fills address parameters in Add a Row modal on Address Datasource page:$")
  public void operatorFillsAddressDatasource(Map<String, String> data) {
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
    if (StringUtils.isNotBlank(data.get("province"))) {
      Assertions.assertThat(addressDatasourcePage.provinceAddRow.getText())
          .as("Province")
          .isEqualToIgnoringCase(data.get("province"));
    }
    if (StringUtils.isNotBlank(data.get("kota"))) {
      Assertions.assertThat(addressDatasourcePage.kotaAddRow.getText())
          .as("Kota")
          .isEqualToIgnoringCase(data.get("kota"));
    }
    if (StringUtils.isNotBlank(data.get("kecamatan"))) {
      Assertions.assertThat(addressDatasourcePage.kecamatanAddRow.getText())
          .as("kecamatan")
          .isEqualToIgnoringCase(data.get("kecamatan"));
    }
    if (StringUtils.isNotBlank(data.get("hub"))) {
      Assertions.assertThat(addressDatasourcePage.hubAddRow.getText())
          .as("hub")
          .isEqualToIgnoringCase(data.get("hub"));
    }
    if (StringUtils.isNotBlank(data.get("zone"))) {
      Assertions.assertThat(addressDatasourcePage.zoneAddRow.getText())
          .as("zone")
          .isEqualToIgnoringCase(data.get("zone"));
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

    if (StringUtils.isNotBlank(data.get("province"))) {
      Assertions.assertThat(addressDatasourcePage.createdProvince.getText())
          .as("Created province " + addressDatasourcePage.createdProvince.getText())
          .isEqualToIgnoringCase(data.get("province"));
    }
    if (StringUtils.isNotBlank(data.get("kota"))) {
      Assertions.assertThat(addressDatasourcePage.createdKota.getText())
          .as("Created Kota " + addressDatasourcePage.createdKota.getText())
          .isEqualToIgnoringCase(data.get("kota"));
    }
    if (StringUtils.isNotBlank(data.get("kecamatan"))) {
      Assertions.assertThat(addressDatasourcePage.createdKecamatan.getText())
          .as("Created kecamatan " + addressDatasourcePage.createdKecamatan.getText())
          .isEqualToIgnoringCase(data.get("kecamatan"));
    }
    if (StringUtils.isNotBlank(data.get("latitude")) && StringUtils
        .isNotBlank(data.get("longitude"))) {
      Assertions.assertThat(addressDatasourcePage.createdLatlong.getText())
          .as("Created LatLong " + addressDatasourcePage.createdLatlong.getText())
          .isEqualToIgnoringCase(data.get("latitude") + ", " + data.get("longitude"));
    }
  }

  @When("^Operator search the created address datasource:$")
  public void operatorSearchCreatedAddressDatasource(Map<String, String> data) {
    data = resolveKeyValues(data);
    addressDatasourcePage.notification.message.waitUntilVisible();
    pause2s();
    addressDatasourcePage.provinceTextBox.sendKeys(data.get("province"));
    addressDatasourcePage.kotaTextBox.sendKeys(data.get("kota"));
    addressDatasourcePage.kecamatanTextBox.sendKeys(data.get("kecamatan"));
    addressDatasourcePage.searchButton.click();
  }
}