package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.OrderCreateHelper;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import com.nv.qa.api.client.order_create.OrderCreateV3Client;
import com.nv.qa.commons.cucumber.glue.StandardApiShipperSteps;
import com.nv.qa.commons.support.JsonHelper;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import com.nv.qa.model.order_creation.v3.CreateOrderRequest;
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
    private OrderCreateV3Client orderCreateV3Client;
    List<CreateOrderRequest> createOrderRequests = new ArrayList<>();
    List<com.nv.qa.model.order_creation.v3.CreateOrderResponse> createOrderResponses = new ArrayList<>();

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
    public void shipperCreateV3Order(List<Map<String, String>> requests)
    {
        orderCreateV3Client = OrderCreateHelper.getVersion3Client();

        for(Map<String, String> request : requests)
        {
            sendOrderCreateV3Req(request);
        }

        pause1s();
    }

    private String createV3Order(Map<String, String> arg1)
    {
        createOrderRequests.clear();
        com.nv.qa.model.order_creation.v3.CreateOrderRequest x = JsonHelper.mapToObject(arg1, com.nv.qa.model.order_creation.v3.CreateOrderRequest.class);
        //-- fix keywords
        OrderCreateHelper.populateRequest(x);
        createOrderRequests.add(x);
        return JsonHelper.toJson(createOrderRequests);
    }

    @SuppressWarnings("unchecked")
    private void sendOrderCreateV3Req(Map<String, String> arg1)
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

            getScenarioStorage().put(KEY_CREATED_ORDER_TRACKING_ID, x.getTrackingId());
        }
    }
}
