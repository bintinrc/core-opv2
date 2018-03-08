package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AllShippersPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "shipper in getTableData()";

    public static final String COLUMN_CLASS_ID = "id";
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_EMAIL = "email";
    public static final String COLUMN_CLASS_INDUSTRY = "_industry";
    public static final String COLUMN_CLASS_LIAISON_EMAIL = "liaison_email";
    public static final String COLUMN_CLASS_CONTACT = "contact";
    public static final String COLUMN_CLASS_SALES_PERSON = "sales_person";
    public static final String COLUMN_CLASS_PRICING_TEMPLATE_NAME = "_template_name";
    public static final String COLUMN_CLASS_STATUS = "_status";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";

    private CreateEditShipperPage createEditShipperPage;

    public AllShippersPage(WebDriver webDriver)
    {
        super(webDriver);
        createEditShipperPage = new CreateEditShipperPage(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading shippers...']");
    }

    public void createNewShipper(Shipper shipper)
    {
        waitUntilPageLoaded();
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        createEditShipperPage.createNewShipper(shipper);
    }

    public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper)
    {
        verifyShipperInfoIsCorrect(shipper.getName(), shipper);
    }

    public void verifyShipperInfoIsCorrect(String shipperNameKeyword, Shipper shipper)
    {
        clearCache();
        refreshPage();
        waitUntilPageLoaded();
        searchTableByName(shipperNameKeyword);
        Assert.assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());

        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_ID));
        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        String actualEmail = getTextOnTable(1, COLUMN_CLASS_EMAIL);
        String actualIndustry = getTextOnTable(1, COLUMN_CLASS_INDUSTRY);
        String actualLiaisonEmail = getTextOnTable(1, COLUMN_CLASS_LIAISON_EMAIL);
        String actualContact = getTextOnTable(1, COLUMN_CLASS_CONTACT);
        String actualSalesPerson = getTextOnTable(1, COLUMN_CLASS_SALES_PERSON);
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_STATUS);

        shipper.setLegacyId(actualLegacyId);

        Assert.assertEquals("Name", shipper.getName(), actualName);
        Assert.assertEquals("Email", shipper.getEmail(), actualEmail);
        Assert.assertEquals("Industry", shipper.getIndustryName(), actualIndustry);
        Assert.assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualLiaisonEmail);
        Assert.assertEquals("Contact", shipper.getContact(), actualContact);
        Assert.assertEquals("Sales Person", shipper.getSalesPerson().split("-")[0], actualSalesPerson);
        Assert.assertEquals("Expected Status = Inactive", convertBooleanToString(shipper.getActive(), "Active", "Inactive"), actualStatus);

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        createEditShipperPage.verifyNewShipperIsCreatedSuccessfully(shipper);
    }

    public void updateShipper(Shipper oldShipper, Shipper updatedShipper)
    {
        searchTableByName(oldShipper.getName());
        Assert.assertFalse("Table is empty. Cannot update shipper with Legacy ID = "+oldShipper.getLegacyId(), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        createEditShipperPage.updateShipper(updatedShipper);
    }

    public void verifyShipperIsUpdatedSuccessfully(Shipper oldShipper, Shipper shipper)
    {
        verifyShipperInfoIsCorrect(oldShipper.getName(), shipper);
    }

    public void verifyShipperIsDeletedSuccessfully(Shipper shipper)
    {
        clearCache();
        refreshPage();
        waitUntilPageLoaded();
        searchTableByName(shipper.getName());
        Assert.assertTrue("Table should be empty.", isTableEmpty());
    }

    public void searchTableByName(String name)
    {
        searchTableCustom1("name", name);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
