package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.Addressing;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class AddressingPage extends OperatorV2SimplePage {

    public AddressingPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickAddAddressButton() {
        clickNvIconTextButtonByNameAndWaitUntilDone("Add Address");
    }

    public void addNewAddress(Addressing addressing) {
        fillTheForm(addressing, false);
        clickNvApiTextButtonByNameAndWaitUntilDone("Add Address");
        waitUntilInvisibilityOfToast("Success create address");
        pause100ms();
    }

    public void fillTheForm(Addressing addressing, boolean excludePostcode) {
        if(!excludePostcode) {
            sendKeysById("postcode", addressing.getPostcode());
        }

        sendKeysByIdAlt("street", addressing.getStreetName());
        sendKeysByIdAlt("building_name", addressing.getBuildingName());
        sendKeysByIdAlt("building_number", addressing.getBuildingNo());
        sendKeysByIdAlt("latitude", String.valueOf(addressing.getLatitude()));
        sendKeysByIdAlt("longitude", String.valueOf(addressing.getLongitude()));
        selectValueFromMdSelectById("address_type", addressing.getAddressType());
    }

    public void searchAddress(Addressing addressing) {
        refreshPage();
        sendKeysAndEnterById("search", addressing.getBuildingNo());
        pause100ms();
    }

    public void verifyAddressExistAndInfoIsCorrect(Addressing addressing) {
        click("//md-card[contains(@class, 'address-list-card')]");
        pause100ms();

        String actualBuildingNo = getText("//label[starts-with(@for, 'building-no')]/following-sibling::div[1]");
        Assert.assertEquals("Building No is different.", addressing.getBuildingNo(), actualBuildingNo);

        String actualStreetName = getText("//label[starts-with(@for, 'street')]/following-sibling::div[1]");
        Assert.assertEquals("Street Name is different.", addressing.getStreetName(), actualStreetName);

        String actualPostcode = getText("//label[starts-with(@for, 'postcode')]/following-sibling::div[1]");
        Assert.assertEquals("Postcode is different.", addressing.getPostcode(), actualPostcode);

        String actualLatitude = getText("//label[starts-with(@for, 'latitude')]/following-sibling::div[1]");
        Assert.assertEquals("Latitude is different.", String.valueOf(addressing.getLatitude()), actualLatitude);

        String actualLongitude = getText("//label[starts-with(@for, 'longitude')]/following-sibling::div[1]");
        Assert.assertEquals("Longitude is different.", String.valueOf(addressing.getLongitude()), actualLongitude);
    }

    public void deleteAddress() {
        clickNvIconTextButtonByNameAndWaitUntilDone("Delete");
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfToast("Success delete address");
    }

    public void verifyDelete(Addressing addressing) {
        searchAddress(addressing);
        String actualResult = getText("//md-card[contains(@class, 'address-list-card')]/div/h5");
        Assert.assertEquals("Result is different.", "No address found!", actualResult);
    }

    public void editAddress(Addressing addressingOld, Addressing addressingEdited) {
        searchAddress(addressingOld);
        click("//md-card[contains(@class, 'address-list-card')]");
        pause1s();
        clickNvIconTextButtonByNameAndWaitUntilDone("Update");
        fillTheForm(addressingEdited, true);
        clickNvApiTextButtonByNameAndWaitUntilDone("Save Changes");
        waitUntilInvisibilityOfToast("Success update address");
        pause100ms();
    }
}
