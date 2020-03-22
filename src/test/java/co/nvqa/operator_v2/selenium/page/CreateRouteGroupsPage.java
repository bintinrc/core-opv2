package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TYPE;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class CreateRouteGroupsPage extends OperatorV2SimplePage
{
    private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");
    private static final SimpleDateFormat DATE_FILTER_SDF_2 = new SimpleDateFormat("yyyy-MM-dd");
    private static final String XPATH_GENERAL_FILTERS = "//div[@possible-filters='ctrl.possibleGeneralFilters']";
    private static final String XPATH_TRANSACTION_FILTERS = "//div[@possible-filters='ctrl.possibleTxnFilters']";
    private static final String XPATH_FILTER_BY_TITLE = "//div[@class='filter-container'][.//div[contains(@class,'main-title')]/p[.='%s']]";

    private Map<String, Consumer<String>> filterSetters;
    private TxnRsvnTable txnRsvnTable;

    @FindBy(css = "th.column-checkbox md-menu")
    public MdMenu selectionMenu;

    @FindBy(css = "[id^='route-group']")
    public MdSelect routeGroup;

    @FindBy(name = "Add Transactions/Reservations")
    public NvButtonSave addTransactionReservation;

    public CreateRouteGroupsPage(WebDriver webDriver)
    {
        super(webDriver);
        filterSetters = ImmutableMap.of(
                "RTS", value -> setSwitchFilter(XPATH_TRANSACTION_FILTERS, "RTS", value),
                "Routed", value -> setSwitchFilter(XPATH_GENERAL_FILTERS, "Routed", value),
                "Creation Time", this::setCreationTimeFilter);
        txnRsvnTable = new TxnRsvnTable(webDriver);
    }

    public void waitUntilRouteGroupPageIsLoaded()
    {
        waitUntilInvisibilityOfElementLocated("//div[contains(@class,'message') and text()='Loading...']");
    }

    public void setCreationTimeFilter()
    {
        String dateLabel = DATE_FILTER_SDF.format(TestUtils.getNextDate(1));

        /*
          Set toHour & toMinute of Creation Time.
         */
        click("//md-input-container[@model='container.toHour']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 23 ')]");
        pause500ms();
        click("//md-input-container[@model='container.toMinute']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 30 ')]");
        pause500ms();

        click("//md-datepicker[@ng-model='container.toDate']/button");
        pause500ms();
        click("//td[@aria-label='" + dateLabel + "']");
        pause500ms();

        /*
          Set fromHour & fromMinute of Creation Time.
         */
        click("//md-input-container[@model='container.fromHour']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 00 ')]");
        pause500ms();
        click("//md-input-container[@model='container.fromMinute']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 00 ')]");
        pause500ms();
    }

    public void setCreationTimeFilter(String dates)
    {
        String fromDateStr;
        String toDateStr;

        if (StringUtils.equalsIgnoreCase("today", dates))
        {
            fromDateStr = DATE_FILTER_SDF_2.format(new Date());
            toDateStr = fromDateStr;
        } else
        {
            String[] datesStr = dates.split(";");
            fromDateStr = StringUtils.normalizeSpace(datesStr[0]);
            toDateStr = StringUtils.normalizeSpace(datesStr[1]);
        }

        /*
          Set fromHour & fromMinute of Creation Time.
         */
        sendKeys("//md-datepicker[@name='fromDateField']//input", fromDateStr);
        pause500ms();
        click("//md-input-container[@model='container.fromHour']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 00 ')]");
        pause500ms();
        click("//md-input-container[@model='container.fromMinute']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 00 ')]");
        pause500ms();

        /*
          Set toHour & toMinute of Creation Time.
         */
        sendKeys("//md-datepicker[@name='toDateField']//input", toDateStr);
        pause500ms();
        click("//md-input-container[@model='container.toHour']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 23 ')]");
        pause500ms();
        click("//md-input-container[@model='container.toMinute']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 30 ')]");
        pause500ms();
    }

    public void removeFilter(String filterName)
    {
        if (filterName.contains("time"))
        {
            if (isElementExist("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button"))
            {
                click("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button");
            }
        } else
        {
            click("//div[div[p[text()='" + filterName + "']]]/div/div/nv-icon-button/button");
        }
    }

    public void removeAllFilterExceptGiven(List<String> filters)
    {
        String xpath = "//div[@class='filter-container']//div[contains(@class,'main-title')]/p";
        List<String> filterTitles = getTextOfElements(xpath);
        filterTitles.removeAll(filters);
        String removeFilterXpath = XPATH_FILTER_BY_TITLE + "//*[@name='commons.remove-filter']";
        filterTitles.forEach(filter -> clickf(removeFilterXpath, filter));
    }

    public void selectTransactionFiltersMode(String value)
    {
        clickf("//div[@model='ctrl.includeTxnModel']//button[@aria-label='%s']", value);
    }

    public void selectReservationFiltersMode(String value)
    {
        clickf("//div[@model='ctrl.includeRxnModel']//button[@aria-label='%s']", value);
    }

    public void addTransactionFilters(Map<String, String> data)
    {
        data.forEach((filter, value) ->
        {
            String xpath = f(XPATH_TRANSACTION_FILTERS + XPATH_FILTER_BY_TITLE, filter);
            if (!isElementExistFast(xpath))
            {
                executeInContext(XPATH_TRANSACTION_FILTERS, () -> selectValueFromNvAutocompleteBySearchTextAndDismiss("::searchText", filter));
            }
            filterSetters.get(filter).accept(value);
        });
    }

    public void addGeneralFilters(Map<String, String> data)
    {
        data.forEach((filter, value) ->
        {
            String xpath = f(XPATH_GENERAL_FILTERS + XPATH_FILTER_BY_TITLE, filter);
            if (!isElementExistFast(xpath))
            {
                executeInContext(XPATH_GENERAL_FILTERS, () -> selectValueFromNvAutocompleteBySearchTextAndDismiss("::searchText", filter));
            }
            filterSetters.get(filter).accept(value);
        });
    }

    public void setSwitchFilter(String blockXpath, String filter, String value)
    {
        clickf(blockXpath + XPATH_FILTER_BY_TITLE + "//button[@aria-label='%s']", filter, value);
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void searchByTrackingId(String trackingId)
    {
        txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
    }

    public void selectAllShown()
    {
        txnRsvnTable.selectAllShown();
    }

    public void clickAddToRouteGroupButton()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("container.transactions.add-to-route-group");
    }

    public void selectRouteGroupOnAddToRouteGroupDialog(String routeGroupName)
    {
        routeGroup.searchAndSelectValue(routeGroupName);
    }

    public void clickAddTransactionsOnAddToRouteGroupDialog()
    {
        addTransactionReservation.clickAndWaitUntilDone();
        waitUntilInvisibilityOfToast("Added successfully");
    }

    public void validateRecord(TxnRsvn expectedRecord, String type)
    {
        txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, expectedRecord.getTrackingId());
        txnRsvnTable.filterByColumn(COLUMN_TYPE, type);
        TxnRsvn actualRecord = txnRsvnTable.readEntity(1);
        expectedRecord.compareWithActual(actualRecord);
    }

    /**
     * Accessor for Transaction/Reservation table
     */
    public static class TxnRsvnTable extends MdVirtualRepeatTable<TxnRsvn>
    {
        public static final String MD_VIRTUAL_REPEAT = "trvn in getTableData()";
        public static final String COLUMN_TRACKING_ID = "trackingId";
        public static final String COLUMN_TYPE = "type";

        public TxnRsvnTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("sequence", "sequence")
                    .put("id", "id")
                    .put("orderId", "order-id")
                    .put("waypointId", "waypoint-id")
                    .put(COLUMN_TRACKING_ID, "tracking-id")
                    .put(COLUMN_TYPE, "type")
                    .put("shipper", "shipper")
                    .put("address", "address")
                    .put("routeId", "route-id")
                    .put("status", "status")
                    .put("startDateTime", "start-date-time")
                    .put("endDateTime", "end-date-time")
                    .put("dp", "dp")
                    .put("pickupSize", "pickup-size")
                    .put("comments", "comments")
                    .build()
            );
            setEntityClass(TxnRsvn.class);
            setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
        }
    }
}
