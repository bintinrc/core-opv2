package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.DistributionPoint;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import com.google.inject.Inject;
import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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

    @When("^Operator create new Shipper with basic settings using data below:$")
    public void operatorCreateNewShipperWithBasicSettingsUsingDataBelow(DataTable dataTable)
    {
        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        Boolean isShipperActive = Boolean.parseBoolean(mapOfData.get("isShipperActive"));
        String shipperType = mapOfData.get("shipperType");
        String ocVersion = mapOfData.get("ocVersion");
        String servicesTemp = mapOfData.get("services");
        String trackingType = mapOfData.get("trackingType");

        List<String> listOfAvailableService;

        if(servicesTemp==null || servicesTemp.isEmpty())
        {
            listOfAvailableService = new ArrayList<>();
        }
        else
        {
            listOfAvailableService = Stream.of(servicesTemp.split(",")).map(String::trim).collect(Collectors.toList());
        }

        Boolean isAllowCod = Boolean.parseBoolean(mapOfData.get("isAllowCod"));
        Boolean isAllowCashPickup = Boolean.parseBoolean(mapOfData.get("isAllowCashPickup"));
        Boolean isPrepaid = Boolean.parseBoolean(mapOfData.get("isPrepaid"));
        Boolean isAllowStagedOrders = Boolean.parseBoolean(mapOfData.get("isAllowStagedOrders"));
        Boolean isMultiParcelShipper = Boolean.parseBoolean(mapOfData.get("isMultiParcelShipper"));
        Boolean isDisableDriverAppReschedule = Boolean.parseBoolean(mapOfData.get("isDisableDriverAppReschedule"));

        String pricingScriptName = mapOfData.get("pricingScriptName");
        String industryName = mapOfData.get("industryName");
        String salesPerson = mapOfData.get("salesPerson");

        String dateUniqueString = generateDateUniqueString();

        Shipper shipper = new Shipper();

        // Shipper Details
        shipper.setActive(isShipperActive);
        shipper.setType(shipperType);
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
        orderCreate.setVersion(ocVersion);
        orderCreate.setServicesAvailable(listOfAvailableService);
        orderCreate.setTrackingType(trackingType);
        orderCreate.setAllowCodService(isAllowCod);
        orderCreate.setAllowCpService(isAllowCashPickup);
        orderCreate.setIsPrePaid(isPrepaid);
        orderCreate.setAllowStagedOrders(isAllowStagedOrders);
        orderCreate.setIsMultiParcelShipper(isMultiParcelShipper);
        shipper.setOrderCreate(orderCreate);

        DistributionPoint distributionPoint = new DistributionPoint();
        distributionPoint.setShipperLiteAllowRescheduleFirstAttempt(isDisableDriverAppReschedule);
        shipper.setDistributionPoints(distributionPoint);

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

        allShippersPage.createNewShipper(shipper);
        put(KEY_CREATED_SHIPPER, shipper);
    }

    @Then("^Operator verify the new Shipper is created successfully$")
    public void operatorVerifyTheNewShipperIsCreatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyNewShipperIsCreatedSuccessfully(shipper);
    }

    @When("^Operator update Shipper's basic settings$")
    public void operatorUpdateShipperBasicSettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        Shipper oldShipper = SerializationUtils.clone(shipper);
        String dateUniqueString = generateDateUniqueString();

        // Shipper Details
        shipper.setActive(!shipper.getActive());
        shipper.setShortName("DS-"+StringUtils.right(dateUniqueString, 13));
        shipper.setContact(generatePhoneNumber(dateUniqueString));

        // Liaison Details
        Address liaisonAddress = generateRandomAddress();

        shipper.setLiaisonName("Liaison #"+dateUniqueString);
        shipper.setLiaisonContact(generatePhoneNumber(dateUniqueString+"1"));
        shipper.setLiaisonEmail("ln."+dateUniqueString+"@automation.co");
        shipper.setLiaisonAddress(liaisonAddress.to1LineAddress()+" #"+dateUniqueString);
        shipper.setLiaisonPostcode(liaisonAddress.getPostcode());

        // Services
        OrderCreate orderCreate = shipper.getOrderCreate();
        orderCreate.setAllowCodService(!orderCreate.getAllowCodService());
        orderCreate.setAllowCpService(!orderCreate.getAllowCpService());
        orderCreate.setIsPrePaid(!orderCreate.getIsPrePaid());
        orderCreate.setAllowStagedOrders(!orderCreate.getAllowStagedOrders());
        orderCreate.setIsMultiParcelShipper(!orderCreate.getIsMultiParcelShipper());

        DistributionPoint distributionPoint = shipper.getDistributionPoints();
        distributionPoint.setShipperLiteAllowRescheduleFirstAttempt(!distributionPoint.getShipperLiteAllowRescheduleFirstAttempt());

        // Billing
        Address billingAddress = generateRandomAddress();

        shipper.setBillingName("Billing #"+dateUniqueString);
        shipper.setBillingContact(generatePhoneNumber(dateUniqueString+"2"));
        shipper.setBillingAddress(billingAddress.to1LineAddress()+" #"+dateUniqueString);
        shipper.setBillingPostcode(billingAddress.getPostcode());

        allShippersPage.updateShipper(oldShipper, shipper);
        put(KEY_UPDATED_SHIPPER, oldShipper);
    }

    @Then("^Operator verify Shipper's basic settings is updated successfully$")
    public void operatorVerifyShipperBasicSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        Shipper oldShipper = get(KEY_UPDATED_SHIPPER);
        allShippersPage.verifyShipperIsUpdatedSuccessfully(oldShipper, shipper);
    }

    @Then("^Operator verify the shipper is deleted successfully$")
    public void operatorVerifyTheShipperIsDeletedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperIsDeletedSuccessfully(shipper);
    }
}
