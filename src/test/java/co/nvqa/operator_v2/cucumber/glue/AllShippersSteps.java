package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AllShippersSteps extends AbstractSteps
{
    private AllShippersPage allShippersPage;

    @Inject
    public AllShippersSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        allShippersPage = new AllShippersPage(getWebDriver());
    }

    @When("^Operator create new Shipper V4 using data below:$")
    public void operatorCreateNewShipperV4(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String pricingScriptName = mapOfData.get("pricingScriptName");
        String industryName = mapOfData.get("industryName");
        String salesPerson = mapOfData.get("salesPerson");

        String dateUniqueString = generateDateUniqueString();

        Shipper shipper = new Shipper();

        // Shipper Details
        shipper.setStatus("Active");
        shipper.setType("Normal");
        shipper.setName("Dummy Shipper #"+dateUniqueString);
        shipper.setShortName("DS-"+StringUtils.right(dateUniqueString, 13));
        shipper.setContact(generatePhoneNumber(dateUniqueString));
        shipper.setEmail("ds."+dateUniqueString+"@automation.co");
        shipper.setShipperDashboardPassword("Ninjitsu89");

        // Liaison Details
        Address liaisonAddress = generateRandomAddress();

        shipper.setLiaisonName("Liaison #"+dateUniqueString);
        shipper.setLiaisonContact(generatePhoneNumber(dateUniqueString+"1"));
        shipper.setLiaisonEmail("ln."+dateUniqueString+"@automation.co");
        shipper.setLiaisonAddress(liaisonAddress.to1LineAddress()+" #"+dateUniqueString);
        shipper.setLiaisonPostcode(liaisonAddress.getPostcode());

        // Services
        OrderCreate orderCreate = new OrderCreate();
        orderCreate.setVersion("v4");
        orderCreate.setServicesAvailable(Arrays.asList("1DAY", "2DAY", "3DAY", "SAMEDAY", "FREIGHT"));
        orderCreate.setTrackingType("Fixed");
        shipper.setOrderCreate(orderCreate);

        // Pricing
        Pricing pricing = new Pricing();
        pricing.setScriptName(pricingScriptName);
        shipper.setPricing(pricing);

        // Billing
        Address billingAddress = generateRandomAddress();

        shipper.setBillingName("Billing #"+dateUniqueString);
        shipper.setBillingContact(generatePhoneNumber(dateUniqueString+"2"));
        shipper.setBillingAddress(billingAddress.to1LineAddress()+" #"+dateUniqueString);
        shipper.setBillingPostcode(billingAddress.getPostcode());

        // Industry & Sales
        shipper.setIndustryName(industryName);
        shipper.setSalesPerson(salesPerson);

        allShippersPage.createNewShipperV4(shipper);
        put("shipper", shipper);
    }

    @Then("^Operator verify the new Shipper V4 is created successfully$")
    public void operatorVerifyTheNewShipperV4IsCreatedSuccessfully()
    {
        Shipper shipper = get("shipper");
        allShippersPage.verifyNewShipperV4IsCreatedSuccessfully(shipper);
    }
}
