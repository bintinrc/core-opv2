package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.DpPartner;
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
    private static final String CSV_FILENAME_PATTERN = "dp-partners";
    private static final String LOCATOR_BUTTON_ADD_PARTNER = "Add Partner";
    private static final String LOCATOR_BUTTON_DOWNLOAD_CSV_FILE = "Download CSV File";

    private AddPartnerDialog addPartnerDialog;
    private DpPartnersTable dpPartnersTable;

    public DpAdministrationPage(WebDriver webDriver)
    {
        super(webDriver);
        addPartnerDialog = new AddPartnerDialog(webDriver);
        dpPartnersTable = new DpPartnersTable(webDriver);
    }

    public DpPartnersTable dpPartnersTable()
    {
        return dpPartnersTable;
    }

    public void clickAddPartnerButton()
    {
        clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_PARTNER);
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByName(LOCATOR_BUTTON_DOWNLOAD_CSV_FILE);
    }

    public void addParner(DpPartner dpPartner)
    {
        clickAddPartnerButton();
        addPartnerDialog.fillForm(dpPartner);
    }

    public void verifyDpPartnerParams(DpPartner expectedDpPartnerParams)
    {
        dpPartnersTable.search(expectedDpPartnerParams.getName());
        DpPartner actualDpPartner = dpPartnersTable.getDpPartnerParams(1);
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

    public void verifyDownloadedFileContent(List<DpPartner> expectedDpPartners)
    {
        String fileName = CSV_FILENAME_PATTERN + ".csv";
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<DpPartner> actualDpPartners = DpPartner.fromCsvFile(DpPartner.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", expectedDpPartners.size(), greaterThanOrEqualTo(expectedDpPartners.size()));

        Map<Long, DpPartner> actualMap = actualDpPartners.stream().collect(Collectors.toMap(
                DpPartner::getId,
                params -> params
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


    public void downloadFile()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    /**
     * Accessor for Create Reservation dialog
     */
    public static class AddPartnerDialog extends OperatorV2SimplePage
    {
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
        }

        public AddPartnerDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
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
            clickNvButtonSaveByNameAndWaitUntilDone(LOCATOR_BUTTON_SUBMIT);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
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
     * Accessor for PD Partners table
     */
    public static class DpPartnersTable extends OperatorV2SimplePage
    {
        private static final String NG_REPEAT = "dpPartner in $data";
        private static final String COLUMN_CLASS_ID = "id";
        private static final String COLUMN_CLASS_NAME = "name";
        private static final String COLUMN_CLASS_POC_NAME = "poc-name";
        private static final String COLUMN_CLASS_POC_TEL = "poc-tel";
        private static final String COLUMN_CLASS_POC_EMAIL = "poc-email";
        private static final String LOCATOR_COLUMN_RESTRICTIONS = "Restrictions";

        public static final String LOCATOR_ACTION_BUTTON_EDIT = "Edit";
        public static final String LOCATOR_ACTION_BUTTON_VIEW_DPS = "View DPs";
        public static final String LOCATOR_INPUT_SEARCH_TEXT = "//input[@ng-model='searchText']";

        public DpPartnersTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public List<DpPartner> getAllDpPartnersParams()
        {
            int rowsCount = getRowsCount();
            List<DpPartner> dpPartnersParams = new ArrayList<>();
            for (int rowIndex = 1; rowIndex <= rowsCount; rowIndex++)
            {
                dpPartnersParams.add(getDpPartnerParams(rowIndex));
            }
            return dpPartnersParams;
        }

        public List<DpPartner> getFirstDpPartnersParams(int count)
        {
            int rowsCount = getRowsCount();
            count = rowsCount >= count ? count : rowsCount;
            List<DpPartner> dpPartnersParams = new ArrayList<>();
            for (int rowIndex = 1; rowIndex <= count; rowIndex++)
            {
                dpPartnersParams.add(getDpPartnerParams(rowIndex));
            }
            return dpPartnersParams;
        }

        public DpPartner getDpPartnerParams(int rowIndex)
        {
            DpPartner dpPartner = new DpPartner();
            dpPartner.setId(StringUtils.trimToNull(getId(rowIndex)));
            dpPartner.setName(StringUtils.trimToNull(getName(rowIndex)));
            dpPartner.setPocName(StringUtils.trimToNull(getPocName(rowIndex)));
            dpPartner.setPocTel(StringUtils.trimToNull(getPocNo(rowIndex)));
            dpPartner.setPocTel(StringUtils.trimToNull(getPocNo(rowIndex)));
            dpPartner.setPocEmail(StringUtils.trimToNull(getPocEmail(rowIndex)));
            dpPartner.setRestrictions(StringUtils.trimToNull(getRestrictions(rowIndex)));
            return dpPartner;
        }

        public String getId(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_ID);
        }

        public String getName(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_NAME);
        }

        public String getPocName(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_POC_NAME);
        }

        public String getPocNo(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_POC_TEL);
        }

        public String getPocEmail(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_POC_EMAIL);
        }

        public String getRestrictions(int rowNumber)
        {
            String text = getTextOnTableWithNgRepeat(rowNumber, "data-title-text", LOCATOR_COLUMN_RESTRICTIONS, NG_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        public void clickEditButton(int rowNumber)
        {
            clickActionButtonOnTableWithNgRepeat(rowNumber, LOCATOR_ACTION_BUTTON_EDIT, NG_REPEAT);
        }

        public void clickViewDpsButton(int rowNumber)
        {
            clickActionButtonOnTableWithNgRepeat(rowNumber, LOCATOR_ACTION_BUTTON_VIEW_DPS, NG_REPEAT);
        }

        public int getRowsCount()
        {
            return getRowsCountOfTableWithNgRepeat(NG_REPEAT);
        }

        public DpPartnersTable search(String searchText)
        {
            sendKeys(LOCATOR_INPUT_SEARCH_TEXT, searchText);
            return this;
        }
    }
}
