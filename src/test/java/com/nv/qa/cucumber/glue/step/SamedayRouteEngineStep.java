package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.api.client.order_create.OrderCreateV2Client;
import com.nv.qa.model.order_creation.authentication.AuthRequest;
import com.nv.qa.model.order_creation.v2.CreateOrderRequest;
import com.nv.qa.model.order_creation.v2.CreateOrderResponse;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.page.RouteGroupTemplatesPage;
import com.nv.qa.selenium.page.page.RouteGroupsPage;
import com.nv.qa.selenium.page.page.SamedayRouteEnginePage;
import com.nv.qa.selenium.page.page.TransactionsPage;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SamedayRouteEngineStep extends AbstractSteps
{
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    private static final SimpleDateFormat CURRENT_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd");
    public static final String FILTER_QUERY = "SELECT t FROM Transaction t INNER JOIN FETCH t.order o WHERE o.trackingId = '{{tracking_id}}'";

    private OrderCreateV2Client orderCreateV2Client;
    private Order order;

    private RouteGroupTemplatesPage routeGroupTemplatesPage;
    private String routeGroupTemplateName;

    private RouteGroupsPage routeGroupsPage;
    private String routeGroupName;

    private TransactionsPage transactionsPage;
    private SamedayRouteEnginePage samedayRouteEnginePage;

    @Inject
    public SamedayRouteEngineStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        try
        {
            AuthRequest shipperAuthRequest = new AuthRequest();
            shipperAuthRequest.setClient_id(APIEndpoint.SHIPPER_V2_CLIENT_ID);
            shipperAuthRequest.setClient_secret(APIEndpoint.SHIPPER_V2_CLIENT_SECRET);

            orderCreateV2Client = new OrderCreateV2Client(APIEndpoint.API_BASE_URL);
            orderCreateV2Client.login(shipperAuthRequest);

            routeGroupTemplatesPage = new RouteGroupTemplatesPage(getDriver());
            routeGroupsPage = new RouteGroupsPage(getDriver());
            transactionsPage = new TransactionsPage(getDriver());
            samedayRouteEnginePage = new SamedayRouteEnginePage(getDriver());
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @Given("^Shipper create Order V2 Parcel using data below:$")
    public void shipperCreateV2Order(DataTable dataTable) throws IOException
    {
        Map<String,String> mapOfDynamicVariable = new HashMap();
        mapOfDynamicVariable.put("created_date", CREATED_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("cur_date", CURRENT_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("tracking_ref_no", CommonUtil.generateTrackingRefNo());

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String v2OrderRequestJson = CommonUtil.replaceParam(mapOfData.get("v2OrderRequest"), mapOfDynamicVariable);

        CreateOrderRequest createOrderRequest = JsonHelper.fromJson(v2OrderRequestJson, CreateOrderRequest.class);
        String suffix = "";

        if("Return".equals(createOrderRequest.getType()))
        {
            suffix = "R";
        }
        else if("C2C".equals(createOrderRequest.getType()))
        {
            suffix = "C";
        }

        createOrderRequest.setTracking_ref_no(createOrderRequest.getTracking_ref_no()+suffix);
        List<CreateOrderResponse> listOfCreateOrderResponse = orderCreateV2Client.createOrder(createOrderRequest);

        /**
         * Please give a minute for the server to create the order before retrieving the order above.
         * Create Order V2 using async when creating an order.
         */
        CommonUtil.pause1s();

        String asyncOrderId = listOfCreateOrderResponse.get(0).getId();
        order = orderCreateV2Client.retrieveOrder(asyncOrderId);
    }

    @Given("^Operator V2 create 'Route Group Templates'$")
    public void createNewRouteGroupTemplate()
    {
        String trackingId = order.getTracking_id();

        /**
         * Create new Route Group Templates.
         */
        Map<String,String> mapOfDynamicVariable = new HashMap();
        mapOfDynamicVariable.put("tracking_id", trackingId);
        String filter = CommonUtil.replaceParam(FILTER_QUERY, mapOfDynamicVariable);

        routeGroupTemplateName = "RGP "+trackingId;
        routeGroupTemplatesPage.createRouteGroupTemplate(routeGroupTemplateName, filter);

        /**
         * Verify new Route Group Templates is created successfully.
         */
        routeGroupTemplatesPage.searchTable(routeGroupTemplateName);
        CommonUtil.pause200ms();
        String actualName = routeGroupTemplatesPage.getTextOnTable(1, RouteGroupTemplatesPage.COLUMN_CLASS_NAME);
        Assert.assertEquals("Fail to create 'Route Group Templates'.", routeGroupTemplateName, actualName);
    }

    @Given("^Operator V2 create 'Route Group'$")
    public void createNewRouteGroup()
    {
        String trackingId = order.getTracking_id();

        /**
         * Create new Route Group.
         */
        routeGroupName = "RG "+trackingId;
        routeGroupsPage.createRouteGroup(routeGroupName);
        CommonUtil.pause500ms();

        /**
         * Verify the page is redirect to '/#/sg/transactions' after route group is created.
         */
        Assert.assertTrue("Page not redirect to '/#/sg/transactions'.", getDriver().getCurrentUrl().contains("/#/sg/transactions"));
    }

    @Given("^Operator V2 add 'Transaction' to 'Route Group'$")
    public void addTransactionToRouteGroup()
    {
        transactionsPage.selectVariable(routeGroupTemplateName);
        transactionsPage.clickLoadAllEntriesButton();
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
    }

    @Given("^op 'Run Route Engine' on Same-Day Route Engine menu using data below:$")
    public void runRouteEngine(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String hubName = mapOfData.get("hub");
        String fleetType1OperatingHoursFrom = mapOfData.get("fleetType1OperatingHoursFrom");
        String fleetType1OperatingHoursTo = mapOfData.get("fleetType1OperatingHoursTo");

        samedayRouteEnginePage.selectRouteGroup(routeGroupName);
        samedayRouteEnginePage.selectHub(hubName);
        samedayRouteEnginePage.selectFleetType1OperatingHoursFrom(fleetType1OperatingHoursFrom);
        samedayRouteEnginePage.selectFleetType1OperatingHoursTo(fleetType1OperatingHoursTo);
        takesScreenshot();
        samedayRouteEnginePage.clickRunRouteEngineButton();
        takesScreenshot();
        samedayRouteEnginePage.selectDriverOnRouteSettingsPage("OpV2No.1");
        takesScreenshot();
        samedayRouteEnginePage.clickCreate1RoutesButton();
    }

    @Then("^Operator V2 clean up 'Route Group Templates'$")
    public void cleanUpRouteGroupTemplates()
    {
        try
        {
            routeGroupTemplatesPage.deleteRouteGroupTemplate(routeGroupTemplateName);
        }
        catch(Exception ex)
        {
            System.out.println("Failed to delete 'Route Group Template'.");
        }
    }

    @Then("^Operator V2 clean up 'Route Groups'$")
    public void cleanUpRouteGroup()
    {
        try
        {
            routeGroupsPage.deleteRouteGroup(routeGroupName);
        }
        catch(Exception ex)
        {
            System.out.println("Failed to delete 'Route Group'.");
        }
    }
}
