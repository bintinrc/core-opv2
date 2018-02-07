package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class VehicleTypeManagementPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT = "vehicleType in $data";
    private static final String CSV_FILENAME = "vehicle_types.csv";

    private static final String COLUMN_DATA_TITLE_TEXT_NAME = "'commons.name' | translate";
    private static final String ACTION_BUTTON_EDIT = "Edit";
    private static final String ACTION_BUTTON_DEL = "Delete";

    public VehicleTypeManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addNewVehicleType(String name)
    {
        clickNvIconTextButtonByName("Add Vehicle Type");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'vehicle-type-add')]");
        sendKeysById("name", name);
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyVehicleType(String expectedVehicleTypeName)
    {
        searchTable(expectedVehicleTypeName);
        String actualVehicleTypeName = getTextOnTable(1, COLUMN_DATA_TITLE_TEXT_NAME);
        Assert.assertEquals("Different Result Returned",expectedVehicleTypeName,actualVehicleTypeName);
    }

    public void verifyVehicleTypeNotExist(String expectedVehicleTypeName)
    {
        waitUntilInvisibilityOfElementLocated(String.format("//tr[@ng-repeat='%s'][1]", NG_REPEAT));
        searchTable(expectedVehicleTypeName);
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue("Vehicle name still exist on table.", isTableEmpty);
    }

    public void editVehicleType(String oldName, String newName)
    {
        searchTable(oldName);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'vehicle-type-edit')]");
        sendKeysById("name", newName);
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void deleteVehicleType(String name)
    {
        searchTable(name);
        clickActionButtonOnTable(1, ACTION_BUTTON_DEL);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'md-nvRed-theme')]");
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }

    public void csvDownload()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void csvDownloadSuccessful(String vehicleTypeName)
    {
        verifyFileDownloadedSuccessfully(CSV_FILENAME, vehicleTypeName);
    }

    public boolean isTableEmpty()
    {
        return !isElementExistFast(String.format("//tr[@ng-repeat='%s'][1]", NG_REPEAT));
    }

    public String getTextOnTable(int rowNumber, String columnDataTitleText)
    {
        return getTextOnTableWithNgRepeatUsingDataTitleText(rowNumber, columnDataTitleText, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
