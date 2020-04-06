package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiShipperSteps;
import co.nvqa.commons.model.order_create.v4.OrderRequestV4;
import co.nvqa.operator_v2.selenium.page.OrderCreationV4Page;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import javax.inject.Inject;
import java.io.IOException;
import java.text.ParseException;
import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
@ScenarioScoped
public class OrderCreationV4Steps extends AbstractSteps
{
    @Inject private StandardApiShipperSteps standardApiShipperSteps;
    private OrderCreationV4Page orderCreationV4Page;

    public OrderCreationV4Steps()
    {
    }

    @Override
    public void init()
    {
        orderCreationV4Page = new OrderCreationV4Page(getWebDriver());
    }

    @When("^Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:$")
    public void operatorCreateOrderVByUploadingXLSXOnOrderCreationVPageUsingDataBelow(Map<String,String> dataTableAsMap)
    {
        int shipperId = Integer.parseInt(dataTableAsMap.get("shipperId"));
        OrderRequestV4 orderRequestV4 = standardApiShipperSteps.buildOrderRequestV4(dataTableAsMap);
        orderCreationV4Page.uploadXlsx(orderRequestV4, shipperId);
        put(KEY_CREATED_ORDER, orderRequestV4);
    }

    @Then("^Operator verify order V4 is created successfully on Order Creation V4 page$")
    public void operatorVerifyOrderVIsCreatedSuccessfullyOnOrderCreationVPage()
    {
        OrderRequestV4 order = get(KEY_CREATED_ORDER);
        orderCreationV4Page.verifyOrderIsCreatedSuccessfully(order);
        String batchId = orderCreationV4Page.getBatchId();
        put(KEY_CREATED_BATCH_ORDER_ID,batchId);
    }

    @When("^Operator click \"Download Sample File\" button on Order Creation V4 page$")
    public void operatorClickDownloadSampleFileButtonOnOrderCreationVIsPage()
    {
        orderCreationV4Page.clickNvIconTextButtonByNameAndWaitUntilDone("container.order.create.download-sample-file");
    }

    @When("^Operator download Sample File of OCV4 on Order Creation V4 page using data below:$")
    public void operator(Map<String,String> dataTableAsMap) throws ParseException
    {
        orderCreationV4Page.downloadSampleFile(dataTableAsMap);
    }

    @When("^Operator verify Sample CSV file on Order Creation V4 page downloaded successfully$")
    public void operatorVerifySampleCsvFileOnOrderCreationIvPageDownloadedSuccessfully()
    {
        orderCreationV4Page.verifyFileDownloadedSuccessfully();
    }

    @When("^Operator verify the downloaded CSV file is contains the correct value by following parameters:$")
    public void OperatorVerifyTheDownloadedCsvFileIsContainsTheCorrectValue(Map<String,String> dataTable) throws IOException
    {
        orderCreationV4Page.verifyDownloadedFile(dataTable);
    }
}
