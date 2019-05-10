package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.OrderBillingPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;

import java.text.ParseException;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingSteps extends AbstractSteps {

    private OrderBillingPage orderBillingPage;

    @Override
    public void init() {
        orderBillingPage = new OrderBillingPage(getWebDriver());
    }

    @Given("^Operator selects start date = \"([^\"]*)\" and end date = \"([^\"]*)\"$")
    public void operatorSelectsRangeDate(String startDate, String endDate) {
        put(KEY_ORDER_BILLING_START_DATE, startDate);
        put(KEY_ORDER_BILLING_END_DATE, endDate);
        try {
            orderBillingPage.selectBetweenDates(YYYY_MM_DD_SDF.parse(startDate), YYYY_MM_DD_SDF.parse(endDate));
        } catch (ParseException e) {
            throw new NvTestRuntimeException("Failed to parse date.", e);
        }
    }

    @And("^Operator ticks \"([^\"]*)\" checkbox$")
    public void operatorTicks(String option) {
        orderBillingPage.tickGenerateTheseFilesOption(option);
    }

    @And("^Operator fills \"Email Address\" field with \"([^\"]*)\"$")
    public void operatorFillsEmailFieldWith(String emailAddressValue) {
        orderBillingPage.setEmailAddress(emailAddressValue);
    }

    @And("^Operator clicks \"Generate Success Billing\" button$")
    public void operatorClicksGenerateButton() {
        orderBillingPage.clickGenerateSuccessBillingsButton();
    }

    @Then("^Operator verifies attached CSV file in received email$")
    public void operatorVerifiesAttachedCSVFileInReceivedEmail() {
        orderBillingPage.orderBillingAttachment(get(KEY_ORDER_BILLING_START_DATE), get(KEY_ORDER_BILLING_END_DATE));
    }
}
