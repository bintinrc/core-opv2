package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage;
import com.google.common.collect.ImmutableList;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static co.nvqa.commons.support.DateUtil.ISO8601_LITE_DATETIME_FORMAT;
import static co.nvqa.commons.support.DateUtil.SDF_YYYY_MM_DD_HH_MM_SS;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CreateRouteGroupsSteps extends AbstractSteps
{
    private CreateRouteGroupsPage createRouteGroupsPage;

    public CreateRouteGroupsSteps()
    {
    }

    @Override
    public void init()
    {
        createRouteGroupsPage = new CreateRouteGroupsPage(getWebDriver());
    }

    @When("^Operator wait until 'Create Route Group' page is loaded$")
    public void waitUntilCreateRouteGroupIsLoaded()
    {
        createRouteGroupsPage.waitUntilRouteGroupPageIsLoaded();
    }

    @When("^Operator V2 add created Transaction to Route Group$")
    public void addCreatedTransactionToRouteGroup()
    {
        String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);

        createRouteGroupsPage.removeFilter("Start Datetime");
        createRouteGroupsPage.removeFilter("End Datetime");
        createRouteGroupsPage.setCreationTimeFilter();
        createRouteGroupsPage.clickButtonLoadSelection();
        createRouteGroupsPage.searchByTrackingId(expectedTrackingId);
        createRouteGroupsPage.selectAllShown();
        createRouteGroupsPage.clickAddToRouteGroupButton();
        createRouteGroupsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        pause1s();
        takesScreenshot();
        createRouteGroupsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause1s();
    }


    @When("^Operator V2 add created Transactions to Route Group$")
    public void addCreatedTransactionsToRouteGroup()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);

        trackingIds.forEach(trackingId ->
        {
            createRouteGroupsPage.removeFilter("Start Datetime");
            createRouteGroupsPage.removeFilter("End Datetime");
            createRouteGroupsPage.setCreationTimeFilter();
            createRouteGroupsPage.clickButtonLoadSelection();
            createRouteGroupsPage.searchByTrackingId(trackingId);
            createRouteGroupsPage.selectAllShown();
            createRouteGroupsPage.clickAddToRouteGroupButton();
            createRouteGroupsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
            pause1s();
            takesScreenshot();
            createRouteGroupsPage.clickAddTransactionsOnAddToRouteGroupDialog();
            takesScreenshot();
            pause3s();
        });
    }

    @Given("^Operator removes all General Filters except following: \"([^\"]*)\"$")
    public void operatorRemovesAllGeneralFiltersExceptFollowingCreationTime(String filtersAsString)
    {
        List<String> filters = Arrays.asList(filtersAsString.replaceAll(", ", ",").split(","));
        createRouteGroupsPage.removeAllFilterExceptGiven(filters);
    }

    @Given("^Operator choose \"([^\"]*)\" on Transaction Filters section on Create Route Group page$")
    public void operatorChooseOnTransactionFiltersSectionOnCreateRouteGroupPage(String value)
    {
        createRouteGroupsPage.selectTransactionFiltersMode(value);
    }

    @Given("^Operator choose \"([^\"]*)\" on Reservation Filters section on Create Route Group page$")
    public void operatorChooseOnReservationFiltersSectionOnCreateRouteGroupPage(String value)
    {
        createRouteGroupsPage.selectReservationFiltersMode(value);
    }

    @Given("^Operator add following filters on Transactions Filters section on Create Route Group page:$")
    public void operatorAddFollowingFiltersOnTransactionsFiltersSectionOnCreateRouteGroupPage(Map<String, String> mapOfData)
    {
        createRouteGroupsPage.addTransactionFilters(mapOfData);
    }

    @Given("^Operator add following filters on General Filters section on Create Route Group page:$")
    public void operatorAddFollowingFiltersOnGeneralFiltersSectionOnCreateRouteGroupPage(Map<String, String> mapOfData)
    {
        createRouteGroupsPage.addGeneralFilters(mapOfData);
    }

    @Given("^Operator click Load Selection on Create Route Group page$")
    public void operatorClickLoadSelectionOnCreateRouteGroupPage()
    {
        createRouteGroupsPage.clickButtonLoadSelection();
    }


    @Then("^Operator verify (.+) Transaction/Reservation record on Create Route Group page using data below:$")
    public void operatorVerifyTransactionReservationRecordOnCreateRouteGroupPageUsingDataBelow(String type, Map<String, String> mapOfData) throws ParseException
    {
        mapOfData = new HashMap<>(mapOfData);
        Order order = get(KEY_ORDER_DETAILS);

        Transaction transaction = order.getTransactions().stream()
                .filter(txn -> StringUtils.equalsIgnoreCase(type, txn.getType()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException(f("Order [%s] doesn't have %s transactions", order.getTrackingId(), type)));

        String value = mapOfData.get("id");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            mapOfData.put("id", String.valueOf(transaction.getId()));
        }

        value = mapOfData.get("orderId");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            mapOfData.put("orderId", String.valueOf(order.getId()));
        }

        value = mapOfData.get("trackingId");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            mapOfData.put("trackingId", String.valueOf(order.getTrackingId()));
        }

        value = mapOfData.get("shipper");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            mapOfData.put("shipper", String.valueOf(transaction.getName()));
        }

        value = mapOfData.get("address");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            String address = StringUtils.normalizeSpace(StringUtils.join(ImmutableList.of(transaction.getAddress1(), transaction.getAddress2(), transaction.getPostcode()), " "));
            mapOfData.put("address", address);
        }

        value = mapOfData.get("startDateTime");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            Date date = ISO8601_LITE_DATETIME_FORMAT.parse(transaction.getStartTime());
            mapOfData.put("startDateTime", SDF_YYYY_MM_DD_HH_MM_SS.format(date));
        }

        value = mapOfData.get("endDateTime");

        if(StringUtils.equalsIgnoreCase(value, "GET_FROM_CREATED_ORDER"))
        {
            Date date = ISO8601_LITE_DATETIME_FORMAT.parse(transaction.getEndTime());
            mapOfData.put("endDateTime", SDF_YYYY_MM_DD_HH_MM_SS.format(date));
        }

        TxnRsvn expectedRecord = new TxnRsvn();
        expectedRecord.fromMap(mapOfData);
        createRouteGroupsPage.validateRecord(expectedRecord, type);
    }
}
