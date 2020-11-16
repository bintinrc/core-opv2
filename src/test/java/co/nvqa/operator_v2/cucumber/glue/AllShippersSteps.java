package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.MilkrunSettings;
import co.nvqa.commons.model.other.LatLong;
import co.nvqa.commons.model.shipper.v2.DistributionPoint;
import co.nvqa.commons.model.shipper.v2.LabelPrinter;
import co.nvqa.commons.model.shipper.v2.Magento;
import co.nvqa.commons.model.shipper.v2.MarketplaceBilling;
import co.nvqa.commons.model.shipper.v2.MarketplaceDefault;
import co.nvqa.commons.model.shipper.v2.OrderCreate;
import co.nvqa.commons.model.shipper.v2.Pickup;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Qoo10;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Return;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.model.shipper.v2.Shopify;
import co.nvqa.operator_v2.selenium.page.AllShippersPage;
import co.nvqa.operator_v2.selenium.page.ProfilePage;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.SerializationUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class AllShippersSteps extends AbstractSteps
{
    private static final String KEY_CURRENT_COUNTRY = "KEY_CURRENT_COUTRY";
    private AllShippersPage allShippersPage;
    private ProfilePage profilePage;

    public AllShippersSteps()
    {
    }

    @Override
    public void init()
    {
        allShippersPage = new AllShippersPage(getWebDriver());
        profilePage = new ProfilePage(getWebDriver());
    }

    @Before("@ResetCountry")
    public void saveCurrentCountry()
    {
        profilePage.clickProfileButton();
        put(KEY_CURRENT_COUNTRY, profilePage.getCurrentCountry());
        profilePage.closeProfile();
    }

    @After("@ResetCountry")
    public void restoreCurrentCountry()
    {
        String country = get(KEY_CURRENT_COUNTRY);
        if (StringUtils.isNotBlank(country))
        {
            profilePage.clickProfileButton();
            profilePage.changeCountry(country);
            profilePage.closeProfile();
        }
    }

    @When("Operator clear browser cache and reload All Shipper page")
    public void operatorClearBrowserCacheAndReloadAllShipperPage()
    {
        allShippersPage.clearBrowserCacheAndReloadPage();
    }

    @When("^Operator create new Shipper with basic settings using data below:$")
    public void operatorCreateNewShipperWithBasicSettingsUsingDataBelow(Map<String, String> mapOfData)
    {
        String dateUniqueString = generateDateUniqueString();

        Shipper shipper = new Shipper();
        setShipperDetails(shipper,dateUniqueString, mapOfData);
        setLiaisonDetails(dateUniqueString, shipper);
        setServices(shipper, mapOfData);
        setIndustryAndSales(shipper,mapOfData);
        setPricing(shipper,mapOfData);
        setBilling(shipper,dateUniqueString);
        fillMarketplaceProperties(shipper, mapOfData);
        generatePickupAddresses(shipper, mapOfData);

        allShippersPage.createNewShipper(shipper);
        put(KEY_CREATED_SHIPPER, shipper);
    }

    private void generatePickupAddresses(Shipper shipper, Map<String, String> mapOfData)
    {
        String pickupAddressCount = mapOfData.get("pickupAddressCount");

        if (StringUtils.isNotBlank(pickupAddressCount))
        {
            int count = Integer.parseInt(pickupAddressCount);
            List<Address> pickupAddresses = new ArrayList<>();

            for (int i = 0; i < count; i++)
            {
                Address address = generateRandomAddress();
                address.setName("DA-" + generateDateUniqueString());
                LatLong latLong = generateRandomLatLong();
                address.setLongitude(latLong.getLongitude());
                address.setLatitude(latLong.getLatitude());
                fillMilkrunReservationsProperties(address, i + 1, mapOfData);
                pickupAddresses.add(address);
            }

            shipper.getPickup().setReservationPickupAddresses(pickupAddresses);
        }
    }

    private <T> Map<String, T> extractSubmap(Map<String, T> map, String prefix)
    {
        return map.entrySet().stream()
                .filter(entry -> entry.getKey().startsWith(prefix))
                .collect(Collectors.toMap(
                        entry -> StringUtils.removeStart(entry.getKey(), prefix + ".").trim(),
                        Map.Entry::getValue
                ));
    }

    private void fillMarketplaceProperties(Shipper shipper, Map<String, String> mapOfData)
    {
        if (mapOfData.keySet().stream().anyMatch(key -> key.startsWith("marketplace.")))
        {
            MarketplaceDefault md = new MarketplaceDefault();
            md.setOrderCreateVersion(mapOfData.get("marketplace.ocVersion"));
            String value = mapOfData.get("marketplace.selectedOcServices");

            if (StringUtils.isNotBlank(value))
            {
                List<String> selectedOcServices = Arrays.asList(value.split(","));
                md.setOrderCreateServicesAvailable(selectedOcServices);
            }

            md.setOrderCreateTrackingType(mapOfData.get("marketplace.trackingType"));
            md.setOrderCreateAllowCodService(Boolean.valueOf(mapOfData.get("marketplace.allowCod")));
            md.setOrderCreateAllowCpService(Boolean.valueOf(mapOfData.get("marketplace.allowCp")));
            md.setOrderCreateIsPrePaid(Boolean.valueOf(mapOfData.get("marketplace.isPrePaid")));
            md.setOrderCreateAllowStagedOrders(Boolean.valueOf(mapOfData.get("marketplace.allowStaging")));
            md.setOrderCreateIsMultiParcelShipper(Boolean.valueOf(mapOfData.get("marketplace.isMultiParcel")));

            value = mapOfData.get("marketplace.premiumPickupDailyLimit");

            if (StringUtils.isNotBlank(value))
            {
                md.setPickupPremiumPickupDailyLimit(Integer.valueOf(value));
            }

            // Billing
            MarketplaceBilling mb = new MarketplaceBilling();
            Address billingAddress = generateRandomAddress();
            String dateUniqueString = generateDateUniqueString();

            value = mapOfData.get("marketplace.billingName");
            mb.setBillingName(StringUtils.isNotBlank(value) ? value : "Billing #" + dateUniqueString);

            value = mapOfData.get("marketplace.billingContact");
            mb.setBillingContact(StringUtils.isNotBlank(value) ? value : generatePhoneNumber(dateUniqueString + "2"));

            value = mapOfData.get("marketplace.billingAddress");
            mb.setBillingAddress(StringUtils.isNotBlank(value) ? value : billingAddress.to1LineAddress() + " #" + dateUniqueString);

            value = mapOfData.get("marketplace.billingPostcode");
            mb.setBillingPostcode(StringUtils.isNotBlank(value) ? value : billingAddress.getPostcode());

            shipper.setMarketplaceBilling(mb);
            shipper.setMarketplaceDefault(md);
        }
    }

    private void fillMilkrunReservationsProperties(Address address, int addressIndex, Map<String, String> mapOfData)
    {
        String milkrunPrefix = "address." + addressIndex + ".milkrun";

        if (mapOfData.keySet().stream().anyMatch(key -> key.startsWith(milkrunPrefix)))
        {
            Map<String, String> milkrunData = extractSubmap(mapOfData, milkrunPrefix);
            int reservationsCount = milkrunData.containsKey("reservationCount") ? Integer.parseInt(milkrunData.get("reservationCount")) : 1;

            for (int j = 1; j <= reservationsCount; j++)
            {
                Map<String, String> reservationData = extractSubmap(milkrunData, String.valueOf(j));
                fillMilkrunReservationProperties(address, reservationData);
            }
        }
    }

    private void fillMilkrunReservationProperties(Address address, Map<String, String> mapOfData)
    {
        MilkrunSettings ms = new MilkrunSettings();
        String value = mapOfData.get("startTime");

        if (StringUtils.isNotBlank(value))
        {
            ms.setStartTime(value);
        }

        value = mapOfData.get("endTime");

        if (StringUtils.isNotBlank(value))
        {
            ms.setEndTime(value);
        }

        value = mapOfData.get("days");

        if (StringUtils.isNotBlank(value))
        {
            List<Integer> days = Arrays.stream(value.split(","))
                    .map(d -> Integer.parseInt(d.trim()))
                    .collect(Collectors.toList());
            ms.setDays(days);
        }

        value = mapOfData.get("noOfReservation");

        if (StringUtils.isNotBlank(value))
        {
            ms.setNoOfReservation(Integer.valueOf(value));
        }

        List<MilkrunSettings> milkrunSettings = new LinkedList<>();
        milkrunSettings.add(ms);

        address.setMilkRun(true);

        if (address.getMilkrunSettings() == null)
        {
            address.setMilkrunSettings(milkrunSettings);
        } else
        {
            address.getMilkrunSettings().addAll(milkrunSettings);
        }
    }

    @Then("^Operator verify the new Shipper is created successfully$")
    public void operatorVerifyTheNewShipperIsCreatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        allShippersPage.verifyNewShipperIsCreatedSuccessfully(shipper);
    }

    @Then("^Operator open Edit Shipper Page of shipper \"(.+)\"$")
    public void operatorOpenEditShipperPageOfShipper(String shipperName)
    {
        shipperName = resolveValue(shipperName);
        allShippersPage.searchShipper(shipperName);
        allShippersPage.openEditShipperPage();
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        allShippersPage.allShippersCreateEditPage.shipperInformation.waitUntilClickable();
        pause2s();
    }

    @Then("^Operator open Edit Pricing Profile dialog on Edit Shipper Page$")
    public void operatorOpenEditPricingProfileDialogOnEditShipperPage()
    {
        allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
        allShippersPage.allShippersCreateEditPage.editPendingProfile.click();
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.waitUntilVisible();
    }

    @Then("^Operator verify Edit Pricing Profile dialog data on Edit Shipper Page:$")
    public void operatorVerifyEditPricingProfileDialogOnEditShipperPage(Map<String, String> data)
    {
        data = resolveKeyValues(data);

        String value = data.get("shipperId");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Shipper ID", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.shipperId.getText());
        }
        value = data.get("shipperName");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Shipper Name", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.shipperName.getText());
        }
        value = data.get("startDate");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Start Date", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingStartDate.getValue());
        }
        value = data.get("endDate");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("End Date", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingEndDate.getValue());
        }
        value = data.get("pricingScript");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertThat("Pricing Script", allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingScript.getValue(), Matchers.containsString(value));
        }
        value = data.get("salespersonDiscountType");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Salesperson Discount Type", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingSalespersonDicountType.getText());
        }
        value = data.get("discountValue");
        if (StringUtils.equalsIgnoreCase("none", value))
        {
            Assert.assertThat("Discount Value", allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.getValue(), Matchers.is(Matchers.emptyOrNullString()));
        } else if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Discount Value", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.getValue());
        }
        value = data.get("comments");
        if (StringUtils.isNotBlank(value))
        {
            Assert.assertEquals("Comments", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.comments.getValue());
        }
    }

    @Then("^Operator add New Pricing Profile on Edit Shipper Page using data below:$")
    public void operatorAddNewPricingProfileOnEditShipperPage(Map<String, String> data)
    {
        data = resolveKeyValues(data);
        allShippersPage.allShippersCreateEditPage.tabs.selectTab("Pricing and Billing");
        allShippersPage.allShippersCreateEditPage.addNewProfile.click();
        allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.waitUntilVisible();

        String value = data.get("startDate");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.pricingBillingStartDate.simpleSetValue(value);
        }
        value = data.get("endDate");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.pricingBillingEndDate.simpleSetValue(value);
        }
        value = data.get("pricingScript");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.pricingScript.searchAndSelectValue(value);
        }
        value = data.get("discountValue");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.discountValue.setValue(value);
        }
        value = data.get("comments");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.comments.setValue(value);
        }
        allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.codCountryDefaultCheckbox.check();
        allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();
        allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.saveChanges.clickAndWaitUntilDone();
        allShippersPage.allShippersCreateEditPage.newPricingProfileDialog.waitUntilInvisible();
    }

    @Then("^Operator fill Edit Pending Profile Dialog form on Edit Shipper Page using data below:$")
    public void operatorFillNewPricingProfileOnEditShipperPage(Map<String, String> data)
    {
        data = resolveKeyValues(data);

        String value = data.get("startDate");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingStartDate.simpleSetValue(value);
        }
        value = data.get("endDate");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingBillingEndDate.simpleSetValue(value);
        }
        value = data.get("pricingScript");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.pricingScript.searchAndSelectValue(value);
        }
        value = data.get("discountValue");
        if (StringUtils.equalsIgnoreCase("none", value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.clear();
        } else if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValue.setValue(value);
        }
        value = data.get("comments");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.comments.setValue(value);
        }
    }

    @Then("^Operator save changes in Edit Pending Profile Dialog form on Edit Shipper Page$")
    public void operatorSaveChangesPricingProfileOnEditShipperPage()
    {
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.saveChanges.clickAndWaitUntilDone();
        allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.waitUntilInvisible();
    }

    @Then("^Operator save changes on Edit Shipper Page$")
    public void operatorSaveChangesOnEditShipperPage()
    {
        allShippersPage.allShippersCreateEditPage.saveChanges.click();
        allShippersPage.allShippersCreateEditPage.waitUntilInvisibilityOfToast("All changes saved successfully");
        allShippersPage.allShippersCreateEditPage.backToShipperList();
        pause3s();
        getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
    }

    @Then("^Operator go back to Shipper List page")
    public void operatorGoBackToShipperListPage()
    {
        allShippersPage.allShippersCreateEditPage.backToShipperList();
        pause3s();
        getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
    }

    @Then("^Operator verify error messages in Edit Pending Profile Dialog on Edit Shipper Page:$")
    public void operatorVerifyErrorMessagesNewPricingProfileOnEditShipperPage(Map<String, String> data)
    {
        pause1s();
        data = resolveKeyValues(data);
        String value = data.get("discountValue");
        if (StringUtils.isNotBlank(value))
        {
            allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.saveChanges.clickAndWaitUntilDone();
            allShippersPage.allShippersCreateEditPage.saveChanges.click();
            Assert.assertEquals("Discount Value Error message", value, allShippersPage.allShippersCreateEditPage.editPendingProfileDialog.discountValueError.getText());
        }
    }

    @Then("^Operator verify the new Shipper is updated successfully$")
    public void operatorVerifyTheNewShipperIsUpdatedSuccessfully()
    {
        operatorVerifyTheNewShipperIsCreatedSuccessfully();
    }

    @When("^Operator update Shipper's basic settings$")
    public void operatorUpdateShipperBasicSettings()
    {
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        Shipper oldShipper = SerializationUtils.clone(shipper);
        String dateUniqueString = generateDateUniqueString();

        // Shipper Details
        shipper.setActive(!shipper.getActive());
        shipper.setShortName("DS-" + StringUtils.right(dateUniqueString, 13));
        shipper.setContact(generatePhoneNumber(dateUniqueString));

        // Liaison Details
        Address liaisonAddress = generateRandomAddress();

        shipper.setLiaisonName("Liaison #" + dateUniqueString);
        shipper.setLiaisonContact(generatePhoneNumber(dateUniqueString + "1"));
        shipper.setLiaisonEmail("ln." + dateUniqueString + "@ninjavan.co");
        shipper.setLiaisonAddress(liaisonAddress.to1LineAddress() + " #" + dateUniqueString);
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
//        Address billingAddress = generateRandomAddress();
//
//        shipper.setBillingName("Billing #" + dateUniqueString);
//        shipper.setBillingContact(generatePhoneNumber(dateUniqueString + "2"));
//        shipper.setBillingAddress(billingAddress.to1LineAddress() + " #" + dateUniqueString);
//        shipper.setBillingPostcode(billingAddress.getPostcode());

        allShippersPage.updateShipperBasicSettings(oldShipper, shipper);
        put(KEY_UPDATED_SHIPPER, oldShipper);
    }

    @Then("^Operator verify Shipper's basic settings is updated successfully$")
    public void operatorVerifyShipperBasicSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        Shipper oldShipper = get(KEY_UPDATED_SHIPPER);
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
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
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        allShippersPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(shipper);
    }

    @When("^Operator update Shipper's Returns settings$")
    public void operatorUpdateShipperReturnsSettings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();
        Address returnAddress = generateRandomAddress();

        Return returnSettings = new Return();
        returnSettings.setName("Return #" + dateUniqueString);
        returnSettings.setContact(generatePhoneNumber(dateUniqueString));
        returnSettings.setEmail("return." + dateUniqueString + "@ninjavan.co");
        returnSettings.setAddress1(returnAddress.getAddress1());
        returnSettings.setAddress2(returnAddress.getAddress2());
        returnSettings.setCity(returnAddress.getCity());
        returnSettings.setPostcode(returnAddress.getPostcode());
        returnSettings.setLastReturnNumber(System.currentTimeMillis());
        shipper.setReturns(returnSettings);

        allShippersPage.updateShipperReturnsSettings(shipper);
    }

    @Then("^Operator verify Shipper's Returns settings is updated successfully$")
    public void operatorVerifyShipperReturnsSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperReturnsSettingsIsUpdatedSuccessfully(shipper);
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
        distributionPoint.setDpmsLogoUrl("https://dpmslogo" + dateUniqueString + ".com");
        distributionPoint.setAllowReturnsOnVault(true);
        distributionPoint.setVaultLogoUrl("https://vaultlogo" + dateUniqueString + ".com");
        distributionPoint.setAllowReturnsOnShipperLite(true);
        distributionPoint.setShipperLiteLogoUrl("https://shipperlitelogo" + dateUniqueString + ".com");
        shipper.setDistributionPoints(distributionPoint);

        allShippersPage.updateShipperDistributionPointSettings(shipper);
    }

    @Then("^Operator verify Shipper's Distribution Point settings is updated successfully$")
    public void operatorVerifyShipperDistributionPointSettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(shipper);
    }

    @When("^Operator update Shipper's Qoo10 settings$")
    public void operatorUpdateShipperQoo10Settings()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);

        String dateUniqueString = generateDateUniqueString();

        Qoo10 qoo10 = new Qoo10();
        qoo10.setUsername("qoo10" + dateUniqueString);
        qoo10.setPassword(dateUniqueString);
        shipper.setQoo10(qoo10);

        allShippersPage.updateShipperQoo10Settings(shipper);
    }

    @Then("^Operator verify Shipper's Qoo10 settings is updated successfully$")
    public void operatorVerifyShipperQoo10SettingsIsUpdatedSuccessfully()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.verifyShipperQoo10SettingsIsUpdatedSuccessfully(shipper);
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
        shopify.setBaseUri(f("https://www.shopify%s.com", dateUniqueString));
        shopify.setApiKey(dateUniqueString + "1");
        shopify.setPassword(dateUniqueString + "2");
        shopify.setShippingCodes(Collections.singletonList(dateUniqueString + "3"));
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
        magento.setUsername("magento" + dateUniqueString);
        magento.setPassword(dateUniqueString);
        magento.setSoapApiUrl(f("https://www.magento%s.com", dateUniqueString));
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
    public void operatorEnableAutoReservationForShipperAndChangeShipperDefaultAddressToTheNewAddressUsingDataBelow(Map<String, String> mapOfData)
    {
        String reservationDays = mapOfData.get("reservationDays");
        String autoReservationReadyTime = mapOfData.get("autoReservationReadyTime");
        String autoReservationLatestTime = mapOfData.get("autoReservationLatestTime");
        String autoReservationCutoffTime = mapOfData.get("autoReservationCutoffTime");
        String autoReservationApproxVolume = mapOfData.get("autoReservationApproxVolume");
        String allowedTypes = mapOfData.get("allowedTypes");

        List<Long> listOfReservationDays;

        if (reservationDays == null || reservationDays.isEmpty())
        {
            listOfReservationDays = new ArrayList<>();
        } else
        {
            listOfReservationDays = Stream.of(reservationDays.split(",")).map(s -> Long.parseLong(s.trim())).collect(Collectors.toList());
        }

        List<String> listOfAllowedTypes;

        if (allowedTypes == null || allowedTypes.isEmpty())
        {
            listOfAllowedTypes = new ArrayList<>();
        } else
        {
            listOfAllowedTypes = Stream.of(allowedTypes.split(",")).map(String::trim).collect(Collectors.toList());
        }

        Shipper shipper = get(KEY_CREATED_SHIPPER);
        Address createdAddress = AddressFactory.getRandomAddress();
        String unique = generateDateUniqueString();
        createdAddress.setName(f("Dummy Address #%s", unique));
        createdAddress.setEmail(f("dummy.address.%s@gmail.com", unique));
        createdAddress.setAddress2(createdAddress.getAddress2() + " #" + unique);

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

    @When("^Operator login to created Shipper's Dashboard from All Shipper page$")
    public void operatorLoginAsCreatedShipperFromAllShipperPage()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        String mainWindowHandle = getWebDriver().getWindowHandle();
        put(KEY_MAIN_WINDOW_HANDLE, mainWindowHandle);
        allShippersPage.loginToShipperDashboard(shipper);
    }

    @When("^Operator set pickup addresses of the created shipper using data below:$")
    public void operatorSetPickupAddressesOfTheCreatedShipperUsingDataBelow(Map<String, String> mapOfData)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        List<Address> addresses = shipper.getPickup().getReservationPickupAddresses();
        if (CollectionUtils.isNotEmpty(addresses))
        {
            for (int i = 0; i < addresses.size(); i++)
            {
                fillMilkrunReservationsProperties(addresses.get(i), i + 1, mapOfData);
            }
        }
        allShippersPage.setPickupAddressesAsMilkrun(shipper);
    }

    @And("^Operator unset milkrun reservation \"(\\d+)\" form pickup address \"(\\d+)\" for created shipper$")
    public void operatorUnsetMilkrunReservationFormPickupAddressForCreatedShipper(int milkrunReservationIndex, int addressIndex)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.removeMilkrunReservarion(shipper, addressIndex, milkrunReservationIndex);
        Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
        address.getMilkrunSettings().remove(milkrunReservationIndex - 1);
        if (CollectionUtils.isEmpty(address.getMilkrunSettings()))
        {
            address.setMilkRun(false);
        }
    }

    @And("^Operator unset all milkrun reservations form pickup address \"(\\d+)\" for created shipper$")
    public void operatorUnsetAllMilkrunReservationsFormPickupAddressForCreatedShipper(int addressIndex)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        allShippersPage.removeAllMilkrunReservarions(shipper, addressIndex);
        Address address = shipper.getPickup().getReservationPickupAddresses().get(addressIndex - 1);
        address.getMilkrunSettings().clear();
        address.setMilkRun(false);
    }

    @Then("^Operator verifies All Shippers Page is displayed$")
    public void operatorVerifiesAllOrdersPageIsDispalyed()
    {
        allShippersPage.waitUntilPageLoaded();
    }

    @When("Operator clears all filters on All Shippers page")
    public void operatorClearsAllFiltersOnAllShippersPage()
    {
        allShippersPage.clearAllSelections();
    }

    @And("Operator chooses {string} filter")
    public void operatorChoosesFilter(String filter)
    {
        allShippersPage.chooseFilter(filter);
    }

    @Then("Operator searches the {string} field with {string} keyword")
    public void OperatorSearchesTheFieldWithKeyword(String filter, String keyword)
    {
        allShippersPage.searchByFilterWithKeyword(filter, keyword);
    }

    @Then("Operator verifies that the results have keyword {string} in {string} column")
    public void operatorVerifiesThatTheResultsHaveKeywordInColumn(String keyword, String column)
    {
        allShippersPage.verifiesResultsOfColumn(keyword, column);
    }

    @Then("Operator searches for Shippers with Active filter")
    public void operatorSearchesForShippersWithActiveFilter()
    {
        allShippersPage.searchActiveFilter();
    }

    @And("Operator searches for keyword {string} in quick search filter")
    public void operatorSearchesForShippersInQuickSearchFilter(String keyword)
    {
        allShippersPage.quickSearchShipper(keyword);
    }

    @And("Operator edits the created shipper")
    public void operatorEditsTheCreatedShipper()
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        allShippersPage.editShipper(shipper);
    }

    @And("Operator edits shipper {string}")
    public void operatorEditsShipper(String shipperLegacyId)
    {
        Shipper shipper = new Shipper();
        shipper.setLegacyId(Long.valueOf(shipperLegacyId));
        put(KEY_CREATED_SHIPPER, shipper);
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        allShippersPage.editShipper(shipper);
    }

    @Then("Operator adds new Shipper's Pricing Profile")
    public void OperatorAddsNewShippersPricingProfile(Map<String, String> mapOfData)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        String pricingScriptName = mapOfData.get("pricingScriptName");
        String discount = mapOfData.get("discount");
        String comments = mapOfData.get("comments");
        String type = mapOfData.get("type");

        Pricing pricing = new Pricing();
        pricing.setScriptName(pricingScriptName);
        pricing.setDiscount(discount);
        pricing.setComments(comments);
        pricing.setType(type);

        shipper.setPricing(pricing);

        String pricingProfileId = allShippersPage.addNewPricingScript(shipper);

        pricing.setTemplateId(Long.parseLong(pricingProfileId));

        put(KEY_CREATED_PRICING_SCRIPT, pricing);
        put(KEY_PRICING_PROFILE_ID, pricingProfileId);

    }

    @Then("Operator edits the Pending Pricing Script")
    public void operatorEditsThePendingPricingScript(Map<String, String> mapOfData)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        String discount = mapOfData.get("discount");
        String comments = mapOfData.get("comments");

        Pricing pricing = new Pricing();
        pricing.setDiscount(discount);
        pricing.setComments(comments);

        shipper.setPricing(pricing);

        allShippersPage.editPricingScript(shipper);
    }

    @Then("Operator verifies that Pricing Script is {string} and {string}")
    public void operatorVerifiesThatPricingScriptIsActiveAnd(String status, String status1)
    {
        allShippersPage.verifyPricingScriptIsActive(status, status1);
    }

    @When("Operator create new Shipper with basic settings and updates pricing script using data below:")
    public void operatorCreateNewShipperWithBasicSettingsAndUpdatesPricingScriptUsingDataBelow(Map<String, String> mapOfData)
    {
        String dateUniqueString = generateDateUniqueString();

        Shipper shipper = new Shipper();
        setShipperDetails(shipper,dateUniqueString, mapOfData);
        setLiaisonDetails(dateUniqueString, shipper);
        setServices(shipper, mapOfData);
        setIndustryAndSales(shipper,mapOfData);
        setPricing(shipper,mapOfData);
        setBilling(shipper,dateUniqueString);
        fillMarketplaceProperties(shipper, mapOfData);
        generatePickupAddresses(shipper, mapOfData);

        allShippersPage.createNewShipperWithUpdatedPricingScript(shipper);
        put(KEY_CREATED_SHIPPER, shipper);
    }

    private void setBilling( Shipper shipper,String dateUniqueString)
    {
        Address billingAddress = generateRandomAddress();

        shipper.setBillingName("Billing #" + dateUniqueString);
        shipper.setBillingContact(generatePhoneNumber(dateUniqueString + "2"));
        shipper.setBillingAddress(billingAddress.to1LineAddress() + " #" + dateUniqueString);
        shipper.setBillingPostcode(billingAddress.getPostcode());
    }

    private void setPricing(Shipper shipper,Map<String, String> mapOfData)
    {
        Pricing pricing = new Pricing();
        pricing.setScriptName(mapOfData.get("pricingScriptName"));
        shipper.setPricing(pricing);
    }

    private void setIndustryAndSales(Shipper shipper,Map<String, String> mapOfData)
    {
        shipper.setIndustryName(mapOfData.get("industryName"));
        shipper.setSalesPerson(mapOfData.get("salesPerson"));
        shipper.setAccountTypeId(6L);

        Pickup pickupSettings = new Pickup();
        pickupSettings.setDefaultStartTime("09:00");
        pickupSettings.setDefaultEndTime("22:00");
        if (mapOfData.containsKey("premiumPickupDailyLimit"))
        {
            pickupSettings.setPremiumPickupDailyLimit(Integer.valueOf(mapOfData.get("premiumPickupDailyLimit")));
        }
        shipper.setPickup(pickupSettings);
    }

    private void setServices(Shipper shipper,Map<String, String> mapOfData)
    {
        Boolean isAllowCod = Boolean.parseBoolean(mapOfData.get("isAllowCod"));
        Boolean isAllowCashPickup = Boolean.parseBoolean(mapOfData.get("isAllowCashPickup"));
        Boolean isPrepaid = Boolean.parseBoolean(mapOfData.get("isPrepaid"));
        Boolean isAllowStagedOrders = Boolean.parseBoolean(mapOfData.get("isAllowStagedOrders"));
        Boolean isMultiParcelShipper = Boolean.parseBoolean(mapOfData.get("isMultiParcelShipper"));
        Boolean isDisableDriverAppReschedule = Boolean.parseBoolean(mapOfData.get("isDisableDriverAppReschedule"));
        String ocVersion = mapOfData.get("ocVersion");
        String servicesTemp = mapOfData.get("services");
        String trackingType = mapOfData.get("trackingType");

        List<String> listOfAvailableService;
        if (servicesTemp == null || servicesTemp.isEmpty())
        {
            listOfAvailableService = new ArrayList<>();
        } else
        {
            listOfAvailableService = Stream.of(servicesTemp.split(",")).map(String::trim).collect(Collectors.toList());
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
        shipper.setOrderCreate(orderCreate);

        DistributionPoint distributionPoint = new DistributionPoint();
        distributionPoint.setShipperLiteAllowRescheduleFirstAttempt(isDisableDriverAppReschedule);
        shipper.setDistributionPoints(distributionPoint);
    }

    private void setLiaisonDetails(String dateUniqueString, Shipper shipper)
    {
        Address liaisonAddress = generateRandomAddress();

        shipper.setLiaisonName("Liaison #" + dateUniqueString);
        shipper.setLiaisonContact(generatePhoneNumber(dateUniqueString + "1"));
        shipper.setLiaisonEmail("ln." + dateUniqueString + "@automation.co");
        shipper.setLiaisonAddress(liaisonAddress.to1LineAddress() + " #" + dateUniqueString);
        shipper.setLiaisonPostcode(liaisonAddress.getPostcode());
    }

    private Shipper setShipperDetails(Shipper shipper,String dateUniqueString,Map<String, String> mapOfData)
    {
        shipper.setActive(Boolean.parseBoolean(mapOfData.get("isShipperActive")));
        shipper.setType(mapOfData.get("shipperType"));
        shipper.setName("Dummy Shipper #" + dateUniqueString);
        shipper.setShortName("DS-" + StringUtils.right(dateUniqueString, 13));
        shipper.setContact(generatePhoneNumber(dateUniqueString));
        shipper.setEmail("ds." + dateUniqueString + "@automation.co");
        shipper.setShipperDashboardPassword("Ninjitsu89");
        return shipper;
    }

    @When("Operator create new Shipper with basic settings and without Pricing profile using data below:")
    public void operatorCreateNewShipperWithBasicSettingsAndWithoutPricingProfileUsingDataBelow(Map<String, String> mapOfData)
    {
        String dateUniqueString = generateDateUniqueString();

        Shipper shipper = new Shipper();
        setShipperDetails(shipper,dateUniqueString, mapOfData);
        setLiaisonDetails(dateUniqueString, shipper);
        setServices(shipper, mapOfData);
        setIndustryAndSales(shipper,mapOfData);
        setBilling(shipper,dateUniqueString);
        fillMarketplaceProperties(shipper, mapOfData);
        generatePickupAddresses(shipper, mapOfData);

        allShippersPage.createNewShipperWithoutPricingScript(shipper);
        put(KEY_CREATED_SHIPPER, shipper);
    }

    @And("Operator verifies the pricing script and shipper discount details are correct")
    public void OperatorVerifiesThePricingScriptAndShipperDiscountDetailsAreCorrect()
    {
        Pricing pricingProfile = get(KEY_CREATED_PRICING_SCRIPT);
        Pricing pricingProfileFromDb = get(KEY_PRICING_PROFILE_DETAILS);
        allShippersPage.verifyPricingScriptAndShipperDiscountDetails(pricingProfile, pricingProfileFromDb);
    }

    @And("Operator verifies the pricing script details are correct")
    public void OperatorVerifiesThePricingScriptDetailsAreCorrect()
    {
        Pricing pricingProfile = get(KEY_CREATED_PRICING_SCRIPT);
        Pricing pricingProfileFromDb = get(KEY_PRICING_PROFILE_DETAILS);
        allShippersPage.verifyPricingScriptDetails(pricingProfile, pricingProfileFromDb);
    }

    @Given("Operator changes the country to {string}")
    public void operatorChangesTheCountryTo(String country)
    {
        profilePage.clickProfileButton();
        profilePage.changeCountry(country);
        profilePage.closeProfile();
    }

    @And("Operator verifies that Edit Pending Profile is displayed")
    public void operatorVerifiesThatEditPendingProfileIsDisplayed()
    {
        allShippersPage.verifyEditPendingProfileIsDisplayed();
    }

    @Then("Operator adds pricing script with invalid discount and verifies the error message")
    public void operatorAddsPricingScriptWithInvalidDiscountAndVerifiesTheErrorMessage(Map<String, String> mapOfData)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        String pricingScriptName = mapOfData.get("pricingScriptName");
        String discount = mapOfData.get("discount");
        String errorMessage = mapOfData.get("errorMessage");

        Pricing pricing = new Pricing();
        pricing.setScriptName(pricingScriptName);
        pricing.setDiscount(discount);

        shipper.setPricing(pricing);

        allShippersPage.addNewPricingScriptAndVerifyErrorMessage(shipper, errorMessage);
    }

    @Then("Operator adds pricing script with discount over 6 digits and verifies the error message")
    public void operatorAddsPricingScriptWithDiscountOver6DigitsAndVerifiesTheErrorMessage(Map<String, String> mapOfData)
    {
        Shipper shipper = get(KEY_CREATED_SHIPPER);
        String pricingScriptName = mapOfData.get("pricingScriptName");
        String discount = mapOfData.get("discount");
        String comments = mapOfData.get("comments");
        String errorMessage = mapOfData.get("errorMessage");

        Pricing pricing = new Pricing();
        pricing.setScriptName(pricingScriptName);
        pricing.setDiscount(discount);
        pricing.setComments(comments);

        shipper.setPricing(pricing);

        allShippersPage.addNewPricingScriptWithDiscountOver6DigitsAndVerifyErrorMessage(shipper, errorMessage);
    }
}
