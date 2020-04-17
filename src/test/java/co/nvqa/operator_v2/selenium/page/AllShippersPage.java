package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Shipper;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

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
    //public static final String COLUMN_CLASS_DATA_PRICING_TEMPLATE_NAME = "_template_name";
    public static final String COLUMN_CLASS_DATA_STATUS = "_status";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_LOGIN = "container.shippers.shipper-dashboard-login";
    public static final String ARIA_LABEL_CLEAR_ALL_SELECTIONS = "Clear All Selections";
    public static final String XPATH_SELECT_FILTER = "//input[@aria-label='Select Filter']";
    public static final String ARIA_LABEL_LOAD_SELECTION = "Load Selection";
    public static final String XPATH_FOR_FILTER = "//span[text()='%s']/ancestor::li";
    public static final String XPATH_FOR_INDIVIDUAL_FILTER = "//p[text()='%s']/parent::div/following-sibling::div//input";
    public static final String XPATH_FOR_COLUMNS = "//table[@class='table-body']//tr[1]/td[@class='%s']";
    public static final String XPATH_ACTIVE_FILTER = "//p[text()='Active']/parent::div/following-sibling::div//span[text()='Yes']/parent::button";
    public static final String XPATH_HIDE_BUTTON = "//div[contains(text(),'Hide')]/following-sibling::i";
    public static final String XPATH_SEARCH_TERM = "//input[@aria-label='Search term']";
    public static final String XPATH_QUICK_SEARCH_AUTOCOMPLETE_LIST = "//ul[@class='md-autocomplete-suggestions']/li[1]";

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

    public void createNewShipperWithUpdatedPricingScript(Shipper shipper)
    {
        waitUntilPageLoaded();
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        allShippersCreateEditPage.createNewShipperWithUpdatedPricingScript(shipper);
    }

    public void createNewShipperWithoutPricingScript(Shipper shipper)
    {
        waitUntilPageLoaded();
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        allShippersCreateEditPage.createNewShipperWithoutPricingScript(shipper);
    }

    public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper)
    {
        verifyShipperInfoIsCorrect(shipper.getName(), shipper);
    }

    public void loginToShipperDashboard(Shipper shipper)
    {
        retryIfRuntimeExceptionOccurred(() -> searchTableByName(shipper.getName()));
        assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_LOGIN);
        waitUntilNewWindowOrTabOpened();
        switchToOtherWindowAndWaitWhileLoading("/orders/management/");
    }

    public void setPickupAddressesAsMilkrun(Shipper shipper){
        searchTableByName(shipper.getName());
        assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        shipper.setLegacyId(actualLegacyId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.setPickupAddressesAsMilkrun(shipper);
    }

    public void removeMilkrunReservarion(Shipper shipper, int addressIndex, int milkrunReservationIndex){
        searchTableByName(shipper.getName());
        assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        shipper.setLegacyId(actualLegacyId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.removeMilkrunReservarion(shipper, addressIndex, milkrunReservationIndex);
    }

    public void removeAllMilkrunReservarions(Shipper shipper, int addressIndex){
        searchTableByName(shipper.getName());
        assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());
        Long actualLegacyId = Long.parseLong(getTextOnTable(1, COLUMN_CLASS_DATA_ID));
        shipper.setLegacyId(actualLegacyId);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        allShippersCreateEditPage.removeAllMilkrunReservations(shipper, addressIndex);
    }

    public void verifyShipperInfoIsCorrect(String shipperNameKeyword, Shipper shipper)
    {
        searchTableByName(shipperNameKeyword);
        assertFalse("Table is empty. New Shipper is not created.", isTableEmpty());

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

        assertEquals("Name", shipper.getName(), actualName);
        assertEquals("Email", shipper.getEmail(), actualEmail);
        assertEquals("Industry", shipper.getIndustryName(), actualIndustry);
        assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualLiaisonEmail);
        assertEquals("Contact", shipper.getContact(), actualContact);
        assertEquals("Sales Person", shipper.getSalesPerson().split("-")[0], actualSalesPerson);
        assertEquals("Expected Status = Inactive", convertBooleanToString(shipper.getActive(), "Active", "Inactive"), actualStatus);

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
        assertTrue("Table should be empty.", isTableEmpty());
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
        assertFalse("Table is empty. Cannot enable Auto-Reservation for shipper with Legacy ID = " + shipper.getLegacyId(), isTableEmpty());
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

    public void clearAllSelections()
    {
        pause1s();
        clickButtonByAriaLabel(ARIA_LABEL_CLEAR_ALL_SELECTIONS);
    }

    public void chooseFilter(String filter)
    {
        click(XPATH_SELECT_FILTER);
        clickf(XPATH_FOR_FILTER, filter);
    }

    public void searchByFilterWithKeyword(String filter, String keyword)
    {
        String xpathForFilter = f(XPATH_FOR_INDIVIDUAL_FILTER, filter);
        click(xpathForFilter);
        sendKeys(xpathForFilter, keyword);
        pause1s();
        sendKeysWithoutClear(xpathForFilter, Keys.RETURN);
        if(isElementVisible(XPATH_HIDE_BUTTON))
        {
            click(XPATH_HIDE_BUTTON);
        }
        clickButtonByAriaLabel(ARIA_LABEL_LOAD_SELECTION);
    }

    public void searchActiveFilter()
    {
        click(XPATH_ACTIVE_FILTER);
        clickButtonByAriaLabel(ARIA_LABEL_LOAD_SELECTION);
    }


    public void verifiesResultsOfColumn(String keyword, String column)
    {
        String columnXpath = null;
        if(column.equalsIgnoreCase("Liaison Email"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "liaison_email");
        }
        else if(column.equalsIgnoreCase("Email"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "email");
        }
        else if(column.equalsIgnoreCase("Contact"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "contact");
        }
        else if(column.equalsIgnoreCase("Status"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "_status");
        }
        else if(column.equalsIgnoreCase("Industry"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "_industry");
        }
        else if(column.equalsIgnoreCase("Salesperson"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "sales_person");
        }
        else if(column.equalsIgnoreCase("Name"))
        {
            columnXpath = f(XPATH_FOR_COLUMNS, "name");
        }
        String text = getText(columnXpath);
        assertTrue("The keyword is found on the respective column", text.toLowerCase().contains(keyword.toLowerCase()));
    }

    public void quickSearchShipper(String keyword)
    {
        moveToElementWithXpath(XPATH_SEARCH_TERM);
        sendKeys(XPATH_SEARCH_TERM, keyword);
        pause1s();
        click(XPATH_QUICK_SEARCH_AUTOCOMPLETE_LIST);
    }

    public void editShipper(Shipper shipper)
    {
        quickSearchShipper(shipper.getName());
        pause2s();
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        pause5s();
    }

    public void addNewPricingScript(Shipper shipper)
    {
        waitUntilPageLoaded();
        allShippersCreateEditPage.addNewPricingScript(shipper);
    }

    public void editPricingScript(Shipper shipper)
    {
        waitUntilPageLoaded();
        allShippersCreateEditPage.editPricingScript(shipper);
    }

    public void verifyPricingScriptIsActive()
    {
        waitUntilPageLoaded();
        allShippersCreateEditPage.verifyPricingScriptIsActive();
    }

}
