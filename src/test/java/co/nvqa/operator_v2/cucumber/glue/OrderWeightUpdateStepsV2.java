package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.operator_v2.model.ListOrderCreationV2Template;
import co.nvqa.operator_v2.model.OrderCreationV2Template;
import co.nvqa.operator_v2.selenium.page.OrderWeightUpdatePageV2;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;

import java.util.*;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OrderWeightUpdateStepsV2 extends AbstractSteps
{
    private OrderWeightUpdatePageV2 orderWeightUpdatePageV2;
    String ORDER_KEY = "orderCreationV2Template";
    static OrderCreationV2Template order;
    public OrderWeightUpdateStepsV2()
    {
    }

    @Override
    public void init()
    {
        orderWeightUpdatePageV2 = new OrderWeightUpdatePageV2(getWebDriver());
    }

    @When("^Operator download Sample CSV file on Order Weight Update V2 page$")
    public void operatorDownloadSampleCsvFileOnOrderWeightUpdatePageV2()
    {
        orderWeightUpdatePageV2.downloadSampleCsvFile();
    }

    @Then("^Operator verify Sample CSV file on Order Weight Update V2 page downloaded successfully$")
    public void operatorVerifySampleCsvFileOnOrderWeightUpdatePageV2DownloadedSuccessfully()
    {
        orderWeightUpdatePageV2.verifyCsvFileDownloadedSuccessfully();
    }

    @When("^Operator uploading invalid CSV file on Order Weight Update V2 page$")
    public void operatorUploadingInvalidCsvFileOnOrderWeightUpdatePageV2()
    {
        orderWeightUpdatePageV2.uploadInvalidCsv();
    }

    @When("^Operator create order V2 by uploading CSV on Order Weight Update V2 page using data below:$")
    public void operatorCreateOrderV2ByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(DataTable dataTable)
    {
        operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(dataTable);
    }

    @When("^Operator create order V3 by uploading CSV on Order Weight Update V2 page using data below:$")
    public void operatorCreateOrderV3ByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(DataTable dataTable)
    {
        operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(dataTable);
    }

    //TODO: should move to page
    private void operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2UsingDataBelow(DataTable dataTable)
    {
        Long shipperV2OrV3Id = null;

        if(containsKey(KEY_CREATED_SHIPPER))
        {
            shipperV2OrV3Id = this.<Shipper>get(KEY_CREATED_SHIPPER).getLegacyId();
        }

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String orderCreationV2TemplateAsJsonString = mapOfData.get("orderCreationV2Template");

        String scenarioName = getScenarioManager().getCurrentScenario().getName();
        Date currentDate = new Date();

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
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

        if("Normal".equals(orderType))
        {
            fromEmail = f("shipper.normal.%s@ninjavan.co", trackingRefNo);
            fromName = f("S-N-%s Shipper", trackingRefNo);
            toEmail = f("customer.normal.%s@ninjavan.co", trackingRefNo);
            toName = f("C-N-%s Customer", trackingRefNo);
        }
        else if("C2C".equals(orderType))
        {
            fromEmail = f("shipper.c2c.%s@ninjavan.co", trackingRefNo);
            fromName = f("S-C-%s Shipper", trackingRefNo);
            toEmail = f("customer.c2c.%s@ninjavan.co", trackingRefNo);
            toName = f("C-C-%s Customer", trackingRefNo);
        }
        else if("Return".equals(orderType))
        {
            fromEmail = f("customer.return.%s@ninjavan.co", trackingRefNo);
            fromName = f("C-R-%s Customer", trackingRefNo);
            toEmail = f("shipper.return.%s@ninjavan.co", trackingRefNo);
            toName = f("S-R-%s Shipper", trackingRefNo);
        }

        Address fromAddress = generateAddress("RANDOM");
        Address toAddress = generateAddress("RANDOM");

        order.setOrderNo(trackingRefNo);
//     //   assertEquals("Tracking ID match0", trackingRefNo, trackingRefNo);
        order.setShipperOrderNo("SORN-"+trackingRefNo);
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

        System.out.println("Getting orderNo :   "+order.getOrderNo());
        orderWeightUpdatePageV2.uploadCsv(order);
        put("orderCreationV2Template", order);
    }

    @Then("^Operator verify order V2 is created successfully on Order Weight Update V2 page$")
    public void operatorVerifyOrderV2IsCreatedSuccessfullyOnOrderWeightUpdatePageV2()
    {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        orderWeightUpdatePageV2.verifyOrderV2IsCreatedSuccessfully(orderCreationV2Template);
        pause(5*1000);
    }

    @Then("^Operator verify order V3 is created successfully on Order Weight Update V2 page$")
    public void operatorVerifyOrderV3IsCreatedSuccessfullyOnOrderWeightUpdatePageV2()
    {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");

        orderWeightUpdatePageV2.verifyOrderV3IsCreatedSuccessfully(orderCreationV2Template);
    }
    @When("^Operator Pop Open Order Weight update CSV on Order Weight Update V2 page$")
    public void downloadOrderWeightUpdateSampleCsvFile()
    {
        orderWeightUpdatePageV2.downloadOrderWeightUpdateSampleCsvFile();
        //pause(15*1000);

    }
    @When("^Operator Download Sample Csv Order Weight update CSV on Order Weight Update V2 page$")
    public void downloadSampleCsvOrderWeightUpdateSampleCsvFile()
    {
        orderWeightUpdatePageV2.downloadOrderUpdateCsvFile();
        pause(10*1000);

    }
    @When("^Operator Order Weight update CSV Upload on Order Weight Update V2 page$")
    public void OrderWeightUpdateUploadCsvFile(Map<String ,String> map)
    {
        System.out.println(" Weight    : "+Integer.parseInt(map.get("weight")));

        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        orderWeightUpdatePageV2.uploadOrderUpdateCsv(orderCreationV2Template,map);
        pause(5*1000);

    }
    @Then("^Operator Order Weight update on Order Weight Update V2 page$")
    public void OrderWeightUpdate()
    {
        pause(5*1000);
        orderWeightUpdatePageV2.uploadOrderWeightUpload();


    }
    @Then("^Operator Verify Order Weight update Successfully on Order Weight Update V2 page$")
    public void VerifyOrderWeightUpdate()
    {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        //orderWeightUpdatePageV2.VerifyOrderWeightUpload("SOCV2"+orderCreationV2Template.getOrderNo());
        orderWeightUpdatePageV2.VerifyOrderWeightUpload("SOCV2JVRNUEW8");
        pause(5*1000);


    }
    @Then("^Operator Edit Order on Order Weight Update V2 page$")
    public void EditOrderClick()
    {
        orderWeightUpdatePageV2.clickOrderEditButton();
        pause(10*1000);
    }

    @Then("^Operator Verify Order Weight on Order Weight Update V2 page$")
    public void VerifyOrderWeightClick()
    {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        orderWeightUpdatePageV2.MatchOrderWeight(orderCreationV2Template.getWeight());
        pause(10*1000);
    }
    @Then("^Operator Search Button For Orders on Order Weight Update V2 page$")
    public void ClickOrderSearch()
    {
        orderWeightUpdatePageV2.clickOrderSearchButton();
        pause(5*1000);

    }


    @When("^Operator create order V2 by uploading CSV on Order Weight Update V2 page for multiple orders using data below:$")
    public void operatorCreateOrderV2ByUploadingCsvOnOrderWeightUpdatePageV2ForMultipleOrderUsingDataBelow(DataTable dataTable)
    {
        operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2ForMultipleOrdersUsingDataBelow(dataTable);
    }

    private void operatorCreateOrderByUploadingCsvOnOrderWeightUpdatePageV2ForMultipleOrdersUsingDataBelow(DataTable dataTable)
    {



        Long shipperV2OrV3Id = null;

        if(containsKey(KEY_CREATED_SHIPPER))
        {
            shipperV2OrV3Id = this.<Shipper>get(KEY_CREATED_SHIPPER).getLegacyId();
        }


        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);

        System.out.println("Map values is :  "+mapOfData +"   Size : "+mapOfData.size());

        ListOrderCreationV2Template listOrderCreationV2Template=new ListOrderCreationV2Template();
        List<OrderCreationV2Template> list=new ArrayList<>();

        for (int i=1;i<=mapOfData.size();i++)
        {

            String orderCreationV2TemplateAsJsonString = mapOfData.get("orderCreationV2Template"+i);
            System.out.println("OrderCreation  : "+orderCreationV2TemplateAsJsonString);


            String scenarioName = getScenarioManager().getCurrentScenario().getName();
            Date currentDate = new Date();

            Map<String,String> mapOfDynamicVariable = new HashMap<>();
            mapOfDynamicVariable.put("cur_date", CURRENT_DATE_SDF.format(currentDate));
            mapOfDynamicVariable.put("shipper_id", String.valueOf(shipperV2OrV3Id));

            orderCreationV2TemplateAsJsonString = replaceTokens(orderCreationV2TemplateAsJsonString, mapOfDynamicVariable);
            order = fromJsonSnakeCase(orderCreationV2TemplateAsJsonString, OrderCreationV2Template.class);
            System.out.println("    "+order);
            String orderType = order.getOrderType();

            String trackingRefNo = TestUtils.generateTrackingRefNo();
            System.out.println(" TrackID :  "+trackingRefNo);

            String fromEmail = null;
            String fromName = null;
            String toEmail = null;
            String toName = null;

            if("Normal".equals(orderType))
            {
                fromEmail = f("shipper.normal.%s@ninjavan.co", trackingRefNo);
                fromName = f("S-N-%s Shipper", trackingRefNo);
                toEmail = f("customer.normal.%s@ninjavan.co", trackingRefNo);
                toName = f("C-N-%s Customer", trackingRefNo);
            }
            else if("C2C".equals(orderType))
            {
                fromEmail = f("shipper.c2c.%s@ninjavan.co", trackingRefNo);
                fromName = f("S-C-%s Shipper", trackingRefNo);
                toEmail = f("customer.c2c.%s@ninjavan.co", trackingRefNo);
                toName = f("C-C-%s Customer", trackingRefNo);
            }
            else if("Return".equals(orderType))
            {
                fromEmail = f("customer.return.%s@ninjavan.co", trackingRefNo);
                fromName = f("C-R-%s Customer", trackingRefNo);
                toEmail = f("shipper.return.%s@ninjavan.co", trackingRefNo);
                toName = f("S-R-%s Shipper", trackingRefNo);
            }

            Address fromAddress = generateAddress("RANDOM");
            Address toAddress = generateAddress("RANDOM");

            order.setOrderNo(trackingRefNo);
//     //   assertEquals("Tracking ID match0", trackingRefNo, trackingRefNo);
            order.setShipperOrderNo("SORN-"+trackingRefNo);
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
        }

        listOrderCreationV2Template.setOrderCreationV2TemplatesList(list);

//
        System.out.println("Getting orderNo :   "+list.get(1));
        orderWeightUpdatePageV2.uploadCsvForMultipleOrders(listOrderCreationV2Template);

        put("orderCreationV2Template", order);
    }



    @Then("^Operator verify order V2 is created successfully for multiple orders on Order Weight Update V2 page$")
    public void operatorVerifyOrderV2IsCreatedSuccessfullyOnOrderWeightUpdatePageV2ForMultipleUsers()
    {
        List<OrderCreationV2Template> list=new ArrayList<>();
        for (int i=1;i<=3;i++)
        {

           list.add( get("orderCreationV2Template"+i));
        }



       ListOrderCreationV2Template listOrderCreationV2Template= new ListOrderCreationV2Template();
        listOrderCreationV2Template.setOrderCreationV2TemplatesList(list);
        orderWeightUpdatePageV2.verifyOrderV2IsCreatedSuccessfullyForMultipleUsers(listOrderCreationV2Template);
        pause(5*1000);
    }


    @When("^Operator Order Weight update CSV Upload on Order Weight Update V2 page for multiple orders$")
    public void OrderWeightUpdateUploadCsvFileForMultipleOrders(Map<String ,String> map)
    {
        List<OrderCreationV2Template> list=new ArrayList<>();
        for (int i=0;i<=map.size();i++)
        {
           list.add( get("orderCreationV2Template"));
        }
        ListOrderCreationV2Template listOrderCreationV2Template=new ListOrderCreationV2Template() ;
        listOrderCreationV2Template.setOrderCreationV2TemplatesList(list);
        orderWeightUpdatePageV2. uploadOrderUpdateCsvForMultipleUsers(listOrderCreationV2Template,map);
        pause(5*1000);

    }


}
