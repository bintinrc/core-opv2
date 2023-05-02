package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DriverTypeParams;
import co.nvqa.operator_v2.model.VehicleType;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.page.DriverTypeManagementPage.DriverTypesTable;
import com.google.common.collect.ImmutableMap;
import io.cucumber.java.en_old.Ac;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.logging.Logger;
import org.assertj.core.api.Assertions;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class VehicleTypeManagementPage extends SimpleReactPage {

  public VehicleTypeTable vehicleTypeTable;
  private static final String NG_REPEAT = "vehicleType in $data";
  private static final String CSV_FILENAME = "vehicle-types.csv";
  private static final String COLUMN_DATA_TITLE_NAME = "'commons.name' | translate";
  private static final String ACTION_BUTTON_EDIT = "update";
  private static final String ACTION_BUTTON_DEL = "delete";

  @FindBy(xpath = "//button[contains(@class,'ant-btn') and@type='button'][span[text() = 'Create Vehicle Type']]")
  public Button btnCreateVehicleType;
  @FindBy(xpath = "//button[contains(@class,'ant-btn') and@type='button' and text() = 'Download CSV File']")
  public Button btnDownloadCSVFile;

  @FindBy(xpath = "//button[contains(@class,'ant-btn') and@type='button'][span[text() = 'Add']]")
  public Button btnAddVehicleType;

  @FindBy(xpath = "//button[contains(@class,'ant-btn') and@type='button'][span[text() = 'Update']]")
  public Button btnUpdateVehicleType;
  @FindBy(xpath = "//button[contains(@class,'ant-btn') and@type='button'][span[text() = 'Delete']]")
  public Button btnDeleteVehicleType;

  @FindBy(xpath = "//div[@class='ant-modal-content'][div[div[text() = 'Add Vehicle Type']]]")
  public PageElement addVehicleTypeModal;

  @FindBy(xpath = "//div[@class='ant-modal-content'][div[div[text() = 'Update Vehicle Type']]]")
  public PageElement updateVehicleTypeModal;

  @FindBy(xpath = "//div[@class='ant-modal-content'][div[div[text() = 'Confirm delete']]]")
  public PageElement deleteVehicleTypeModal;

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  @FindBy(xpath = "//input[contains(@data-testid,'search-bar') and @placeholder = 'Search']")
  public PageElement seachBar;

  @FindBy(xpath = "//input[@id='name' and @class='ant-input']")
  public PageElement txtFieldInput;

  public VehicleTypeManagementPage(WebDriver webDriver) {
    super(webDriver);
    vehicleTypeTable = new VehicleTypeTable(webDriver);
  }

  public static class VehicleTypeTable extends AntTableV3<DriverTypeParams> {

    public static final String COLUMN_ID = "vehicleId";
    public static final String COLUMN_NAME = "vehicleTypeName";

    public static final String ACTION_UPDATE = "update";
    public static final String ACTION_DELETE = "delete";

    public VehicleTypeTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "1")
          .put(COLUMN_NAME, "2")
          .build()
      );
      setActionButtonsLocators(ImmutableMap
          .of(ACTION_UPDATE, "1", ACTION_DELETE, "2"));
      setEntityClass(DriverTypeParams.class);
    }
  }

  public void addNewVehicleType(VehicleType vehicleType) {
    vehicleTypeTable.waitUntilPageLoaded();
    btnCreateVehicleType.click();
    addVehicleTypeModal.waitUntilVisible();
    txtFieldInput.sendKeys(vehicleType.getName());
    btnAddVehicleType.click();
    addVehicleTypeModal.waitUntilInvisible();
  }

  public void verifyVehicleType(VehicleType vehicleType) {
    clearWebField(seachBar.getWebElement());
    seachBar.sendKeys(vehicleType.getName());

    Map<String, String> actualData = vehicleTypeTable.readRow(1);
    Boolean isVehicleTypeNameMatch = vehicleType.getName()
        .equals(actualData.get(VehicleTypeTable.COLUMN_NAME));
    Boolean isVehicleIdMatch = vehicleType.getId()
        .equals(Long.parseLong(actualData.get(VehicleTypeTable.COLUMN_ID)));

    Assertions.assertThat(isVehicleTypeNameMatch).as("Vehicle Type Name is not match")
        .isTrue();
    Assertions.assertThat(isVehicleIdMatch).as("Vehicle ID is not match")
        .isTrue();
  }

  public void verifyVehicleTypeNotExist(String expectedVehicleTypeName) {
    clearWebField(seachBar.getWebElement());
    seachBar.sendKeys(expectedVehicleTypeName);
    boolean isTableEmpty = isTableEmpty();
    Assertions.assertThat(isTableEmpty).as("Vehicle name still exist on table.").isTrue();
  }

  public void editVehicleType(String oldName, String newName) {
    if (seachBar.getValue().isBlank() || seachBar.getValue().isEmpty()) {
      seachBar.sendKeys(oldName);
    }
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    updateVehicleTypeModal.waitUntilVisible();
    if (!(txtFieldInput.getValue().isBlank() || txtFieldInput.getValue().isEmpty())) {
      clearWebField(txtFieldInput.getWebElement());
      txtFieldInput.sendKeys(newName);
    }
    btnUpdateVehicleType.moveAndClick();
    updateVehicleTypeModal.waitUntilInvisible();
  }

  public void deleteVehicleType(String name) {
    if (seachBar.getValue().isBlank() || seachBar.getValue().isEmpty()) {
      seachBar.sendKeys(name);
    }
    clickActionButtonOnTable(1, ACTION_BUTTON_DEL);
    deleteVehicleTypeModal.waitUntilVisible();
    btnDeleteVehicleType.moveAndClick();
    deleteVehicleTypeModal.waitUntilInvisible();
  }

  public void csvDownload() {
    vehicleTypeTable.waitUntilPageLoaded();
    btnDownloadCSVFile.click();
    pause5s(); //This pause is used to wait until the cache is synced to all node. Sometimes we got an error that says the new Vehicle Type is not found.
  }

  public void csvDownloadSuccessful(String vehicleTypeName) {
    verifyFileDownloadedSuccessfully(CSV_FILENAME, vehicleTypeName);
  }

  public boolean isTableEmpty() {
    List<WebElement> elements = findElementsBy(By.xpath(
        "//tr[contains(@class,'ant-table-row')][td[contains(@class, 'ant-table-cell')]]"));
    return elements.size() == 0;
  }

  public String getTextOnTable(int rowNumber, String columnDataTitle) {
    return getTextOnTableWithNgRepeatUsingDataTitle(rowNumber, columnDataTitle, NG_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
//    clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    String updateBtnXpath = f(
        "//button[@type='button' and @data-testid='%s-button' and contains(@class,'ant-btn')]",
        actionButtonName);
    WebElement btnTable = findElementsBy(By.xpath(updateBtnXpath)).get(rowNumber - 1);
    if (!btnTable.isDisplayed()) {
      Assertions.assertThat(btnTable.isDisplayed())
          .as("Update button not found in table")
          .isFalse();
    } else {
      btnTable.click();
    }
  }
}
