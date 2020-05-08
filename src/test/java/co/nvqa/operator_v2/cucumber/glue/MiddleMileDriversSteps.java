package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.GetDriverResponse;
import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.model.MiddleMileDriver;
import co.nvqa.operator_v2.selenium.page.MiddleMileDriversPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

/**
 *
 * @author Tristania Siagian
 */

public class MiddleMileDriversSteps extends AbstractSteps {

    private static final ZonedDateTime TODAY = DateUtil.getDate();
    private static final DateTimeFormatter CAL_FORMATTER = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    private static final String AUTO = "AUTO";
    private static final String CLASS_5 = "Class 5";
    private static final String RANDOM = "RANDOM";
    private static final String PASSWORD = "password";
    private static final String COMMENTS = String.format("Created at : %s", CAL_FORMATTER.format(TODAY));

    private static final String FULL_TIME = "FULL_TIME";
    private static final String PART_TIME = "PART_TIME";
    private static final String VENDOR = "VENDOR";

    private static final String FULL_TIME_CONTRACT = "Full-time / Contract";
    private static final String PART_TIME_FREELANCE = "Part-time / Freelance";
    private static final String VENDOR_SELECTION = "Vendor";

    private MiddleMileDriversPage middleMileDriversPage;

    public MiddleMileDriversSteps() {
    }

    @Override
    public void init()
    {
        middleMileDriversPage = new MiddleMileDriversPage(getWebDriver());
    }

    @When("Operator clicks on Load Driver Button on the Middle Mile Driver Page")
    public void operatorClicksOnLoadDriverButtonOnTheMiddleMileDriverPage() {
        middleMileDriversPage.clickLoadDriversButton();
    }

    @Then("Operator verifies that the data shown has the same value")
    public void operatorVerifiesThatTheDataShownHasTheSameValue() {
        GetDriverResponse driver = get(KEY_ALL_DRIVERS_DATA);
        int totalDriver = 0;

        if (driver != null) {
            totalDriver = driver.getData().getCount();
        }

        middleMileDriversPage.verifiesTotalDriverIsTheSame(totalDriver);
    }

    @When("Operator selects the hub on the Middle Mile Drivers Page")
    public void operatorSelectsTheHubOnTheMiddleMileDriversPage() {
        Hub hub = get(KEY_HUB_INFO);
        String hubName = hub.getName();
        middleMileDriversPage.selectHubFilter(hubName);
    }

    @When("Operator create new Middle Mile Driver with details:")
    public void operatorCreateNewMiddleMileDriverWithDetails(List<MiddleMileDriver> middleMileDrivers) {
        for (MiddleMileDriver middleMileDriver : middleMileDrivers) {
            middleMileDriversPage.clickCreateDriversButton();

            if (RANDOM.equalsIgnoreCase(middleMileDriver.getName())) {
                String name = AUTO + generateRequestedTrackingNumber();
                System.out.println("Name and Username : " + name);
                middleMileDriver.setName(name);
            }
            middleMileDriversPage.fillName(middleMileDriver.getName());

            middleMileDriversPage.chooseHub(middleMileDriver.getHub());
            middleMileDriversPage.fillcontactNumber(middleMileDriver.getContactNumber());

            if (RANDOM.equalsIgnoreCase(middleMileDriver.getLicenseNumber())) {
                String licenseNumber = generateRequestedTrackingNumber();
                System.out.println("License Number : " + licenseNumber);
                middleMileDriver.setLicenseNumber(licenseNumber);
            }
            middleMileDriversPage.fillLicenseNumber(middleMileDriver.getLicenseNumber());

            middleMileDriversPage.fillLicenseExpiryDate(CAL_FORMATTER.format(TODAY.plusMonths(2)));

            middleMileDriver.setLicenseType(CLASS_5);
            middleMileDriversPage.chooseLicenseType();

            if (FULL_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
                middleMileDriver.setEmploymentType(FULL_TIME_CONTRACT);
            } else if (PART_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
                middleMileDriver.setEmploymentType(PART_TIME_FREELANCE);
            } else if (VENDOR.equalsIgnoreCase(middleMileDriver.getEmploymentType())) {
                middleMileDriver.setEmploymentType(VENDOR_SELECTION);
            }
            middleMileDriversPage.chooseEmploymentType(middleMileDriver.getEmploymentType());

            middleMileDriversPage.fillEmploymentStartDate(CAL_FORMATTER.format(TODAY));
            middleMileDriversPage.fillEmploymentEndDate(CAL_FORMATTER.format(TODAY.plusMonths(2)));

            if (RANDOM.equalsIgnoreCase(middleMileDriver.getUsername())) {
                middleMileDriver.setUsername(middleMileDriver.getName());
            }
            middleMileDriversPage.fillUsername(middleMileDriver.getUsername());

            middleMileDriversPage.fillPassword(PASSWORD);

            middleMileDriver.setComments(COMMENTS);
            middleMileDriversPage.fillComments(middleMileDriver.getComments());

            middleMileDriversPage.clickSaveButton();
        }

        if (middleMileDrivers.size() > 1) {
            for (MiddleMileDriver middleMileDriver : middleMileDrivers) {
                put(KEY_LIST_OF_CREATED_MIDDLE_MILE_DRIVER_DETAILS, middleMileDriver);
                put(KEY_LIST_OF_CREATED_MIDDLE_MILE_DRIVER_USERNAME, middleMileDriver.getUsername());
            }
        } else {
            put(KEY_CREATED_MIDDLE_MILE_DRIVER_DETAILS, middleMileDrivers);
            put(KEY_CREATED_MIDDLE_MILE_DRIVER_USERNAME, middleMileDrivers.get(0).getUsername());
        }
    }

    @Then("Operator verifies that the new Middle Mile Driver has been created")
    public void operatorVerifiesThatTheNewMiddleMileDriverHasBeenCreated() {
        String username = get(KEY_CREATED_MIDDLE_MILE_DRIVER_USERNAME);
        middleMileDriversPage.driverHasBeenCreatedToast(username);
    }

    @When("Operator selects the {string} with the value of {string} on Middle Mile Driver Page")
    public void operatorSelectsTheWithTheValueOfOnMiddleMileDriverPage(String filterName, String value) {
        middleMileDriversPage.selectFilter(filterName, value);
    }

    @Then("Operator searches by {string} and verifies the created username")
    public void operatorSearchesAndVerifiesTheCreatedUsername(String filterBy) {
        List<MiddleMileDriver> middleMileDriver = get(KEY_CREATED_MIDDLE_MILE_DRIVER_DETAILS);
        middleMileDriversPage.filterByTableAndVerifiesData(middleMileDriver.get(0), filterBy);
    }

    @Then("Operator searches and verifies the created username is not exist")
    public void operatorSearchesAndVerifiesTheCreatedUsernameIsNotExist() {
        String driverName = get(KEY_CREATED_MIDDLE_MILE_DRIVER_USERNAME);
        middleMileDriversPage.verifiesDataIsNotExisted(driverName);
    }
}
