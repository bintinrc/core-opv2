package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.model.core.GetDriverResponse;
import co.nvqa.commons.model.sort.hub.Hub;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.MiddleMileDriversPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * @author Tristania Siagian
 */

public class MiddleMileDriversSteps extends AbstractSteps
{

    private static final ZonedDateTime TODAY = DateUtil.getDate();
    private static final DateTimeFormatter CAL_FORMATTER = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    private static final DateTimeFormatter EXPIRY_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
    private static final DateTimeFormatter COMMENT_FORMATTER = DateUtil.DATE_TIME_FORMATTER;
    private static final String AUTO = "AUTO";
    private static final String RANDOM = "RANDOM";
    private static final String PASSWORD = "password";
    private static final String COMMENTS = String.format("Created at : %s", COMMENT_FORMATTER.format(TODAY));

    private static final String CLASS_5 = "Class 5";
    private static final String SIM_B_I_UMUM = "SIM B I Umum";
    private static final String TYPE_C = "Type C";
    private static final String CLASS_E = "Class E";
    private static final String RESTRICTION_5 = "Restriction 5";

    private static final String FULL_TIME = "FULL_TIME";
    private static final String PART_TIME = "PART_TIME";
    private static final String VENDOR = "VENDOR";

    private static final String NAME_FILTER = "name";
    private static final String ID_FILTER = "id";
    private static final String USERNAME_FILTER = "username";
    private static final String HUB_FILTER = "hub";
    private static final String EMPLOYMENT_TYPE_FILTER = "employment type";
    private static final String EMPLOYMENT_STATUS_FILTER = "employment status";
    private static final String LICENSE_TYPE_FILTER = "license type";
    private static final String LICENSE_STATUS_FILTER = "license status";
    private static final String COMMENTS_FILTER = "comments";

    private static final String FULL_TIME_CONTRACT = "Full-time / Contract";
    private static final String PART_TIME_FREELANCE = "Part-time / Freelance";
    private static final String VENDOR_SELECTION = "Vendor";
    private static final String COUNTRY = "country";

    private static final String SG_HUB = "OPV2-SG-HUB";
    private static final String ID_HUB = "JKSLT-JKSLT-JKSLT-JKSLT";
    private static final String TH_HUB = "DRIVER-APP-TH-HUB";
    private static final String VN_HUB = "BAG - Bac Giang - NOR";
    private static final String MY_HUB = "BUTTERWORTH";
    private static final String PH_HUB = "CEBU-NAGA";

    private static final String SINGAPORE = "singapore";
    private static final String INDONESIA = "indonesia";
    private static final String THAILAND = "thailand";
    private static final String VIETNAM = "vietnam";
    private static final String MALAYSIA = "malaysia";
    private static final String PHILIPPINES = "philippines";

    private MiddleMileDriversPage middleMileDriversPage;

    public MiddleMileDriversSteps()
    {
    }

    @Override
    public void init()
    {
        middleMileDriversPage = new MiddleMileDriversPage(getWebDriver());
    }

    @When("Operator clicks on Load Driver Button on the Middle Mile Driver Page")
    public void operatorClicksOnLoadDriverButtonOnTheMiddleMileDriverPage()
    {
        middleMileDriversPage.clickLoadDriversButton();
    }

    @Then("Operator verifies that the data shown has the same value")
    public void operatorVerifiesThatTheDataShownHasTheSameValue()
    {
        GetDriverResponse driver = get(KEY_ALL_DRIVERS_DATA);
        int totalDriver = 0;

        if (driver != null)
        {
            totalDriver = driver.getData().getCount();
        }

        middleMileDriversPage.verifiesTotalDriverIsTheSame(totalDriver);
    }

    @When("Operator selects the hub on the Middle Mile Drivers Page")
    public void operatorSelectsTheHubOnTheMiddleMileDriversPage()
    {
        Hub hub = get(KEY_HUB_INFO);
        String hubName = hub.getName();
        middleMileDriversPage.selectHubFilter(hubName);
    }

