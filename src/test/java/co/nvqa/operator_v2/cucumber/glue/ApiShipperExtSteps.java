package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.client.order_create.OrderCreateClientV3;
import co.nvqa.commons.client.order_create.OrderCreateClientV4;
import co.nvqa.commons.constants.HttpConstants;
import co.nvqa.commons.cucumber.glue.StandardSteps;
import co.nvqa.commons.model.order_create.v3.AsyncResponse;
import co.nvqa.commons.model.order_create.v3.OrderRequestV3;
import co.nvqa.commons.model.order_create.v4.OrderRequestV4;
import co.nvqa.commons.support.JsonHelper;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.util.OrderCreateHelper;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.Assert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiShipperExtSteps extends StandardSteps<ScenarioManager>
{
    private OrderCreateClientV3 orderCreateClientV3;
    private final List<OrderRequestV3> listOfOrderRequestV3 = new ArrayList<>();

    @Inject
    public ApiShipperExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @Given("^Create an V3 order with the following attributes:$")
    public void shipperCreateV3Order(List<Map<String, String>> listOfRequest)
    {
        orderCreateClientV3 = OrderCreateHelper.getOrderCreateClientV3();

        for(Map<String,String> request : listOfRequest)
        {
            sendOrderCreateV3Req(request);
        }

        pause1s();
    }

    @Given("^Create an V4 order with the following attributes:$")
    public void shipperCreateV4Order(Map<String,String> mapOfData) {
        OrderRequestV4 response = createV4Order(mapOfData);
        put(KEY_CREATED_ORDER_TRACKING_ID, response.getTrackingNumber());
    }

    @Given("^Create multiple V4 orders with the following attributes:$")
    public void shipperCreateMultipleV4Orders(Map<String,String> mapOfData) {
        int numberOfOrder = Integer.parseInt(mapOfData.getOrDefault("numberOfOrder", "1"));
        List<String> orderTrackingIds = new ArrayList<>();
        for (int i=0; i<numberOfOrder; i++){
            OrderRequestV4 response = createV4Order(mapOfData);
            orderTrackingIds.add(response.getTrackingNumber());
        }
        put(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID, orderTrackingIds);
    }

    private OrderRequestV4 createV4Order(Map<String,String> mapOfData){
        String v4OrderRequestTemplate = mapOfData.get("v4OrderRequest");
        String shipperRefNo = generateShipperRefNo();
        String pickupDate = PICKUP_OR_DELIVERY_DATE_FORMAT.format(getNextDate(1));

        Map<String, String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("shipper-order-ref-no", shipperRefNo);
        mapOfDynamicVariable.put("tmp-pickup-date", pickupDate);
        String orderRequestV4Json = replaceParam(v4OrderRequestTemplate, mapOfDynamicVariable);

        OrderRequestV4 orderRequestV4 = JsonHelper.fromJson(JsonHelper.getDefaultSnakeCaseMapper(), orderRequestV4Json, OrderRequestV4.class);
        OrderCreateClientV4 orderCreateClientV4 = OrderCreateHelper.getOrderCreateClientV4();
        return orderCreateClientV4.createOrder(orderRequestV4);
    }

    private OrderRequestV3 createV3Order(Map<String, String> arg1)
    {
        listOfOrderRequestV3.clear();
        OrderRequestV3 orderRequestV3 = JsonHelper.mapToObject(JsonHelper.getDefaultSnakeCaseMapper(), arg1, OrderRequestV3.class);
        OrderCreateHelper.populateRequest(orderRequestV3);
        listOfOrderRequestV3.add(orderRequestV3);
        return orderRequestV3;
    }

    @SuppressWarnings("unchecked")
    private void sendOrderCreateV3Req(Map<String, String> arg1)
    {
        OrderRequestV3 orderRequestV3 = createV3Order(arg1);
        Response response = orderCreateClientV3.createOrderAsyncAndGetRawResponse(orderRequestV3);
        response.then().statusCode(HttpConstants.RESPONSE_200_SUCCESS);
        response.then().contentType(ContentType.JSON);
        String json = response.then().extract().body().asString();
        Assert.assertNotNull("Response json not null", json);

        List<AsyncResponse> listOfAsyncResponseV3 = JsonHelper.fromJsonCollection(JsonHelper.getDefaultSnakeCaseMapper(), json, List.class, AsyncResponse.class);
        Assert.assertNotNull("Response POJO not null", listOfAsyncResponseV3);
        Assert.assertEquals("Size", listOfOrderRequestV3.size(), listOfAsyncResponseV3.size());

        int idx = 0;

        for(AsyncResponse asyncResponseV3 : listOfAsyncResponseV3)
        {
            Assert.assertNotNull("Async id", asyncResponseV3.getId());
            Assert.assertEquals("Status", "SUCCESS", asyncResponseV3.getStatus());
            Assert.assertNotNull("Message", asyncResponseV3.getMessage());
            Assert.assertEquals("Order ref No", listOfOrderRequestV3.get(idx++).getOrderRefNo(), asyncResponseV3.getOrderRefNo());
            Assert.assertNotNull("Tracking ID", asyncResponseV3.getTrackingId());
            Assert.assertEquals("Tracking id length", 18, asyncResponseV3.getTrackingId().length());
            put(KEY_CREATED_ORDER_TRACKING_ID, asyncResponseV3.getTrackingId());
        }
    }
}
