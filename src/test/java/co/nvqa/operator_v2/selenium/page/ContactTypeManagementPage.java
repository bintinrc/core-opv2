package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ContactType;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Optional;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ContactTypeManagementPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT = "contactType in $data";
    private static final String CSV_FILENAME = "contact_types.csv";

    public static final String COLUMN_DATA_TITLE_ID = "'commons.id' | translate";
    public static final String COLUMN_DATA_TITLE_NAME = "'commons.name' | translate";

    private static final String ACTION_BUTTON_EDIT = "Edit";
    private static final String ACTION_BUTTON_DELETE = "Delete";

    public ContactTypeManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(ContactType contactType)
    {
        String contactTypeName = contactType.getName();
        verifyFileDownloadedSuccessfully(CSV_FILENAME, contactTypeName);
    }

    public void createNewContactType(ContactType contactType)
    {
        clickNvIconTextButtonByName("Add Contact Type");
        sendKeysById("name", contactType.getName());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyContactTypeIsExistAndDataIsCorrect(ContactType contactType)
    {
        ContactType actualContactType = searchContactType(contactType.getName());
        contactType.setId(actualContactType.getId());
        Assert.assertEquals("Contact Type Name", contactType.getName(), actualContactType.getName());
    }

    public void updateContactType(String searchContactTypesKeyword, ContactType contactType)
    {
        searchTable(searchContactTypesKeyword);
        Assert.assertFalse(String.format("Table is empty. Contact Type with keywords = '%s' not found.", searchContactTypesKeyword), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);

        Optional.ofNullable(contactType.getName()).ifPresent(value -> sendKeysById("name", value));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void deleteContactType(String searchContactTypesKeyword)
    {
        searchTable(searchContactTypesKeyword);
        Assert.assertFalse(String.format("Table is empty. Contact Type with keywords = '%s' not found.", searchContactTypesKeyword), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        clickButtonOnMdDialogByAriaLabel("Delete");
        pause1s();
    }

    public void verifyContactTypeIsNotExistAnymore(String searchContactTypesKeyword)
    {
        searchTable(searchContactTypesKeyword);
        Assert.assertTrue(String.format("Table is not empty. Contact Type with keywords = '%s' is still listed on table.", searchContactTypesKeyword), isTableEmpty());
    }

    public ContactType searchContactType(String searchContactTypesKeyword)
    {
        searchTable(searchContactTypesKeyword);
        Assert.assertFalse(String.format("Table is empty. Contact type with keywords = '%s' not found.", searchContactTypesKeyword), isTableEmpty());

        String id = getTextOnTable(1, COLUMN_DATA_TITLE_ID);
        String actualName = getTextOnTable(1, COLUMN_DATA_TITLE_NAME);

        ContactType contactType = new ContactType();
        contactType.setId(Long.parseLong(Optional.ofNullable(id).orElse("-1")));
        contactType.setName(actualName);

        return contactType;
    }

    public void searchTable(String keyword)
    {
        super.searchTable(keyword);
        pause1s();
    }

    public boolean isTableEmpty()
    {
        return !isElementExistFast(String.format("//tr[@ng-repeat='%s'][1]", NG_REPEAT));
    }

    public String getTextOnTable(int rowNumber, String columnDataTitle)
    {
        return getTextOnTableWithNgRepeatUsingDataTitle(rowNumber, columnDataTitle, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
