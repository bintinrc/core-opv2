package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.api.client.order_create.OrderCreateV2Client;
import com.nv.qa.model.order_creation.authentication.AuthRequest;
import com.nv.qa.model.order_creation.v2.CreateOrderRequest;
import com.nv.qa.model.order_creation.v2.CreateOrderResponse;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

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
public class CommonShipperStep extends AbstractSteps
{
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    private static final SimpleDateFormat CURRENT_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd");

    @Inject private ScenarioStorage scenarioStorage;
    private OrderCreateV2Client orderCreateV2Client;

    @Inject
    public CommonShipperStep(CommonScenario commonScenario)
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
        Order order = orderCreateV2Client.retrieveOrder(asyncOrderId);
        scenarioStorage.put("order", order);
    }
}
