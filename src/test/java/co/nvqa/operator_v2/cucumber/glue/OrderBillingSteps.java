package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.OrderBillingPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import java.text.ParseException;
import java.util.Map;
import java.util.Objects;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingSteps extends AbstractSteps
{
    private OrderBillingPage orderBillingPage;

    public OrderBillingSteps()
    {
    }

    @Override
    public void init()
    {
        orderBillingPage = new OrderBillingPage(getWebDriver());
    }

    @Then("^Operator verifies zip attached with multiple CSV files in received email$")
    public void operatorVerifiesAttachedZipFileInReceivedEmail()
    {
        orderBillingPage.verifyOrderBillingZipAttachment(get(KEY_ORDER_BILLING_START_DATE), get(KEY_ORDER_BILLING_END_DATE));
    }

    @Then("^Operator verifies attached CSV file in received email$")
    public void operatorVerifiesAttachedCsvFileInReceivedEmail()
    {
        orderBillingPage.verifyOrderBillingCsvAttachment(get(KEY_CREATED_ORDER));
    }

    @When("^Operator generates success billings using data below:$")
    public void operatorGeneratesSuccessBillingsForData(Map<String, String> mapOfData)
    {
        try
        {
            if(Objects.nonNull(mapOfData.get("startDate")))
            {
                String startDate = mapOfData.get("startDate");
                put(KEY_ORDER_BILLING_START_DATE, startDate);
                orderBillingPage.selectStartDate(YYYY_MM_DD_SDF.parse(startDate));
            }
            if(Objects.nonNull(mapOfData.get("endDate")))
            {
                String endDate = mapOfData.get("endDate");
                put(KEY_ORDER_BILLING_END_DATE, endDate);
                orderBillingPage.selectEndDate(YYYY_MM_DD_SDF.parse(endDate));
            }
        }
        catch(ParseException e)
        {
            throw new NvTestRuntimeException("Failed to parse date.", e);
        }
        if(Objects.nonNull(mapOfData.get("shipper")))
        {
            orderBillingPage.setSpecificShipper(mapOfData.get("shipper"));
        }
        if(Objects.nonNull(mapOfData.get("generateFile")))
        {
            orderBillingPage.tickGenerateTheseFilesOption(mapOfData.get("generateFile"));
        }
        if(Objects.nonNull(mapOfData.get("emailAddress")))
        {
            orderBillingPage.setEmailAddress(mapOfData.get("emailAddress"));
        }

        orderBillingPage.clickGenerateSuccessBillingsButton();
    }
}
