package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.GetDriverDataResponse;
import co.nvqa.commons.model.core.GetDriverResponse;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.MiddleMileDriversPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tristania Siagian
 */

public class MiddleMileDriversSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(MiddleMileDriversSteps.class);

  private static final ZonedDateTime TODAY = DateUtil.getDate();
  private static final DateTimeFormatter CAL_FORMATTER = DateTimeFormatter
      .ofPattern("MMMM d, yyyy", Locale.ENGLISH);
  private static final DateTimeFormatter EXPIRY_DATE_FORMATTER = DateTimeFormatter
      .ofPattern("yyyy-MM-dd", Locale.ENGLISH);
  private static final DateTimeFormatter COMMENT_FORMATTER = DateUtil.DATE_TIME_FORMATTER;
  private static final String AUTO = "AUTO";
  private static final String RANDOM = "RANDOM";
  private static final String PASSWORD = "Ninjitsu89";
  private static final String COMMENTS = String
      .format("Created at : %s", COMMENT_FORMATTER.format(TODAY));

  private static final String CLASS_5 = "Class 5";
  private static final String SIM_B_I_UMUM = "SIM B I Umum";
  private static final String TYPE_C = "Type C";
  private static final String CLASS_E = "Class E";
  private static final String RESTRICTION_5 = "Restriction 5";

  private static final String IN_HOUSE_FULL_TIME = "IN_HOUSE_FULL_TIME";
  private static final String IN_HOUSE_PART_TIME = "IN_HOUSE_PART_TIME";
  private static final String OUTSOURCED_SUBCON = "OUTSOURCED_SUBCON";
  private static final String OUTSOURCED_VENDOR = "OUTSOURCED_VENDOR";

  private static final String NAME_FILTER = "name";
  private static final String ID_FILTER = "id";
  private static final String USERNAME_FILTER = "username";
  private static final String HUB_FILTER = "hub";
  private static final String EMPLOYMENT_TYPE_FILTER = "employment type";
  private static final String EMPLOYMENT_STATUS_FILTER = "employment status";
  private static final String LICENSE_TYPE_FILTER = "license type";
  private static final String LICENSE_STATUS_FILTER = "license status";
  private static final String COMMENTS_FILTER = "comments";

  private static final String IN_HOUSE_FULL_TIME_CONTRACT = "In-House - Full-Time";
  private static final String IN_HOUSE_PART_TIME_CONTRACT = "In-House - Part-Time";
  private static final String OUTSOURCED_SUBCON_CONTRACT = "Outsourced - Subcon";
  private static final String OUTSOURCED_VENDORS_CONTRACT = "Outsourced - Vendors";
  private static final String PART_TIME_FREELANCE = "Part-time / Freelance";
  private static final String VENDOR_SELECTION = "Vendor";
  private static final String COUNTRY = "country";


  private static final String SINGAPORE = "singapore";
  private static final String INDONESIA = "indonesia";
  private static final String THAILAND = "thailand";
  private static final String VIETNAM = "vietnam";
  private static final String MALAYSIA = "malaysia";
  private static final String PHILIPPINES = "philippines";

  private static final String MIDDLE_MILE_DRIVERS_URL = "https://operatorv2-qa.ninjavan.co/#/sg/middle-mile-drivers";

  private static Boolean IS_FIRST_TIME_SETUP_DRIVER = true;

  private MiddleMileDriversPage middleMileDriversPage;

  public MiddleMileDriversSteps() {
  }

  @Override
  public void init() {
    middleMileDriversPage = new MiddleMileDriversPage(getWebDriver());
  }

  @Given("Operator verifies middle mile driver management page is loaded")
  public void operatorMovementTripPageIsLoaded() {
    middleMileDriversPage.switchTo();
    middleMileDriversPage.loadButton.waitUntilClickable(30);
  }

  @When("Operator clicks on Load Driver Button on the Middle Mile Driver Page")
  public void operatorClicksOnLoadDriverButtonOnTheMiddleMileDriverPage() {
    middleMileDriversPage.clickLoadDriversButton();
  }

  @Then("Operator verifies that the data shown has the same value")
  public void operatorVerifiesThatTheDataShownHasTheSameValue() {
    pause10s();
    GetDriverResponse driver = get(KEY_ALL_DRIVERS_DATA);
    int totalDriver = 0;

    if (driver != null) {
      totalDriver = driver.getData().getDrivers().size();
    }

    middleMileDriversPage.verifiesTotalDriverIsTheSame(totalDriver);
  }

  @When("Operator selects the hub on the Middle Mile Drivers Page")
  public void operatorSelectsTheHubOnTheMiddleMileDriversPage() {
    Hub hub = get(KEY_HUB_INFO);
    String hubName = hub.getName();
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        middleMileDriversPage.selectHubFilter(hubName);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Element in middle mile driver page not found, retrying...");
        middleMileDriversPage.refreshPage();
        middleMileDriversPage.switchTo();
        middleMileDriversPage.loadButton.waitUntilClickable();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, getCurrentMethodName(), 500, 5);

  }

  @When("Operator create new Middle Mile Driver with details:")
  public void operatorCreateNewMiddleMileDriverWithDetails(
      List<Map<String, String>> middleMileDrivers) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        String country = get(COUNTRY);
        for (Map<String, String> data : middleMileDrivers) {
          Driver middleMileDriver = new Driver();
          middleMileDriversPage.clickCreateDriversButton();
          middleMileDriver.setFirstName(data.get("name"));

          if (RANDOM.equalsIgnoreCase(middleMileDriver.getFirstName())) {
            String name = AUTO;
            String lastName = StandardTestUtils.generateRequestedTrackingNumber();
            String displayName = name + " " + lastName;
            System.out.println("Display name: " + displayName);
            middleMileDriver.setFirstName(name);
            middleMileDriver.setLastName(lastName);
            middleMileDriver.setDisplayName(displayName);
          }
          middleMileDriversPage.fillNames(middleMileDriver.getFirstName(),
              middleMileDriver.getLastName());

          middleMileDriver.setHub(resolveValue(data.get("hub")));
          if (!"country_based".equalsIgnoreCase(middleMileDriver.getHub())) {
            middleMileDriversPage.chooseHub(middleMileDriver.getHub());
          }

          middleMileDriver.setMobilePhone(data.get("contactNumber"));
          middleMileDriversPage.fillcontactNumber(middleMileDriver.getMobilePhone());

          middleMileDriver.setLicenseNumber(data.get("licenseNumber"));
          if (RANDOM.equalsIgnoreCase(middleMileDriver.getLicenseNumber())) {
            String licenseNumber = RandomUtil.randomString(5);
            System.out.println("License Number : " + licenseNumber);
            middleMileDriver.setLicenseNumber(licenseNumber);
          }
          middleMileDriversPage.fillLicenseNumber(middleMileDriver.getLicenseNumber());

          middleMileDriver
              .setLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
          middleMileDriversPage.fillLicenseExpiryDate(
              EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));

          if (country == null) {
            middleMileDriver.setLicenseType(CLASS_5);
          } else {
            switch (country.toLowerCase()) {
              case SINGAPORE:
                middleMileDriver.setLicenseType(CLASS_5);
                break;

              case INDONESIA:
                middleMileDriver.setLicenseType(SIM_B_I_UMUM);
                break;

              case THAILAND:
                middleMileDriver.setLicenseType(TYPE_C);
                break;

              case VIETNAM:
              case MALAYSIA:
                middleMileDriver.setLicenseType(CLASS_E);
                break;
              case PHILIPPINES:
                middleMileDriver.setLicenseType(RESTRICTION_5);
                break;

              default:
                LOGGER.warn("Country is not on the list");
            }
          }
          middleMileDriversPage.chooseLicenseType(middleMileDriver.getLicenseType());

          middleMileDriver.setEmploymentType(data.get("employmentType"));
          if (IN_HOUSE_FULL_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(IN_HOUSE_FULL_TIME_CONTRACT);
          } else if (IN_HOUSE_PART_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(IN_HOUSE_PART_TIME_CONTRACT);
          } else if (OUTSOURCED_SUBCON.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(OUTSOURCED_SUBCON_CONTRACT);
          } else if (OUTSOURCED_VENDOR.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(OUTSOURCED_VENDORS_CONTRACT);
          }
          middleMileDriversPage.chooseEmploymentType(middleMileDriver.getEmploymentType());

          middleMileDriversPage.fillEmploymentStartDate(EXPIRY_DATE_FORMATTER.format(TODAY));
          middleMileDriversPage.fillEmploymentEndDate(
              EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
          middleMileDriver.setUsername(data.get("username"));
          if (RANDOM.equalsIgnoreCase(middleMileDriver.getUsername())) {
            middleMileDriver.setUsername(
                middleMileDriver.getFirstName() + middleMileDriver.getLastName());
          }
          middleMileDriversPage.fillUsername(middleMileDriver.getUsername());

          middleMileDriversPage.fillPassword(PASSWORD);

          middleMileDriver.setComments(COMMENTS);
          middleMileDriversPage.fillComments(middleMileDriver.getComments());

          middleMileDriversPage.clickSaveButton();

          put(KEY_CREATED_DRIVER, middleMileDriver);
          putInList(KEY_LIST_OF_CREATED_DRIVERS, middleMileDriver);
          put(KEY_CREATED_DRIVER_USERNAME, middleMileDriver.getUsername());
        }
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Element in middle mile driver page not found, retrying...");
        middleMileDriversPage.refreshPage();
        middleMileDriversPage.switchTo();
        middleMileDriversPage.loadButton.waitUntilClickable();
        middleMileDriversPage.clickCreateDriversButton();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 5);

  }

  @Then("Operator verifies that the new Middle Mile Driver has been created")
  public void operatorVerifiesThatTheNewMiddleMileDriverHasBeenCreated() {
    String username = get(KEY_CREATED_DRIVER_USERNAME);
    middleMileDriversPage.driverHasBeenCreatedToast(username);
  }

  @When("Operator selects the hub on the Middle Mile Drivers Page with value {string}")
  public void operatorSelectsTheHubOnTheMiddleMileDriversPageWithValue(String hubName) {
    String resolvedHubName = resolveValue(hubName);
    middleMileDriversPage.selectHubFilter(resolvedHubName);
  }

  @When("Operator selects the {string} with the value of {string} on Middle Mile Driver Page")
  public void operatorSelectsTheWithTheValueOfOnMiddleMileDriverPage(String filterName,
      String value) {
    middleMileDriversPage.selectFilter(filterName, value);
    if (IS_FIRST_TIME_SETUP_DRIVER){
      GetDriverResponse drivers = get(KEY_ALL_DRIVERS_DATA);
      middleMileDriversPage.LIST_OF_FILTER_DRIVERS = drivers.getData().getDrivers();
      IS_FIRST_TIME_SETUP_DRIVER = false;
    }
    middleMileDriversPage.LIST_OF_FILTER_DRIVERS=middleMileDriversPage.filterDriver(middleMileDriversPage.LIST_OF_FILTER_DRIVERS,filterName,value);
  }

  @When("Operator searches by {string} with value {string}")
  public void operatorSearchesByWithValue(String filterName, String filterValue) {
    String resolvedFilterValue = resolveValue(filterValue);
    if ("id".equals(filterName)) {
      middleMileDriversPage.tableFilterByIdWithValue(Long.valueOf(resolvedFilterValue));
    }

  }

  @Then("Operator searches by {string} and verifies the created username")
  public void operatorSearchesAndVerifiesTheCreatedUsername(String filterBy) {
    List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
    switch (filterBy.toLowerCase()) {
      case NAME_FILTER:
        middleMileDriversPage.tableFilter(middleMileDriver.get(0), NAME_FILTER);
        break;

      case ID_FILTER:
        Long driverId = get(KEY_CREATED_DRIVER_ID);
        middleMileDriversPage.tableFilterById(middleMileDriver.get(0), driverId);
        break;

      case USERNAME_FILTER:
        middleMileDriversPage.tableFilter(middleMileDriver.get(0), USERNAME_FILTER);
        break;

      case HUB_FILTER:
        middleMileDriversPage.tableFilter(middleMileDriver.get(0), HUB_FILTER);
        break;

      case EMPLOYMENT_TYPE_FILTER:
        middleMileDriversPage
            .tableFilterCombobox(middleMileDriver.get(0), EMPLOYMENT_TYPE_FILTER);
        break;

      case EMPLOYMENT_STATUS_FILTER:
        middleMileDriversPage
            .tableFilterCombobox(middleMileDriver.get(0), EMPLOYMENT_STATUS_FILTER);
        break;

      case LICENSE_TYPE_FILTER:
        middleMileDriversPage.tableFilterCombobox(middleMileDriver.get(0), LICENSE_TYPE_FILTER);
        break;

      case LICENSE_STATUS_FILTER:
        middleMileDriversPage.tableFilterCombobox(middleMileDriver.get(0), LICENSE_STATUS_FILTER);
        break;

      case COMMENTS_FILTER:
        middleMileDriversPage.tableFilter(middleMileDriver.get(0), COMMENTS_FILTER);
        break;

      default:
        LOGGER.warn("Filter is not found");
    }
  }

  @Then("Operator searches and verifies the created username is not exist")
  public void operatorSearchesAndVerifiesTheCreatedUsernameIsNotExist() {
    String driverName = get(KEY_CREATED_DRIVER_USERNAME);
    middleMileDriversPage.verifiesDataIsNotExisted(driverName);
  }

  @When("Operator clicks view button on the middle mile driver page")
  public void operatorClicksViewButtonOnTheMiddleMileDriverPage() {
    middleMileDriversPage.clickViewButton();
  }

  @When("Operator clicks edit button on the middle mile driver page")
  public void operatorClicksEditButtonOnTheMiddleMileDriverPage() {
    middleMileDriversPage.clickEditButton();
  }

  @When("Operator edit {string} on edit driver dialog with value {string}")
  public void operatorEditDriverOnEditDriverDialogWithValue(String column, String value) {
    String resolvedValue = resolveValue(value);
    middleMileDriversPage.editDriverByWithValue(column, resolvedValue);
  }

  @Then("Operator verifies {string} is updated with value {string}")
  public void operatorVerifiesDriverIsUpdatedWithValue(String column, String value) {
    String resolvedValue = resolveValue(value);
    middleMileDriversPage.verifiesDriverIsUpdatedByWithValue(column, resolvedValue);
  }

  @Then("Operator verifies that the details of the middle mile driver is true")
  public void operatorVerifiesThatTheDetailsOfTheMiddleMileDriverIsTrue() {
    List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
    middleMileDriversPage.verifiesDataInViewModalIsTheSame(middleMileDriver.get(0));
  }

  @When("Operator clicks {string} button on the middle mile driver page")
  public void operatorClicksButtonOnTheMiddleMileDriverPage(String mode) {
    middleMileDriversPage.clickAvailabilityMode(mode);
  }

  @Then("Operator verifies that the driver availability's value is the same")
  public void operatorVeririesThatTheDriverAvailabilitySValueIsTheSame() {
    boolean driverAvailability = get(KEY_CREATED_MIDDLE_MILE_DRIVER_AVAILABILITY);
    middleMileDriversPage.verifiesDriverAvailability(driverAvailability);
  }

  @When("Operator sets all selected middle mile driver to {string}")
  public void operatorSetsAllSelectedMiddleMileDriverTo(String mode) {
    middleMileDriversPage.clickBulkAvailabilityMode(mode);
  }

  @When("Operator refresh Middle Mile Driver Page")
  public void operatorRefreshMiddleMileDriverPage() {
    middleMileDriversPage.refreshAndWaitUntilLoadingDone();
  }

  @When("Operator click {string} in {string} column on Middle Mile Driver Page")
  public void operatorClicksortIconInNameColumn(String sortOrder, String column){
    middleMileDriversPage.sortColumn(column, sortOrder);
  }

  @Then("Make sure All data in Middle Mile Driver tables is {string} shown based on {string}")
  public void verifies_that_the_column_is_in_ascending_order(String sortOrder, String column){
    middleMileDriversPage.getRecordsAndValidateSorting(column,sortOrder);
  }

  @When("Operator click on Browser back button")
  public void OperatorClickOnBrowserBackButton(){
    middleMileDriversPage.ClickToBrowserBackButton();
  }

  @Then("Operator verifies the Employment Status is {string} and License Status is {string}")
  public void OperatorVerifiesFilterStatus(String Employment_value, String license_value){
    middleMileDriversPage.verifiesTextInEmploymentStatusFilter(Employment_value);
    middleMileDriversPage.verifiesTextInLicenseStatusFilter(license_value);
  }

  @When("Operator click on Browser Forward button")
  public void OperatorClickOnBrowserForwardButton(){
    middleMileDriversPage.ClickToBrowserForwardButton();
  }

  @Then("Make sure URL show is {string}")
  public void VerifyURLinMiddleDriverPage(String URL){
    if (URL.contains("<id>")){
      Hub hub = get(KEY_HUB_INFO);
      String hubID = hub.getId().toString();
      URL = URL.replaceAll("<id>",hubID);
    }
    middleMileDriversPage.verifyURLofPage(URL);
  }

  @Then("Operator verifies that the GUI elements are shown on the Middle Mile Driver Page")
  public void operatorVerifyTheElementsAreShown() {
    List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
    middleMileDriversPage.convertDateToUnixTimestamp(middleMileDriver.get(0));
    middleMileDriversPage.tableFilterByname(middleMileDriver.get(0));
  }

  @When("Operator verifies UI elements in Middle Mile Driver Page on {string}")
  public void operatorVerifiesUIElementsInMiddleMileDriverPage(String url) {
    Map<String, String> dataTableAsMap = new HashMap<>();
    dataTableAsMap.put("url", url);
    operatorVerifiesUIElementsInMiddleMileDriverPage(dataTableAsMap);
  }

  private void filterAllDriverDataWithQueryParam(String queryParam) {
    Map<String, Boolean> statusMap = new HashMap<>();
    List<String> statuses = Arrays.stream(queryParam.split("&")).collect(Collectors.toList());

    if (statuses.contains("employmentStatus=active") || statuses.contains("employmentStatus=inactive")) statusMap.put("isEmploymentActive", statuses.contains("employmentStatus=active"));
    if (statuses.contains("licenseStatus=active") || statuses.contains("licenseStatus=inactive")) statusMap.put("isLicenseActive", statuses.contains("licenseStatus=active"));

    GetDriverResponse driver = get(KEY_ALL_DRIVERS_DATA);
    List<Driver> drivers = driver.getData().getDrivers();

    if (statusMap.containsKey("isEmploymentActive")) {
      drivers = drivers.stream().filter(d -> {
        if (d.getEmploymentEndDate() == null) return statusMap.get("isEmploymentActive");
        return (Long.parseLong(d.getEmploymentEndDate()) >= new Date().getTime()) == statusMap.get("isEmploymentActive");
      }).collect(
          Collectors.toList());
    }
    if (statusMap.containsKey("isLicenseActive")) {
      drivers = drivers.stream().filter(d -> {
        if (d.getLicenseExpiryDate() == null) return false;
        return (Long.parseLong(d.getLicenseExpiryDate()) >= new Date().getTime()) == statusMap.get("isLicenseActive");
      }).collect(
          Collectors.toList());
    }

    LOGGER.info("Driver count: {}", drivers.size());

    GetDriverDataResponse driverData = driver.getData();
    driverData.setDrivers(drivers);
    driver.setData(driverData);
    put(KEY_ALL_DRIVERS_DATA, driver);
  }

  @When("Operator verifies UI elements in Middle Mile Driver Page with data below")
  public void operatorVerifiesUIElementsInMiddleMileDriverPage(Map<String, String> dataTableAsMap) {
    String url = dataTableAsMap.get("url");
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      middleMileDriversPage.goToUrl(MIDDLE_MILE_DRIVERS_URL);
      operatorMovementTripPageIsLoaded();
      if (dataTableAsMap.keySet().size() > 1) {
        List<String> filterKeys = dataTableAsMap.keySet().stream()
            .filter(k -> !k.equalsIgnoreCase("url")).collect(
                Collectors.toList());
        filterKeys.forEach(key -> {
          String filterValue = resolveValue(dataTableAsMap.get(key));
          operatorSelectsTheWithTheValueOfOnMiddleMileDriverPage(key, filterValue);
        });
      }
      operatorClicksOnLoadDriverButtonOnTheMiddleMileDriverPage();
      VerifyURLinMiddleDriverPage(url);
      filterAllDriverDataWithQueryParam(url.split("\\?+")[1]);
      operatorVerifiesThatTheDataShownHasTheSameValue();
      operatorVerifyTheElementsAreShown();
    }, "Retrying until UI is showing the right data...", 1000, 1);
  }

