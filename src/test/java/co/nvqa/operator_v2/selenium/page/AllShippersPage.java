package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Shipper;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import static co.nvqa.commons.utils.StandardTestUtils.retryIfRuntimeExceptionOccurred;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AllShippersPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "shipper in getTableData()";

    public static final String COLUMN_CLASS_DATA_ID = "id";
    public static final String COLUMN_CLASS_DATA_NAME = "name";
    public static final String COLUMN_CLASS_DATA_EMAIL = "email";
    public static final String COLUMN_CLASS_DATA_INDUSTRY = "_industry";
    public static final String COLUMN_CLASS_DATA_LIAISON_EMAIL = "liaison_email";
    public static final String COLUMN_CLASS_DATA_CONTACT = "contact";
    public static final String COLUMN_CLASS_DATA_SALES_PERSON = "sales_person";
    public static final String COLUMN_CLASS_DATA_PRICING_TEMPLATE_NAME = "_template_name";
    public static final String COLUMN_CLASS_DATA_STATUS = "_status";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_LOGIN = "container.shippers.shipper-dashboard-login";

    private final AllShippersCreateEditPage allShippersCreateEditPage;

    public AllShippersPage(WebDriver webDriver)
    {
        super(webDriver);
        allShippersCreateEditPage = new AllShippersCreateEditPage(webDriver);
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
        allShippersCreateEditPage.createNewShipper(shipper);
    }

    public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper)
    {
        verifyShipperInfoIsCorrect(shipper.getName(), shipper);
    }

    public void loginToShipperDashboard(Shipper shipper)
    {
        retryIfRuntimeExceptionOccurred(() -> {
            searchTableByName(shipper.getName());
        });
        Assert.assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_LOGIN);
        waitUntilNewWindowOrTabOpened();
        switchToOtherWindowAndWaitWhileLoading("/orders/management/");
    }

    public void setPickupAddressesAsMilkrun(Shipper shipper){
        searchTableByName(shipper.getName());
        Assert.assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        shipper.setLegacyId(actualLegacyId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.setPickupAddressesAsMilkrun(shipper);
    }

    public void removeMilkrunReservarion(Shipper shipper, int addressIndex, int milkrunReservationIndex){
        searchTableByName(shipper.getName());
        Assert.assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        shipper.setLegacyId(actualLegacyId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.removeMilkrunReservarion(shipper, addressIndex, milkrunReservationIndex);
    }

    public void removeAllMilkrunReservarions(Shipper shipper, int addressIndex){
        searchTableByName(shipper.getName());
        Assert.assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        shipper.setLegacyId(actualLegacyId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.removeAllMilkrunReservations(shipper, addressIndex);
    }

    public void verifyShipperInfoIsCorrect(String shipperNameKeyword, Shipper shipper)
    {
        searchTableByName(shipperNameKeyword);
        Assert.assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());

        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        String actualName = getTextOnTable(1, COLUMN_CLASS_DATA_NAME);
        String actualEmail = getTextOnTable(1, COLUMN_CLASS_DATA_EMAIL);
        String actualIndustry = getTextOnTable(1, COLUMN_CLASS_DATA_INDUSTRY);
        String actualLiaisonEmail = getTextOnTable(1, COLUMN_CLASS_DATA_LIAISON_EMAIL);
        String actualContact = getTextOnTable(1, COLUMN_CLASS_DATA_CONTACT);
        String actualSalesPerson = getTextOnTable(1, COLUMN_CLASS_DATA_SALES_PERSON);
        String actualStatus = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);

        switch (actualStatus)
        {
            case "container.shippers.active":
                actualStatus = "Active";
                break;
            case "container.shippers.inactive":
                actualStatus = "Inactive";
                break;
        }

        shipper.setLegacyId(actualLegacyId);

        Assert.assertEquals("Name", shipper.getName(), actualName);
        Assert.assertEquals("Email", shipper.getEmail(), actualEmail);
        Assert.assertEquals("Industry", shipper.getIndustryName(), actualIndustry);
        Assert.assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualLiaisonEmail);
        Assert.assertEquals("Contact", shipper.getContact(), actualContact);
        Assert.assertEquals("Sales Person", shipper.getSalesPerson().split("-")[0], actualSalesPerson);
        Assert.assertEquals("Expected Status = Inactive", convertBooleanToString(shipper.getActive(), "Active", "Inactive"), actualStatus);

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.verifyNewShipperIsCreatedSuccessfully(shipper);
    }

    public void updateShipper(Shipper oldShipper, Shipper updatedShipper)
    {
        searchTableByNameAndGoToEditPage(oldShipper);
        allShippersCreateEditPage.updateShipper(updatedShipper);
    }

    public void verifyShipperIsUpdatedSuccessfully(Shipper oldShipper, Shipper shipper)
    {
        verifyShipperInfoIsCorrect(oldShipper.getName(), shipper);
    }

    public void verifyShipperIsDeletedSuccessfully(Shipper shipper)
    {
        searchTableByName(shipper.getShortName());
        Assert.assertTrue("Table should be empty.", isTableEmpty());
    }

    public void enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(Shipper shipper, Address address, Reservation reservation)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(shipper, address, reservation);
    }

    public void updateShipperLabelPrinterSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.updateShipperLabelPrinterSettings(shipper);
    }

    public void verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(shipper);
    }

    public void updateShipperDistributionPointSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.updateShipperDistributionPointSettings(shipper);
    }

    public void verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(shipper);
    }

    public void updateShipperReturnsSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.updateShipperReturnsSettings(shipper);
    }

    public void verifyShipperReturnsSettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.verifyShipperReturnsSettingsIsUpdatedSuccessfully(shipper);
    }

    public void updateShipperQoo10Settings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.updateShipperQoo10Settings(shipper);
    }

    public void verifyShipperQoo10SettingsIsUpdatedSuccessfully(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.verifyShipperQoo10SettingsIsUpdatedSuccessfully(shipper);
    }

    public void updateShipperShopifySettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.updateShipperShopifySettings(shipper);
    }

    public void verifyShipperShopifySettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.verifyShipperShopifySettingsIsUpdatedSuccessfully(shipper);
    }

    public void updateShipperMagentoSettings(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.updateShipperMagentoSettings(shipper);
    }

    public void verifyShipperMagentoSettingsIsUpdatedSuccessfuly(Shipper shipper)
    {
        searchTableByNameAndGoToEditPage(shipper);
        allShippersCreateEditPage.verifyShipperMagentoSettingsIsUpdatedSuccessfully(shipper);
    }

    public void searchTableByNameAndGoToEditPage(Shipper shipper)
    {
        searchTableByName(shipper.getName());
        Assert.assertFalse("Table is empty. Cannot enable Auto-Reservation for shipper with Legacy ID = " + shipper.getLegacyId(), isTableEmpty());
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
