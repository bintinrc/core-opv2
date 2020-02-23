package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.VehicleType;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class VehicleTypeManagementPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT = "vehicleType in $data";
    private static final String CSV_FILENAME = "vehicle_types.csv";

    private static final String COLUMN_DATA_TITLE_NAME = "'commons.name' | translate";
    private static final String ACTION_BUTTON_EDIT = "Edit";
    private static final String ACTION_BUTTON_DEL = "Delete";

    @FindBy(css = "md-dialog")
    public ConfirmDeleteDialog confirmDeleteDialog;

    public VehicleTypeManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addNewVehicleType(VehicleType vehicleType)
    {
        clickNvIconTextButtonByName("Add Vehicle Type");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'vehicle-type-add')]");
        sendKeysById("name", vehicleType.getName());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        pause5s(); //This pause is used to wait until the cache is synced to all node. Sometimes we got an error that says the new Vehicle Type is not found.
    }

    public void verifyVehicleType(VehicleType vehicleType)
    {
        searchTable(vehicleType.getName());
        String actualVehicleTypeName = getTextOnTable(1, COLUMN_DATA_TITLE_NAME);
        assertEquals("Vehicle Type name", vehicleType.getName(), actualVehicleTypeName);
    }

    public void verifyVehicleTypeNotExist(String expectedVehicleTypeName)
    {
        waitUntilInvisibilityOfElementLocated(String.format("//tr[@ng-repeat='%s'][1]", NG_REPEAT));
        searchTable(expectedVehicleTypeName);
        boolean isTableEmpty = isTableEmpty();
        assertTrue("Vehicle name still exist on table.", isTableEmpty);
    }

    public void editVehicleType(String oldName, String newName)
    {
        searchTable(oldName);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'vehicle-type-edit')]");
        sendKeysById("name", newName);
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        pause5s(); //This pause is used to wait until the cache is synced to all node. Sometimes we got an error that says the new Vehicle Type is not found.
    }

    public void deleteVehicleType(String name)
    {
        searchTable(name);
        clickActionButtonOnTable(1, ACTION_BUTTON_DEL);
        confirmDeleteDialog.waitUntilClickable();
        confirmDeleteDialog.delete.click();
        pause5s(); //This pause is used to wait until the cache is synced to all node. Sometimes we got an error that says the new Vehicle Type is not found.
    }

    public void csvDownload()
    {
        clickNvApiTextButtonByName("Download CSV File");
        pause5s(); //This pause is used to wait until the cache is synced to all node. Sometimes we got an error that says the new Vehicle Type is not found.
    }

    public void csvDownloadSuccessful(String vehicleTypeName)
    {
        verifyFileDownloadedSuccessfully(CSV_FILENAME, vehicleTypeName);
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
