package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DpVault;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpVaultManagementPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "station in getTableData()";
    private static final String CSV_FILENAME = "station.csv";

    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_ADDRESS = "_address";
    public static final String COLUMN_CLASS_LAT_LONG = "_latlng";
    public static final String COLUMN_CLASS_DP_NAME = "_distribution-point";

    public static final String ACTION_BUTTON_EDIT = "Edit";
    public static final String ACTION_BUTTON_DELETE = "Delete";

    public DpVaultManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addDpVault(DpVault dpVault)
    {
        click("//button[@aria-label='Add Station']");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'dp-station-add')]");
        fillTheFormAndSubmit(dpVault);
    }

    private void fillTheFormAndSubmit(DpVault dpVault)
    {
        sendKeys("//input[@aria-label='Name']", dpVault.getName());
        sendKeys("//input[@aria-label='commons.model.appVersion']", String.valueOf(dpVault.getAppVersion()));
        sendKeys("//input[@aria-label='Distribution Point']", dpVault.getDpName());
        click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", dpVault.getDpName()));
        sendKeys("//input[@aria-label='Address 1']", dpVault.getAddress1());
        sendKeys("//input[@aria-label='Address 2']", dpVault.getAddress2());
        sendKeys("(//input[@aria-label='City'])[1]", dpVault.getCity());
        sendKeys("//input[@aria-label='Country']", dpVault.getCountry());
        sendKeys("(//input[@aria-label='City'])[2]", dpVault.getCity());
        sendKeys("//input[@aria-label='commons.latitude']", String.valueOf(dpVault.getLatitude()));
        sendKeys("//input[@aria-label='commons.longitude']", String.valueOf(dpVault.getLongitude()));
        click("//button[@aria-label='Save Button']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular");
    }

    public void deleteDpVault(DpVault dpVault)
    {
        searchTableByName(dpVault.getName());
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }

    public void downloadCsvFile()
    {
        click("//button[@aria-label='Download CSV File']");
    }

    public void verifyCsvFileDownloadedSuccessfully(DpVault dpVault)
    {
        verifyFileDownloadedSuccessfully(CSV_FILENAME, dpVault.getName());
    }

    public void verifyDpCompanyIsCreatedSuccessfully(DpVault dpVault)
    {
        searchTableByName(dpVault.getName());
        verifyDpVaultInfoIsCorrect(dpVault);
    }

    private void verifyDpVaultInfoIsCorrect(DpVault dpVault)
    {
        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals("DP Vault Name", dpVault.getName(), actualName);

        String expectedAddress = dpVault.getAddress1()+' '+dpVault.getAddress2()+' '+dpVault.getCity()+' '+dpVault.getCountry();
        String actualAddress = getTextOnTable(1, COLUMN_CLASS_ADDRESS);
        Assert.assertEquals("DP Vault Address", expectedAddress, actualAddress);

        String expectedLatLong = "("+dpVault.getLatitude()+", "+dpVault.getLongitude()+')';
        String actualLatLong = getTextOnTable(1, COLUMN_CLASS_LAT_LONG);
        Assert.assertEquals("DP Vault Lat/Long", expectedLatLong, actualLatLong);

        String actualDpName = getTextOnTable(1, COLUMN_CLASS_DP_NAME);
        Assert.assertEquals("DP Vault DP Name", dpVault.getDpName(), actualDpName);
    }

    public void verifyDpVaultIsDeletedSuccessfully(DpVault dpVault)
    {
        searchTableByName(dpVault.getName());
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue("DP Vault still exist in table. Fail to delete DP Vault.", isTableEmpty);
    }

    public void verifyAllFiltersWorkFine(DpVault dpVault)
    {
        searchTableByName(dpVault.getName());
        verifyDpVaultInfoIsCorrect(dpVault);
        searchTableByAddress(dpVault.getAddress1());
        verifyDpVaultInfoIsCorrect(dpVault);
        searchTableByLatLong("("+dpVault.getLatitude()+", "+dpVault.getLongitude()+')');
        verifyDpVaultInfoIsCorrect(dpVault);
    }

    public void searchTableByName(String name)
    {
        searchTable("name", name);
    }

    public void searchTableByAddress(String address)
    {
        searchTable("_address", address);
    }

    public void searchTableByLatLong(String latLong)
    {
        searchTable("_latlng", latLong);
    }

    private void searchTable(String filterColumnClass, String value)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", filterColumnClass), value);
        pause100ms();
    }

    public boolean isTableEmpty()
    {
        WebElement we = findElementByXpath("//h5[text()='No Results Found']");
        return we!=null;
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
