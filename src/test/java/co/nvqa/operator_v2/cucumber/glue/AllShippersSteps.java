package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.shipper.v2.DistributionPoint;
import co.nvqa.commons.model.shipper.v2.LabelPrinter;
import co.nvqa.commons.model.shipper.v2.Magento;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Qoo10;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Return;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.model.shipper.v2.Shopify;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
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

    @When("Operator clear browser cache and reload All Shipper page")
    public void operatorClearBrowserCacheAndReloadAllShipperPage()
    {
        allShippersPage.clearBrowserCacheAndReloadPage();
    }

    @When("^Operator create new Shipper with basic settings using data below:$")
    public void operatorCreateNewShipperWithBasicSettingsUsingDataBelow(Map<String,String> mapOfData)
    {
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

    @When("^Operator update Shipper's Label Printer settings$")
    public void operatorUpdateShipperLabelPrinterSettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        LabelPrinter labelPrinter = new LabelPrinter();
        labelPrinter.setPrinterIp("127.0.0.1");
        labelPrinter.setShowShipperDetails(true);
        shipper.setLabelPrinter(labelPrinter);

        allShippersPage.updateShipperLabelPrinterSettings(shipper);
    }

    @Then("^Operator verify Shipper's Label Printer settings is updated successfully$")
    public void operatorVerifyShipperLabelPrinterSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfuly(shipper);
    }

    @When("^Operator update Shipper's Returns settings$")
    public void operatorUpdateShipperReturnsSettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();
        Address returnAddress = generateRandomAddress();

        Return returnSettings = new Return();
        returnSettings.setName("Return #"+dateUniqueString);
        returnSettings.setContact(generatePhoneNumber(dateUniqueString));
        returnSettings.setEmail("return."+dateUniqueString+"@automation.co");
        returnSettings.setAddress1(returnAddress.getAddress1());
        returnSettings.setAddress2(returnAddress.getAddress2());
        returnSettings.setCity(returnAddress.getCity());
        returnSettings.setPostcode(returnAddress.getPostcode());
        returnSettings.setLastReturnNumber(dateUniqueString);
        shipper.setReturns(returnSettings);

        allShippersPage.updateShipperReturnsSettings(shipper);
    }

    @Then("^Operator verify Shipper's Returns settings is updated successfully$")
    public void operatorVerifyShipperReturnsSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperReturnsSettingsIsUpdatedSuccessfuly(shipper);
    }

    @When("^Operator update Shipper's Distribution Point settings$")
    public void operatorUpdateShipperDistributionPointSettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();

        DistributionPoint distributionPoint = new DistributionPoint();
        distributionPoint.setVaultIsIntegrated(true);
        distributionPoint.setVaultCollectCustomerNricCode(true);
        distributionPoint.setAllowReturnsOnDpms(true);
        distributionPoint.setDpmsLogoUrl("https://dpmslogo"+dateUniqueString+".com");
        distributionPoint.setAllowReturnsOnVault(true);
        distributionPoint.setVaultLogoUrl("https://vaultlogo"+dateUniqueString+".com");
        distributionPoint.setAllowReturnsOnShipperLite(true);
        distributionPoint.setShipperLiteLogoUrl("https://shipperlitelogo"+dateUniqueString+".com");
        shipper.setDistributionPoints(distributionPoint);

        allShippersPage.updateShipperDistributionPointSettings(shipper);
    }

    @Then("^Operator verify Shipper's Distribution Point settings is updated successfully$")
    public void operatorVerifyShipperDistributionPointSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfuly(shipper);
    }

    @When("^Operator update Shipper's Qoo10 settings$")
    public void operatorUpdateShipperQoo10Settings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();

        Qoo10 qoo10 = new Qoo10();
        qoo10.setUsername("qoo10"+dateUniqueString);
        qoo10.setPassword(dateUniqueString);
        shipper.setQoo10(qoo10);

        allShippersPage.updateShipperQoo10Settings(shipper);
    }

    @Then("^Operator verify Shipper's Qoo10 settings is updated successfully$")
    public void operatorVerifyShipperQoo10SettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperQoo10SettingsIsUpdatedSuccessfuly(shipper);
    }

    @When("^Operator update Shipper's Shopify settings$")
    public void operatorUpdateShipperShopifySettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();

        Shopify shopify = new Shopify();
        shopify.setMaxDeliveryDays(randomLong(0, 3));
        shopify.setDdOffset(1L);
        shopify.setDdTimewindowId(2L);
        shopify.setBaseUri(String.format("https://www.shopify%s.com", dateUniqueString));
        shopify.setApiKey(dateUniqueString+"1");
        shopify.setPassword(dateUniqueString+"2");
        shopify.setShippingCodes(Arrays.asList(dateUniqueString+"3"));
        shopify.setShippingCodeFilterEnabled(true);
        shipper.setShopify(shopify);

        allShippersPage.updateShipperShopifySettings(shipper);
    }

    @Then("^Operator verify Shipper's Shopify settings is updated successfully$")
    public void operatorVerifyShipperShopifySettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperShopifySettingsIsUpdatedSuccessfuly(shipper);
    }

    @When("^Operator update Shipper's Magento settings$")
    public void operatorUpdateShipperMagentoSettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();

        Magento magento = new Magento();
        magento.setUsername("magento"+dateUniqueString);
        magento.setPassword(dateUniqueString);
        magento.setSoapApiUrl(String.format("https://www.magento%s.com", dateUniqueString));
        shipper.setMagento(magento);

        allShippersPage.updateShipperMagentoSettings(shipper);
    }

    @Then("^Operator verify Shipper's Magento settings is updated successfully$")
    public void operatorVerifyShipperMagentoSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperMagentoSettingsIsUpdatedSuccessfuly(shipper);
    }

    @When("^Operator enable Auto Reservation for Shipper and change Shipper default Address to the new Address using data below:$")
    public void operatorEnableAutoReservationForShipperAndChangeShipperDefaultAddressToTheNewAddressUsingDataBelow(Map<String,String> mapOfData)
    {
        String reservationDays = mapOfData.get("reservationDays");
        String autoReservationReadyTime = mapOfData.get("autoReservationReadyTime");
        String autoReservationLatestTime = mapOfData.get("autoReservationLatestTime");
        String autoReservationCutoffTime = mapOfData.get("autoReservationCutoffTime");
        String autoReservationApproxVolume = mapOfData.get("autoReservationApproxVolume");
        String allowedTypes = mapOfData.get("allowedTypes");

        List<Long> listOfReservationDays;

        if(reservationDays==null || reservationDays.isEmpty())
        {
            listOfReservationDays = new ArrayList<>();
        }
        else
        {
            listOfReservationDays = Stream.of(reservationDays.split(",")).map(s -> Long.parseLong(s.trim())).collect(Collectors.toList());
        }

        List<String> listOfAllowedTypes;

        if(allowedTypes==null || allowedTypes.isEmpty())
        {
            listOfAllowedTypes = new ArrayList<>();
        }
        else
        {
            listOfAllowedTypes = Stream.of(allowedTypes.split(",")).map(String::trim).collect(Collectors.toList());
        }

        Shipper shipper = get(KEY_CREATED_SHIPPER);
        Address createdAddress = AddressFactory.getRandomAddress();
        String unique = generateDateUniqueString();
        createdAddress.setName(String.format("Dummy Address #%s", unique));
        createdAddress.setEmail(String.format("dummy.address.%s@gmail.com", unique));
        createdAddress.setAddress2(createdAddress.getAddress2()+" #"+unique);

        Reservation reservation = new Reservation();
        reservation.setAutoReservationEnabled(true);
        reservation.setDays(listOfReservationDays);
        reservation.setAutoReservationReadyTime(autoReservationReadyTime);
        reservation.setAutoReservationLatestTime(autoReservationLatestTime);
        reservation.setAutoReservationCutoffTime(autoReservationCutoffTime);
        reservation.setAutoReservationApproxVolume(autoReservationApproxVolume);
        reservation.setAllowedTypes(listOfAllowedTypes);

        allShippersPage.enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(shipper, createdAddress, reservation);
        put(KEY_CREATED_ADDRESS, createdAddress);
    }

    @Then("^Operator verify the shipper is deleted successfully$")
    public void operatorVerifyTheShipperIsDeletedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperIsDeletedSuccessfully(shipper);
    }
}
