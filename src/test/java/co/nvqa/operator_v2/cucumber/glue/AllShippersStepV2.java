package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.all_shippers.AllShippersPageV2;
import co.nvqa.operator_v2.selenium.page.all_shippers.ShipperCreatePageV2;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.commons.lang3.RandomStringUtils;

public class AllShippersStepV2 extends AbstractSteps {

    private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersStepV2.class);
    AllShippersPageV2 allShippersPage;
    ShipperCreatePageV2 shipperCreatePage;


    @Override
    public void init() {
        allShippersPage = new AllShippersPageV2(getWebDriver());
        shipperCreatePage = new ShipperCreatePageV2(getWebDriver());
    }

    public AllShippersStepV2() {

    }

    @When("Operator click create new shipper button")
    public void operatorClickCreateNewShipper() {
        allShippersPage.createShipper.click();
        allShippersPage.waitUntilLoaded(60);
    }

    @When("Operator switch to create new shipper tab")
    public void switchToCreateShipperTab() {
        allShippersPage.switchToOtherWindowAndWaitWhileLoading("/shippers/create");
    }

    @When("Operator select tracking type = {string} in shipper settings page")
    public void selectFixedPrefixType(String trackingType) {
        shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.scrollIntoView();
        shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.selectValue(
                resolveValue(trackingType));
    }

    @When("Operator fill shipper prefix with = {string} in shipper settings page")
    public void operatorFillInShipperPrefixSettingsPage(String value) {
        shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.forceClear();
        shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.type(resolveValue(value));
    }

    @When("Operator fill multi shipper prefix {string} with = {string} in shipper settings page")
    public void operatorFillInShipperMultiPrefixSettingsPage(String index, String value) {
        shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefix(index)
                .forceClear();
        shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefix(index)
                .type(resolveValue(value));
    }

    @When("Operator check error message in shipper prefix input is {string}")
    public void operatorCheckErrorInShipperPrefix(String value) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            String expectedError = resolveValue(value);
            String currentMessage = shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefixError();
            Assertions.assertThat(currentMessage)
                    .as(f("check shipper prefix error is: %s", expectedError))
                    .isEqualTo(expectedError);
        }, 2000, 3);
    }

    @When("Operator check error message in multi shipper prefix {string} input is {string}")
    public void operatorCheckErrorInShipperPrefix(String index, String value) {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            String expectedError = resolveValue(value);
            String currentMessage = shipperCreatePage.basicSettingsForm.operationalSettings.getShipperPrefixError(
                    index);
            Assertions.assertThat(currentMessage)
                    .as(f("check shipper prefix error is: %s", expectedError))
                    .isEqualTo(expectedError);
        }, 2000, 3);
    }

    @When("Operator fill Shipper Information Section with data:")
    public void fillShipperInformation(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Shipper Status") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.shipperStatus.selectValue(
                        shipperData.get("Shipper Status"));
            }
            if (shipperData.get("Shipper Type") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.shipperType.selectValue(
                        shipperData.get("Shipper Type"));
            }
            if (shipperData.get("Shipper Name") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.shipperName.type(
                        shipperData.get("Shipper Name"));
            }
            if (shipperData.get("Short Name") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.shortName.type(
                        shipperData.get("Short Name"));
            }
            if (shipperData.get("Shipper Phone Number") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.shipperPhoneNumber.type(
                        shipperData.get("Shipper Phone Number"));
            }
            if (shipperData.get("Shipper Email") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.shipperEmail.type(
                        shipperData.get("Shipper Email"));
            }
            if (shipperData.get("Chanel") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.channel.selectValue(
                        shipperData.get("Chanel"));
            }
            if (shipperData.get("Industry") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.industry.selectValue(
                        shipperData.get("Industry"));
            }
            if (shipperData.get("Account Type") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.accountType.selectValue(
                        shipperData.get("Account Type"));
            }
            if (shipperData.get("Sales person") != null) {
                shipperCreatePage.basicSettingsForm.shipperInformation.salesperson.selectValue(
                        shipperData.get("Sales person"));
            }

        }, 1000, 3);
    }

    @When("Operator verify Shipper Information Section with data:")
    public void verifyShipperInformation(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Shipper Status") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.shipperStatus
                        .getValue().trim();
                String expected = shipperData.get("Shipper Status");
                Assertions.assertThat(actual).as("Shipper Status").isEqualTo(expected);
            }
            if (shipperData.get("Shipper Type") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.shipperType
                        .getValue().trim();
                String expected = shipperData.get("Shipper Type");
                Assertions.assertThat(actual).as("Shipper Type").isEqualTo(expected);
            }
            if (shipperData.get("Shipper Name") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.shipperName
                        .getValue().trim();
                String expected = shipperData.get("Shipper Name");
                Assertions.assertThat(actual).as("Shipper Name").isEqualTo(expected);
            }
            if (shipperData.get("Short Name") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.shortName
                        .getValue().trim();
                String expected = shipperData.get("Short Name");
                Assertions.assertThat(actual).as("Short Name").isEqualTo(expected);
            }
            if (shipperData.get("Shipper Phone Number") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.shipperPhoneNumber
                        .getValue().trim();
                String expected = shipperData.get("Shipper Phone Number");
                Assertions.assertThat(actual).as("Shipper Phone Number").isEqualTo(expected);
            }
            if (shipperData.get("Shipper Email") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.shipperEmail
                        .getValue().trim();
                String expected = shipperData.get("Shipper Email");
                Assertions.assertThat(actual).as("Shipper Email").isEqualTo(expected);
            }
            if (shipperData.get("Chanel") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.channel
                        .getValue().trim();
                String expected = shipperData.get("Chanel");
                Assertions.assertThat(actual).as("Channel").isEqualTo(expected);
            }
            if (shipperData.get("Industry") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.industry
                        .getValue().trim();
                String expected = shipperData.get("Industry");
                Assertions.assertThat(actual).as("Industry").isEqualTo(expected);
            }
            if (shipperData.get("Account Type") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.accountType
                        .getValue().trim();
                String expected = shipperData.get("Account Type");
                Assertions.assertThat(actual).as("Account Type").isEqualTo(expected);
            }
            if (shipperData.get("Sales person") != null) {
                String actual = shipperCreatePage.basicSettingsForm.shipperInformation.salesperson
                        .getValue().trim();
                String expected = shipperData.get("Sales person");
                Assertions.assertThat(actual).as("Sales person").isEqualTo(expected);
            }


        }, 1000, 3);
    }

    @When("Operator fill Shipper Contact Details Section with data:")
    public void fillContactDetails(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {

            if (shipperData.get("Liaison Name") != null) {
                shipperCreatePage.basicSettingsForm.contactDetails.liaisonName.type(
                        shipperData.get("Liaison Name"));
            }
            if (shipperData.get("Liaison Contact") != null) {
                shipperCreatePage.basicSettingsForm.contactDetails.liaisonContact.type(
                        shipperData.get("Liaison Contact"));
            }
            if (shipperData.get("Liaison Email") != null) {
                shipperCreatePage.basicSettingsForm.contactDetails.liaisonEmail.type(
                        shipperData.get("Liaison Email"));
            }
            if (shipperData.get("Liaison Address") != null) {
                shipperCreatePage.basicSettingsForm.contactDetails.liaisonAddress.type(
                        shipperData.get("Liaison Address"));
            }
            if (shipperData.get("Liaison Postcode") != null) {
                shipperCreatePage.basicSettingsForm.contactDetails.liaisonPostcode.type(
                        shipperData.get("Liaison Postcode"));
            }
        }, 1000, 3);
    }

    @When("Operator verify Shipper Contact Details Section with data:")
    public void verifyContactDetails(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Liaison Name") != null) {
                String actual = shipperCreatePage.basicSettingsForm.contactDetails.liaisonName.getValue()
                        .trim();
                String expected = shipperData.get("Liaison Name");
                Assertions.assertThat(actual).as("Liaison Name").isEqualTo(expected);
            }
            if (shipperData.get("Liaison Contact") != null) {
                String actual = shipperCreatePage.basicSettingsForm.contactDetails.liaisonContact.getValue()
                        .trim();
                String expected = shipperData.get("Liaison Contact");
                Assertions.assertThat(actual).as("Liaison Contact").isEqualTo(expected);
            }
            if (shipperData.get("Liaison Email") != null) {
                String actual = shipperCreatePage.basicSettingsForm.contactDetails.liaisonEmail.getValue()
                        .trim();
                String expected = shipperData.get("Liaison Email");
                Assertions.assertThat(actual).as("Liaison Email").isEqualTo(expected);
            }
            if (shipperData.get("Liaison Address") != null) {
                String actual = shipperCreatePage.basicSettingsForm.contactDetails.liaisonAddress.getValue()
                        .trim();
                String expected = shipperData.get("Liaison Address");
                Assertions.assertThat(actual).as("Liaison Address").isEqualTo(expected);
            }
            if (shipperData.get("Liaison Postcode") != null) {
                String actual = shipperCreatePage.basicSettingsForm.contactDetails.liaisonPostcode.getValue()
                        .trim();
                String expected = shipperData.get("Liaison Postcode");
                Assertions.assertThat(actual).as("Liaison Postcode").isEqualTo(expected);
            }

        }, 1000, 3);
    }


    @When("Operator fill Service Offerings Section with data:")
    public void fillServiceOfferings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.basicSettingsForm.serviceOfferings.ocVersion.scrollIntoView();

            if (shipperData.get("Parcel Delivery") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.parcelDelivery.selectValue(
                        shipperData.get("Parcel Delivery"));
            }
            if (shipperData.get("Return") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.Return.selectValue(
                        shipperData.get("Return"));
            }
            if (shipperData.get("Marketplace") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.marketplace.selectValue(
                        shipperData.get("Marketplace"));
            }
            if (shipperData.get("International") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.international.selectValue(
                        shipperData.get("International"));
            }
            if (shipperData.get("Marketplace International") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.marketplaceInternational.selectValue(
                        shipperData.get("Marketplace International"));
            }
            if (shipperData.get("Document") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.document.selectValue(
                        shipperData.get("Document"));
            }
            if (shipperData.get("Corporate") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.corporate.selectValue(
                        shipperData.get("Corporate"));
            }
            if (shipperData.get("Corporate Return") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.corporateReturn.selectValue(
                        shipperData.get("Corporate Return"));
            }
            if (shipperData.get("Corporate Manual AWB") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.corporateManualAWB.selectValue(
                        shipperData.get("Corporate Manual AWB"));
            }
            if (shipperData.get("Corporate Document") != null) {
                shipperCreatePage.basicSettingsForm.serviceOfferings.corporateDocument.selectValue(
                        shipperData.get("Corporate Document"));
            }

            if (shipperData.get("Service Level") != null) {
                String[] values = shipperData.get("Service Level").split(",", -1);
                for (String value : values) {
                    shipperCreatePage.basicSettingsForm.serviceOfferings.serviceLevel.selectValue(
                            value);

                }
                shipperCreatePage.basicSettingsForm.serviceOfferings.serviceLevel.closeMenu();
            }
        }, 1000, 3);
    }


    @When("Operator verify Service Offerings Section with data:")
    public void verifyServiceOfferings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.basicSettingsForm.serviceOfferings.ocVersion.scrollIntoView();

            if (shipperData.get("Parcel Delivery") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.parcelDelivery.getValue()
                        .trim();
                String expected = shipperData.get("Parcel Delivery");
                Assertions.assertThat(actual).as("Parcel Delivery").isEqualTo(expected);
            }
            if (shipperData.get("Return") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.Return.getValue()
                        .trim();
                String expected = shipperData.get("Return");
                Assertions.assertThat(actual).as("Return").isEqualTo(expected);
            }
            if (shipperData.get("Marketplace") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.marketplace.getValue()
                        .trim();
                String expected = shipperData.get("Marketplace");
                Assertions.assertThat(actual).as("Marketplace").isEqualTo(expected);
            }
            if (shipperData.get("International") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.international.getValue()
                        .trim();
                String expected = shipperData.get("International");
                Assertions.assertThat(actual).as("International").isEqualTo(expected);
            }
            if (shipperData.get("Marketplace International") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.marketplaceInternational.getValue()
                        .trim();
                String expected = shipperData.get("Marketplace International");
                Assertions.assertThat(actual).as("Marketplace International").isEqualTo(expected);
            }
            if (shipperData.get("Document") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.document.getValue()
                        .trim();
                String expected = shipperData.get("Document");
                Assertions.assertThat(actual).as("Document").isEqualTo(expected);
            }
            if (shipperData.get("Corporate") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.corporate.getValue()
                        .trim();
                String expected = shipperData.get("Corporate");
                Assertions.assertThat(actual).as("Corporate").isEqualTo(expected);
            }
            if (shipperData.get("Corporate Return") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.corporateReturn.getValue()
                        .trim();
                String expected = shipperData.get("Corporate Return");
                Assertions.assertThat(actual).as("Corporate Return").isEqualTo(expected);
            }
            if (shipperData.get("Corporate Manual AWB") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.corporateManualAWB.getValue()
                        .trim();
                String expected = shipperData.get("Corporate Manual AWB");
                Assertions.assertThat(actual).as("Corporate Manual AWB").isEqualTo(expected);
            }
            if (shipperData.get("Corporate Document") != null) {
                String actual = shipperCreatePage.basicSettingsForm.serviceOfferings.corporateDocument.getValue()
                        .trim();
                String expected = shipperData.get("Corporate Document");
                Assertions.assertThat(actual).as("Corporate Document").isEqualTo(expected);
            }


        }, 1000, 3);
    }


    @When("Operator fill Operational settings Section with data:")
    public void fillOperationalSettings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {

            if (shipperData.get("Cash on Delivery(COD)") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.allowCod.selectValue(
                        shipperData.get("Cash on Delivery(COD)"));
            }

            if (shipperData.get("Cash Pickup (CP)") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.allowCp.selectValue(
                        shipperData.get("Cash Pickup (CP)"));
            }

            if (shipperData.get("Prepaid Account") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.isPrePaid.selectValue(
                        shipperData.get("Prepaid Account"));
            }

            if (shipperData.get("Staged Orders") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.allowStaging.selectValue(
                        shipperData.get("Staged Orders"));
            }

            if (shipperData.get("Multi Parcel") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.isMultiParcel.selectValue(
                        shipperData.get("Multi Parcel"));
            }

            if (shipperData.get("Allow Driver Reschedule") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.disableReschedule.selectValue(
                        shipperData.get("Allow Driver Reschedule"));
            }

            if (shipperData.get("Enforce Pickup Scanning") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.enforceParcelPickupTracking.selectValue(
                        shipperData.get("Enforce Pickup Scanning"));
            }

            if (shipperData.get("Allow Enforce Delivery Verification") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.allowEnforceDeliveryVerification.selectValue(
                        shipperData.get("Allow Enforce Delivery Verification"));
            }

            if (shipperData.get("Delivery Address Validation") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.isDeliveryAddressValidationEnabled.selectValue(
                        shipperData.get("Delivery Address Validation"));
            }

            if (shipperData.get("No of Digits in delivery") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.deliveryOtpLength.selectValue(
                        shipperData.get("No of Digits in delivery"));
            }

            if (shipperData.get("No of validation attemps") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.deliveryOtpValidationLimit.selectValue(
                        shipperData.get("No of validation attemps"));
            }

            if (shipperData.get("Tracking type") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.selectValue(
                        shipperData.get("Tracking type"));

            }

            if (shipperData.get("Prefix") != null) {
                if (shipperData.get("Prefix").equals("RANDOM")) {
                    String prefix = RandomStringUtils.randomAlphabetic(5);
                    shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.type(
                            prefix);
                    put("KEY_SHIPPER_PREFIX", prefix);
                } else {
                    shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.type(
                            shipperData.get("Prefix"));
                }
            }
            if (shipperData.get("Show Shipper Details") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.showShipperDetails.selectValue(
                        shipperData.get("Show Shipper Details"));
            }

            if (shipperData.get("Show COD") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.showCod.selectValue(
                        shipperData.get("Show COD"));
            }

            if (shipperData.get("Show Parcel Description") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.showParcelDescription.selectValue(
                        shipperData.get("Show Parcel Description"));
            }

            if (shipperData.get("Printer IP") != null) {
                shipperCreatePage.basicSettingsForm.operationalSettings.printerIp.type(
                        shipperData.get("Printer IP"));
            }

        }, 1000, 3);
    }

    @When("Operator verify Operational settings Section with data:")
    public void verifyOperationalSettings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {

            if (shipperData.get("Cash on Delivery(COD)") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.allowCod.getValue()
                        .trim();
                String expected = shipperData.get("Cash on Delivery(COD)");
                Assertions.assertThat(actual).as("Cash on Delivery(COD)").isEqualTo(expected);
            }

            if (shipperData.get("Cash Pickup (CP)") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.allowCp.getValue()
                        .trim();
                String expected = shipperData.get("Cash Pickup (CP)");
                Assertions.assertThat(actual).as("Cash Pickup (CP)").isEqualTo(expected);
            }

            if (shipperData.get("Prepaid Account") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.isPrePaid.getValue()
                        .trim();
                String expected = shipperData.get("Prepaid Account");
                Assertions.assertThat(actual).as("Prepaid Account").isEqualTo(expected);
            }

            if (shipperData.get("Staged Orders") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.allowStaging.getValue()
                        .trim();
                String expected = shipperData.get("Staged Orders");
                Assertions.assertThat(actual).as("Staged Orders").isEqualTo(expected);
            }

            if (shipperData.get("Multi Parcel") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.isMultiParcel.getValue()
                        .trim();
                String expected = shipperData.get("Multi Parcel");
                Assertions.assertThat(actual).as("Multi Parcel").isEqualTo(expected);
            }

            if (shipperData.get("Allow Driver Reschedule") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.disableReschedule.getValue()
                        .trim();
                String expected = shipperData.get("Allow Driver Reschedule");
                Assertions.assertThat(actual).as("Allow Driver Reschedule").isEqualTo(expected);
            }

            if (shipperData.get("Enforce Pickup Scanning") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.enforceParcelPickupTracking.getValue()
                        .trim();
                String expected = shipperData.get("Enforce Pickup Scanning");
                Assertions.assertThat(actual).as("Enforce Pickup Scanning").isEqualTo(expected);
            }

            if (shipperData.get("Allow Enforce Delivery Verification") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.allowEnforceDeliveryVerification.getValue()
                        .trim();
                String expected = shipperData.get("Allow Enforce Delivery Verification");
                Assertions.assertThat(actual).as("Allow Enforce Delivery Verification").isEqualTo(expected);
            }

            if (shipperData.get("Delivery Address Validation") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.isDeliveryAddressValidationEnabled.getValue()
                        .trim();
                String expected = shipperData.get("Delivery Address Validation");
                Assertions.assertThat(actual).as("Delivery Address Validation").isEqualTo(expected);
            }

            if (shipperData.get("No of Digits in delivery") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.deliveryOtpLength.getValue()
                        .trim();
                String expected = shipperData.get("No of Digits in delivery");
                Assertions.assertThat(actual).as("No of Digits in delivery").isEqualTo(expected);
            }

            if (shipperData.get("No of validation attemps") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.deliveryOtpValidationLimit.getValue()
                        .trim();
                String expected = shipperData.get("No of validation attemps");
                Assertions.assertThat(actual).as("No of validation attempts").isEqualTo(expected);

            }

            if (shipperData.get("Tracking type") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.getValue()
                        .trim();
                String expected = shipperData.get("Tracking type");
                Assertions.assertThat(actual).as("Tracking type").isEqualTo(expected);

            }

            if (shipperData.get("Prefix") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.shipperPrefix.getValue()
                        .trim();
                String expected = shipperData.get("Prefix");
                Assertions.assertThat(actual).as("Shipper Prefix").isEqualTo(expected);

            }
            if (shipperData.get("Show Shipper Details") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.showShipperDetails.getValue()
                        .trim();
                String expected = shipperData.get("Show Shipper Details");
                Assertions.assertThat(actual).as("Show Shipper Details").isEqualTo(expected);

            }

            if (shipperData.get("Show COD") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.showCod.getValue()
                        .trim();
                String expected = shipperData.get("Show COD");
                Assertions.assertThat(actual).as("Show COD").isEqualTo(expected);

            }

            if (shipperData.get("Show Parcel Description") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.showParcelDescription.getValue()
                        .trim();
                String expected = shipperData.get("Show Parcel Description");
                Assertions.assertThat(actual).as("Show Parcel Description").isEqualTo(expected);

            }

            if (shipperData.get("Printer IP") != null) {
                String actual = shipperCreatePage.basicSettingsForm.operationalSettings.printerIp.getValue()
                        .trim();
                String expected = shipperData.get("Printer IP");
                Assertions.assertThat(actual).as("Printer IP").isEqualTo(expected);

            }

        }, 1000, 3);
    }
    @Given("Operator verify that toggle: {string} is disabled in Operational settings")
    public void operatorVerifyThatToggleIsDisabledInOperationalSettings(String toggle) {
        if (toggle.equalsIgnoreCase("Show Parcel Description")) {
            System.out.println(shipperCreatePage.basicSettingsForm.operationalSettings.showParcelDescription.getAttribute("disabled"));
            String actual = ! Objects.isNull(shipperCreatePage.basicSettingsForm.operationalSettings.showParcelDescription.getAttribute("disabled")) ?
                shipperCreatePage.basicSettingsForm.operationalSettings.showParcelDescription.getAttribute("disabled").trim() : "false";
            Assertions.assertThat(actual).as("Show Parcel Description").isEqualToIgnoringCase("true");
            return;
        }
        Assertions.fail("No matches for the given toggle name");
    }

    @When("Operator fill Failed Delivery Management Section with data:")
    public void fillFailedDeliveryManagement(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Shipper Bucket") != null) {
                shipperCreatePage.basicSettingsForm.failedDeliveryManagement.shipperBucket.selectValue(
                        shipperData.get("Shipper Bucket"));
            }

            if (shipperData.get("XB Fulfillment Setting") != null) {
                shipperCreatePage.basicSettingsForm.failedDeliveryManagement.fulfillmentService.selectValue(
                        shipperData.get("XB Fulfillment Setting"));
            }

            if (shipperData.get("No. of Free Storage Days") != null) {
                shipperCreatePage.basicSettingsForm.failedDeliveryManagement.freeStorageDays.clear();
                shipperCreatePage.basicSettingsForm.failedDeliveryManagement.freeStorageDays.type(
                        shipperData.get("No. of Free Storage Days"));
            }

            if (shipperData.get("No. of Maximum Storage Days") != null) {
                shipperCreatePage.basicSettingsForm.failedDeliveryManagement.maximumStorageDays.clear();
                shipperCreatePage.basicSettingsForm.failedDeliveryManagement.maximumStorageDays.type(
                        shipperData.get("No. of Maximum Storage Days"));
            }


        }, 1000, 3);
    }


    @When("Operator verify Failed Delivery Management Section with data:")
    public void verifyFailedDeliveryManagement(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Shipper Bucket") != null) {
                String actual = shipperCreatePage.basicSettingsForm.failedDeliveryManagement.shipperBucket.getValue()
                        .trim();
                String expected = shipperData.get("Shipper Bucket");
                Assertions.assertThat(actual).as("Shipper Bucket").isEqualTo(expected);

            }

            if (shipperData.get("XB Fulfillment Setting") != null) {
                String actual = shipperCreatePage.basicSettingsForm.failedDeliveryManagement.fulfillmentService.getValue()
                        .trim();
                String expected = shipperData.get("XB Fulfillment Setting");
                Assertions.assertThat(actual).as("XB Fulfillment Setting").isEqualTo(expected);

            }

            if (shipperData.get("No. of Free Storage Days") != null) {
                String actual = shipperCreatePage.basicSettingsForm.failedDeliveryManagement.freeStorageDays.getValue()
                        .trim();
                String expected = shipperData.get("No. of Free Storage Days");
                Assertions.assertThat(actual).as("No. of Free Storage Days").isEqualTo(expected);

            }

            if (shipperData.get("No. of Maximum Storage Days") != null) {
                String actual = shipperCreatePage.basicSettingsForm.failedDeliveryManagement.maximumStorageDays.getValue(
                ).trim();
                String expected = shipperData.get("No. of Maximum Storage Days");
                Assertions.assertThat(actual).as("No. of Maximum Storage Days").isEqualTo(expected);

            }


        }, 1000, 3);
    }

    @When("Operator click in more settings tab in shipper create edit page")
    public void moreSettingsTab() {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.tabs.selectTab("More Settings");
        }, 1000, 3);
    }


    @When("Operator Add new address in More Settings Section with data:")
    public void fillAddAddressInMoreSettings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.moreSettingsForm.addAddress.click();
            shipperCreatePage.addAddressDialog.contactName.type(
                    shipperData.get("Contact Name"));
            shipperCreatePage.addAddressDialog.contactMobileNumber.type(
                    shipperData.get("Contact Mobile Number"));
            shipperCreatePage.addAddressDialog.contactEmail.type(
                    shipperData.get("Contact Email"));
            shipperCreatePage.addAddressDialog.pickupAddress1.type(
                    shipperData.get("Pickup Address 1"));
            shipperCreatePage.addAddressDialog.pickupAddress2.type(
                    shipperData.get("Pickup Address 2"));
            shipperCreatePage.addAddressDialog.country.selectValue(
                    shipperData.get("Country"));
            shipperCreatePage.addAddressDialog.pickupPostcode.type(
                    shipperData.get("Pickup Postcode"));
            shipperCreatePage.addAddressDialog.latitude.type(
                    shipperData.get("Latitude"));
            shipperCreatePage.addAddressDialog.longitude.type(
                    shipperData.get("Longitude"));
            shipperCreatePage.addAddressDialog.saveChanges.click();
        }, 1000, 3);
    }

    @When("Operator fill More Settings Section with data:")
    public void fillMoreSettings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Shipper Customer Reservation") != null) {
                shipperCreatePage.moreSettingsForm.customerReservation.selectValue(
                        shipperData.get("Shipper Customer Reservation"));
            }

            if (shipperData.get("Allow premium pickup on Sunday") != null) {
                shipperCreatePage.moreSettingsForm.allowPremiumPickupOnSunday.selectValue(
                        shipperData.get("Allow premium pickup on Sunday"));
            }

            if (shipperData.get("Premium pickup daily limit") != null) {
                shipperCreatePage.moreSettingsForm.premiumPickupDailyLimit.clear();
                shipperCreatePage.moreSettingsForm.premiumPickupDailyLimit.type(
                        shipperData.get("Premium pickup daily limit"));
            }

            if (shipperData.get("Premium pickup daily limit marktplace") != null) {
                shipperCreatePage.premiumPickupDailyLimitMarketplace.clear();
                shipperCreatePage.premiumPickupDailyLimitMarketplace.type(
                        shipperData.get("Premium pickup daily limit marktplace"));
            }

            if (shipperData.get("Service Level") != null) {
                shipperCreatePage.moreSettingsForm.serviceLevel.selectValue(
                        shipperData.get("Service Level"));
            }

            if (shipperData.get("Default Pickup Time Selector") != null) {
                shipperCreatePage.moreSettingsForm.defaultPickupTimeSelector.selectValue(
                        shipperData.get("Default Pickup Time Selector"));
            }

            if (shipperData.get("Returns for this Shipper") != null) {
                shipperCreatePage.moreSettingsForm.isReturnsEnabled.selectValue(
                        shipperData.get("Returns for this Shipper"));
            }


            if (shipperData.get("Pickup Address 2") != null) {
                shipperCreatePage.moreSettingsForm.replaceWithLiaisonDetails.click();
                shipperCreatePage.moreSettingsForm.returnAddress2.type(shipperData.get("Pickup Address 2"));
            }

            if (shipperData.get("Return City") != null) {
                shipperCreatePage.moreSettingsForm.returnCity.type(shipperData.get("Return City"));
            }

            if (shipperData.get("Last Return Number") != null) {
                shipperCreatePage.moreSettingsForm.lastReturnNumber.type(
                        shipperData.get("Last Return Number"));
            }

            if (shipperData.get("Integrated Vault") != null) {
                shipperCreatePage.moreSettingsForm.isIntegratedVault.selectValue(
                        shipperData.get("Integrated Vault"));
            }

            if (shipperData.get("Collect Customer NRIC Code") != null) {
                shipperCreatePage.moreSettingsForm.isCollectCustomerNricCode.selectValue(
                        shipperData.get("Collect Customer NRIC Code"));
            }

            if (shipperData.get("Return on DBMS") != null) {
                shipperCreatePage.moreSettingsForm.isReturnsOnDpms.selectValue(
                        shipperData.get("Return on DBMS"));
            }

            if (shipperData.get("Return on Vault") != null) {
                shipperCreatePage.moreSettingsForm.isReturnsOnVault.selectValue(
                        shipperData.get("Return on Vault"));
            }

            if (shipperData.get("Returns on Shipper Lite") != null) {
                shipperCreatePage.moreSettingsForm.isReturnsOnShipperLite.selectValue(
                        shipperData.get("Returns on Shipper Lite"));
            }

            if (shipperData.get("Allow Fully Integrated Ninja Collect") != null) {
                shipperCreatePage.moreSettingsForm.allowNinjaCollect.selectValue(
                        shipperData.get("Allow Fully Integrated Ninja Collect"));
            }

            if (shipperData.get("Allow doorstep delivery for no capacity scenarios") != null) {
                shipperCreatePage.moreSettingsForm.allowNoCapDoorStepDelivery.selectValue(
                        shipperData.get("Allow doorstep delivery for no capacity scenarios"));
            }

            if (shipperData.get("DPMS Logo URL") != null) {
                shipperCreatePage.moreSettingsForm.DPMSLogoURL.type(shipperData.get("DPMS Logo URL"));
            }

            if (shipperData.get("Vault Logo URL") != null) {
                shipperCreatePage.moreSettingsForm.VaultLogoURL.type(shipperData.get("Vault Logo URL"));
            }

            if (shipperData.get("Shipper Lite Logo URL") != null) {
                shipperCreatePage.moreSettingsForm.ShipperLiteLogoURL.type(
                        shipperData.get("Shipper Lite Logo URL"));
            }

            if (shipperData.get("Eligible Service Levels for Ninja Collect") != null) {
                shipperCreatePage.moreSettingsForm.eligibleServiceLevels.selectValue(
                        shipperData.get("Eligible Service Levels for Ninja Collect"));
            }
            shipperCreatePage.moreSettingsForm.eligibleServiceLevels.closeMenu();

            if (shipperData.get("Deadline Fallback Action") != null) {
                shipperCreatePage.moreSettingsForm.deadlineFallbackAction.selectValue(
                        shipperData.get("Deadline Fallback Action"));
            }

            if (shipperData.get("Transit Shipper") != null) {
                shipperCreatePage.moreSettingsForm.transitShipper.selectValue(
                        shipperData.get("Transit Shipper"));
            }

            if (shipperData.get("Transit Customer") != null) {
                shipperCreatePage.moreSettingsForm.transitCustomer.selectValue(
                        shipperData.get("Transit Customer"));
            }

            if (shipperData.get("Completed Shipper") != null) {
                shipperCreatePage.moreSettingsForm.completedShipper.selectValue(
                        shipperData.get("Completed Shipper"));
            }

            if (shipperData.get("Completed Customer") != null) {
                shipperCreatePage.moreSettingsForm.completedCustomer.selectValue(
                        shipperData.get("Completed Customer"));
            }

            if (shipperData.get("Pickup fail Shipper") != null) {
                shipperCreatePage.moreSettingsForm.pickupFailShipper.selectValue(
                        shipperData.get("Pickup fail Shipper"));
            }

            if (shipperData.get("Pickup fail Customer") != null) {
                shipperCreatePage.moreSettingsForm.pickupFailCustomer.selectValue(
                        shipperData.get("Pickup fail Customer"));
            }

            if (shipperData.get("Delivery fail Shipper") != null) {
                shipperCreatePage.moreSettingsForm.deliveryFailShipper.selectValue(
                        shipperData.get("Delivery fail Shipper"));
            }

            if (shipperData.get("Delivery fail Customer") != null) {
                shipperCreatePage.moreSettingsForm.deliveryFailCustomer.selectValue(
                        shipperData.get("Delivery fail Customer"));
            }


        }, 1000, 3);
    }


    @When("Operator verify More Settings Section with data:")
    public void verifyMoreSettings(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Shipper Customer Reservation") != null) {
                String actual = shipperCreatePage.moreSettingsForm.customerReservation.getValue().trim();
                String expected = shipperData.get("Shipper Customer Reservation");
                Assertions.assertThat(actual).as("Shipper Customer Reservation").isEqualTo(expected);

            }

            if (shipperData.get("Allow premium pickup on Sunday") != null) {
                String actual = shipperCreatePage.moreSettingsForm.allowPremiumPickupOnSunday.getValue()
                        .trim();
                String expected = shipperData.get("Allow premium pickup on Sunday");
                Assertions.assertThat(actual).as("Allow premium pickup on Sunday").isEqualTo(expected);

            }

            if (shipperData.get("Premium pickup daily limit") != null) {
                String actual = shipperCreatePage.moreSettingsForm.premiumPickupDailyLimit.getValue()
                        .trim();
                String expected = shipperData.get("Premium pickup daily limit");
                Assertions.assertThat(actual).as("Premium pickup daily limit").isEqualTo(expected);

            }

            if (shipperData.get("Service Level") != null) {
                String actual = shipperCreatePage.moreSettingsForm.serviceLevel.getValue().trim();
                String expected = shipperData.get("Service Level");
                Assertions.assertThat(actual).as("Service Level").isEqualTo(expected);

            }

            if (shipperData.get("Return City") != null) {
                String returnCity = shipperData.get("Return City");
                String actual = shipperCreatePage.moreSettingsForm.returnCity.getValue().trim();
                Assertions.assertThat(actual).as("Return City").isEqualTo(returnCity);

            }

            if (shipperData.get("Last Return Number") != null) {
                String lastReturnNumber = shipperData.get("Last Return Number");
                String actual = shipperCreatePage.moreSettingsForm.lastReturnNumber.getValue().trim();
                Assertions.assertThat(actual).as("Last Return Number").isEqualTo(lastReturnNumber);

            }

            if (shipperData.get("Integrated Vault") != null) {
                String expected = shipperData.get("Integrated Vault");
                String actual = shipperCreatePage.moreSettingsForm.isIntegratedVault.getValue().trim();
                Assertions.assertThat(actual).as("Integrated Vault").isEqualTo(expected);

            }

            if (shipperData.get("Collect Customer NRIC Code") != null) {
                String expected = shipperData.get("Collect Customer NRIC Code");
                String actual = shipperCreatePage.moreSettingsForm.isCollectCustomerNricCode.getValue()
                        .trim();
                Assertions.assertThat(actual).as("Collect Customer NRIC Code").isEqualTo(expected);

            }

            if (shipperData.get("Return on DBMS") != null) {
                String expected = shipperData.get("Return on DBMS");
                String actual = shipperCreatePage.moreSettingsForm.isReturnsOnDpms.getValue().trim();
                Assertions.assertThat(actual).as("Return on DBMS").isEqualTo(expected);

            }

            if (shipperData.get("Return on Vault") != null) {
                String expected = shipperData.get("Return on Vault");
                String actual = shipperCreatePage.moreSettingsForm.isReturnsOnVault.getValue().trim();
                Assertions.assertThat(actual).as("Return on Vault").isEqualTo(expected);

            }

            if (shipperData.get("Returns on Shipper Lite") != null) {
                String expected = shipperData.get("Returns on Shipper Lite");
                String actual = shipperCreatePage.moreSettingsForm.isReturnsOnShipperLite.getValue().trim();
                Assertions.assertThat(actual).as("Returns on Shipper Lite").isEqualTo(expected);

            }

            if (shipperData.get("Allow Fully Integrated Ninja Collect") != null) {
                String expected = shipperData.get("Allow Fully Integrated Ninja Collect");
                String actual = shipperCreatePage.moreSettingsForm.allowNinjaCollect.getValue().trim();
                Assertions.assertThat(actual).as("Allow Fully Integrated Ninja Collect")
                        .isEqualTo(expected);

            }

            if (shipperData.get("Allow doorstep delivery for no capacity scenarios") != null) {
                String expected = shipperData.get("Allow doorstep delivery for no capacity scenarios");
                String actual = shipperCreatePage.moreSettingsForm.allowNoCapDoorStepDelivery.getValue()
                        .trim();
                Assertions.assertThat(actual).as("Allow doorstep delivery for no capacity scenarios")
                        .isEqualTo(expected);

            }

            if (shipperData.get("DPMS Logo URL") != null) {
                String expected = shipperData.get("DPMS Logo URL");
                String actual = shipperCreatePage.moreSettingsForm.DPMSLogoURL.getValue().trim();
                Assertions.assertThat(actual).as("DPMS Logo URL").isEqualTo(expected);

            }

            if (shipperData.get("Vault Logo URL") != null) {
                String expected = shipperData.get("Vault Logo URL");
                String actual = shipperCreatePage.moreSettingsForm.VaultLogoURL.getValue().trim();
                Assertions.assertThat(actual).as("Vault Logo URL").isEqualTo(expected);

            }

            if (shipperData.get("Shipper Lite Logo URL") != null) {
                String expected = shipperData.get("Shipper Lite Logo URL");
                String actual = shipperCreatePage.moreSettingsForm.ShipperLiteLogoURL.getValue().trim();
                Assertions.assertThat(actual).as("Shipper Lite Logo URL").isEqualTo(expected);

            }

            if (shipperData.get("Eligible Service Levels for Ninja Collect") != null) {
                String actual = shipperCreatePage.moreSettingsForm.eligibleServiceLevels.getValue().trim();
                String expected = shipperData.get("Eligible Service Levels for Ninja Collect");
                Assertions.assertThat(actual).as("Eligible Service Levels for Ninja Collect")
                        .isEqualTo(expected);

            }

            if (shipperData.get("Deadline Fallback Action") != null) {
                String actual = shipperCreatePage.moreSettingsForm.deadlineFallbackAction.getValue().trim();
                String expected = shipperData.get("Deadline Fallback Action");
                Assertions.assertThat(actual).as("Deadline Fallback Action").isEqualTo(expected);

            }

            if (shipperData.get("Transit Shipper") != null) {
                String actual = shipperCreatePage.moreSettingsForm.transitShipper.getValue().trim();
                String expected = shipperData.get("Transit Shipper");
                Assertions.assertThat(actual).as("Transit Shipper").isEqualTo(expected);

            }

            if (shipperData.get("Transit Customer") != null) {
                String actual = shipperCreatePage.moreSettingsForm.transitCustomer.getValue().trim();
                String expected = shipperData.get("Transit Customer");
                Assertions.assertThat(actual).as("Transit Customer").isEqualTo(expected);

            }

            if (shipperData.get("Completed Shipper") != null) {
                String actual = shipperCreatePage.moreSettingsForm.completedShipper.getValue().trim();
                String expected = shipperData.get("Completed Shipper");
                Assertions.assertThat(actual).as("Completed Shipper").isEqualTo(expected);

            }

            if (shipperData.get("Completed Customer") != null) {
                String actual = shipperCreatePage.moreSettingsForm.completedCustomer.getValue().trim();
                String expected = shipperData.get("Completed Customer");
                Assertions.assertThat(actual).as("Completed Customer").isEqualTo(expected);

            }

            if (shipperData.get("Pickup fail Shipper") != null) {
                String actual = shipperCreatePage.moreSettingsForm.pickupFailShipper.getValue().trim();
                String expected = shipperData.get("Pickup fail Shipper");
                Assertions.assertThat(actual).as("Pickup Fail Shipper").isEqualTo(expected);

            }

            if (shipperData.get("Pickup fail Customer") != null) {
                String actual = shipperCreatePage.moreSettingsForm.pickupFailCustomer.getValue().trim();
                String expected = shipperData.get("Pickup fail Customer");
                Assertions.assertThat(actual).as("Pickup Fail Customer").isEqualTo(expected);

            }

            if (shipperData.get("Delivery fail Shipper") != null) {
                String actual = shipperCreatePage.moreSettingsForm.deliveryFailShipper.getValue().trim();
                String expected = shipperData.get("Delivery fail Shipper");
                Assertions.assertThat(actual).as("Delivery Fail Shipper").isEqualTo(expected);

            }

            if (shipperData.get("Delivery fail Customer") != null) {
                String actual = shipperCreatePage.moreSettingsForm.deliveryFailCustomer.getValue().trim();
                String expected = shipperData.get("Delivery fail Customer");
                Assertions.assertThat(actual).as("Delivery Fail Customer").isEqualTo(expected);

            }

        }, 1000, 3);
    }


    @When("Operator click in Pricing and Billing tab in shipper create edit page")
    public void pricingAndBillingTab() {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.tabs.selectTab("Pricing and Billing");
        }, 1000, 3);
    }

    @When("Operator fill Billing information in Pricing and Billing Section with data:")
    public void fillBillingPricingAnDBilling(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Billing Name") != null) {
                shipperCreatePage.pricingAndBillingForm.billingName.type(shipperData.get("Billing Name"));
            }

            if (shipperData.get("Billing Contact") != null) {
                shipperCreatePage.pricingAndBillingForm.billingContact.type(
                        shipperData.get("Billing Contact"));
            }

            if (shipperData.get("Billing Address") != null) {
                shipperCreatePage.pricingAndBillingForm.billingAddress.type(
                        shipperData.get("Billing Address"));
            }

            if (shipperData.get("Billing Post Code") != null) {
                shipperCreatePage.pricingAndBillingForm.billingPostcode.type(
                        shipperData.get("Billing Post Code"));
            }


        }, 1000, 3);

    }

    @When("Operator verify Billing information in Pricing and Billing Section with data:")
    public void verifyBillingPricingAnDBilling(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            if (shipperData.get("Billing Name") != null) {
                String expectedBillingName = shipperData.get("Billing Name");
                String actualBillingName = shipperCreatePage.pricingAndBillingForm.billingName.getValue()
                        .trim();
                Assertions.assertThat(actualBillingName).as("Billing Name").isEqualTo(expectedBillingName);

            }

            if (shipperData.get("Billing Contact") != null) {
                String expectedBillingContact = shipperData.get("Billing Contact");
                String actualBillingContact = shipperCreatePage.pricingAndBillingForm.billingContact.getValue()
                        .trim();
                Assertions.assertThat(actualBillingContact).as("Billing Contact")
                        .isEqualTo(expectedBillingContact);

            }

            if (shipperData.get("Billing Address") != null) {
                String expectedBillingAddress = shipperData.get("Billing Address");
                String actualBillingAddress = shipperCreatePage.pricingAndBillingForm.billingAddress.getValue()
                        .trim();
                Assertions.assertThat(actualBillingAddress).as("Billing Address")
                        .isEqualTo(expectedBillingAddress);

            }

            if (shipperData.get("Billing Post Code") != null) {
                String expectedBillingPostcode = shipperData.get("Billing Post Code");
                String actualBillingPostcode = shipperCreatePage.pricingAndBillingForm.billingPostcode.getValue()
                        .trim();
                Assertions.assertThat(actualBillingPostcode).as("Billing Post Code")
                        .isEqualTo(expectedBillingPostcode);

            }


        }, 1000, 3);

    }

    @When("Operator Add new profile in Pricing and Billing Section with data:")
    public void fillProfileInPricingAnDBiling(Map<String, String> mapOfData) {
        Map<String, String> shipperData = resolveKeyValues(mapOfData);
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.pricingAndBillingForm.addNewProfile.click();
            shipperCreatePage.newPricingProfileDialog.pricingBillingEndDate.simpleSetValue(
                    shipperData.get("End Date"));

            shipperCreatePage.newPricingProfileDialog.pricingScript.selectValue(
                    shipperData.get("Pricing Scripts"));
            shipperCreatePage.newPricingProfileDialog.comments.type(
                    shipperData.get("Comments"));
            shipperCreatePage.newPricingProfileDialog.discountValue.type(
                    shipperData.get("Discount Value"));
            shipperCreatePage.newPricingProfileDialog.codCountryDefaultCheckbox.check();
            shipperCreatePage.newPricingProfileDialog.insuranceCountryDefaultCheckbox.check();
            shipperCreatePage.newPricingProfileDialog.rtsCountryDefaultCheckbox.check();
            shipperCreatePage.newPricingProfileDialog.saveChanges.click();
        }, 1000, 3);
    }


    @When("Operator save new shipper")
    public void operatorSaveNewShipper() {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            pause8s();
            shipperCreatePage.createShipper.click();
            shipperCreatePage.waitUntilInvisibilityOfToast("All changes saved successfully");
            String url = getWebDriver().getCurrentUrl();
            Long shipperLegacyId = Long.valueOf(url.substring(url.lastIndexOf("/") + 1));
            put("KEY_CREATED_SHIPPER_ID", shipperLegacyId);
        }, 1000, 3);
    }

    @When("Operator save changes on Edit Shippers page")
    public void operatorUpdateShipper() {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            pause8s();
            shipperCreatePage.saveChanges.click();
            shipperCreatePage.waitUntilInvisibilityOfToast("All changes saved successfully");
        }, 1000, 3);
    }

    @When("Operator verify {string} equals {string}")
    public void verifySettingsValue(String value, String setting) {
        String val = resolveValue(value);
        String set = resolveValue(setting);
        Assertions.assertThat(val)
                .as(f("key value is equal")).contains(set);
    }

    @When("Operator click in Marketplace settings tab in shipper create edit page")
    public void MarketplaceTab() {
        retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
            shipperCreatePage.tabs.selectTab("Marketplace");
        }, 1000, 3);
    }

    @When("Operator check prefix type {string} is disabled")
    public void checkPrefixTypeStatus(String type) {
        String value = resolveValue(type);
        shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.scrollIntoView();
        boolean status = shipperCreatePage.basicSettingsForm.operationalSettings.trackingType.isValueDisabled(value);
        Assertions.assertThat(status).as(f("check prefix enabled: %s", value)).isTrue();
    }

}
