package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.operator_v2.model.OrderCreationV2Template;
import co.nvqa.operator_v2.selenium.page.OrderCreationV2Page;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class OrderCreationV2Steps extends AbstractSteps
{
    private OrderCreationV2Page orderCreationV2Page;

    public OrderCreationV2Steps()
    {
    }

    @Override
    public void init()
    {
        orderCreationV2Page = new OrderCreationV2Page(getWebDriver());
    }

    @When("^Operator download Sample CSV file on Order Creation V2 page$")
    public void operatorDownloadSampleCsvFileOnOrderCreationV2Page()
    {
        orderCreationV2Page.downloadSampleCsvFile();
    }

    @Then("^Operator verify Sample CSV file on Order Creation V2 page downloaded successfully$")
    public void operatorVerifySampleCsvFileOnOrderCreationV2PageDownloadedSuccessfully()
    {
        orderCreationV2Page.verifyCsvFileDownloadedSuccessfully();
    }

    @When("^Operator uploading invalid CSV file on Order Creation V2 page$")
    public void operatorUploadingInvalidCsvFileOnOrderCreationV2Page()
    {
        orderCreationV2Page.uploadInvalidCsv();
    }

    @Then("^Operator verify Order is not created by Creation V2 page$")
    public void operatorVerifyOrderIsNotCreatedByCreationV2Page()
    {
        orderCreationV2Page.verifyOrderIsNotCreated();
    }

    @When("^Operator create order V2 by uploading CSV on Order Creation V2 page using data below:$")
    public void operatorCreateOrderV2ByUploadingCsvOnOrderCreationV2PageUsingDataBelow(DataTable dataTable)
    {
        operatorCreateOrderByUploadingCsvOnOrderCreationV2PageUsingDataBelow(dataTable);
    }

    @When("^Operator create order V3 by uploading CSV on Order Creation V2 page using data below:$")
    public void operatorCreateOrderV3ByUploadingCsvOnOrderCreationV2PageUsingDataBelow(DataTable dataTable)
    {
        operatorCreateOrderByUploadingCsvOnOrderCreationV2PageUsingDataBelow(dataTable);
    }

    private void operatorCreateOrderByUploadingCsvOnOrderCreationV2PageUsingDataBelow(DataTable dataTable)
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

        orderCreationV2Page.uploadCsv(order);
        put("orderCreationV2Template", order);
    }

    @Then("^Operator verify order V2 is created successfully on Order Creation V2 page$")
    public void operatorVerifyOrderV2IsCreatedSuccessfullyOnOrderCreationV2Page()
    {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        orderCreationV2Page.verifyOrderV2IsCreatedSuccessfully(orderCreationV2Template);
        pause(5*000);
    }

    @Then("^Operator verify order V3 is created successfully on Order Creation V2 page$")
    public void operatorVerifyOrderV3IsCreatedSuccessfullyOnOrderCreationV2Page()
    {
        OrderCreationV2Template orderCreationV2Template = get("orderCreationV2Template");
        orderCreationV2Page.verifyOrderV3IsCreatedSuccessfully(orderCreationV2Template);
    }
}