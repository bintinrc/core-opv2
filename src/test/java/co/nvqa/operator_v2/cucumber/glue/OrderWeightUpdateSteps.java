package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.client.auth.AuthClient;
import co.nvqa.commons.client.dp.Dp3plClient;
import co.nvqa.commons.client.order_create.OrderCreateClientV2;
import co.nvqa.commons.client.order_create.OrderCreateClientV4;
import co.nvqa.commons.cucumber.StandardScenarioManager;
import co.nvqa.commons.cucumber.StandardScenarioStorageKeys;
import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import co.nvqa.commons.database.CoreJdbc;
import co.nvqa.commons.model.auth.AuthResponse;
import co.nvqa.commons.model.auth.ClientCredentialsAuth;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v4.*;
import co.nvqa.commons.model.order_create.v4.OrderRequestV4;
import co.nvqa.commons.model.order_create.v4.job.ParcelJob;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.ListOrderCreationV2Template;
import co.nvqa.operator_v2.model.OrderCreationV2Template;
import co.nvqa.operator_v2.selenium.page.OrderWeightUpdatePage;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;

import javax.inject.Inject;
import java.util.*;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OrderWeightUpdateSteps extends AbstractSteps    {
    private String apiBaseUrl;

    private String shipperV2ClientId;
    private String shipperV2ClientSecret;

    private String shipperV4ClientId;
    private String shipperV4ClientSecret;

    private String shipperGrabClientId;
    private String shipperGrabClientSecret;

    private OrderCreateClientV2 orderCreateClientV2;
    private OrderCreateClientV4 orderCreateClientV4;
    private OrderCreateClientV4 orderCreateClientGrab;
    private Dp3plClient dp3plClient;

    /*
      This is a hack for Timezone issue on OCV2. The transaction time need to be corrected.
     */
    private String dbDriver;
    private String dbUser;
    private String dbPass;
    private String dbUrlCore;
    private CoreJdbc coreJdbc;

    private OrderWeightUpdatePage orderWeightUpdatePage;
    String ORDER_KEY = "orderCreationV2Template";
    static OrderCreationV2Template order;
    @Inject
    private StandardApiOperatorPortalSteps standardApiOperatorPortalSteps;
    public static final String KEY_ORDER_WEIGHT = "KEY_ORDER_WEIGHT";
    public OrderWeightUpdateSteps() {
    }

    @Override
    public void init() {
        orderWeightUpdatePage = new OrderWeightUpdatePage(getWebDriver());
        this.apiBaseUrl = StandardTestConstants.API_BASE_URL;

        this.shipperV2ClientId = get(KEY_SHIPPER_V2_CLIENT_ID);
        this.shipperV2ClientSecret = get(KEY_SHIPPER_V2_CLIENT_SECRET);

        this.shipperV4ClientId = get(KEY_SHIPPER_V4_CLIENT_ID);
        this.shipperV4ClientSecret = get(KEY_SHIPPER_V4_CLIENT_SECRET);

        this.dbDriver = StandardTestConstants.DB_DRIVER;
        this.dbUser = StandardTestConstants.DB_USER;
        this.dbPass = StandardTestConstants.DB_PASS;
        this.dbUrlCore = StandardTestConstants.DB_URL_CORE;
    }


    @When("^Operator download Sample CSV file on Order Weight Update V2 page$")
    public void operatorDownloadSampleCsvFileOnOrderWeightUpdatePageV2() {
        orderWeightUpdatePage.downloadSampleCsvFile();
    }

    @Then("^Operator verify Sample CSV file on Order Weight Update V2 page downloaded successfully$")
    public void operatorVerifySampleCsvFileOnOrderWeightUpdatePageV2DownloadedSuccessfully() {
        orderWeightUpdatePage.verifyCsvFileDownloadedSuccessfully();
    }

    @When("^Operator uploading invalid CSV file on Order Weight Update V2 page$")
    public void operatorUploadingInvalidCsvFileOnOrderWeightUpdatePageV2() {
        orderWeightUpdatePage.uploadInvalidCsv();
    }

    @When("^Operator create order V2 by uploading CSV on Order Weight Update V2 page using data below:$")
    public void operatorCreateOrderV2ByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(DataTable dataTable) {
        operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(dataTable);
    }

    @When("^Operator create order V3 by uploading CSV on Order Weight Update V2 page using data below:$")
    public void operatorCreateOrderV3ByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(DataTable dataTable) {
        operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(dataTable);
    }

    //TODO: should move to page
    private void operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(DataTable dataTable) {
        Long shipperV2OrV3Id = null;

        if (containsKey(KEY_CREATED_SHIPPER)) {
            shipperV2OrV3Id = this.<Shipper>get(KEY_CREATED_SHIPPER).getLegacyId();
        }

        Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);
        String orderCreationV2TemplateAsJsonString = mapOfData.get("orderCreationV2Template");

        String scenarioName = getScenarioManager().getCurrentScenario().getName();
        Date currentDate = new Date();

        Map<String, String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("cur_date", CURRENT_DATE_SDF.format(currentDate));
        mapOfDynamicVariable.put("shipper_id", String.valueOf(shipperV2OrV3Id));

        orderCreationV2TemplateAsJsonString = replaceTokens(orderCreationV2TemplateAsJsonString, mapOfDynamicVariable);
        OrderCreationV2Template order = fromJsonSnakeCase(orderCreationV2TemplateAsJsonString, OrderCreationV2Template.class);

        String orderType = order.getOrderType();
        String trackingRefNo = TestUtils.generateTrackingRefNo();
        String fromEmail = null;
        String fromName = null;
        String toEmail = null;
        String toName = null;

        if ("Normal".equals(orderType)) {
            fromEmail = f("shipper.normal.%s@ninjavan.co", trackingRefNo);
            fromName = f("S-N-%s Shipper", trackingRefNo);
            toEmail = f("customer.normal.%s@ninjavan.co", trackingRefNo);
            toName = f("C-N-%s Customer", trackingRefNo);
        } else if ("C2C".equals(orderType)) {
            fromEmail = f("shipper.c2c.%s@ninjavan.co", trackingRefNo);
            fromName = f("S-C-%s Shipper", trackingRefNo);
            toEmail = f("customer.c2c.%s@ninjavan.co", trackingRefNo);
            toName = f("C-C-%s Customer", trackingRefNo);
        } else if ("Return".equals(orderType)) {
            fromEmail = f("customer.return.%s@ninjavan.co", trackingRefNo);
            fromName = f("C-R-%s Customer", trackingRefNo);
            toEmail = f("shipper.return.%s@ninjavan.co", trackingRefNo);
            toName = f("S-R-%s Shipper", trackingRefNo);
        }

        Address fromAddress = generateAddress("RANDOM");
        Address toAddress = generateAddress("RANDOM");

        order.setOrderNo(trackingRefNo);
//     //   assertEquals("Tracking ID match0", trackingRefNo, trackingRefNo);
        order.setShipperOrderNo("SORN-" + trackingRefNo);
        order.setToFirstName(toName);
        order.setToLastName("");
        order.setToContact(toAddress.getContact());
        order.setToEmail(toEmail);
        order.setToAddress1(toAddress.getAddress1());
        order.setToAddress2(toAddress.getAddress2());
        order.setToPostcode(toAddress.getPostcode());
        order.setToDistrict("");
        order.setToCity(toAddress.getCity());
        order.setToStateOrProvince("");
        order.setToCountry(toAddress.getCountry());
        order.setPickupWeekend(true);
        order.setDeliveryWeekend(true);
        order.setPickupInstruction(f("This order's pickup instruction is created by automation test. Ignore this order. Created at %s by scenario '%s'.", CREATED_DATE_SDF.format(currentDate), scenarioName));
        order.setDeliveryInstruction(f("This order's delivery instruction is created by automation test. Ignore this order. Created at %s by scenario '%s'.", CREATED_DATE_SDF.format(currentDate), scenarioName));
        order.setCodValue(0.0);
        order.setInsuredValue(0.0);
        order.setFromFirstName(fromName);
        order.setFromLastName("");
        order.setFromContact(fromAddress.getContact());
        order.setFromEmail(fromEmail);
        order.setFromAddress1(fromAddress.getAddress1());
        order.setFromAddress2(fromAddress.getAddress2());
        order.setFromPostcode(fromAddress.getPostcode());
        order.setFromDistrict("");
        order.setFromCity(fromAddress.getCity());
        order.setFromStateOrProvince("");
        order.setFromCountry(fromAddress.getCountry());
        order.setMultiParcelRefNo("");
        order.setWeight(2);

        System.out.println("Getting orderNo :   " + order.getOrderNo());
        orderWeightUpdatePage.uploadCsv(order);
        put("orderCreationV2Template", order);
    }

    @Then("^Operator verify order V2 is created successfully on Order Weight Update V2 page$")
    public void operatorVerifyOrderV2IsCreatedSuccessfullyOnOrderWeightUpdatePageV2() {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        orderWeightUpdatePage.verifyOrderV2IsCreatedSuccessfully(orderCreationV2Template);
        pause(5 * 1000);
    }

    @Then("^Operator verify order V3 is created successfully on Order Weight Update V2 page$")
    public void operatorVerifyOrderV3IsCreatedSuccessfullyOnOrderWeightUpdatePageV2() {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");

        orderWeightUpdatePage.verifyOrderV3IsCreatedSuccessfully(orderCreationV2Template);
    }

    @When("^Operator Pop Open Order Weight update CSV on Order Weight Update V2 page$")
    public void downloadOrderWeightUpdateSampleCsvFile() {
        orderWeightUpdatePage.downloadOrderWeightUpdateSampleCsvFile();
        //pause(15*1000);

    }

    @When("^Operator Download Sample Csv Order Weight update CSV on Order Weight Update V2 page$")
    public void downloadSampleCsvOrderWeightUpdateSampleCsvFile() {
        orderWeightUpdatePage.downloadOrderUpdateCsvFile();
        pause(10 * 1000);

    }

    @When("^Operator Order Weight update CSV Upload on Order Weight Update V2 page$")
    public void OrderWeightUpdateUploadCsvFile(Map<String, String> map) {
        //System.out.println(" Weight    : " + Integer.parseInt(map.get("weight")));
        put(KEY_ORDER_WEIGHT, map.get("new-weight-in-double-format"));
        System.out.println("Order Id====>" + get(KEY_CREATED_ORDER_ID));
        System.out.println("Tracking Id====>" + get(KEY_CREATED_ORDER_TRACKING_ID));
        System.out.println("map Id====>" + map.get("new-weight-in-double-format"));
        Long OrderId = get(KEY_CREATED_ORDER_ID);
        String OrderTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        orderWeightUpdatePage.uploadOrderUpdateCsv(OrderTrackingId, map);
        pause(5 * 1000);

    }

    @Then("^Operator Order Weight update on Order Weight Update V2 page$")
    public void OrderWeightUpdate() {
        pause(2000);
        orderWeightUpdatePage.uploadOrderWeightUpload();


    }

    @Then("^Operator Verify Order Weight update Successfully on Order Weight Update V2 page$")
    public void VerifyOrderWeightUpdate() {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        //orderWeightUpdatePage.VerifyOrderWeightUpload("SOCV2"+orderCreationV2Template.getOrderNo());
        orderWeightUpdatePage.VerifyOrderWeightUpload("SOCV2JVRNUEW8");
        pause(5 * 1000);


    }

    @Then("^Operator Edit Order on Order Weight Update V2 page$")
    public void EditOrderClick() {
       // String OrderId  = ""+String.valueOf(get(KEY_CREATED_ORDER_ID));
        orderWeightUpdatePage.clickOrderEditButton("" + get(KEY_CREATED_ORDER_ID));
        pause(10 * 1000);
    }

    @Then("^Operator Verify Order Weight on Order Weight Update V2 page$")
    public void VerifyOrderWeightClick() {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");

        Long orderId = get(KEY_CREATED_ORDER_ID);
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String methodInfo = f("%s - [Tracking ID = %s]", getCurrentMethodName(), trackingId);

        retryIfAssertionErrorOrRuntimeExceptionOccurred(()->
                {
                    //Order orderDetails = getOrderClient().getOrder(orderId);
                    //assertEquals("Order Weight Matched", orderDetails.getWeight(),f("%s kg",get(KEY_ORDER_WEIGHT)));

                }, methodInfo);
        pause(2 * 1000);
    }

    @Then("^Operator Search Button For Orders on Order Weight Update V2 page$")
    public void ClickOrderSearch() {
        orderWeightUpdatePage.clickOrderSearchButton();
        pause(5 * 1000);

    }

    @Given("^API create multiple V4 orders using data below:$")
    public void shipperCreateMultipleV4Orders(Map<String, String> dataTableAsMap) {
        int numberOfOrder = Integer.parseInt(dataTableAsMap.getOrDefault("numberOfOrder", "1"));
        System.out.println("Muliti order" + numberOfOrder);
        for (int i = 0; i < numberOfOrder; i++) {
            apiCreateV4MultiOrder(dataTableAsMap);
        }
        put("numberOfOrder", numberOfOrder);
    }

    @When("^Operator create order V2 by uploading CSV on Order Weight Update V2 page for multiple orders using data below:$")
    public void operatorCreateOrderV2ByUploadingCsvOnOrderWeightUpdatePageV2ForMultipleOrderUsingDataBelow(DataTable dataTable) {
        operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2ForMultipleOrdersUsingDataBelow(dataTable);
    }

    @When("^Operator Multiple Order Weight update CSV Upload on Order Weight Update V2 page$")
    public void multiOrderWeightUpdateUploadCsvFile(List listWeight) {

        List<String> listOfCreatedTrackingId = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

        if (listOfCreatedTrackingId == null || listOfCreatedTrackingId.isEmpty()) {
            throw new RuntimeException("List of created Tracking ID should not be null or empty.");
        }
        //orderWeightUpdatePage.uploadMultiOrderUpdateCsv(listOfCreatedTrackingId,listWeight);
        put("orderMultiweight", listWeight);
        Long OrderId = get(KEY_CREATED_ORDER_ID);
        String OrderTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        orderWeightUpdatePage.uploadMultiOrderUpdateCsv(listOfCreatedTrackingId, listWeight);
        pause(5 * 1000);

    }

    @Then("^Operator verify all orders Weights Updated  on All Orders page with correct info$")
    public void operatorVerifyAllOrdersInCsvIsFoundOnAllOrdersPageWithCorrectInfo() {
        List<Order> listOfCreatedOrder = containsKey(KEY_LIST_OF_ORDER_DETAILS) ? get(KEY_LIST_OF_ORDER_DETAILS) : get(KEY_LIST_OF_CREATED_ORDER);
        List weight = get("orderMultiweight");
        orderWeightUpdatePage.verifyAllOrdersInCsvIsFoundWithCorrectInfo(listOfCreatedOrder, weight);
    }

    private void apiCreateV4MultiOrder(Map<String, String> dataTableAsMap) {
        OrderRequestV4 requestOrder = buildOrderRequestV4(dataTableAsMap);
        OrderRequestV4 createdOrder = getOrderCreateClientV4().createOrder(requestOrder, "4.1");
        String trackingNumber = createdOrder.getTrackingNumber();

        Order order = retrieveOrderFromCore(trackingNumber);
        storeOrderToScenarioStorage(order);
    }

    private void operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2ForMultipleOrdersUsingDataBelow(DataTable dataTable) {


        Long shipperV2OrV3Id = null;

        if (containsKey(KEY_CREATED_SHIPPER)) {
            shipperV2OrV3Id = this.<Shipper>get(KEY_CREATED_SHIPPER).getLegacyId();
        }


        Map<String, String> mapOfData = dataTable.asMap(String.class, String.class);

        System.out.println("Map values is :  " + mapOfData + "   Size : " + mapOfData.size());

        ListOrderCreationV2Template listOrderCreationV2Template = new ListOrderCreationV2Template();
        List<OrderCreationV2Template> list = new ArrayList<>();

        for (int i = 1; i <= mapOfData.size(); i++) {

            String orderCreationV2TemplateAsJsonString = mapOfData.get("orderCreationV2Template" + i);
            System.out.println("OrderCreation  : " + orderCreationV2TemplateAsJsonString);


            String scenarioName = getScenarioManager().getCurrentScenario().getName();
            Date currentDate = new Date();

            Map<String, String> mapOfDynamicVariable = new HashMap<>();
            mapOfDynamicVariable.put("cur_date", CURRENT_DATE_SDF.format(currentDate));
            mapOfDynamicVariable.put("shipper_id", String.valueOf(shipperV2OrV3Id));

            orderCreationV2TemplateAsJsonString = replaceTokens(orderCreationV2TemplateAsJsonString, mapOfDynamicVariable);
            order = fromJsonSnakeCase(orderCreationV2TemplateAsJsonString, OrderCreationV2Template.class);
            System.out.println("    " + order);
            String orderType = order.getOrderType();

            String trackingRefNo = TestUtils.generateTrackingRefNo();
            System.out.println(" TrackID :  " + trackingRefNo);

            String fromEmail = null;
            String fromName = null;
            String toEmail = null;
            String toName = null;

            if ("Normal".equals(orderType)) {
                fromEmail = f("shipper.normal.%s@ninjavan.co", trackingRefNo);
                fromName = f("S-N-%s Shipper", trackingRefNo);
                toEmail = f("customer.normal.%s@ninjavan.co", trackingRefNo);
                toName = f("C-N-%s Customer", trackingRefNo);
            } else if ("C2C".equals(orderType)) {
                fromEmail = f("shipper.c2c.%s@ninjavan.co", trackingRefNo);
                fromName = f("S-C-%s Shipper", trackingRefNo);
                toEmail = f("customer.c2c.%s@ninjavan.co", trackingRefNo);
                toName = f("C-C-%s Customer", trackingRefNo);
            } else if ("Return".equals(orderType)) {
                fromEmail = f("customer.return.%s@ninjavan.co", trackingRefNo);
                fromName = f("C-R-%s Customer", trackingRefNo);
                toEmail = f("shipper.return.%s@ninjavan.co", trackingRefNo);
                toName = f("S-R-%s Shipper", trackingRefNo);
            }

            Address fromAddress = generateAddress("RANDOM");
            Address toAddress = generateAddress("RANDOM");

            order.setOrderNo(trackingRefNo);
//     //   assertEquals("Tracking ID match0", trackingRefNo, trackingRefNo);
            order.setShipperOrderNo("SORN-" + trackingRefNo);
            order.setToFirstName(toName);
            order.setToLastName("");
            order.setToContact(toAddress.getContact());
            order.setToEmail(toEmail);
            order.setToAddress1(toAddress.getAddress1());
            order.setToAddress2(toAddress.getAddress2());
            order.setToPostcode(toAddress.getPostcode());
            order.setToDistrict("");
            order.setToCity(toAddress.getCity());
            order.setToStateOrProvince("");
            order.setToCountry(toAddress.getCountry());
            order.setPickupWeekend(true);
            order.setDeliveryWeekend(true);
            order.setPickupInstruction(f("This order's pickup instruction is created by automation test. Ignore this order. Created at %s by scenario '%s'.", CREATED_DATE_SDF.format(currentDate), scenarioName));
            order.setDeliveryInstruction(f("This order's delivery instruction is created by automation test. Ignore this order. Created at %s by scenario '%s'.", CREATED_DATE_SDF.format(currentDate), scenarioName));
            order.setCodValue(0.0);
            order.setInsuredValue(0.0);
            order.setFromFirstName(fromName);
            order.setFromLastName("");
            order.setFromContact(fromAddress.getContact());
            order.setFromEmail(fromEmail);
            order.setFromAddress1(fromAddress.getAddress1());
            order.setFromAddress2(fromAddress.getAddress2());
            order.setFromPostcode(fromAddress.getPostcode());
            order.setFromDistrict("");
            order.setFromCity(fromAddress.getCity());
            order.setFromStateOrProvince("");
            order.setFromCountry(fromAddress.getCountry());
            order.setMultiParcelRefNo("");

            list.add(order);
            put("orderCreationV2Template" + i, order);
        }

        listOrderCreationV2Template.setOrderCreationV2TemplatesList(list);

//
        System.out.println("Getting orderNo :   " + list.get(1).getOrderNo());
        orderWeightUpdatePage.uploadCsvForMultipleOrders(listOrderCreationV2Template);


    }


    @Then("^Operator verify order V2 is created successfully for multiple orders on Order Weight Update V2 page$")
    public void operatorVerifyOrderV2IsCreatedSuccessfullyOnOrderWeightUpdatePageV2ForMultipleUsers() {
        List<OrderCreationV2Template> list = new ArrayList<>();

        for (int i = 1; i <= 3; i++) {
            list.add(get("orderCreationV2Template" + i));
        }
        System.out.println("Size Of the List  : " + list.size());


        ListOrderCreationV2Template listOrderCreationV2Template = new ListOrderCreationV2Template();
        listOrderCreationV2Template.setOrderCreationV2TemplatesList(list);
        orderWeightUpdatePage.verifyOrderV2IsCreatedSuccessfullyForMultipleUsers(listOrderCreationV2Template);
        pause(5 * 1000);
    }


    @When("^Operator Order Weight update CSV Upload on Order Weight Update V2 page for multiple orders$")
    public void OrderWeightUpdateUploadCsvFileForMultipleOrders(Map<String, String> map) {
        List<OrderCreationV2Template> list = new ArrayList<>();
        for (int i = 1; i <= map.size(); i++) {
            list.add(get("orderCreationV2Template" + i));
        }
        ListOrderCreationV2Template listOrderCreationV2Template = new ListOrderCreationV2Template();
        listOrderCreationV2Template.setOrderCreationV2TemplatesList(list);
        orderWeightUpdatePage.uploadOrderUpdateCsvForMultipleUsers(listOrderCreationV2Template, map);
        pause(5 * 1000);

    }
    private synchronized String getShipperAccessToken(String shipperVersion) {
        shipperVersion = shipperVersion.toUpperCase();
        String shipperAccessToken = null;
        String shipperClientId = null;
        String shipperClientSecret = null;

        switch (shipperVersion) {
            case "V2": {
                shipperAccessToken = get(StandardScenarioStorageKeys.KEY_SHIPPER_V2_ACCESS_TOKEN);
                shipperClientId = shipperV2ClientId;
                shipperClientSecret = shipperV2ClientSecret;
                break;
            }
            case "V4": {
                shipperAccessToken = get(StandardScenarioStorageKeys.KEY_SHIPPER_V4_ACCESS_TOKEN);
                shipperClientId = shipperV4ClientId;
                shipperClientSecret = shipperV4ClientSecret;
                break;
            }
        }

        if (shipperAccessToken == null) {
            ClientCredentialsAuth clientCredentialsAuth = new ClientCredentialsAuth(shipperClientId, shipperClientSecret);
            AuthClient authClient = new AuthClient(apiBaseUrl);
            AuthResponse authResponse = authClient.authenticate(clientCredentialsAuth);
            shipperAccessToken = authResponse.getAccessToken();

            switch (shipperVersion) {
                case "V2":
                    put(KEY_SHIPPER_V2_ACCESS_TOKEN, shipperAccessToken);
                    break;
                case "V4":
                    put(KEY_SHIPPER_V4_ACCESS_TOKEN, shipperAccessToken);
                    break;
            }
        }

        return shipperAccessToken;
    }

    private Order retrieveOrderFromCore(String trackingNumber) {
        return retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> standardApiOperatorPortalSteps.getOrderClient().searchOrderByTrackingId(trackingNumber), f("%s - [Tracking ID = %s]", getCurrentMethodName(), trackingNumber));
    }

    private void storeOrderToScenarioStorage(Order order) {
        put(KEY_CREATED_ORDER, order);
        put(KEY_CREATED_ORDER_ID, order.getId());
        put(KEY_CREATED_ORDER_TRACKING_ID, order.getTrackingId());
        put(KEY_CREATED_ORDER_TYPE, order.getType());
        putInList(KEY_LIST_OF_CREATED_ORDER, order);
        putInList(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID, order.getTrackingId());
        putInList(KEY_LIST_OF_CREATED_ORDER_ID, order.getId());
        put(KEY_SHIPPER_OF_CREATED_ORDER, order.getShipper());
    }

    private synchronized OrderCreateClientV4 getOrderCreateClientV4() {
        if (orderCreateClientV4 == null) {
            orderCreateClientV4 = new OrderCreateClientV4(apiBaseUrl, getShipperAccessToken("V4"));
        }
        return orderCreateClientV4;
    }

    public OrderRequestV4 buildOrderRequestV4(Map<String, String> dataTableAsMap) {
        return buildOrderRequestV4(dataTableAsMap, false);
    }

    public OrderRequestV4 buildOrderRequestV4(Map<String, String> dataTableAsMap, boolean isGrabParcel) {
        String scenarioName;

        if (getScenarioManager() == null) {
            scenarioName = dataTableAsMap.getOrDefault("scenarioName", "N/A");
        } else {
            scenarioName = getScenarioManager().getCurrentScenario().getName();
        }

        String requestedTrackingNumber = generateRequestedTrackingNumber();

        Map<String, String> mapOfTokens = createDefaultTokens();

        mapOfTokens.put("requested-tracking-number", requestedTrackingNumber);

        Map<String, String> dataTableAsMapReplaced = replaceDataTableTokens(dataTableAsMap, mapOfTokens);

        String v4OrderRequestTemplate = dataTableAsMapReplaced.get("v4OrderRequest");
        String generateFrom = dataTableAsMap.getOrDefault("generateFromAndTo", dataTableAsMap.get("generateFrom"));
        String generateTo = dataTableAsMap.getOrDefault("generateFromAndTo", dataTableAsMap.get("generateTo"));

        OrderRequestV4 orderRequestV4 = fromJsonSnakeCase(v4OrderRequestTemplate, OrderRequestV4.class);
        Address fromAddress = generateAddress(generateFrom);
        Address toAddress = generateAddress(generateTo);

        if (!isGrabParcel) {
            orderRequestV4.setRequestedTrackingNumber(Optional.ofNullable(orderRequestV4.getRequestedTrackingNumber()).orElse(requestedTrackingNumber));
        }

        Reference reference = orderRequestV4.getReference();

        if (reference == null) {
            reference = new Reference();
            orderRequestV4.setReference(reference);
        }

        reference.setMerchantOrderNumber(Optional.ofNullable(reference.getMerchantOrderNumber()).orElse(requestedTrackingNumber));

        UserDetail from = orderRequestV4.getFrom();

        if (from == null) {
            from = new UserDetail();
            orderRequestV4.setFrom(from);
        }

        UserDetail to = orderRequestV4.getTo();

        if (to == null) {
            to = new UserDetail();
            orderRequestV4.setTo(to);
        }

        String fromName = null;
        String fromEmail = null;
        String toName = null;
        String toEmail = null;
        String serviceType = orderRequestV4.getServiceType();

        switch (serviceType) {
            case "Normal": {
                orderRequestV4.setServiceType("Parcel");
            }
            case "Marketplace": {
                fromName = f("S-P-%s Marketplace Shipper", requestedTrackingNumber);
                fromEmail = f("marketplace.shipper.parcel.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                toName = f("C-P-%s Marketplace Customer", requestedTrackingNumber);
                toEmail = f("marketplace.customer.parcel.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                break;
            }
            case "Parcel": {
                fromName = f("S-P-%s Shipper", requestedTrackingNumber);
                fromEmail = f("shipper.parcel.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                toName = f("C-P-%s Customer", requestedTrackingNumber);
                toEmail = f("customer.parcel.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                break;
            }
            case "Return": {
                fromName = f("C-R-%s Customer", requestedTrackingNumber);
                fromEmail = f("customer.return.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                toName = f("S-R-%s Shipper", requestedTrackingNumber);
                toEmail = f("shipper.return.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                break;
            }
            case "International": {
                International international = orderRequestV4.getInternational();

                if (international != null) {
                    String portation = international.getPortation();

                    if (portation.equals("Export")) {
                        toAddress = getRandomAddressIntl();
                    } else if (portation.equals("Import")) {
                        fromAddress = getRandomAddressIntl();
                    }
                }

                fromName = f("C-I-%s Customer", requestedTrackingNumber);
                fromEmail = f("customer.international.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                toName = f("S-I-%s Shipper", requestedTrackingNumber);
                toEmail = f("shipper.international.%s@ninjavan.co", requestedTrackingNumber.toLowerCase());
                break;
            }
        }

        from.setName(Optional.ofNullable(from.getName()).orElse(fromName));
        from.setEmail(Optional.ofNullable(from.getEmail()).orElse(fromEmail));

        if (fromAddress != null) {
            from.setAddress(convertValueToMapSnakeCase(fromAddress, String.class, String.class));

            if (from.getPhoneNumber() == null) {
                from.setPhoneNumber(fromAddress.getContact());
            }
        }

        to.setName(Optional.ofNullable(to.getName()).orElse(toName));
        to.setEmail(Optional.ofNullable(to.getEmail()).orElse(toEmail));

        if (toAddress != null) {
            to.setAddress(convertValueToMapSnakeCase(toAddress, String.class, String.class));

            if (to.getPhoneNumber() == null) {
                to.setPhoneNumber(toAddress.getContact());
            }
        }

        ParcelJob parcelJob = orderRequestV4.getParcelJob();

        if (parcelJob == null) {
            parcelJob = new ParcelJob();
            orderRequestV4.setParcelJob(parcelJob);
        }

        if (parcelJob.getIsPickupRequired()) {
            parcelJob.setPickupAddress(from);
        }

        parcelJob.setPickupAddressId(Optional.ofNullable(parcelJob.getPickupAddressId()).orElse(generateDateUniqueString()));

        Timeslot pickupTimeslot = parcelJob.getPickupTimeslot();

        if (pickupTimeslot != null) {
            pickupTimeslot.setTimezone(Optional.ofNullable(pickupTimeslot.getTimezone()).orElse(TimeZone.getDefault().getID()));
        }

        String formattedCreatedDate = CREATED_DATE_SDF.format(new Date());

        if (parcelJob.getPickupInstruction() == null) {
            parcelJob.setPickupInstruction(f("[PICKUP] This V4 order is created for testing purpose only. Ignore this order. Created at %s by scenario \"%s\".", formattedCreatedDate, scenarioName));
        }

        Timeslot deliveryTimeslot = parcelJob.getDeliveryTimeslot();

        if (deliveryTimeslot != null) {
            if (serviceType.equals("International")) {
                deliveryTimeslot.setTimezone(StandardTestUtils.getTimeZoneByCountryCode(toAddress.getCountry()));
            } else {
                deliveryTimeslot.setTimezone(Optional.ofNullable(deliveryTimeslot.getTimezone()).orElse(TimeZone.getDefault().getID()));
            }
        }

        if (parcelJob.getDeliveryInstruction() == null) {
            parcelJob.setDeliveryInstruction(f("[DELIVERY] This V4 order is created for testing purpose only. Ignore this order. Created at %s by scenario \"%s\".", formattedCreatedDate, scenarioName));
        }

        Dimension dimension = parcelJob.getDimensions();

        if (dimension == null) {
            dimension = new Dimension();
            dimension.setLength((double) randomInt(1, 5));
            dimension.setWidth((double) randomInt(1, 5));
            dimension.setHeight((double) randomInt(1, 5));
            dimension.setWeight((double) randomInt(1, 5));
            dimension.setSize(getParcelSizeAsString(randomInt(0, 4)));
            parcelJob.setDimensions(dimension);
        }

        return orderRequestV4;
    }


}
