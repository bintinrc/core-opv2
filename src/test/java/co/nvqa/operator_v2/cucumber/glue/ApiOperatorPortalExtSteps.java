package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.cucumber.glue.StandardSteps;
import co.nvqa.common.driver.client.DriverManagementClient;
import co.nvqa.common.driver.cucumber.DriverKeyStorage;
import co.nvqa.common.driver.model.Driver;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import javax.inject.Inject;
import lombok.Getter;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends StandardSteps<ScenarioManager> {

  @Inject
  @Getter
  private DriverManagementClient driverManagementClient;

  public ApiOperatorPortalExtSteps() {
  }

  @Override
  public void init() {
  }

  @Given("API Driver - Operator create new Driver using data below:")
  public void operatorCreateNewDriver(Map<String, String> mapOfData) {
    String country = StandardTestConstants.NV_SYSTEM_ID.toUpperCase();
    Map<String, String> mapOfDynamicVariable = new HashMap<>() {{
      put("RANDOM_FIRST_NAME", "Driver");
      put("RANDOM_LAST_NAME", "Automation");
      put("TIMESTAMP", TestUtils.generateDateUniqueString());
      put("RANDOM_LATITUDE", String.valueOf(StandardTestUtils.generateLatitude()));
      put("RANDOM_LONGITUDE", String.valueOf(StandardTestUtils.generateLongitude()));
      put("CURRENT_DATE", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
    }};
    setPhoneNumber(mapOfDynamicVariable, country);

    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    String driverCreateRequestJson = StandardTestUtils.replaceTokens(
        resolvedMapOfData.get("driverCreateRequest"),
        mapOfDynamicVariable);
    Driver createDriverRequest = fromJsonSnakeCase(
        driverCreateRequestJson,
        Driver.class);

    doWithRetry(() -> {
          Driver result = getDriverManagementClient().
              createDriver(createDriverRequest, "1.0").getData();
          putInList(DriverKeyStorage.KEY_DRIVER_LIST_OF_DRIVERS, result);
        },
        " Create Driver");
  }

  private void setPhoneNumber(Map<String, String> mapOfDynamicVariable, String country) {
    switch (country) {
      case "SG":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+6531594329");
        break;
      case "ID":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+6282188881593");
        break;
      case "MY":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+6066567878");
        break;
      case "PH":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+639285554697");
        break;
      case "TH":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+66955573510");
        break;
      case "VN":
        mapOfDynamicVariable.put("DRIVER_CONTACT_DETAIL", "+0812345678");
        break;
      default:
        break;
    }
  }
}
