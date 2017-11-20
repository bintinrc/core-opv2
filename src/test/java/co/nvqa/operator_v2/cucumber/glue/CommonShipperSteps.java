package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.OrderCreateHelper;
import co.nvqa.operator_v2.util.ScenarioStorage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.api.client.order_create.OrderCreateV2Client;
import com.nv.qa.api.client.order_create.OrderCreateV3Client;
import com.nv.qa.model.order_creation.authentication.AuthRequest;
import com.nv.qa.model.order_creation.v2.CreateOrderRequest;
import com.nv.qa.model.order_creation.v2.CreateOrderResponse;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.commons.support.*;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.Assert;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CommonShipperSteps extends AbstractSteps
{
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    private static final SimpleDateFormat CURRENT_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd");

    @Inject private ScenarioStorage scenarioStorage;

    private OrderCreateV2Client orderCreateV2Client;
    private OrderCreateV3Client orderCreateV3Client;
    List<com.nv.qa.model.order_creation.v3.CreateOrderRequest> createOrderRequests = new ArrayList<>();
    List<com.nv.qa.model.order_creation.v3.CreateOrderResponse> createOrderResponses = new ArrayList<>();

    @Inject
    public CommonShipperSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        try
        {
            AuthRequest shipperAuthRequest = new AuthRequest();
            shipperAuthRequest.setClient_id(TestConstants.SHIPPER_V2_CLIENT_ID);
            shipperAuthRequest.setClient_secret(TestConstants.SHIPPER_V2_CLIENT_SECRET);

            orderCreateV2Client = new OrderCreateV2Client(TestConstants.API_BASE_URL, TestConstants.ORDER_CREATE_BASE_URL);
            orderCreateV2Client.login(shipperAuthRequest);
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @Given("^Shipper create Order V2 Parcel using data below:$")
    public void shipperCreateV2Order(DataTable dataTable) throws IOException
    {
        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("created_date", CREATED_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("cur_date", CURRENT_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("tracking_ref_no", TestUtils.generateTrackingRefNo());

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String v2OrderRequestJson = TestUtils.replaceParam(mapOfData.get("v2OrderRequest"), mapOfDynamicVariable);

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
        List<CreateOrderResponse> listOfCreateOrderResponse = TestUtils.retryIfAssertionErrorOrRuntimeExceptionOccurred(()->orderCreateV2Client.createOrder(createOrderRequest), "createV2Order", getScenarioManager()::writeToScenarioLog);

        /**
         * Retry if the order fail to retrieve.
         */
        String asyncOrderId = listOfCreateOrderResponse.get(0).getId();
        scenarioStorage.put("orderAsyncId", asyncOrderId);
        Order order = TestUtils.retryIfAssertionErrorOrRuntimeExceptionOccurred(()->orderCreateV2Client.retrieveOrder(asyncOrderId), String.format("createV2Order - retrieve order - [Async ID = %s]", asyncOrderId), getScenarioManager()::writeToScenarioLog);

        scenarioStorage.put("order", order);
        scenarioStorage.put("orderAsyncId", asyncOrderId);
        scenarioStorage.put("trackingId", order.getTracking_id());
        saveTrackingId(order.getTracking_id());
    }

    private void saveTrackingId(String trackingId)
    {
        List<String> trackingIds = scenarioStorage.get("trackingIds");

        if(trackingIds==null)
        {
            trackingIds = new ArrayList<>();
            scenarioStorage.put("trackingIds", trackingIds);
        }

        trackingIds.add(trackingId);
    }

    private List<String> getTrackingIds()
    {
        return scenarioStorage.get("trackingIds");
    }

    @Given("^Create an V3 order with the following attributes:$")
    public void shipperCreateV3Order(List<Map<String, String>> requests) throws Throwable
    {
        orderCreateV3Client = OrderCreateHelper.getVersion3Client();

        for(Map<String, String> request : requests)
        {
            sendOrderCreateV3Req(request);
        }

        TestUtils.pause1s();
    }

    private String createV3Order(Map<String, String> arg1) throws Throwable
    {
        createOrderRequests.clear();
        com.nv.qa.model.order_creation.v3.CreateOrderRequest x = JsonHelper.mapToObject(arg1, com.nv.qa.model.order_creation.v3.CreateOrderRequest.class);
        //-- fix keywords
        OrderCreateHelper.populateRequest(x);
        createOrderRequests.add(x);
        return JsonHelper.toJson(createOrderRequests);
    }

    @SuppressWarnings("unchecked")
    private void sendOrderCreateV3Req(Map<String, String> arg1) throws Throwable
    {
        String payload = createV3Order(arg1);
        Response r = orderCreateV3Client.getCreateOrderResponse(payload);
        r.then().statusCode(200);
        r.then().contentType(ContentType.JSON);
        String json = r.then().extract().body().asString();
        Assert.assertNotNull("Response json not null", json);

        createOrderResponses = JsonHelper.fromJsonCollection(json, List.class, com.nv.qa.model.order_creation.v3.CreateOrderResponse.class);
        Assert.assertNotNull("Response pojo not null", createOrderResponses);
        Assert.assertEquals("Size", createOrderRequests.size(), createOrderResponses.size());

        int idx = 0;

        for(com.nv.qa.model.order_creation.v3.CreateOrderResponse x : createOrderResponses)
        {
            Assert.assertNotNull("Async id", x.getId());
            Assert.assertEquals("Status", "SUCCESS", x.getStatus());
            Assert.assertNotNull("Message", x.getMessage());
            Assert.assertEquals("Order ref No", createOrderRequests.get(idx++).getOrderRefNo(), x.getOrderRefNo());
            Assert.assertNotNull("Tracking ID", x.getTrackingId());
            Assert.assertEquals("Tracking id length", 18, x.getTrackingId().length());

            scenarioStorage.put(ScenarioStorage.KEY_TRACKING_ID, x.getTrackingId());
        }
    }
}
