package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.address.Address;
import co.nvqa.common.model.address.MilkrunSettings;
import co.nvqa.common.model.others.LatLong;
import co.nvqa.common.shipper.model.ServiceTypeLevel;
import co.nvqa.common.shipper.model.Shipper;
import co.nvqa.common.shipper.model.settings.DistributionPoint;
import co.nvqa.common.shipper.model.settings.LabelPrinter;
import co.nvqa.common.shipper.model.settings.MarketplaceBilling;
import co.nvqa.common.shipper.model.settings.MarketplaceDefault;
import co.nvqa.common.shipper.model.settings.OrderCreate;
import co.nvqa.common.shipper.model.settings.Pickup;
import co.nvqa.common.shipper.model.settings.Pricing;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.common.utils.factory.address.AddressFactory;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import co.nvqa.operator_v2.selenium.page.ProfilePage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;

import static co.nvqa.common.utils.StandardTestUtils.generateDateUniqueString;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllShippersSteps extends AbstractSteps {

    private AllShippersPage allShippersPage;
    private ProfilePage profilePage;

    public AllShippersSteps() {
    }

    @Override
    public void init() {
        allShippersPage = new AllShippersPage(getWebDriver());
        profilePage = new ProfilePage(getWebDriver());
    }

    @When("Operator create new Shipper with basic settings using data below:")
    public void operatorCreateNewShipperWithBasicSettingsUsingDataBelow(
            Map<String, String> mapOfData) {
        Shipper shipper = prepareShipperData(mapOfData);

        allShippersPage.createNewShipper(shipper);
        put(KEY_CREATED_SHIPPER, shipper);
    }

    @When("Operator verify pickup address on Edit Shipper page:")
    public void verifyPickupAddress(Map<String, String> data) {
        data = resolveKeyValues(data);
        List<Address> shipperPickupAddresses = fromJsonToList(data.get("shipperPickupAddresses"),
                Address.class);
        allShippersPage.allShippersCreateEditPage.clickTabItem("More Settings");
        if (CollectionUtils.isNotEmpty(shipperPickupAddresses)) {
            for (int i = 0; i < shipperPickupAddresses.size(); i++) {
                fillMilkrunReservationsProperties(shipperPickupAddresses.get(i), i + 1,
                        resolveKeyValues(data));
                allShippersPage.allShippersCreateEditPage.verifyPickupAddress(
                        shipperPickupAddresses.get(i));
            }
        }
    }

    private Shipper prepareShipperData(Map<String, String> mapOfData) {
        mapOfData = resolveKeyValues(mapOfData);
        String dateUniqueString = generateDateUniqueString();

        Shipper shipper = new Shipper();
        setShipperDetails(shipper, dateUniqueString, mapOfData);
        setLiaisonDetails(dateUniqueString, shipper);
        setServices(shipper, mapOfData);
        setIndustryAndSales(shipper, mapOfData);
        setPricing(shipper, mapOfData);
        setBilling(shipper, dateUniqueString);
        fillMarketplaceProperties(shipper, mapOfData);
        generatePickupAddresses(shipper, mapOfData);
        return shipper;
    }

    private void generatePickupAddresses(Shipper shipper, Map<String, String> mapOfData) {
        String pickupAddressCount = mapOfData.get("pickupAddressCount");

        if (StringUtils.isNotBlank(pickupAddressCount)) {
            int count = Integer.parseInt(pickupAddressCount);
            List<Address> pickupAddresses = new ArrayList<>();

            for (int i = 0; i < count; i++) {
                Address address = AddressFactory.getRandomAddress();
                address.setName("DA-" + generateDateUniqueString());
                LatLong latLong = StandardTestUtils.generateRandomLatLong();
                address.setLongitude(latLong.getLongitude());
                address.setLatitude(latLong.getLatitude());
                fillMilkrunReservationsProperties(address, i + 1, mapOfData);
                pickupAddresses.add(address);
            }

            shipper.getPickup().setReservationPickupAddresses(pickupAddresses);
        } else if (mapOfData.containsKey("useCreatedAddress")) {
            List<Address> pickupAddresses = new ArrayList<>();
            int i = Integer.parseInt(mapOfData.get("useCreatedAddress"));
            List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
            Address address = addresses.get(i - 1);
            fillMilkrunReservationsProperties(address, i, mapOfData);
            pickupAddresses.add(address);
            shipper.getPickup().setReservationPickupAddresses(pickupAddresses);
        }
    }

    private <T> Map<String, T> extractSubmap(Map<String, T> map, String prefix) {
        return map.entrySet().stream().filter(entry -> entry.getKey().startsWith(prefix)).collect(
                Collectors.toMap(entry -> StringUtils.removeStart(entry.getKey(), prefix + ".").trim(),
                        Map.Entry::getValue));
    }

    private void fillMarketplaceProperties(Shipper shipper, Map<String, String> mapOfData) {
        if (mapOfData.keySet().stream().anyMatch(key -> key.startsWith("marketplace."))) {
            MarketplaceDefault md = new MarketplaceDefault();
            md.setOrderCreateVersion(mapOfData.get("marketplace.ocVersion"));
            String value = mapOfData.get("marketplace.selectedOcServices");

            if (StringUtils.isNotBlank(value)) {
                List<String> selectedOcServices = Arrays.asList(value.split(","));
                md.setOrderCreateServicesAvailable(selectedOcServices);
            }

            md.setOrderCreateTrackingType(mapOfData.get("marketplace.trackingType"));
            md.setOrderCreateAllowCodService(Boolean.valueOf(mapOfData.get("marketplace.allowCod")));
            md.setOrderCreateAllowCpService(Boolean.valueOf(mapOfData.get("marketplace.allowCp")));
            md.setOrderCreateIsPrePaid(Boolean.valueOf(mapOfData.get("marketplace.isPrePaid")));
            md.setOrderCreateAllowStagedOrders(
                    Boolean.valueOf(mapOfData.get("marketplace.allowStaging")));
            md.setOrderCreateIsMultiParcelShipper(
                    Boolean.valueOf(mapOfData.get("marketplace.isMultiParcel")));

            value = mapOfData.get("marketplace.premiumPickupDailyLimit");
            if (StringUtils.isNotBlank(value)) {
                md.setPickupPremiumPickupDailyLimit(Integer.valueOf(value));
            }
            value = mapOfData.get("marketplace.orderCreateAvailableServiceLevels");
            if (StringUtils.isNotBlank(value)) {
                List<String> serviceLevels = Arrays.stream(value.split(",")).map(StringUtils::trim)
                        .collect(Collectors.toList());
                md.setOrderCreateAvailableServiceLevels(serviceLevels);
            }

            // Billing
            MarketplaceBilling mb = new MarketplaceBilling();
            Address billingAddress = StandardTestUtils.generateRandomAddress();
            String dateUniqueString = generateDateUniqueString();

            value = mapOfData.get("marketplace.billingName");
            mb.setBillingName(StringUtils.isNotBlank(value) ? value : "Billing #" + dateUniqueString);

            value = mapOfData.get("marketplace.billingContact");
            mb.setBillingContact(
                    StringUtils.isNotBlank(value) ? value
                            : StandardTestUtils.generatePhoneNumber(dateUniqueString + "2"));

            value = mapOfData.get("marketplace.billingAddress");
            mb.setBillingAddress(StringUtils.isNotBlank(value) ? value
                    : billingAddress.to1LineAddress() + " #" + dateUniqueString);

            value = mapOfData.get("marketplace.billingPostcode");
            mb.setBillingPostcode(StringUtils.isNotBlank(value) ? value : billingAddress.getPostcode());

            shipper.setMarketplaceBilling(mb);
            shipper.setMarketplaceDefault(md);
        }
    }

    private void fillMilkrunReservationsProperties(Address address, int addressIndex,
                                                   Map<String, String> mapOfData) {
        String milkrunPrefix = "address." + addressIndex + ".milkrun";

        if (mapOfData.keySet().stream().anyMatch(key -> key.startsWith(milkrunPrefix))) {
            Map<String, String> milkrunData = extractSubmap(mapOfData, milkrunPrefix);
            String isMilkrun = milkrunData.get("isMilkrun");
            if (StringUtils.equalsIgnoreCase(isMilkrun, "false")) {
                address.setMilkRun(false);
                return;
            }
            int reservationsCount = milkrunData.containsKey("reservationCount") ? Integer.parseInt(
                    milkrunData.get("reservationCount")) : 1;

            for (int j = 1; j <= reservationsCount; j++) {
                Map<String, String> reservationData = extractSubmap(milkrunData, String.valueOf(j));
                fillMilkrunReservationProperties(address, reservationData);
            }
        }
    }

    private void fillMilkrunReservationProperties(Address address, Map<String, String> mapOfData) {
        MilkrunSettings ms = new MilkrunSettings();
        String value = mapOfData.get("startTime");

        if (StringUtils.isNotBlank(value)) {
            ms.setStartTime(value);
        }

        value = mapOfData.get("endTime");

        if (StringUtils.isNotBlank(value)) {
            ms.setEndTime(value);
        }

        value = mapOfData.get("days");

        if (StringUtils.isNotBlank(value)) {
            List<Integer> days = Arrays.stream(value.split(",")).map(d -> Integer.parseInt(d.trim()))
                    .collect(Collectors.toList());
            ms.setDays(days);
        }

        value = mapOfData.get("noOfReservation");

        if (StringUtils.isNotBlank(value)) {
            ms.setNoOfReservation(Integer.valueOf(value));
        }
        address.setMilkRun(true);

        List<MilkrunSettings> milkrunSettings = Collections.singletonList(ms);
        address.setMilkrunSettings(milkrunSettings);
    }

    @Then("Operator open Edit Shipper Page of shipper {string}")
    public void operatorOpenEditShipperPageOfShipper(String shipperName) {
        shipperName = resolveValue(shipperName);
        allShippersPage.searchShipper(shipperName);
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        allShippersPage.openEditShipperPage();
        allShippersPage.allShippersCreateEditPage.shipperInformation.waitUntilClickable();
        pause2s();
    }

    @Then("Operator opens Edit Shipper Page of shipper {value}")
    public void operatorOpenEditsShipperPageOfShipper(String legacyId) {
        allShippersPage.allShippersCreateEditPage.openPage(legacyId);
    }

    @When("Operator unset pickup addresses of the created shipper:")
    public void operatorUnsetPickupAddressesOfTheCreatedShipper(Map<String, String> data) {
        Map<String, String> resolvedData = resolveKeyValues(data);
        String shipperName = resolvedData.get("shipperName");
        Address shipperPickupAddress = fromJson(resolvedData.get("shipperPickupAddress"),
                Address.class);
        allShippersPage.unsetPickupAddressesAsMilkrun(shipperName, shipperPickupAddress);
    }

    private void setBilling(Shipper shipper, String dateUniqueString) {
        Address billingAddress = StandardTestUtils.generateRandomAddress();

        shipper.setBillingName("Billing #" + dateUniqueString);
        shipper.setBillingContact(StandardTestUtils.generatePhoneNumber(dateUniqueString + "2"));
        shipper.setBillingAddress(billingAddress.to1LineAddress() + " #" + dateUniqueString);
        shipper.setBillingPostcode(billingAddress.getPostcode());
    }

    private void setPricing(Shipper shipper, Map<String, String> mapOfData) {
        Pricing pricing = new Pricing();
        pricing.setScriptName(mapOfData.get("pricingScriptName"));
        shipper.setPricing(pricing);
    }

    private void setIndustryAndSales(Shipper shipper, Map<String, String> mapOfData) {
        shipper.setIndustryName(mapOfData.get("industryName"));
        shipper.setSalesPerson(mapOfData.get("salesPerson"));
        shipper.setAccountTypeId(6L);

        Pickup pickupSettings = new Pickup();
        pickupSettings.setDefaultStartTime("09:00");
        pickupSettings.setDefaultEndTime("22:00");
        if (mapOfData.containsKey("premiumPickupDailyLimit")) {
            pickupSettings.setPremiumPickupDailyLimit(
                    Integer.valueOf(mapOfData.get("premiumPickupDailyLimit")));
        }
        if (mapOfData.containsKey("pickupServiceTypeLevels")) {
            List<ServiceTypeLevel> serviceTypeLevels = Arrays.stream(
                    mapOfData.get("pickupServiceTypeLevels").split(",")).map(val -> {
                ServiceTypeLevel serviceTypeLevel = new ServiceTypeLevel();
                String[] values = val.split(":");
                serviceTypeLevel.setType(values[0].trim());
                serviceTypeLevel.setLevel(values[1].trim());
                return serviceTypeLevel;
            }).collect(Collectors.toList());
            pickupSettings.setServiceTypeLevel(serviceTypeLevels);
        }
        shipper.setPickup(pickupSettings);
    }

    private void setServices(Shipper shipper, Map<String, String> mapOfData) {
        Boolean isAllowCod = Boolean.parseBoolean(mapOfData.get("isAllowCod"));
        Boolean isAllowCashPickup = Boolean.parseBoolean(mapOfData.get("isAllowCashPickup"));
        Boolean isPrepaid = Boolean.parseBoolean(mapOfData.get("isPrepaid"));
        Boolean isAllowStagedOrders = Boolean.parseBoolean(mapOfData.get("isAllowStagedOrders"));
        Boolean isMultiParcelShipper = Boolean.parseBoolean(mapOfData.get("isMultiParcelShipper"));
        Boolean isDisableDriverAppReschedule = Boolean.parseBoolean(
                mapOfData.get("isDisableDriverAppReschedule"));
        String ocVersion = mapOfData.get("ocVersion");
        String servicesTemp = mapOfData.get("services");
        String trackingType = mapOfData.get("trackingType");

        List<String> listOfAvailableService;
        if (servicesTemp == null || servicesTemp.isEmpty()) {
            listOfAvailableService = new ArrayList<>();
        } else {
            listOfAvailableService = splitAndNormalize(servicesTemp);
        }

        OrderCreate orderCreate = new OrderCreate();
        orderCreate.setVersion(ocVersion);
        orderCreate.setServicesAvailable(listOfAvailableService);
        orderCreate.setTrackingType(trackingType);
        orderCreate.setAllowCodService(isAllowCod);
        orderCreate.setAllowCpService(isAllowCashPickup);
        orderCreate.setIsPrePaid(isPrepaid);
        orderCreate.setAllowStagedOrders(isAllowStagedOrders);
        orderCreate.setIsMultiParcelShipper(isMultiParcelShipper);
        orderCreate.setIsCorporate(Boolean.parseBoolean(mapOfData.get("isCorporate")));
        orderCreate.setIsCorporateManualAWB(
                Boolean.parseBoolean(mapOfData.get("isCorporateManualAWB")));
        orderCreate.setIsCorporateReturn(Boolean.parseBoolean(mapOfData.get("isCorporateReturn")));
        orderCreate.setIsCorporateDocument(Boolean.parseBoolean(mapOfData.get("isCorporateDocument")));
        shipper.setOrderCreate(orderCreate);

        DistributionPoint distributionPoint = new DistributionPoint();
        distributionPoint.setShipperLiteAllowRescheduleFirstAttempt(isDisableDriverAppReschedule);
        shipper.setDistributionPoints(distributionPoint);

        Map<String, String> labelPrintingSettings = extractSubmap(mapOfData, "labelPrinting");
        if (MapUtils.isNotEmpty(labelPrintingSettings)) {
            LabelPrinter labelPrinter = new LabelPrinter();
            String value = labelPrintingSettings.get("showShipperDetails");
            if (StringUtils.isNotBlank(value)) {
                labelPrinter.setShowShipperDetails(Boolean.parseBoolean(value));
            }
            value = labelPrintingSettings.get("showCod");
            if (StringUtils.isNotBlank(value)) {
                labelPrinter.setShowCod(Boolean.parseBoolean(value));
            }
            value = labelPrintingSettings.get("showParcelDescription");
            if (StringUtils.isNotBlank(value)) {
                labelPrinter.setShowParcelDescription(Boolean.parseBoolean(value));
            }
            value = labelPrintingSettings.get("printerIp");
            if (StringUtils.isNotBlank(value)) {
                labelPrinter.setPrinterIp(value);
            }
            shipper.setLabelPrinter(labelPrinter);
        }
    }

    private void setLiaisonDetails(String dateUniqueString, Shipper shipper) {
        Address liaisonAddress = StandardTestUtils.generateRandomAddress();

        shipper.setLiaisonName("Liaison #" + dateUniqueString);
        shipper.setLiaisonContact(StandardTestUtils.generatePhoneNumber(dateUniqueString + "1"));
        shipper.setLiaisonEmail("ln." + dateUniqueString + "@automation.co");
        shipper.setLiaisonAddress(liaisonAddress.to1LineAddress() + " #" + dateUniqueString);
        shipper.setLiaisonPostcode(liaisonAddress.getPostcode());
    }

    private Shipper setShipperDetails(Shipper shipper, String dateUniqueString,
                                      Map<String, String> mapOfData) {
        shipper.setActive(Boolean.parseBoolean(mapOfData.get("isShipperActive")));
        shipper.setType(mapOfData.get("shipperType"));
        shipper.setName("Dummy Shipper #" + dateUniqueString);
        shipper.setShortName("DS-" + StringUtils.right(dateUniqueString, 13));
        shipper.setContact(StandardTestUtils.generatePhoneNumber(dateUniqueString));
        if (mapOfData.containsKey("email")) {
            shipper.setEmail(mapOfData.get("email"));
        } else {
            shipper.setEmail("ds." + dateUniqueString + "@automation.co");
        }
        shipper.setShipperDashboardPassword("Ninjitsu89");
        return shipper;
    }
}