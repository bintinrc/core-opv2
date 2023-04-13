package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.model.NVDriversInfo;
import co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_RESIGNED;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_TYPE;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_USERNAME;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_ZONE;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DriverStrengthStepsV2 extends AbstractSteps {

  private DriverStrengthPageV2 dsPage;
  private static final String KEY_INITIAL_COMING_VALUE = "KEY_INITIAL_COMING_VALUE";
  private static final String DRIVER_CSV_FILE_NAME = "NV Drivers.csv";

  public DriverStrengthStepsV2() {
  }

  @Override
  public void init() {
    dsPage = new DriverStrengthPageV2(getWebDriver());
  }

  @When("Operator create new Driver on Driver Strength page using data below:")
  public void operatorCreateNewDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> data) {
    String driverTypeName = get(KEY_CREATED_DRIVER_TYPE_NAME);
    DriverInfo driverInfo = new DriverInfo(resolveKeyValues(data));
    if (!Objects.isNull(driverTypeName)) {
      driverInfo.setType(driverTypeName);
    }
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    dsPage.inFrame(() -> {
      dsPage.addNewDriver(driverInfo);
    });
  }

  @When("Operator opens Add Driver dialog on Driver Strength")
  public void operatorOpensAddDriverDialog() {
    dsPage.inFrame(() -> {
      dsPage.addNewDriver.click();
      pause5s();
    });
  }

  @When("Operator fill Add Driver form on Driver Strength page using data below:")
  public void operatorFillAddDriverOnDriverStrengthPageUsingDataBelow(
      Map<String, String> mapOfData) {
    String driverTypeName = get(KEY_CREATED_DRIVER_TYPE_NAME);
    DriverInfo driverInfo = new DriverInfo(resolveKeyValues(mapOfData));
    if (!Objects.isNull(driverTypeName)) {
      driverInfo.setType(driverTypeName);
    }
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    dsPage.inFrame(() -> dsPage.addDriverDialog.fillForm(driverInfo));
  }

  @When("Operator verifies Submit button in Add Driver dialog is disabled")
  public void operatorVerifiesSubmitButtonState() {
    dsPage.inFrame(() ->
        Assertions.assertThat(dsPage.addDriverDialog.submit.isEnabled())
            .as("Submit button is enabled").isFalse());
    takesScreenshot();
  }

  @When("Operator verifies hint {string} is displayed in Add/Edit Driver dialog")
  public void operatorVerifiesAddDriverHint(String expected) {
    final String exp = resolveValue(expected);
    dsPage.inFrame(() -> {
      switch (exp) {
        case "At least one contacts required.":
          Assertions.assertThat(dsPage.addDriverDialog.contactHints.isDisplayed())
              .as("Hint is displayed").isTrue();
          Assertions.assertThat(dsPage.addDriverDialog.contactHints.getNormalizedText())
              .as("Hint text").isEqualTo(expected);
          break;
        case "At least one vehicle required.":
          Assertions.assertThat(dsPage.addDriverDialog.vehicleHints.isDisplayed())
              .as("Hint is displayed").isTrue();
          Assertions.assertThat(dsPage.addDriverDialog.vehicleHints.getNormalizedText())
              .as("Hint text").isEqualTo(expected);
          break;
        case "At least one zone preference required.":
          Assertions.assertThat(dsPage.addDriverDialog.zoneHints.isDisplayed())
              .as("Hint is displayed").isTrue();
          Assertions.assertThat(dsPage.addDriverDialog.zoneHints.getNormalizedText())
              .as("Hint text").isEqualTo(expected);
          break;
        case "Please input a valid mobile phone number (e.g. 8123 4567)":
          Assertions.assertThat(dsPage.addDriverDialog.validContactNumber.isDisplayed())
              .as("Valid mobile phone number").isTrue();
          Assertions.assertThat(dsPage.addDriverDialog.validContactNumber.getNormalizedText())
              .as("Hint text").isEqualTo(expected);
          break;
        default:
          break;
      }
    });
    takesScreenshot();
  }

  @When("^Operator edit created Driver on Driver Strength page using data below:$")
  public void operatorEditCreatedDriver(Map<String, String> mapOfData) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    driverInfo.fromMap(mapOfData);
    dsPage.inFrame(() -> {
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, username);
      dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
      dsPage.editDriverDialog.fillForm(driverInfo);
      dsPage.editDriverDialog.submitForm();
    });
  }

  @When("^Operator updates created Driver on Driver Strength page using data below:$")
  public void operatorUpdateCreatedDriver(Map<String, String> mapOfData) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    driverInfo.fromMap(mapOfData);
    dsPage.inFrame(() -> {
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, username);
      dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
      dsPage.editDriverDialog.fillForm(driverInfo);
    });
  }

  @When("Operator updates driver details with the following info:")
  public void operator_updates_driver_details_with_the_following_info(
      Map<String, String> mapOfData) {
    DriverInfo driverInfo = new DriverInfo();
    driverInfo.fromMap(mapOfData);
    put(KEY_CREATED_DRIVER_INFO, driverInfo);
    put(KEY_UPDATED_DRIVER_FIRST_NAME, driverInfo.getFirstName());
    dsPage.inFrame(() -> {
      dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
      dsPage.editDriverDialog.fillForm(driverInfo);
      dsPage.editDriverDialog.submitForm();
    });
  }

  @When("Operator removes contact details on Edit Driver dialog on Driver Strength page")
  public void operatorRemoveContactDetails() {
    dsPage.inFrame(() -> {
      if (dsPage.editDriverDialog.contactsSettingsForms.size() > 0) {
        dsPage.editDriverDialog.contactsSettingsForms.forEach(form -> form.remove.click());
      }
    });
  }

  @When("Operator removes vehicle details on Edit Driver dialog on Driver Strength page")
  public void operatorRemoveVehicleDetails() {
    dsPage.inFrame(() -> {
      if (dsPage.editDriverDialog.vehicleSettingsForm.size() > 0) {
        dsPage.editDriverDialog.vehicleSettingsForm.forEach(form -> form.remove.click());
      }
    });
  }

  @When("Operator removes zone preferences on Edit Driver dialog on Driver Strength page")
  public void operatorRemoveZonePreference() {
    dsPage.inFrame((() -> {
      if (dsPage.editDriverDialog.zoneSettingsForms.size() > 0) {
        dsPage.editDriverDialog.zoneSettingsForms.forEach(form -> form.remove.click());
      }
    }));
  }

  @When("Operator opens Edit Driver dialog for created driver on Driver Strength page")
  public void operatorOpensEditDriverDialogOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String username = driverInfo.getUsername();
    dsPage.inFrame(() -> {
      if (!dsPage.isTableLoaded()) {
        dsPage.loadSelection.click();
      }
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, username);
      dsPage.driversTable.clickActionButton(1, ACTION_EDIT);
      dsPage.editDriverDialog.waitUntilVisible();
    });
  }

  @Then("^Operator verify driver strength params of created driver on Driver Strength page$")
  public void dbOperatorVerifyDriverIsCreatedSuccessfully() {
    pause2s();
    DriverInfo expectedDriverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      dsPage.waitUntilTableLoaded();
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, expectedDriverInfo.getUsername());
      Map<String, String> actualDriverInfo = dsPage.driversTable.readRow(1);
      if (expectedDriverInfo.getId() != null) {
        Assertions.assertThat(Long.parseLong(actualDriverInfo.get("id"))).as("Id")
            .isEqualTo(expectedDriverInfo.getId());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getUsername())) {
        Assertions.assertThat(actualDriverInfo.get("username")).as("Username")
            .isEqualTo(expectedDriverInfo.getUsername());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getDisplayName())) {
        Assertions.assertThat(actualDriverInfo.get("name")).as("Display Name")
            .isEqualTo(expectedDriverInfo.getDisplayName());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getFullName())) {
        Assertions.assertThat(actualDriverInfo.get("hub")).as("Name")
            .isEqualTo(expectedDriverInfo.getFullName());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getType())) {
        Assertions.assertThat(actualDriverInfo.get("dpmsId")).as("Type")
            .isEqualTo(expectedDriverInfo.getType());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getDpmsId())) {
        Assertions.assertThat(actualDriverInfo.get("vehicleType")).as("DPMS ID")
            .isEqualTo(expectedDriverInfo.getDpmsId());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getVehicleType())) {
        Assertions.assertThat(actualDriverInfo.get("vehicleOwn")).as("Vehicle Type")
            .isEqualTo(expectedDriverInfo.getVehicleType());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getHub())) {
        Assertions.assertThat(actualDriverInfo.get("type")).as("Hub Id")
            .isEqualTo(expectedDriverInfo.getHub());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getZoneId())) {
        Assertions.assertThat(actualDriverInfo.get("zoneMin")).as("Zone Id")
            .isEqualTo(expectedDriverInfo.getZoneId());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getComments())) {
        Assertions.assertThat(actualDriverInfo.get("employmentStartName")).as("Comments")
            .isEqualTo(expectedDriverInfo.getComments());
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.getEmploymentStartDate())) {
        Assertions.assertThat(actualDriverInfo.get("employmentEndName")).as("Employment Start Date")
            .isEqualTo(expectedDriverInfo.getEmploymentStartDate());
      }
    });
    takesScreenshot();
  }

  @Then("Operator verify contact details of created driver on Driver Strength page")
  public void dbOperatorVerifyContactDetailsOfCreatedDriver() {
    DriverInfo expectedDriverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      dsPage.verifyContactDetails(expectedDriverInfo.getUsername(), expectedDriverInfo);
    });
    takesScreenshot();
  }

  @When("Operator filter driver strength by {string} zone")
  public void operatorFilterDriverStrengthByZone(String zone) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(zone)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      zone = driverInfo.getZoneId();
    }
    dsPage.filterBy(COLUMN_ZONE, zone);
  }

  @When("Operator filter driver strength by {string} driver type")
  public void operatorFilterDriverStrengthByDriverType(String driverType) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(driverType)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      driverType = driverInfo.getType();
    }
    dsPage.filterBy(COLUMN_TYPE, driverType);
  }

  @When("Operator click Load Everything on Driver Strength page")
  public void operatorClickLoadEverything() {
    dsPage.inFrame(() -> dsPage.loadEverything());
  }

  @When("Operator filter driver strength using data below:")
  public void operatorFilterDriverStrengthUsingDataBelow(Map<String, String> map) {
    dsPage.refreshPage();
    Map<String, String> data = resolveKeyValues(map);
    dsPage.inFrame(() -> {
      dsPage.loadSelection.waitUntilClickable();
      dsPage.clearSelection.click();

      if (data.containsKey("zones")) {
        List<String> zones = splitAndNormalize(data.get("zones"));
        dsPage.zonesFilter.selectValues(zones);
      }

      if (data.containsKey("hubs")) {
        List<String> zones = splitAndNormalize(data.get("hubs"));
        dsPage.hubsFilter.selectValues(zones);
        dsPage.hubsFilter.click();
      }

      if (data.containsKey("driverTypes")) {
        List<String> driverTypes = splitAndNormalize(data.get("driverTypes"));
        dsPage.driverTypesFilter.selectValues(driverTypes);
      }

      if (data.containsKey("resigned")) {
        pause1s();
        dsPage.clickResignedOption(data.get("resigned"));
      }

      takesScreenshot();
      dsPage.loadSelection();
      pause2s();
    });
  }

  @Then("Operator verify driver strength is filtered by {string} zone")
  public void operatorVerifyDriverStrengthIsFilteredByZone(String expectedZone) {
    if ("GET_FROM_CREATED_DRIVER".equalsIgnoreCase(expectedZone)) {
      DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
      expectedZone = driverInfo.getZoneId();
    }
    final String exp = expectedZone;
    dsPage.inFrame(() -> {
      List<String> actualZones = dsPage.driversTable().readFirstRowsInColumn(COLUMN_ZONE, 10);
      takesScreenshot();
      Assertions.assertThat(actualZones).as("Driver Strength records list").isNotEmpty();
      Assertions.assertThat(actualZones).as("Zone values")
          .allSatisfy(zone -> Assertions.assertThat(zone).contains(exp));
    });
  }

  @Then("Operator verify driver strength is filtered by {string} driver type")
  public void operatorVerifyDriverStrengthIsFilteredByDriverType(String expectedDriverType) {
    List<String> rowDataTypes = new ArrayList<>();
    String currentExpectedDriverType = expectedDriverType;
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    if (driverInfo.getType().equalsIgnoreCase(expectedDriverType)) {
      currentExpectedDriverType = driverInfo.getType();
    }
    final String exp = currentExpectedDriverType;
    dsPage.inFrame(() -> {
      for (int i = 1; i <= 10; i++) {
        rowDataTypes.add(dsPage.driversTable().readRow(i).get("dpmsId"));
      }
      Assertions.assertThat(rowDataTypes).as("Driver Strength records list").isNotEmpty();
      Assertions.assertThat(rowDataTypes).as("Type values")
          .allSatisfy(driverType -> Assertions.assertThat(driverType).contains(exp));
    });
  }

  @Then("Operator verify driver strength is filtered by {string} resigned")
  public void operatorVerifyDriverStrengthIsFilteredByResigned(String expected) {
    dsPage.inFrame(() -> {
      List<String> actualDriverTypes = dsPage.driversTable()
          .readFirstRowsInColumn(COLUMN_RESIGNED, 10);
      Assertions.assertThat(actualDriverTypes).as("Driver Strength records list").isNotEmpty();
      Assertions.assertThat(actualDriverTypes).as("Type values")
          .allSatisfy(driverType -> Assertions.assertThat(driverType).contains(expected));
    });
  }

  @Then("Operator delete created driver on Driver Strength page")
  public void operatorDeleteCreatedDriverOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      dsPage.waitUntilTableLoaded();
      dsPage.deleteDriver(driverInfo.getUsername());
    });
  }

  @Then("Operator delete driver on Driver Strength page by userName {string}")
  public void operatorDeleteCreatedDriverOnDriverStrengthPage(String userName) {
    userName = resolveValue(userName);
    String finalUserName = userName;
    dsPage.inFrame(() -> {
      dsPage.waitUntilTableLoaded();
      dsPage.deleteDriver(finalUserName);
    });
  }

  @Then("Operator verify new driver is deleted successfully on Driver Strength page")
  public void operatorVerifyNewDriverIsDeletedSuccessfullyOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      dsPage.filterBy(COLUMN_USERNAME, driverInfo.getUsername());
      Assertions.assertThat(dsPage.verifyNoDataOnTable()).as("Table has no data").isTrue();
    });
    takesScreenshot();
    remove(KEY_CREATED_DRIVER_UUID);
  }

  @When("Operator change Coming value for created driver on Driver Strength page")
  public void operatorChangeComingValueForCreatedDriverOnDriverStrengthPage() {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      if (!dsPage.isTableLoaded()) {
        dsPage.click("//button[span[text()='Load Selection']]");
      }
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, driverInfo.getUsername());
      takesScreenshot();
      put(KEY_INITIAL_COMING_VALUE, dsPage.driversTable().getComingStatus(1));
      dsPage.driversTable().toggleComingStatus(1);
    });
  }

  @Then("Operator verify Coming value for created driver has been changed on Driver Strength page")
  public void operatorVerifyComingValueForCreatedDriverHasBeenChangedOnDriverStrengthPage() {
    String initialComingValue = get(KEY_INITIAL_COMING_VALUE);
    Assertions.assertThat(initialComingValue).as("Initial Coming value").isNotEmpty();
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    dsPage.inFrame(() -> {
      dsPage.driversTable.filterByColumn(COLUMN_USERNAME, driverInfo.getUsername());
      takesScreenshot();
      Assertions.assertThat(dsPage.driversTable().getComingStatus(1)).as("Actual Coming Value")
          .isNotEqualToIgnoringCase(initialComingValue);
    });
    takesScreenshot();
  }

  @Then("Operator load all data for driver on Driver Strength Page")
  public void operatorLoadAllData() {
    dsPage.inFrame(() -> {
      pause2s();
      dsPage.loadSelection.waitUntilVisible();
      dsPage.loadSelection.click();
    });
  }

  @When("^Operator click Submit button in .* Driver dialog$")
  public void clickSubmitButton() {
    dsPage.inFrame(() -> {
      dsPage.addDriverDialog.submit.click();
    });
  }

  @When("Operator wait until table loaded")
  public void waitForTableToLoad() {
    dsPage.inFrame(() -> dsPage.waitUntilTableLoaded());
  }

  @Then("Operator verifies that the column: {string} displays between the columns: {string} and {string}")
  public void operatorVerifiesThatTheColumnDisplaysBetweenTheColumnsAnd(String column,
      String precedingColumn, String followingColumn) {
    DriverInfo driverInfo = get(KEY_CREATED_DRIVER_INFO);
    String userName = driverInfo.getUsername();
    dsPage.inFrame(() -> {
      List<String> columns = dsPage.getAllColumnsInResultGrid(userName);
      int columnIndex = columns.indexOf(column);
      takesScreenshot();
      Assertions.assertThat(columns.get(columnIndex - 1)).as("Verify preceding column name")
          .isEqualTo(precedingColumn);
      Assertions.assertThat(columns.get(columnIndex + 1)).as("Verify following column name")
          .isEqualTo(followingColumn);
    });
  }

  @Then("Operator verifies that the following buttons are displayed in driver strength page")
  public void operatorVerifiesThatTheFollowingButtonsAreDisplayedInDriverStrengthPage(
      List<String> labels) {
    dsPage.inFrame(() -> {
      for (String label : labels) {
        Assertions.assertThat(dsPage.verifyButtonsDisplayed(label))
            .as(f("Verify that the button: %s is displayed", label)).isTrue();
      }
      takesScreenshot();
    });
  }

  @Then("Operator verifies that the following UI element(s) is/are displayed in update driver modal up")
  public void operatorVerifiesThatTheFollowingUIElementsAreDisplayedInUpdateDriverModalUp(
      List<String> elements) {
    dsPage.inFrame(() -> {
      dsPage.updateDriverDetails.click();
      for (String element : elements) {
        Assertions.assertThat(dsPage.verifyUpdateDriverModalUiDisplayed(element))
            .as(f("Verify that Ui element: %s is displayed", element)).isTrue();
      }
      takesScreenshot();
    });
  }

  @Then("Operator verifies that the selected driver details can be downloaded with the file name: {string}")
  public void verifiesThatTheSelectedDriverDetailsCanBeDownloadedWithTheFileName(String fileName) {
    dsPage.inFrame(() -> {
      dsPage.waitUntilPageLoaded();
      dsPage.downloadAllShown.click();
      dsPage.verifyFileDownloadedSuccessfully(fileName);
    });
  }

  @When("Operator verifies that the template for updating driver details can be downloaded with the file name: {string}")
  public void operatorVerifiesThatTheTemplateForUpdatingDriverDetailsCanBeDownloadedWithTheFileName(
      String fileName) {
    dsPage.inFrame(() -> {
      dsPage.waitUntilPageLoaded();
      dsPage.downloadCsvTemplate.click();
      dsPage.verifyFileDownloadedSuccessfully(fileName);
    });
  }

  @Then("Operator verifies that the content in the downloaded csv file matches with the result displayed")
  public void operatorVerifiesThatTheContentInTheDownloadedCsvFileMatchesWithTheResultDisplayed() {
    dsPage.inFrame(() -> {
      Map<String, String> expectedDriverInfo = dsPage.driversTable.readRow(1);
      String fileName = dsPage
          .getLatestDownloadedFilename(DRIVER_CSV_FILE_NAME);
      dsPage.verifyFileDownloadedSuccessfully(fileName);
      String pathName = StandardTestConstants.TEMP_DIR + fileName;
      List<NVDriversInfo> actualDriverInfo = NVDriversInfo
          .fromCsvFile(NVDriversInfo.class, pathName, true);
      FileUtils.deleteQuietly(new File(pathName));
      Assertions.assertThat(actualDriverInfo.size())
          .as("Number of lines in CSV")
          .isGreaterThanOrEqualTo(1);

      if (StringUtils.isNotBlank(expectedDriverInfo.get("id"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getId()).as("Id")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("id")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("hub"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getName()).as("Full name")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("hub")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("type"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getHub()).as("Hub ID")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("type")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("dpmsId"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getType()).as("Type")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("dpmsId")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("vehicleOwn"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getVehicle()).as("Vehicle")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("vehicleOwn")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("employmentStartName"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getComments()).as("Comments")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("employmentStartName")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("username"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getLicenseNumber()).as("License Number")
            .isEqualTo(expectedDriverInfo.get("username"));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("zoneMax"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getMinCapacity()).as("Min")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("zoneMax")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("comments"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getMaxCapacity()).as("Max")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("comments")));
      }
      if (StringUtils.isNotBlank(expectedDriverInfo.get("zoneMin"))) {
        Assertions.assertThat(actualDriverInfo.get(0).getZone()).as("Zone ID")
            .isEqualTo(String.valueOf(expectedDriverInfo.get("zoneMin")));
      }
    });
  }

  @Then("Operator verifies that the following options are displayed on clicking hamburger icon")
  public void operatorVerifiesThatTheFollowingOptionsAreDisplayedOnClickingHamburgerIcon(
      List<String> values) {
    dsPage.inFrame(() -> {
      List<String> actualOptions = dsPage.getAllDownloadOptions();
      Assertions.assertThat(actualOptions.containsAll(values))
          .as("Assert that Download hamburger contains all expected options!").isTrue();
    });
  }

  @Then("Operator verifies that the file name: {string} can be downloaded on clicking the option: {string}")
  public void operatorVerifiesThatTheFileNameCanBeDownloadedOnClickingTheOption(String fileName,
      String downloadOption) {
    String resolvedFileName = resolveValue(fileName).toString().replace("-", "_");
    dsPage.inFrame(() -> {
      dsPage.verifyFileDownloadForUpdate(downloadOption);
      dsPage.verifyFileDownloadedSuccessfully(resolvedFileName);
    });
  }

  @Then("Operator verifies that the following content displayed on the downloaded csv file: {string}")
  public void operatorVerifiesThatTheFollowingContentDisplayedOnTheDownloadedCsvFile(
      String fileName, List<String> values) {
    String resolvedFileName = resolveValue(fileName).toString().replace("-", "_");
    values = resolveValues(values);
    String expectedText = String.join(",", values);
    dsPage.verifyFileDownloadedSuccessfully(resolvedFileName, expectedText);
  }

  @Then("Operator selects the records that are displayed in the result grid")
  public void operatorSelectsTheRecordsThatAreDisplayedInTheResultGrid() {
    dsPage.inFrame(() -> {
      dsPage.waitUntilPageLoaded();
      dsPage.recordCheckbox.click();
    });
  }

  @When("Operator uploads csv file: {string} to bulk update the driver details")
  public void operatorUploadsCsvFileToBulkUpdateTheDriverDetails(String fileName) {
    fileName = resolveValue(fileName);
    ClassLoader classLoader = getClass().getClassLoader();
    File file = new File(Objects.requireNonNull(classLoader.getResource(fileName)).getFile());
    dsPage.inFrame(() -> {
      dsPage.bulkUploadDrivers.sendKeys(file.getAbsolutePath());
    });
  }

  @Then("Operator verifies that the notice/alert message: {string} is displayed")
  public void operatorVerifiesThatTheNoticeMessageIsDisplayed(String noticeMessage) {
    dsPage.inFrame(() -> {
      boolean isDisplayed = dsPage.verifyNoticeDisplayed(noticeMessage);
      Assertions.assertThat(isDisplayed)
          .as(f("Assert that notice : %s  is displayed as expected!", noticeMessage)).isTrue();
    });
  }

  @Then("Operator verifies that the failure reasons can be downloaded with file name: {string}")
  public void operatorVerifiesThatTheFailureReasonsCanBeDownloadedWithFileName(String fileName) {
    String resolvedFileName = resolveValue(fileName).toString().replace("-", "_");
    dsPage.inFrame(() -> {
      dsPage.waitUntilVisibilityOfElementLocated(dsPage.downloadFailureReasons.getWebElement());
      dsPage.downloadFailureReasons.click();
      dsPage.verifyFileDownloadedSuccessfully(resolvedFileName);
    });
  }

}
