package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestWaitTimeoutException;
import co.nvqa.common.utils.NvWait;
import co.nvqa.operator_v2.exception.NvTestCoreElementNotFoundError;
import java.io.File;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.openqa.selenium.WebDriver;

/**
 * @author Kateryna Skakunova
 */
public class OrderLevelTagManagementPage extends OperatorV2SimplePage {

  private static final String TABLE_DATA = "data in getTableData()";
  private static final String TABLE_DATA_ORDER_ID_COLUMN_CLASS = "order-id";

  private static final String FILTER_STATUS_MAIN_TITLE = "Status";
  private static final String FILTER_GRANULAR_STATUS_MAIN_TITLE = "Granular Status";
  private static final String FILTER_SHIPPER_ITEM_TYPES = "Shipper";
  private static final String FILTER_MASTER_SHIPPER_ITEM_TYPES = "Master Shipper";

  public OrderLevelTagManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectShipperValue(String value) {
    selectValueFromNvAutocompleteByItemTypes(FILTER_SHIPPER_ITEM_TYPES, value);
  }

  public void selectMasterShipperValue(String value) {
    selectValueFromNvAutocompleteByItemTypes(FILTER_MASTER_SHIPPER_ITEM_TYPES, value);
  }

  public void selectUniqueStatusValue(String value) {
    List<String> valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);

    if ((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected
        .isEmpty()) {
      selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_STATUS_MAIN_TITLE, value);
    }

    valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);

    if (Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty()) {
      valuesSelected.stream()
          .filter(valueSelected -> !valueSelected.equals(value))
          .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(
              FILTER_STATUS_MAIN_TITLE, valueSelected));
    }
  }

  public void selectUniqueGranularStatusValue(String value) {
    List<String> valuesSelected = getSelectedValuesFromNvFilterBox(
        FILTER_GRANULAR_STATUS_MAIN_TITLE);

    if ((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected
        .isEmpty()) {
      selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_GRANULAR_STATUS_MAIN_TITLE, value);
    }

    valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_GRANULAR_STATUS_MAIN_TITLE);

    if (Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty()) {
      valuesSelected.stream()
          .filter(valueSelected -> !valueSelected.equals(value))
          .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(
              FILTER_GRANULAR_STATUS_MAIN_TITLE, valueSelected));
    }
  }

  public void clickLoadSelectionButton() {
    clickNvIconTextButtonByNameAndWaitUntilDone("Load Selection");
  }

  public void searchAndSelectOrderInTable(String keyword) {
    searchTableCustom1(TABLE_DATA_ORDER_ID_COLUMN_CLASS, keyword);
    try {
      new NvWait(10_000).until(() -> getRowsCountOfTableWithMdVirtualRepeat(TABLE_DATA) == 1);
    } catch (NvTestWaitTimeoutException e) {
      throw new NvTestCoreElementNotFoundError("Unable to find order in table", e);
    }
    checkRowWithMdVirtualRepeat(1, TABLE_DATA);
    clearSearchTableCustom1(TABLE_DATA_ORDER_ID_COLUMN_CLASS);
  }

  public void selectOrdersInTable() {
    int numberOfRows = getRowsCountOfTableWithMdVirtualRepeat(TABLE_DATA);
    for (int rowIndex = 1; rowIndex <= numberOfRows; rowIndex++) {
      checkRowWithMdVirtualRepeat(rowIndex, TABLE_DATA);
    }
  }

  public void clickTagSelectedOrdersButton() {
    clickButtonByAriaLabel("Tag Selected Orders");
  }

  public void tagSelectedOrdersAndSave(String tagLabel) {
    sendKeysByAriaLabel("tag-0", tagLabel);
    clickButtonOnMdDialogByAriaLabel("Save");
    waitUntilInvisibilityOfMdDialog();
  }

  public void uploadFindOrdersCsvWithOrderInfo(List<String> trackingIds) {
    clickNvIconTextButtonByNameAndWaitUntilDone(
        "container.order-level-tag-management.find-orders-with-csv");
    waitUntilVisibilityOfElementLocated("//md-dialog//h2[text()='Find Orders with CSV']");

    String csvContents = trackingIds.stream().collect(Collectors.joining(System.lineSeparator()));
    File csvFile = createFile(f("find-orders-with-csv-%s.csv", generateDateUniqueString()),
        csvContents);

    sendKeysByAriaLabel("Choose", csvFile.getAbsolutePath());
    waitUntilVisibilityOfElementLocated(
        f("//div[@class='upload-button-holder']/span[contains(text(), '%s')]", csvFile.getName()));
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.upload");
    waitUntilInvisibilityOfToast(f("Matches with file shown in table"));
  }
}
