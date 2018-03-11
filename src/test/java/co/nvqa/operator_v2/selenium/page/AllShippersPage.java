package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Return;
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

    public void clearBrowserCacheAndReloadPage()
    {
        clearCache();
        refreshPage();
        waitUntilPageLoaded();
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
        searchTableByNameAndGoToEditPage(oldShipper);
        createEditShipperPage.updateShipper(updatedShipper);
    }

    public void verifyShipperIsUpdatedSuccessfully(Shipper oldShipper, Shipper shipper)
    {
        verifyShipperInfoIsCorrect(oldShipper.getName(), shipper);
    }

    public void verifyShipperIsDeletedSuccessfully(Shipper shipper)
    {
        searchTableByName(shipper.getName());
        Assert.assertTrue("Table should be empty.", isTableEmpty());
    }

    public void enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(Shipper shipper, Address address, Reservation reservation)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(shipper, address, reservation);
    }

    public void updateShipperLabelPrinterSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.updateShipperLabelPrinterSettings(shipper);
    }

    public void verifyShipperLabelPrinterSettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfuly(shipper);
    }

    public void updateShipperDistributionPointSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.updateShipperDistributionPointSettings(shipper);
    }

    public void verifyShipperDistributionPointSettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfuly(shipper);
    }

    public void updateShipperReturnsSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.updateShipperReturnsSettings(shipper);
    }

    public void verifyShipperReturnsSettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.verifyShipperReturnsSettingsIsUpdatedSuccessfuly(shipper);
    }

    public void updateShipperQoo10Settings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.updateShipperQoo10Settings(shipper);
    }

    public void verifyShipperQoo10SettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.verifyShipperQoo10SettingsIsUpdatedSuccessfuly(shipper);
    }

    public void updateShipperShopifySettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.updateShipperShopifySettings(shipper);
    }

    public void verifyShipperShopifySettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.verifyShipperShopifySettingsIsUpdatedSuccessfuly(shipper);
    }

    public void updateShipperMagentoSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.updateShipperMagentoSettings(shipper);
    }

    public void verifyShipperMagentoSettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        createEditShipperPage.verifyShipperMagentoSettingsIsUpdatedSuccessfuly(shipper);
    }

    public void searchTableByNameAndGoToEditPage(Shipper shipper)
    {
        searchTableByName(shipper.getName());
        Assert.assertFalse("Table is empty. Cannot enable Auto-Reservation for shipper with Legacy ID = "+shipper.getLegacyId(), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
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
