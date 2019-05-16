package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.List;
import java.util.Objects;

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
        if ((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected.size() == 0) {
            selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_STATUS_MAIN_TITLE, value);
        }

        valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);
        if (Objects.nonNull(valuesSelected) && valuesSelected.size() >= 1) {
            valuesSelected.stream().filter(valueSelected -> !valueSelected.equals(value))
                    .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(FILTER_STATUS_MAIN_TITLE, valueSelected));
        }
    }

    public void selectUniqueGranularStatusValue(String value) {
        List<String> valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_GRANULAR_STATUS_MAIN_TITLE);
        if ((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected.size() == 0) {
            selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_GRANULAR_STATUS_MAIN_TITLE, value);
        }

        valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_GRANULAR_STATUS_MAIN_TITLE);
        if (Objects.nonNull(valuesSelected) && valuesSelected.size() >= 1) {
            valuesSelected.stream().filter(valueSelected -> !valueSelected.equals(value))
                    .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(FILTER_GRANULAR_STATUS_MAIN_TITLE, valueSelected));
        }
    }

    public void clickLoadSelectionButton() {
        clickNvIconTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void selectOrderInTable(String keyword) {
        searchTableCustom1(TABLE_DATA_ORDER_ID_COLUMN_CLASS, keyword);
        wait10sUntil(() -> getRowsCountOfTableWithMdVirtualRepeat(TABLE_DATA) == 1);
        checkRowWithMdVirtualRepeat(1, TABLE_DATA);
        clearSearchTableCustom1(TABLE_DATA_ORDER_ID_COLUMN_CLASS);
    }

    public void clickTagSelectedOrdersButton() {
        clickButtonByAriaLabel("Tag Selected Orders");
    }

    public void tagSelectedOrdersAndSave(String tagLabel) {
        sendKeysByAriaLabel("tag-0", tagLabel);
        clickButtonOnMdDialogByAriaLabel("Save");
        waitUntilInvisibilityOfMdDialog();
    }

}
