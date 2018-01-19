package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.client.order_create.OrderCreateClientV3;
import co.nvqa.commons.constants.HttpConstants;
import co.nvqa.commons.cucumber.glue.StandardApiShipperSteps;
import co.nvqa.commons.model.order_create.v3.AsyncResponse;
import co.nvqa.commons.model.order_create.v3.OrderRequestV3;
import co.nvqa.commons.support.JsonHelper;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.util.OrderCreateHelper;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.Assert;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiShipperExtSteps extends StandardApiShipperSteps<ScenarioManager>
{
    private OrderCreateClientV3 orderCreateClientV3;
    List<OrderRequestV3> listOfOrderRequestV3 = new ArrayList<>();
    List<AsyncResponse> listOfAsyncResponseV3 = new ArrayList<>();

    @Inject
    public ApiShipperExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage, TestConstants.SHIPPER_V2_CLIENT_ID, TestConstants.SHIPPER_V2_CLIENT_SECRET);
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

        listOfAsyncResponseV3 = JsonHelper.fromJsonCollection(JsonHelper.getDefaultSnakeCaseMapper(), json, List.class, AsyncResponse.class);
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
