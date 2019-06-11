package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.notNullValue;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class DpAdministrationPage extends OperatorV2SimplePage
{
    private static final String CSV_FILENAME_PATTERN = "data-dp-users";
    private static final String CSV_DPS_FILENAME_PATTERN = "data-dps";
    private static final String CSV_DP_USERS_FILENAME_PATTERN = "data-dp-users";
    private static final String LOCATOR_BUTTON_ADD_PARTNER = "container.dp-administration.dp-partners.add-title";
    private static final String LOCATOR_BUTTON_ADD_DP = "container.dp-administration.dps.add-title";
    private static final String LOCATOR_BUTTON_ADD_DP_USER = "container.dp-administration.dp-users.add-title";
    private static final String LOCATOR_BUTTON_DOWNLOAD_CSV_FILE = "commons.download-csv";
    public static final String LOCATOR_SPINNER = "//md-progress-circular";

    private AddPartnerDialog addPartnerDialog;
    private EditPartnerDialog editPartnerDialog;
    private DpPartnersTable dpPartnersTable;
    private DpTable dpTable;
    private AddDpDialog addDpDialog;
    private EditDpDialog editDpDialog;
    private AddDpUserDialog addDpUserDialog;
    private EditDpUserDialog editDpUserDialog;
    private DpUsersTable dpUsersTable;

    public DpAdministrationPage(WebDriver webDriver)
    {
        super(webDriver);
        addPartnerDialog = new AddPartnerDialog(webDriver);
        dpPartnersTable = new DpPartnersTable(webDriver);
        editPartnerDialog = new EditPartnerDialog(webDriver);
        addDpDialog = new AddDpDialog(webDriver);
        dpTable = new DpTable(webDriver);
        editDpDialog = new EditDpDialog(webDriver);
        addDpUserDialog = new AddDpUserDialog(webDriver);
        editDpUserDialog = new EditDpUserDialog(webDriver);
        dpUsersTable = new DpUsersTable(webDriver);
    }

    public DpPartnersTable dpPartnersTable()
    {
        return dpPartnersTable;
    }

    public DpTable dpTable()
    {
        return dpTable;
    }

    public DpUsersTable dpUsersTable()
    {
        return dpUsersTable;
    }

    public void clickAddPartnerButton()
    {
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
        clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_PARTNER);
    }

    public void clickAddDpButton()
    {
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
        clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_DP);
    }
    public void clickAddDpUserButton()
    {
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
        clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_DP_USER);
    }

    public void downloadCsvFile()
    {
        clickNvIconTextButtonByName(LOCATOR_BUTTON_DOWNLOAD_CSV_FILE);
    }

    public void addPartner(DpPartner dpPartner)
    {
        clickAddPartnerButton();
        addPartnerDialog.fillForm(dpPartner);
    }

    public void editPartner(String dpPartnerName, DpPartner newDpPartnerParams)
    {
        dpPartnersTable.filterByColumn( "name", dpPartnerName);
        dpPartnersTable.clickActionButton(1, "edit");
        editPartnerDialog.fillForm(newDpPartnerParams);
    }

    public void addDistributionPoint(String dpPartnerName, Dp dpParams)
    {
        openViewDpsScreen(dpPartnerName);
        clickAddDpButton();
        addDpDialog.fillForm(dpParams);
    }

    public void openViewDpsScreen(String dpPartnerName)
    {
        dpPartnersTable.filterByColumn( "name", dpPartnerName);
        dpPartnersTable.clickActionButton(1, "View DPs");
    }

    public void openViewUsersScreen(String dpName)
    {
        dpTable.filterByColumn( "name", dpName);
        dpTable.clickActionButton(1, "View DPs");
    }

    public void addDpUser(String dpName, DpUser dpUserParams)
    {
        openViewUsersScreen(dpName);
        clickAddDpUserButton();
        addDpUserDialog.fillForm(dpUserParams);
    }

    public void editDpUser(String username, DpUser newDpuserParams)
    {
        dpUsersTable.filterByColumn(DpUsersTable.COLUMN_USERNAME, username);
        dpUsersTable.clickActionButton(1, DpUsersTable.ACTION_EDIT);
        editDpUserDialog.fillForm(newDpuserParams);
    }

    public void editDistributionPoint(String dpName, Dp newDpParams)
    {
        dpTable.filterByColumn("name", dpName);
        dpTable.clickActionButton(1, "edit");
        editDpDialog.fillForm(newDpParams);
    }

    public void verifyDpPartnerParams(DpPartner expectedDpPartnerParams)
    {
        dpPartnersTable.filterByColumn( "name", expectedDpPartnerParams.getName());
        DpPartner actualDpPartner = dpPartnersTable.readEntity(1);
        assertThatIfExpectedValueNotNull("DP Partner ID", expectedDpPartnerParams.getId(), actualDpPartner.getId(), equalTo(expectedDpPartnerParams.getId()));
        assertThatIfExpectedValueNotNull("DP Partner Name", expectedDpPartnerParams.getName(), actualDpPartner.getName(), equalTo(expectedDpPartnerParams.getName()));
        assertThatIfExpectedValueNotNull("DP Partner POC Name", expectedDpPartnerParams.getPocName(), actualDpPartner.getPocName(), equalTo(expectedDpPartnerParams.getPocName()));
        assertThatIfExpectedValueNotNull("DP Partner POC No.", expectedDpPartnerParams.getPocTel(), actualDpPartner.getPocTel(), equalTo(expectedDpPartnerParams.getPocTel()));
        assertThatIfExpectedValueNotNull("DP Partner POC Email", expectedDpPartnerParams.getPocEmail(), actualDpPartner.getPocEmail(), equalTo(expectedDpPartnerParams.getPocEmail()));
        assertThatIfExpectedValueNotNull("DP Partner POC Restrictions", expectedDpPartnerParams.getRestrictions(), actualDpPartner.getRestrictions(), equalTo(expectedDpPartnerParams.getRestrictions()));
        expectedDpPartnerParams.setId(actualDpPartner.getId());
    }

    public void verifyDpParams(Dp expectedDpParams)
    {
        dpTable.filterByColumn( "name", expectedDpParams.getName());
        Dp actualDpParams = dpTable.readEntity(1);
        assertThatIfExpectedValueNotNull("DP ID", expectedDpParams.getId(), actualDpParams.getId(), equalTo(expectedDpParams.getId()));
        assertThatIfExpectedValueNotNull("DP Name", expectedDpParams.getName(), actualDpParams.getName(), equalTo(expectedDpParams.getName()));
        assertThatIfExpectedValueNotNull("DP Short Name", expectedDpParams.getShortName(), actualDpParams.getShortName(), equalTo(expectedDpParams.getShortName()));
        assertThatIfExpectedValueNotNull("DP Hub", expectedDpParams.getHub(), actualDpParams.getHub(), equalTo(expectedDpParams.getHub()));
        assertThatIfExpectedValueNotNull("DP Address", expectedDpParams.getAddress(), actualDpParams.getAddress(), equalTo(expectedDpParams.getAddress()));
        assertThatIfExpectedValueNotNull("DP Directions", expectedDpParams.getDirections(), actualDpParams.getDirections(), equalTo(expectedDpParams.getDirections()));
        assertThatIfExpectedValueNotNull("DP Activity", expectedDpParams.getActivity(), actualDpParams.getDirections(), equalTo(expectedDpParams.getActivity()));
        expectedDpParams.setId(actualDpParams.getId());
    }

    public void verifyDpUserParams(DpUser expectedDpUserParams)
    {
        dpUsersTable.filterByColumn( DpUsersTable.COLUMN_USERNAME, expectedDpUserParams.getClientId());
        DpUser actualDpUserParams = dpUsersTable.readEntity(1);

        assertThatIfExpectedValueNotNull("DP User Username", expectedDpUserParams.getClientId(), actualDpUserParams.getClientId(), equalTo(expectedDpUserParams.getClientId()));
        assertThatIfExpectedValueNotNull("DP User First Name", expectedDpUserParams.getFirstName(), actualDpUserParams.getFirstName(), equalTo(expectedDpUserParams.getFirstName()));
        assertThatIfExpectedValueNotNull("DP User Last Name", expectedDpUserParams.getLastName(), actualDpUserParams.getLastName(), equalTo(expectedDpUserParams.getLastName()));
        assertThatIfExpectedValueNotNull("DP User Email", expectedDpUserParams.getEmailId(), actualDpUserParams.getEmailId(), equalTo(expectedDpUserParams.getEmailId()));
        assertThatIfExpectedValueNotNull("DP User Contact No", expectedDpUserParams.getContactNo(), actualDpUserParams.getContactNo(), equalTo(expectedDpUserParams.getContactNo()));
    }

    public void verifyDownloadedFileContent(List<DpPartner> expectedDpPartners)
    {
        String fileName = getLatestDownloadedFilename(CSV_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<DpPartner> actualDpPartners = DpPartner.fromCsvFile(DpPartner.class, pathName, true);

        assertThat("Unexpected number of lines in CSV file", actualDpPartners.size(), greaterThanOrEqualTo(expectedDpPartners.size()));

        Map<Long, DpPartner> actualMap = actualDpPartners.stream().collect(Collectors.toMap(
                DpPartner::getId,
                params -> params,
                (params1, params2) -> params1
        ));

        for(DpPartner expectedDpPartner : expectedDpPartners)
        {
            DpPartner actualDpPartner = actualMap.get(expectedDpPartner.getId());
            assertEquals("DP Partner ID", expectedDpPartner.getId(), actualDpPartner.getId());
            assertEquals("DP Partner Name", expectedDpPartner.getName(), actualDpPartner.getName());
            assertEquals("POC Name", expectedDpPartner.getPocName(), actualDpPartner.getPocName());
            assertEquals("POC No.", expectedDpPartner.getPocTel(), actualDpPartner.getPocTel());
            assertEquals("POC Email", Optional.ofNullable(expectedDpPartner.getPocEmail()).orElse("-"), actualDpPartner.getPocEmail());
            assertEquals("Restrictions", Optional.ofNullable(expectedDpPartner.getRestrictions()).orElse("-"), actualDpPartner.getRestrictions());
        }
    }

    public void verifyDownloadedDpFileContent(List<Dp> expectedDpParams)
    {
        String fileName = getLatestDownloadedFilename(CSV_DPS_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<Dp> actualDpParams = Dp.fromCsvFile(Dp.class, pathName, true);

        assertThat("Unexpected number of lines in CSV file", actualDpParams.size(), greaterThanOrEqualTo(expectedDpParams.size()));

        Map<Long, Dp> actualMap = actualDpParams.stream().collect(Collectors.toMap(
                Dp::getId,
                params -> params,
                (params1, params2) -> params1
        ));

        for(Dp expectedDp : expectedDpParams)
        {
            Dp actualDp = actualMap.get(expectedDp.getId());

            assertEquals("DP ID", expectedDp.getId(), actualDp.getId());
            assertEquals("DP Name", expectedDp.getName(), actualDp.getName());
            assertEquals("DP Short Name", expectedDp.getShortName(), actualDp.getShortName());
            assertEquals("DP Hub", Optional.ofNullable(expectedDp.getHub()).orElse(""), actualDp.getHub());
            assertEquals("DP Address", expectedDp.getAddress(), actualDp.getAddress());
            assertEquals("DP Directions", expectedDp.getDirections(), actualDp.getDirections());
            assertEquals("DP Activity", expectedDp.getActivity(), actualDp.getActivity());
        }
    }

    public void verifyDownloadedDpUsersFileContent(List<DpUser> expectedDpUsersParams)
    {
        String fileName = getLatestDownloadedFilename(CSV_DP_USERS_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<DpUser> actualDpUsersParams = DpUser.fromCsvFile(DpUser.class, pathName, true);

        assertThat("Unexpected number of lines in CSV file", actualDpUsersParams.size(), greaterThanOrEqualTo(expectedDpUsersParams.size()));

        Map<String, DpUser> actualMap = actualDpUsersParams.stream().collect(Collectors.toMap(
                DpUser::getClientId,
                params -> params
        ));

        for(DpUser expectedDpUserParams : expectedDpUsersParams)
        {
            DpUser actualDpUser = actualMap.get(expectedDpUserParams.getClientId());

            assertThat("DP with Username " + expectedDpUserParams.getClientId(), actualDpUser, notNullValue());
            assertEquals("DP User First Name", expectedDpUserParams.getFirstName(), actualDpUser.getFirstName());
            assertEquals("DP User Last Name", expectedDpUserParams.getLastName(), actualDpUser.getLastName());
            assertEquals("DP User Email", expectedDpUserParams.getEmailId(), actualDpUser.getEmailId());
            assertEquals("DP User Contact No.", expectedDpUserParams.getContactNo(), actualDpUser.getContactNo());
        }
    }

    /**
     * Accessor for Add Partner dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class AddPartnerDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        static final String DIALOG_TITLE = "Add Partner";
        static final String LOCATOR_FIELD_PARTNER_NAME = "Partner Name";
        static final String LOCATOR_FIELD_POC_NAME = "POC Name";
        static final String LOCATOR_FIELD_POC_NO = "POC No.";
        static final String LOCATOR_FIELD_POC_EMAIL = "POC Email";
        static final String LOCATOR_FIELD_RESTRICTIONS = "Restrictions";
        static final String LOCATOR_BUTTON_SUBMIT = "Submit";

        public AddPartnerDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }

        public AddPartnerDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
            return this;
        }

        public AddPartnerDialog setPartnerName(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_PARTNER_NAME, value);
            return this;
        }

        public AddPartnerDialog setPocName(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_POC_NAME, value);
            return this;
        }

        public AddPartnerDialog setPocNo(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_POC_NO, value);
            return this;
        }

        public AddPartnerDialog setPocEmail(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_POC_EMAIL, value);
            return this;
        }

        public AddPartnerDialog setRestrictions(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_RESTRICTIONS, value);
            return this;
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
            waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
        }

        public void fillForm(DpPartner dpPartner)
        {
            waitUntilVisible();
            String value = dpPartner.getName();
            if (StringUtils.isNotBlank(value))
            {
                setPartnerName(value);
            }
            value = dpPartner.getPocName();
            if (StringUtils.isNotBlank(value))
            {
                setPocName(value);
            }
            value = dpPartner.getPocTel();
            if (StringUtils.isNotBlank(value))
            {
                setPocNo(value);
            }
            value = dpPartner.getPocEmail();
            if (StringUtils.isNotBlank(value))
            {
                setPocEmail(value);
            }
            value = dpPartner.getRestrictions();
            if (StringUtils.isNotBlank(value))
            {
                setRestrictions(value);
            }
            submitForm();
        }
    }

    /**
     * Accessor for Edit Partner dialog
     */
    public static class EditPartnerDialog extends AddPartnerDialog
    {
        static final String DIALOG_TITLE = "Edit Partner";
        static final String LOCATOR_BUTTON_SUBMIT = "Submit Changes";

        public EditPartnerDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }
    }

    /**
     * Accessor for DP Partners table
     */
    public static class DpPartnersTable extends MdVirtualRepeatTable<DpPartner>
    {
        public DpPartnersTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("id", "id")
                    .put("name", "name")
                    .put("pocName", "poc_name")
                    .put("pocTel", "poc_tel")
                    .put("pocEmail", "poc_email")
                    .put("restrictions", "restrictions")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of("edit", "Edit", "View DPs", "View DPs"));
            setEntityClass(DpPartner.class);
        }
    }

    /**
     * Accessor for DP table
     */
    public static class DpTable extends MdVirtualRepeatTable<Dp>
    {
        public DpTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("id", "dpms_id")
                    .put("name", "name")
                    .put("shortName", "short_name")
                    .put("hub", "hub")
                    .put("address", "address")
                    .put("directions", "directions")
                    .put("activity", "activity")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of("edit", "Edit", "View DPs", "View DPs"));
            setEntityClass(Dp.class);
        }
    }

    /**
     * Accessor for Add Distribution Point dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class AddDpDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        static final String DIALOG_TITLE = "Add Distribution Point";
        static final String LOCATOR_FIELD_NAME = "Name *";
        static final String LOCATOR_FIELD_SHORT_NAME = "Shortname";
        static final String LOCATOR_FIELD_TYPE = "type";
        static final String LOCATOR_FIELD_SERVICE = "service";
        static final String LOCATOR_FIELD_CAN_SHIPPER_LODGE_IN = "can-shipper-lodge-in?";
        static final String LOCATOR_FIELD_CAN_CUSTOMER_COLLECT = "can-customer-collect?";
        static final String LOCATOR_FIELD_MAX_CAP = "Max Cap *";
        static final String LOCATOR_FIELD_CAP_BUFFER = "Cap Buffer *";
        static final String LOCATOR_FIELD_CONTACT_NO = "Contact No. *";
        static final String LOCATOR_FIELD_ADDRESS_LINE_1 = "Address Line 1 *";
        static final String LOCATOR_FIELD_ADDRESS_LINE_2 = "Address Line 2 *";
        static final String LOCATOR_FIELD_UNIT_NO = "Unit No. *";
        static final String LOCATOR_FIELD_FLOOR_NO = "Floor No. *";
        static final String LOCATOR_FIELD_CITY = "City *";
        static final String LOCATOR_FIELD_COUNTRY = "Country *";
        static final String LOCATOR_FIELD_POSTCODE = "Postcode *";
        static final String LOCATOR_FIELD_DIRECTIONS = "Directions";
        static final String LOCATOR_BUTTON_SUBMIT = "Submit";

        public AddDpDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }

        public AddDpDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
            return this;
        }

        public AddDpDialog setName(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_NAME, value);
            return this;
        }

        public AddDpDialog setShortName(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_SHORT_NAME, value);
            return this;
        }

        public AddDpDialog setType(String value)
        {
            selectValueFromMdSelectById(LOCATOR_FIELD_TYPE, value);
            return this;
        }

        public AddDpDialog setService(String value)
        {
            selectValueFromMdSelectById(LOCATOR_FIELD_SERVICE, value);
            return this;
        }

        public AddDpDialog setCanShipperLodgeIn(Boolean value)
        {
            toggleMdSwitchById(LOCATOR_FIELD_CAN_SHIPPER_LODGE_IN, value);
            return this;
        }

        public AddDpDialog setCanCustomerCollect(Boolean value)
        {
            toggleMdSwitchById(LOCATOR_FIELD_CAN_CUSTOMER_COLLECT, value);
            return this;
        }

        public AddDpDialog setMaxCap(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_MAX_CAP, value);
            return this;
        }

        public AddDpDialog setCapBuffer(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_CAP_BUFFER, value);
            return this;
        }

        public AddDpDialog setContactNo(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_CONTACT_NO, value);
            return this;
        }

        public AddDpDialog setAddressLine1(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_ADDRESS_LINE_1, value);
            return this;
        }

        public AddDpDialog setAddressLine2(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_ADDRESS_LINE_2, value);
            return this;
        }

        public AddDpDialog setUnitNo(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_UNIT_NO, value);
            return this;
        }

        public AddDpDialog setFloorNo(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_FLOOR_NO, value);
            return this;
        }

        public AddDpDialog setCity(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_CITY, value);
            return this;
        }

        public AddDpDialog setCountry(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_COUNTRY, value);
            return this;
        }

        public AddDpDialog setPostcode(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_POSTCODE, value);
            return this;
        }

        public AddDpDialog setDirections(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_DIRECTIONS, value);
            return this;
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
            waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
        }

        public void fillForm(Dp dpParams)
        {
            waitUntilVisible();
            String value = dpParams.getName();
            if (StringUtils.isNotBlank(value))
            {
                setName(value);
            }
            value = dpParams.getShortName();
            if (StringUtils.isNotBlank(value))
            {
                setShortName(value);
            }
            value = dpParams.getType();
            if (StringUtils.isNotBlank(value))
            {
                setType(value);
            }
            value = dpParams.getService();
            if (StringUtils.isNotBlank(value))
            {
                setService(value);
            }
            if (dpParams.getCanShipperLodgeIn() != null)
            {
                setCanShipperLodgeIn(dpParams.getCanShipperLodgeIn());
            }
            if (dpParams.getCanCustomerCollect() != null)
            {
                setCanCustomerCollect(dpParams.getCanCustomerCollect());
            }
            value = dpParams.getMaxCap();
            if (StringUtils.isNotBlank(value))
            {
                setMaxCap(value);
            }
            value = dpParams.getCapBuffer();
            if (StringUtils.isNotBlank(value))
            {
                setCapBuffer(value);
            }
            value = dpParams.getContactNo();
            if (StringUtils.isNotBlank(value))
            {
                setContactNo(value);
            }
            value = dpParams.getAddress1();
            if (StringUtils.isNotBlank(value))
            {
                setAddressLine1(value);
            }
            value = dpParams.getAddress2();
            if (StringUtils.isNotBlank(value))
            {
                setAddressLine2(value);
            }
            value = dpParams.getUnitNo();
            if (StringUtils.isNotBlank(value))
            {
                setUnitNo(value);
            }
            value = dpParams.getFloorNo();
            if (StringUtils.isNotBlank(value))
            {
                setFloorNo(value);
            }
            value = dpParams.getCity();
            if (StringUtils.isNotBlank(value))
            {
                setCity(value);
            }
            value = dpParams.getCountry();
            //Country is removed from page.
            /*if (StringUtils.isNotBlank(value))
            {
                setCountry(value);
            }*/
            value = dpParams.getPostcode();
            if (StringUtils.isNotBlank(value))
            {
                setPostcode(value);
            }
            value = dpParams.getDirections();
            if (StringUtils.isNotBlank(value))
            {
                setDirections(value);
            }
            submitForm();
        }
    }

    /**
     * Accessor for Edit Distribution Point dialog
     */
    public static class EditDpDialog extends AddDpDialog
    {
        static final String DIALOG_TITLE = "Edit Distribution Point";
        static final String LOCATOR_BUTTON_SUBMIT = "Submit Changes";

        public EditDpDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }
    }

    /**
     * Accessor for Add User dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class AddDpUserDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        static final String DIALOG_TITLE = "Add User";
        static final String LOCATOR_FIELD_FIRST_NAME = "First Name";
        static final String LOCATOR_FIELD_LAST_NAME = "Last Name";
        static final String LOCATOR_FIELD_CONTACT_NO = "Contact No.";
        static final String LOCATOR_FIELD_EMAIL = "Email";
        static final String LOCATOR_FIELD_USERNAME = "Username";
        static final String LOCATOR_FIELD_PASSWORD = "Password";
        static final String LOCATOR_BUTTON_SUBMIT = "Submit";

        public AddDpUserDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }

        public AddDpUserDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
            return this;
        }

        public AddDpUserDialog setFirstName(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_FIRST_NAME, value);
            return this;
        }

        public AddDpUserDialog setLastName(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_LAST_NAME, value);
            return this;
        }

        public AddDpUserDialog setContactNo(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_CONTACT_NO, value);
            return this;
        }

        public AddDpUserDialog setEmail(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_EMAIL, value);
            return this;
        }

        public AddDpUserDialog setUsername(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_USERNAME, value);
            return this;
        }

        public AddDpUserDialog setPassword(String value)
        {
            sendKeysByAriaLabel(LOCATOR_FIELD_PASSWORD, value);
            return this;
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
            waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
        }

        public void fillForm(DpUser dpUser)
        {
            waitUntilVisible();
            String value = dpUser.getFirstName();
            if (StringUtils.isNotBlank(value))
            {
                setFirstName(value);
            }
            value = dpUser.getLastName();
            if (StringUtils.isNotBlank(value))
            {
                setLastName(value);
            }
            value = dpUser.getContactNo();
            if (StringUtils.isNotBlank(value))
            {
                setContactNo(value);
            }
            value = dpUser.getEmailId();
            if (StringUtils.isNotBlank(value))
            {
                setEmail(value);
            }
            value = dpUser.getClientId();
            if (StringUtils.isNotBlank(value))
            {
                setUsername(value);
            }
            value = dpUser.getClientSecret();
            if (StringUtils.isNotBlank(value))
            {
                setPassword(value);
            }
            submitForm();
        }
    }

    /**
     * Accessor for Edit User dialog
     */
    public static class EditDpUserDialog extends AddDpUserDialog
    {
        static final String DIALOG_TITLE = "Edit User";
        static final String LOCATOR_BUTTON_SUBMIT = "Submit";

        public EditDpUserDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }
    }

    /**
     * Accessor for DP Users table
     */
    public static class DpUsersTable extends MdVirtualRepeatTable<DpUser>
    {
        public static final String COLUMN_USERNAME = "clientId";
        public static final String COLUMN_FIRST_NAME = "firstName";
        public static final String COLUMN_LAST_NAME = "lastName";
        public static final String COLUMN_EMAIL = "emailId";
        public static final String COLUMN_CONTACT_NO = "contactNo";
        public static final String ACTION_EDIT = "edit";

        public DpUsersTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.of(
                    COLUMN_USERNAME, "username",
                    COLUMN_FIRST_NAME, "first_name",
                    COLUMN_LAST_NAME, "last_name",
                    COLUMN_EMAIL, "email",
                    COLUMN_CONTACT_NO, "contact_no"
            ));
            setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit"));
            setEntityClass(DpUser.class);
        }
    }
}
