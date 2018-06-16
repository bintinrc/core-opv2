package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
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
        dpPartnersTable.filterByColumn( "name", dpPartnerName);
        dpPartnersTable.clickActionButton(1, "View DPs");
        clickAddDpButton();
        addDpDialog.fillForm(dpParams);
    }

    public void addDpUser(String dpName, DpUser dpUserParams)
    {
        dpTable.filterByColumn( "name", dpName);
        dpTable.clickActionButton(1, "View DPs");
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
        if (expectedDpPartnerParams.getId() != null)
        {
            Assert.assertThat("DP Partner ID", actualDpPartner.getId(), Matchers.equalTo(expectedDpPartnerParams.getId()));
        }
        if (expectedDpPartnerParams.getName() != null)
        {
            Assert.assertThat("DP Partner Name", actualDpPartner.getName(), Matchers.equalTo(expectedDpPartnerParams.getName()));
        }
        if (expectedDpPartnerParams.getPocName() != null)
        {
            Assert.assertThat("DP Partner POC Name", actualDpPartner.getPocName(), Matchers.equalTo(expectedDpPartnerParams.getPocName()));
        }
        if (expectedDpPartnerParams.getPocTel() != null)
        {
            Assert.assertThat("DP Partner POC No.", actualDpPartner.getPocTel(), Matchers.equalTo(expectedDpPartnerParams.getPocTel()));
        }
        if (expectedDpPartnerParams.getPocEmail() != null)
        {
            Assert.assertThat("DP Partner POC Email", actualDpPartner.getPocEmail(), Matchers.equalTo(expectedDpPartnerParams.getPocEmail()));
        }
        if (expectedDpPartnerParams.getRestrictions() != null)
        {
            Assert.assertThat("DP Partner Restrictions", actualDpPartner.getRestrictions(), Matchers.equalTo(expectedDpPartnerParams.getRestrictions()));
        }
        expectedDpPartnerParams.setId(actualDpPartner.getId());
    }

    public void verifyDpParams(Dp expectedDpParams)
    {
        dpTable.filterByColumn( "name", expectedDpParams.getName());
        Dp actualDpParams = dpTable.readEntity(1);
        if (expectedDpParams.getId() != null)
        {
            Assert.assertThat("DP ID", actualDpParams.getId(), Matchers.equalTo(expectedDpParams.getId()));
        }
        if (expectedDpParams.getName() != null)
        {
            Assert.assertThat("DP Name", actualDpParams.getName(), Matchers.equalTo(expectedDpParams.getName()));
        }
        if (expectedDpParams.getShortname() != null)
        {
            Assert.assertThat("DP Short Name", actualDpParams.getShortname(), Matchers.equalTo(expectedDpParams.getShortname()));
        }
        if (expectedDpParams.getHub() != null)
        {
            Assert.assertThat("DP Hub", actualDpParams.getHub(), Matchers.equalTo(expectedDpParams.getHub()));
        }
        if (expectedDpParams.getAddress() != null)
        {
            Assert.assertThat("DP Address", actualDpParams.getAddress(), Matchers.equalTo(expectedDpParams.getAddress()));
        }
        if (expectedDpParams.getDirections() != null)
        {
            Assert.assertThat("DP Directions", actualDpParams.getDirections(), Matchers.equalTo(expectedDpParams.getDirections()));
        }
        if (expectedDpParams.getActivity() != null)
        {
            Assert.assertThat("DP Activity", actualDpParams.getActivity(), Matchers.equalTo(expectedDpParams.getActivity()));
        }
        expectedDpParams.setId(actualDpParams.getId());
    }

    public void verifyDpUserParams(DpUser expectedDpUserParams)
    {
        dpUsersTable.filterByColumn( "username", expectedDpUserParams.getUsername());
        DpUser actualDpUserParams = dpUsersTable.readEntity(1);
        if (expectedDpUserParams.getId() != null)
        {
            Assert.assertThat("DP User ID", actualDpUserParams.getId(), Matchers.equalTo(expectedDpUserParams.getId()));
        }
        if (expectedDpUserParams.getUsername() != null)
        {
            Assert.assertThat("DP User Username", actualDpUserParams.getUsername(), Matchers.equalTo(expectedDpUserParams.getUsername()));
        }
        if (expectedDpUserParams.getFirstName() != null)
        {
            Assert.assertThat("DP User First Name", actualDpUserParams.getFirstName(), Matchers.equalTo(expectedDpUserParams.getFirstName()));
        }
        if (expectedDpUserParams.getLastName() != null)
        {
            Assert.assertThat("DP User Last Name", actualDpUserParams.getLastName(), Matchers.equalTo(expectedDpUserParams.getLastName()));
        }
        if (expectedDpUserParams.getEmail() != null)
        {
            Assert.assertThat("DP User Email", actualDpUserParams.getEmail(), Matchers.equalTo(expectedDpUserParams.getEmail()));
        }
        if (expectedDpUserParams.getContactNo() != null)
        {
            Assert.assertThat("DP User Contact No", actualDpUserParams.getContactNo(), Matchers.equalTo(expectedDpUserParams.getContactNo()));
        }
    }

    public void verifyDownloadedFileContent(List<DpPartner> expectedDpPartners)
    {
        String fileName = getLatestDownloadedFilename(CSV_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<DpPartner> actualDpPartners = DpPartner.fromCsvFile(DpPartner.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualDpPartners.size(), greaterThanOrEqualTo(expectedDpPartners.size()));

        Map<Long, DpPartner> actualMap = actualDpPartners.stream().collect(Collectors.toMap(
                DpPartner::getId,
                params -> params,
                (params1, params2) -> params1
        ));

        for (DpPartner expectedDpPartner : expectedDpPartners)
        {
            DpPartner actualDpPartner = actualMap.get(expectedDpPartner.getId());

            Assert.assertThat("DP Partner with Id " + expectedDpPartner.getId(), actualDpPartner, notNullValue());
            Assert.assertEquals("DP Partner Name", expectedDpPartner.getName(), actualDpPartner.getName());
            Assert.assertEquals("POC Name", expectedDpPartner.getPocName(), actualDpPartner.getPocName());
            Assert.assertEquals("POC No.", expectedDpPartner.getPocTel(), actualDpPartner.getPocTel());
            Assert.assertEquals("POC Email", expectedDpPartner.getPocEmail(), actualDpPartner.getPocEmail());
            Assert.assertEquals("Restrictions", expectedDpPartner.getRestrictions(), actualDpPartner.getRestrictions());
        }
    }

    public void verifyDownloadedDpFileContent(List<Dp> expectedDpParams)
    {
        String fileName = getLatestDownloadedFilename(CSV_DPS_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<Dp> actualDpParams = Dp.fromCsvFile(Dp.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualDpParams.size(), greaterThanOrEqualTo(expectedDpParams.size()));

        Map<Long, Dp> actualMap = actualDpParams.stream().collect(Collectors.toMap(
                Dp::getId,
                params -> params,
                (params1, params2) -> params1
        ));

        for (Dp expectedDp : expectedDpParams)
        {
            Dp actualDp = actualMap.get(expectedDp.getId());

            Assert.assertThat("DP with Id " + expectedDp.getId(), actualDp, notNullValue());
            Assert.assertEquals("DP Name", expectedDp.getName(), actualDp.getName());
            Assert.assertEquals("DP Shortname", expectedDp.getShortname(), actualDp.getShortname());
            Assert.assertEquals("DP Hub", expectedDp.getHub(), actualDp.getHub());
            Assert.assertEquals("DP Address", expectedDp.getAddress(), actualDp.getAddress());
            Assert.assertEquals("DP Directions", expectedDp.getDirections(), actualDp.getDirections());
            Assert.assertEquals("DP Activity", expectedDp.getActivity(), actualDp.getActivity());
        }
    }

    public void verifyDownloadedDpUsersFileContent(List<DpUser> expectedDpUsersParams)
    {
        String fileName = getLatestDownloadedFilename(CSV_DP_USERS_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<DpUser> actualDpUsersParams = DpUser.fromCsvFile(DpUser.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualDpUsersParams.size(), greaterThanOrEqualTo(expectedDpUsersParams.size()));

        Map<String, DpUser> actualMap = actualDpUsersParams.stream().collect(Collectors.toMap(
                DpUser::getUsername,
                params -> params
        ));

        for (DpUser expectedDpUserParams : expectedDpUsersParams)
        {
            DpUser actualDpUser = actualMap.get(expectedDpUserParams.getUsername());

            Assert.assertThat("DP with Username " + expectedDpUserParams.getUsername(), actualDpUser, notNullValue());
            Assert.assertEquals("DP User First Name", expectedDpUserParams.getFirstName(), actualDpUser.getFirstName());
            Assert.assertEquals("DP User Last Name", expectedDpUserParams.getLastName(), actualDpUser.getLastName());
            Assert.assertEquals("DP User Email", expectedDpUserParams.getEmail(), actualDpUser.getEmail());
            Assert.assertEquals("DP User Contact No.", expectedDpUserParams.getContactNo(), actualDpUser.getContactNo());
        }
    }

    /**
     * Accessor for Add Partner dialog
     */
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
                    .put("id", "id")
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
    public static class AddDpDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        static final String DIALOG_TITLE = "Add Distribution Point";
        static final String LOCATOR_FIELD_NAME = "Name";
        static final String LOCATOR_FIELD_SHORT_NAME = "Shortname";
        static final String LOCATOR_FIELD_TYPE = "type";
        static final String LOCATOR_FIELD_SERVICE = "service";
        static final String LOCATOR_FIELD_CAN_SHIPPER_LODGE_IN = "can-shipper-lodge-in?";
        static final String LOCATOR_FIELD_CAN_CUSTOMER_COLLECT = "can-customer-collect?";
        static final String LOCATOR_FIELD_CONTACT_NO = "Contact No.";
        static final String LOCATOR_FIELD_ADDRESS_LINE_1 = "Address Line 1";
        static final String LOCATOR_FIELD_ADDRESS_LINE_2 = "Address Line 2";
        static final String LOCATOR_FIELD_CITY = "City";
        static final String LOCATOR_FIELD_COUNTRY = "Country";
        static final String LOCATOR_FIELD_POSTCODE = "Postcode";
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
            toggleMdSwithcById(LOCATOR_FIELD_CAN_SHIPPER_LODGE_IN, value);
            return this;
        }

        public AddDpDialog setCanCustomerCollect(Boolean value)
        {
            toggleMdSwithcById(LOCATOR_FIELD_CAN_CUSTOMER_COLLECT, value);
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
            value = dpParams.getShortname();
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
            value = dpParams.getCity();
            if (StringUtils.isNotBlank(value))
            {
                setCity(value);
            }
            value = dpParams.getCountry();
            if (StringUtils.isNotBlank(value))
            {
                setCountry(value);
            }
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
            value = dpUser.getEmail();
            if (StringUtils.isNotBlank(value))
            {
                setEmail(value);
            }
            value = dpUser.getUsername();
            if (StringUtils.isNotBlank(value))
            {
                setUsername(value);
            }
            value = dpUser.getPassword();
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
        public static final String COLUMN_USERNAME = "username";
        public static final String COLUMN_FIRST_NAME = "firstName";
        public static final String COLUMN_LAST_NAME = "lastName";
        public static final String COLUMN_EMAIL = "email";
        public static final String COLUMN_CONTACT_NO = "contactNo";
        public static final String ACTION_EDIT = "edit";

        public DpUsersTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.of(
                    COLUMN_USERNAME, "client-id",
                    COLUMN_FIRST_NAME, "first-name",
                    COLUMN_LAST_NAME, "last-name",
                    COLUMN_EMAIL, "email-id",
                    COLUMN_CONTACT_NO, "contact-no"
            ));
            setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit"));
            setEntityClass(DpUser.class);
        }
    }

}
