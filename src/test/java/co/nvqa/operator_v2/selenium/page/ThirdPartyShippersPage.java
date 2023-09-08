package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ThirdPartyShipper;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ThirdPartyShippersPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(ThirdPartyShippersPage.class);

  private static final String MD_VIRTUAL_REPEAT = "shipper in getTableData()";
  private static final String CSV_FILENAME = "third-party-shipper.csv";

  public static final String COLUMN_CLASS_DATA_ID = "id";
  public static final String COLUMN_CLASS_DATA_CODE = "code";
  public static final String COLUMN_CLASS_DATA_NAME = "name";
  public static final String COLUMN_CLASS_DATA_URL = "url";

  public static final String ACTION_BUTTON_EDIT = "Edit";
  public static final String ACTION_BUTTON_DELETE = "Delete";

  @FindBy(css = "md-dialog")
  public ConfirmDeleteDialog confirmDeleteDialog;

  public ThirdPartyShippersPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void addThirdPartyShipper(ThirdPartyShipper thirdPartyShipper) {
    clickNvIconTextButtonByName("container.third-party-shipper.add-shipper");
    fillTheForm(thirdPartyShipper);
    clickNvButtonSaveByName("Submit");
    waitUntilVisibilityOfElementLocated(
        "//div[@id='toast-container']//div[contains(text(), 'created!')]");
    waitUntilInvisibilityOfElementLocated(
        "//div[@id='toast-container']//div[contains(text(), 'created!')]");
  }

  public void editThirdPartyShipper(ThirdPartyShipper oldThirdPartyShipper,
      ThirdPartyShipper newThirdPartyShipper) {
    searchTableByCode(oldThirdPartyShipper.getCode());
    clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
    waitUntilVisibilityOfElementLocated("//input[contains(@id, 'commons.model.name')]");
    fillTheForm(newThirdPartyShipper);
    clickNvButtonSaveByName("Submit Changes");
    waitUntilVisibilityOfElementLocated(
        "//div[@id='toast-container']//div[contains(text(), 'updated!')]");
    waitUntilInvisibilityOfElementLocated(
        "//div[@id='toast-container']//div[contains(text(), 'updated!')]");
  }

  private void fillTheForm(ThirdPartyShipper thirdPartyShipper) {
    sendKeysById("commons.model.name", thirdPartyShipper.getName());
    sendKeysById("commons.model.code", thirdPartyShipper.getCode());
    sendKeysById("commons.model.url", thirdPartyShipper.getUrl());
  }

  public void verifyThirdPartyShipperIsCreatedSuccessfully(ThirdPartyShipper thirdPartyShipper) {
    searchTableByCode(thirdPartyShipper.getCode());
    verifyThirdPartyShipperInfoIsCorrect(thirdPartyShipper);
  }

  public void verifyThirdPartyShipperIsUpdatedSuccessfully(ThirdPartyShipper thirdPartyShipper) {
    searchTableByCode(thirdPartyShipper.getCode());
    verifyThirdPartyShipperInfoIsCorrect(thirdPartyShipper);
  }

  private void verifyThirdPartyShipperInfoIsCorrect(ThirdPartyShipper thirdPartyShipper) {
    if (thirdPartyShipper.getId() == null) {
      String idAsString = getTextOnTable(1, COLUMN_CLASS_DATA_ID);

      try {
        int id = Integer.parseInt(idAsString);
        thirdPartyShipper.setId(id);
      } catch (NullPointerException | NumberFormatException ex) {
        LOGGER.warn("Failed to parse ID to Integer.", ex);
      }
    } else {
      String actualId = getTextOnTable(1, COLUMN_CLASS_DATA_ID);
      Assertions.assertThat(actualId).as("Third Party Shipper - Code")
          .isEqualTo(String.valueOf(thirdPartyShipper.getId()));
    }

    String actualCode = getTextOnTable(1, COLUMN_CLASS_DATA_CODE);
    Assertions.assertThat(actualCode).as("Third Party Shipper - Code")
        .isEqualTo(thirdPartyShipper.getCode());

    String actualName = getTextOnTable(1, COLUMN_CLASS_DATA_NAME);
    Assertions.assertThat(actualName).as("Third Party Shipper - Name")
        .isEqualTo(thirdPartyShipper.getName());

    String actualUrl = getTextOnTable(1, COLUMN_CLASS_DATA_URL);
    Assertions.assertThat(actualUrl).as("Third Party Shipper - URL")
        .isEqualTo(thirdPartyShipper.getUrl());
  }

  public void deleteThirdPartyShipper(ThirdPartyShipper thirdPartyShipper) {
    searchTableByCode(thirdPartyShipper.getCode());
    clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
    confirmDeleteDialog.confirmDelete();
    waitUntilVisibilityOfElementLocated(
        "//div[@id='toast-container']//div[contains(text(), 'deleted!')]");
    waitUntilInvisibilityOfElementLocated(
        "//div[@id='toast-container']//div[contains(text(), 'deleted!')]");
  }

  public void verifyThirdPartyShipperIsDeletedSuccessfully(ThirdPartyShipper thirdPartyShipper) {
    searchTableByCode(thirdPartyShipper.getCode());
    boolean isTableEmpty = isTableEmpty();
    assertTrue(
        f("Third Party Shipper still exist in table. Fail to delete Third Party Shipper (code = %s).",
            thirdPartyShipper.getCode()), isTableEmpty);
  }

  public void verifyAllFiltersWorkFine(ThirdPartyShipper thirdPartyShipper) {
    searchTableByCode(thirdPartyShipper.getCode());
    verifyThirdPartyShipperInfoIsCorrect(thirdPartyShipper);
    searchTableByName(thirdPartyShipper.getName());
    verifyThirdPartyShipperInfoIsCorrect(thirdPartyShipper);
    searchTableByUrl(thirdPartyShipper.getUrl());
    verifyThirdPartyShipperInfoIsCorrect(thirdPartyShipper);
    searchTableById(thirdPartyShipper.getId());
    verifyThirdPartyShipperInfoIsCorrect(thirdPartyShipper);
  }

  public void downloadCsvFile() {
    clickNvApiTextButtonByName("Download CSV File");
  }

  public void verifyCsvFileDownloadedSuccessfully(ThirdPartyShipper thirdPartyShipper) {
    Integer id = thirdPartyShipper.getId();
    String name = thirdPartyShipper.getName();
    String url = thirdPartyShipper.getUrl();
    String expectedText = String.format("%d,\"%s\",\"%s\"", id, name, url);
    verifyFileDownloadedSuccessfully(CSV_FILENAME, expectedText);
  }

  public void searchTableById(Integer id) {
    searchTableCustom1("id", String.valueOf(id));
  }

  public void searchTableByCode(String code) {
    searchTableCustom1("code", code);
  }

  public void searchTableByName(String name) {
    searchTableCustom1("name", name);
  }

  public void searchTableByUrl(String url) {
    searchTableCustom1("url", url);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }
}