    @When("Operator create new Middle Mile Driver with details:")
    public void operatorCreateNewMiddleMileDriverWithDetails(List<Map<String, String>> middleMileDrivers)
    {
        String country = get(COUNTRY);
        for (Map<String, String> data : middleMileDrivers)
        {
            Driver middleMileDriver = new Driver();
            middleMileDriversPage.clickCreateDriversButton();
            middleMileDriver.setFirstName(data.get("name"));

            if (RANDOM.equalsIgnoreCase(middleMileDriver.getFirstName()))
            {
                String name = AUTO + generateRequestedTrackingNumber();
                System.out.println("Name and Username : " + name);
                middleMileDriver.setFirstName(name);
            }
            middleMileDriversPage.fillName(middleMileDriver.getFirstName());

            middleMileDriver.setHub(data.get("hub"));
            if (!"country_based".equalsIgnoreCase(middleMileDriver.getHub()))
            {
                middleMileDriversPage.chooseHub(middleMileDriver.getHub());
            } else
            {
                switch (country.toLowerCase())
                {
                    case SINGAPORE:
                        middleMileDriver.setHub(SG_HUB);
                        break;

                    case INDONESIA:
                        middleMileDriver.setHub(ID_HUB);
                        break;

                    case THAILAND:
                        middleMileDriver.setHub(TH_HUB);
                        break;

                    case VIETNAM:
                        middleMileDriver.setHub(VN_HUB);
                        break;

                    case MALAYSIA:
                        middleMileDriver.setHub(MY_HUB);
                        break;

                    case PHILIPPINES:
                        middleMileDriver.setHub(PH_HUB);
                        break;

                    default:
                        NvLogger.warn("Country is not on the list");
                }
                middleMileDriversPage.chooseHub(middleMileDriver.getHub());
            }

            middleMileDriver.setMobilePhone(data.get("contactNumber"));
            middleMileDriversPage.fillcontactNumber(middleMileDriver.getMobilePhone());

            middleMileDriver.setLicenseNumber(data.get("licenseNumber"));
            if (RANDOM.equalsIgnoreCase(middleMileDriver.getLicenseNumber()))
            {
                String licenseNumber = RandomUtil.randomString(5);
                System.out.println("License Number : " + licenseNumber);
                middleMileDriver.setLicenseNumber(licenseNumber);
            }
            middleMileDriversPage.fillLicenseNumber(middleMileDriver.getLicenseNumber());

            middleMileDriver.setLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
            middleMileDriversPage.fillLicenseExpiryDate(CAL_FORMATTER.format(TODAY.plusMonths(2)));

            if (country == null)
            {
                middleMileDriver.setLicenseType(CLASS_5);
            } else
            {
                switch (country.toLowerCase())
                {
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
                        middleMileDriver.setLicenseType(CLASS_E);
                        break;

                    case MALAYSIA:
                        middleMileDriver.setLicenseType(CLASS_E);
                        break;

                    case PHILIPPINES:
                        middleMileDriver.setLicenseType(RESTRICTION_5);
                        break;

                    default:
                        NvLogger.warn("Country is not on the list");
                }
            }
            middleMileDriversPage.chooseLicenseType(middleMileDriver.getLicenseType());

            middleMileDriver.setEmploymentType(data.get("employmentType"));
            if (FULL_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType()))
            {
                middleMileDriver.setEmploymentType(FULL_TIME_CONTRACT);
            } else if (PART_TIME.equalsIgnoreCase(middleMileDriver.getEmploymentType()))
            {
                middleMileDriver.setEmploymentType(PART_TIME_FREELANCE);
            } else if (VENDOR.equalsIgnoreCase(middleMileDriver.getEmploymentType()))
            {
                middleMileDriver.setEmploymentType(VENDOR_SELECTION);
            }
            middleMileDriversPage.chooseEmploymentType(middleMileDriver.getEmploymentType());

            middleMileDriversPage.fillEmploymentStartDate(CAL_FORMATTER.format(TODAY));
            middleMileDriversPage.fillEmploymentEndDate(CAL_FORMATTER.format(TODAY.plusMonths(2)));

            middleMileDriver.setUsername(data.get("username"));
            if (RANDOM.equalsIgnoreCase(middleMileDriver.getUsername()))
            {
                middleMileDriver.setUsername(middleMileDriver.getFirstName());
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
    }

    @Then("Operator verifies that the new Middle Mile Driver has been created")
    public void operatorVerifiesThatTheNewMiddleMileDriverHasBeenCreated()
    {
        String username = get(KEY_CREATED_DRIVER_USERNAME);
        middleMileDriversPage.driverHasBeenCreatedToast(username);
    }

    @When("Operator selects the {string} with the value of {string} on Middle Mile Driver Page")
    public void operatorSelectsTheWithTheValueOfOnMiddleMileDriverPage(String filterName, String value)
    {
        middleMileDriversPage.selectFilter(filterName, value);
    }

    @Then("Operator searches by {string} and verifies the created username")
    public void operatorSearchesAndVerifiesTheCreatedUsername(String filterBy)
    {
        List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
        switch (filterBy.toLowerCase())
        {
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
                middleMileDriversPage.tableFilterCombobox(middleMileDriver.get(0), EMPLOYMENT_TYPE_FILTER);
                break;

            case EMPLOYMENT_STATUS_FILTER:
                middleMileDriversPage.tableFilterCombobox(middleMileDriver.get(0), EMPLOYMENT_STATUS_FILTER);
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
                NvLogger.warn("Filter is not found");
        }
    }

    @Then("Operator searches and verifies the created username is not exist")
    public void operatorSearchesAndVerifiesTheCreatedUsernameIsNotExist()
    {
        String driverName = get(KEY_CREATED_DRIVER_USERNAME);
        middleMileDriversPage.verifiesDataIsNotExisted(driverName);
    }

    @When("Operator clicks view button on the middle mile driver page")
    public void operatorClicksViewButtonOnTheMiddleMileDriverPage()
    {
        middleMileDriversPage.clickViewButton();
    }

    @Then("Operator verifies that the details of the middle mile driver is true")
    public void operatorVerifiesThatTheDetailsOfTheMiddleMileDriverIsTrue()
    {
        List<Driver> middleMileDriver = get(KEY_LIST_OF_CREATED_DRIVERS);
        middleMileDriversPage.verifiesDataInViewModalIsTheSame(middleMileDriver.get(0));
    }

    @When("Operator clicks {string} button on the middle mile driver page")
    public void operatorClicksButtonOnTheMiddleMileDriverPage(String mode)
    {
        middleMileDriversPage.clickAvailabilityMode(mode);
    }

    @Then("Operator verifies that the driver availability's value is the same")
    public void operatorVeririesThatTheDriverAvailabilitySValueIsTheSame()
    {
        boolean driverAvailability = get(KEY_CREATED_MIDDLE_MILE_DRIVER_AVAILABILITY);
        middleMileDriversPage.verifiesDriverAvailability(driverAvailability);
    }

    @When("Operator sets all selected middle mile driver to {string}")
    public void operatorSetsAllSelectedMiddleMileDriverTo(String mode)
    {
        middleMileDriversPage.clickBulkAvailabilityMode(mode);
    }

    @When("Operator refresh Middle Mile Driver Page")
    public void operatorRefreshMiddleMileDriverPage()
    {
        middleMileDriversPage.refreshAndWaitUntilLoadingDone();
    }
}
