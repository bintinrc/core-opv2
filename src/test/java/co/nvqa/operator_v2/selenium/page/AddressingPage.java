package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.Addressing;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import static org.apache.commons.lang3.StringUtils.isNotBlank;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class AddressingPage extends OperatorV2SimplePage
{

    @FindBy(name = "Add Address")
    public NvIconTextButton addAddress;

    @FindBy(name = "Update")
    public NvIconTextButton editAddress;

    @FindBy(name = "Delete")
    public NvIconTextButton deleteAddress;

    @FindBy(tagName = "md-dialog")
    public AddAddressModal addAddressModal;

    @FindBy(tagName = "md-dialog")
    public EditAddressModal editAddressModal;

    @FindBy(css = "md-dialog")
    public ConfirmDeleteDialog confirmDeleteDialog;

    @FindBy(id = "search")
    public TextBox searchInput;

    @FindBy(xpath = "//md-card[contains(@class, 'address-list-card')]")
    public PageElement addressCard;


    public AddressingPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickAddAddressButton()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("Add Address");
    }

    public void addNewAddress(Addressing addressing)
    {
        addAddress.click();
        addAddressModal.fill(addressing);
        addAddressModal.addAddress.clickAndWaitUntilDone();
        waitUntilInvisibilityOfToast("Success create address", true);
        pause100ms();
    }

    public void searchAddress(Addressing addressing)
    {
        refreshPage();
        searchInput.setValue(addressing.getBuildingNo() + Keys.ENTER);
        pause1s();
    }

    public void verifyAddressExistAndInfoIsCorrect(Addressing addressing)
    {
        clickf("//md-card[contains(@class, 'address-list-card')][contains(.,'%s')]", addressing.getBuildingNo());
        pause100ms();

        String actualBuildingNo = getText("//label[starts-with(@for, 'building-no')]/following-sibling::div[1]");
        assertEquals("Building No is different.", addressing.getBuildingNo(), actualBuildingNo);

        String actualStreetName = getText("//label[starts-with(@for, 'street')]/following-sibling::div[1]");
        assertEquals("Street Name is different.", addressing.getStreetName(), actualStreetName);

        String actualPostcode = getText("//label[starts-with(@for, 'postcode')]/following-sibling::div[1]");
        assertEquals("Postcode is different.", addressing.getPostcode(), actualPostcode);

        String actualLatitude = getText("//label[starts-with(@for, 'latitude')]/following-sibling::div[1]");
        assertEquals("Latitude is different.", String.valueOf(addressing.getLatitude()), actualLatitude);

        String actualLongitude = getText("//label[starts-with(@for, 'longitude')]/following-sibling::div[1]");
        assertEquals("Longitude is different.", String.valueOf(addressing.getLongitude()), actualLongitude);
    }

    public void deleteAddress()
    {
        deleteAddress.waitUntilClickable();
        deleteAddress.click();
        confirmDeleteDialog.confirmDelete();
        waitUntilInvisibilityOfToast("Success delete address");
    }

    public void verifyDelete(Addressing addressing)
    {
        searchAddress(addressing);
        pause2s();
        String actualResult = getText("//md-card[contains(@class, 'address-list-card')]/div/h5");
        assertEquals("Result is different.", "No address found!", actualResult);
    }

    public void editAddress(Addressing addressingOld, Addressing addressingEdited)
    {
        searchAddress(addressingOld);
        addressCard.click();
        editAddress.waitUntilClickable();
        editAddress.click();
        editAddressModal.waitUntilVisible();
        editAddressModal.fill(addressingEdited);
        editAddressModal.saveChanges.clickAndWaitUntilDone();
        waitUntilInvisibilityOfToast("Success update address");
    }

    public static class AddAddressModal extends BaseAddressModel
    {
        public AddAddressModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(name = "Add Address")
        public NvApiTextButton addAddress;

        public void fill(Addressing address)
        {
            if (isNotBlank(address.getPostcode()))
            {
                postcode.setValue(address.getPostcode());
            }
            super.fill(address);
        }
    }

    public static class EditAddressModal extends BaseAddressModel
    {
        public EditAddressModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(name = "Save Changes")
        public NvApiTextButton saveChanges;

        @FindBy(id = "deleteButton")
        public NvApiTextButton deleteAddress;
    }

    public static class BaseAddressModel extends MdDialog
    {
        public BaseAddressModel(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(id = "country")
        public MdSelect country;

        @FindBy(id = "city")
        public TextBox city;

        @FindBy(id = "postcode")
        public TextBox postcode;

        @FindBy(id = "street")
        public TextBox street;

        @FindBy(id = "building_name")
        public TextBox buildingName;

        @FindBy(id = "building_number")
        public TextBox buildingNumber;

        @FindBy(id = "latitude")
        public TextBox latitude;

        @FindBy(id = "longitude")
        public TextBox longitude;

        @FindBy(id = "address_type")
        public MdSelect addressType;

        @FindBy(id = "source")
        public MdSelect source;

        public void fill(Addressing address)
        {
            if (isNotBlank(address.getStreetName()))
            {
                street.setValue(address.getStreetName());
            }
            if (isNotBlank(address.getBuildingName()))
            {
                buildingName.setValue(address.getBuildingName());
            }
            if (isNotBlank(address.getBuildingNo()))
            {
                buildingNumber.setValue(address.getBuildingNo());
            }
            if (address.getLatitude() != null)
            {
                latitude.setValue(String.valueOf(address.getLatitude()));
            }
            if (address.getLongitude() != null)
            {
                longitude.setValue(String.valueOf(address.getLongitude()));
            }
            if (isNotBlank(address.getAddressType()))
            {
                addressType.selectValue(String.valueOf(address.getAddressType()));
            }
        }
    }
}