package com.nv.qa.cucumber.glue.step;

import com.nv.qa.api.client.order_create.OrderCreateV3Client;
import com.nv.qa.model.order_creation.v3.CreateOrderRequest;
import com.nv.qa.model.order_creation.v3.CreateOrderResponse;
import com.nv.qa.selenium.page.page.ShipmentManagementPage;
import com.nv.qa.selenium.page.page.ShipmentScanningPage;
import com.nv.qa.support.*;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by lanangjati
 * on 9/26/16.
 */
@ScenarioScoped
public class ShipmentScanningStep {

    private WebDriver driver;
    static final int TRACKING_ID_LENGTH = 18; //-- for V3, e.g. NVSGSHAUN000000149
    static final String STATUS_SUCCESS = "SUCCESS";
    String payload;

    //-- create order
    List<CreateOrderRequest> createOrderRequests = new ArrayList<>();
    List<CreateOrderResponse> createOrderResponses = new ArrayList<>();
    int shipperId = 0;
    String shipmentId = "";
    String trackingId = "";

    //-- client
    OrderCreateV3Client orderCreateV3Client;
    private ShipmentManagementPage shipmentManagementPage;
    private ShipmentScanningPage scanningPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        shipmentManagementPage = new ShipmentManagementPage(driver);
        scanningPage = new ShipmentScanningPage(driver);
    }

    @Given("^Create an V3 order with the following attributes:$")
    public void createOrderV3(List<Map<String, String>> orders) throws Throwable {
        shipperId = APIEndpoint.SHIPPER_ID;
        orderCreateV3Client = OrderCreateHelper.getVersion3Client();

        for (Map<String, String> order : orders) {
            createV3Order(order);
            sendOrderCreateV3Req();
        }

        CommonUtil.pause1s();
    }

    public void createV3Order(Map<String, String> arg1) throws Throwable {
        createOrderRequests.clear();
        CreateOrderRequest x = JsonHelper.mapToObject(arg1, CreateOrderRequest.class);
        //-- fix keywords
        OrderCreateHelper.populateRequest(x);
        createOrderRequests.add(x);
        payload = JsonHelper.toJson(createOrderRequests);
    }

    @SuppressWarnings("unchecked")
    public void sendOrderCreateV3Req() throws Throwable {
        Response r = orderCreateV3Client.getCreateOrderResponse(payload);
        r.then().statusCode(200);
        r.then().contentType(ContentType.JSON);
        String json = r.then().extract().body().asString();
        Assert.assertNotNull("Response json not null", json);

        createOrderResponses = JsonHelper.fromJsonCollection(json, List.class, CreateOrderResponse.class);
        Assert.assertNotNull("Response pojo not null", createOrderResponses);
        Assert.assertEquals("Size", createOrderResponses.size(), createOrderRequests.size());

        int idx = 0;
        for (CreateOrderResponse x : createOrderResponses) {
            Assert.assertNotNull("Asyng id", x.getId());
            Assert.assertEquals("Status", x.getStatus(), STATUS_SUCCESS);
            Assert.assertNotNull("Message", x.getMessage());
            Assert.assertEquals("Order ref No", x.getOrderRefNo(), createOrderRequests.get(idx++).getOrderRefNo());
            Assert.assertNotNull("Tracking ID", x.getTrackingId());
            Assert.assertEquals("Tracking id length", x.getTrackingId().length(), TRACKING_ID_LENGTH);

            trackingId = x.getTrackingId();
            System.out.println(trackingId);
        }
    }

    @When("^choose hub ([^\"]*)$")
    public void choose_hub_JKB(String hub) throws Throwable {
        scanningPage.selectHub(hub);
    }

    @Then("^get first shipment for shipment scanning$")
    public void get_first_shipment() throws Throwable {
        ShipmentManagementPage.Shipment shipment = shipmentManagementPage.getShipmentFromTable(0);
        shipmentId = shipment.getId();
    }

    @When("^choose above shipment$")
    public void choose_above_shipment() throws Throwable {
        scanningPage.selectShipment(shipmentId);
        CommonUtil.clickBtn(driver, ShipmentScanningPage.XPATH_SELECT_SHIPMENT_BUTTON);
    }

    @When("^scan order to shipment$")
    public void scan_order_to_shipment() throws Throwable {
        CommonUtil.inputText(driver, ShipmentScanningPage.XPATH_BARCODE_SCAN, trackingId + "\n");
    }

    @Then("^order in shipment$")
    public void order_in_shipment() throws Throwable {
        scanningPage.checkOrderInShipment(trackingId);
    }
}