//  @Then("API Fillter the list of driver")
//  public void fillterTheListOfDriver(){
//    GetDriverResponse drivers = get(KEY_ALL_DRIVERS_DATA);
//    List<Driver> middleMileDrivers = drivers.getData().getDrivers();
//    middleMileDriversPage.LIST_OF_FILTER_DRIVERS = middleMileDrivers;
//    middleMileDriversPage.LIST_OF_FILTER_DRIVERS=middleMileDriversPage.filterDriver(middleMileDriversPage.LIST_OF_FILTER_DRIVERS,"Employment Status","Active");
//    int count = middleMileDriversPage.LIST_OF_FILTER_DRIVERS.size();
//    middleMileDriversPage.LIST_OF_FILTER_DRIVERS=middleMileDriversPage.filterDriver(middleMileDriversPage.LIST_OF_FILTER_DRIVERS,"License Status","Active");
//    count = middleMileDriversPage.LIST_OF_FILTER_DRIVERS.size();
//  }

  @When("Operator verifies that list of middle mile drivers is shown")
  public void filterDriverby(){
    int totalDriver = middleMileDriversPage.LIST_OF_FILTER_DRIVERS.size();
    middleMileDriversPage.verifiesTotalDriverIsTheSame(totalDriver);
  }

  @When("Operator create new Existing username Middle Mile Driver and verify error message with details:")
  public void operatorCreateNewExitstingUsernameMiddleMileDriverWithDetails(
          List<Map<String, String>> middleMileDrivers) {
    retryIfRuntimeExceptionOccurred(() ->
    {
      try {
        String country = get(COUNTRY);
        for (Map<String, String> data : middleMileDrivers) {
          Driver middleMileDriver = new Driver();
          middleMileDriversPage.clickCreateDriversButton();
          middleMileDriver.setFirstName(data.get("name"));

          if (RANDOM.equalsIgnoreCase(middleMileDriver.getFirstName())) {
            String name = AUTO;
            String lastName = StandardTestUtils.generateRequestedTrackingNumber();
            String displayName = name + " " + lastName;
            System.out.println("Display name: " + displayName);
            middleMileDriver.setFirstName(name);
            middleMileDriver.setLastName(lastName);
            middleMileDriver.setDisplayName(displayName);
          }
          middleMileDriversPage.fillNames(middleMileDriver.getFirstName(),
              middleMileDriver.getLastName());

          middleMileDriver.setHub(resolveValue(data.get("hub")));
          if (!"country_based".equalsIgnoreCase(middleMileDriver.getHub())) {
            middleMileDriversPage.chooseHub(middleMileDriver.getHub());
          }

          middleMileDriver.setMobilePhone(data.get("contactNumber"));
          middleMileDriversPage.fillcontactNumber(middleMileDriver.getMobilePhone());

          middleMileDriver.setLicenseNumber(data.get("licenseNumber"));
          if (RANDOM.equalsIgnoreCase(middleMileDriver.getLicenseNumber())) {
            String licenseNumber = RandomUtil.randomString(5);
            System.out.println("License Number : " + licenseNumber);
            middleMileDriver.setLicenseNumber(licenseNumber);
          }
          middleMileDriversPage.fillLicenseNumber(middleMileDriver.getLicenseNumber());

          middleMileDriver
                  .setLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
          middleMileDriversPage.fillLicenseExpiryDate(
                  EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));

          if (country == null) {
            middleMileDriver.setLicenseType(CLASS_5);
          } else {
            switch (country.toLowerCase()) {
              case SINGAPORE:
                middleMileDriver.setLicenseType(CLASS_5);
                break;

              case INDONESIA:
                middleMileDriver.setLicenseType(SIM_B_I_UMUM);
                break;

              case THAILAND:
                middleMileDriver.setLicenseType(TYPE_C);
                break;

              case VIETNAM:
              case MALAYSIA:
                middleMileDriver.setLicenseType(CLASS_E);
                break;
              case PHILIPPINES:
                middleMileDriver.setLicenseType(RESTRICTION_5);
                break;

              default:
                LOGGER.warn("Country is not on the list");
            }
          }
          middleMileDriversPage.chooseLicenseType(middleMileDriver.getLicenseType());

          middleMileDriver.setEmploymentType(data.get("employmentType"));
          if (IN_HOUSE_FULL_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(IN_HOUSE_FULL_TIME_CONTRACT);
          } else if (IN_HOUSE_PART_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(IN_HOUSE_PART_TIME_CONTRACT);
          } else if (OUTSOURCED_SUBCON.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(OUTSOURCED_SUBCON_CONTRACT);
          } else if (OUTSOURCED_VENDOR.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
            middleMileDriver.setEmploymentType(OUTSOURCED_VENDORS_CONTRACT);
          }
          middleMileDriversPage.chooseEmploymentType(middleMileDriver.getEmploymentType());

          middleMileDriversPage.fillEmploymentStartDate(EXPIRY_DATE_FORMATTER.format(TODAY));
          middleMileDriversPage.fillEmploymentEndDate(
                  EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
          middleMileDriver.setUsername(data.get("username"));
          if (RANDOM.equalsIgnoreCase(middleMileDriver.getUsername())) {
            middleMileDriver.setUsername(
                middleMileDriver.getFirstName() + middleMileDriver.getLastName());
          }
          middleMileDriversPage.fillUsername(middleMileDriver.getUsername());
          middleMileDriversPage.clickCheckAvailabilityButton();
          middleMileDriversPage.verifyErrorMessage(data.get("username")+" is not available!");

          middleMileDriversPage.fillPassword(PASSWORD);

          middleMileDriver.setComments(COMMENTS);
          middleMileDriversPage.fillComments(middleMileDriver.getComments());

          middleMileDriversPage.clickSaveButton();
          middleMileDriversPage.verifyErrorMessage("lib.exceptions.NVConflictException: Username already registered");
          put(KEY_CREATED_DRIVER, middleMileDriver);
          putInList(KEY_LIST_OF_CREATED_DRIVERS, middleMileDriver);
          put(KEY_CREATED_DRIVER_USERNAME, middleMileDriver.getUsername());
        }
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage());
        LOGGER.info("Element in middle mile driver page not found, retrying...");
        middleMileDriversPage.refreshPage();
        middleMileDriversPage.switchTo();
        middleMileDriversPage.loadButton.waitUntilClickable();
        middleMileDriversPage.clickCreateDriversButton();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, 1);

  }
}
