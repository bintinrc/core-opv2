package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.List;
import java.util.Objects;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class OrderTagManagementPage extends OperatorV2SimplePage
{
    private static final String TABLE_DATA = "data in getTableData()";
    private static final String TABLE_DATA_ORDER_ID_COLUMN_CLASS = "order-id";

    private static final String FILTER_STATUS_MAIN_TITLE = "Status";
    private static final String FILTER_GRANULAR_STATUS_MAIN_TITLE = "Granular Status";
    private static final String FILTER_SHIPPER_ITEM_TYPES = "Shipper";
    private static final String FILTER_MASTER_SHIPPER_ITEM_TYPES = "Master Shipper";

    public OrderTagManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }


    public void selectShipperValue(String value)
    {
        selectValueFromNvAutocompleteByItemTypes(FILTER_SHIPPER_ITEM_TYPES, value);
    }

    public void selectUniqueStatusValue(String value)
    {
        List<String> valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);
         if((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected.isEmpty())
         {
             selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_STATUS_MAIN_TITLE, value);
         }

         valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_STATUS_MAIN_TITLE);

         if(Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty())
         {
             valuesSelected.stream()
                     .filter(valueSelected -> !valueSelected.equals(value))
                     .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(FILTER_STATUS_MAIN_TITLE, valueSelected));
         }
    }

    public void selectUniqueGranularStatusValue(String value)
    {
        List<String> valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_GRANULAR_STATUS_MAIN_TITLE);

        if((Objects.nonNull(valuesSelected) && !valuesSelected.contains(value)) || valuesSelected.isEmpty())
        {
            selectValueFromNvAutocompleteByItemTypesAndDismiss(FILTER_GRANULAR_STATUS_MAIN_TITLE, value);
        }

        valuesSelected = getSelectedValuesFromNvFilterBox(FILTER_GRANULAR_STATUS_MAIN_TITLE);

        if(Objects.nonNull(valuesSelected) && !valuesSelected.isEmpty())
        {
            valuesSelected.stream()
                    .filter(valueSelected -> !valueSelected.equals(value))
                    .forEach(valueSelected -> removeSelectedValueFromNvFilterBoxByAriaLabel(FILTER_GRANULAR_STATUS_MAIN_TITLE, valueSelected));
        }
    }

    public void clickLoadSelectionButton()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void selectOrdersInTable()
    {
        checkRowWithMdVirtualRepeat(1, TABLE_DATA);
    }

    public void addTag(List orderTag)
    {
        clickButtonByAriaLabel("Action");
        clickButtonByAriaLabel("Add Tags");
        for (int i = 0; i < orderTag.size(); i++)
        {
            sendKeysAndEnter("//md-autocomplete//input[@aria-autocomplete='list']", String.valueOf(orderTag.get(i)));
        }

        click("//md-icon/i[contains(text(),'arrow_drop_down')]");
        clickButtonByAriaLabel("Save");
        pause5s();
    }

    public void removeTag(List orderTag)
    {
        clickButtonByAriaLabel("Action");
        clickButtonByAriaLabel("Remove Tags");

        for (int i = 0; i < orderTag.size(); i++)
        {
            sendKeysAndEnter("//md-autocomplete//input[@aria-autocomplete='list']", String.valueOf(orderTag.get(i)));
        }

        click("//md-icon/i[contains(text(),'arrow_drop_down')]");
        clickButtonByAriaLabel("Remove");
        pause5s();
    }

}
