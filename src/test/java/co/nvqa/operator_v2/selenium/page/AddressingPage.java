package co.nvqa.operator_v2.selenium.page;


import co.nvqa.commonsort.model.addressing.Addressing;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import java.util.List;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import static org.apache.commons.lang3.StringUtils.isNotBlank;

/**
 * @author Tristania Siagian
 */
public class AddressingPage extends SimpleReactPage<AddressingPage> {

  @FindBy(css = ".ant-list-empty-text")
  public PageElement emptyListText;

  @FindBy(css = "[data-testid='add-address-button']")
  public Button addAddress;

  @FindBy(css = ".ant-modal")
  public AddAddressModal addAddressModal;

  @FindBy(css = ".ant-modal")
  public ConfirmDeleteModal confirmDeleteModal;

  @FindBy(css = ".ant-modal")
  public EditAddressModal editAddressModal;

  @FindBy(css = "[data-testid='search-input']")
  public ForceClearTextBox searchInput;

  @FindBy(css = "li[data-testid^='address-row']")
  public List<PageElement> addressCardBtn;

  @FindBy(css = ".ant-card")
  public List<AddressCard> addressCards;

  public AddressingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddAddressButton() {
    addAddress.waitUntilVisible();
    addAddress.click();
  }

  public void addNewAddress(Addressing addressing) {
    addAddress.click();
    addAddressModal.fill(addressing);
    addAddressModal.addAddress.click();
  }

  public void searchAddress(Addressing addressing) {
    searchInput.setValue(
        addressing.getBuildingNo() + ", " + addressing.getStreetName() + Keys.ENTER);
    pause2s();
  }

  public static class AddAddressModal extends BaseAddressModel {

    public AddAddressModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='save-text']")
    public Button addAddress;

    public void fill(Addressing address) {
      if (isNotBlank(address.getPostcode())) {
        postcode.setValue(address.getPostcode());
      }
      super.fill(address);
    }
  }

  public static class EditAddressModal extends BaseAddressModel {

    public EditAddressModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(css = "[data-testid='save-text']")
    public Button editAddress;
  }

  public static class BaseAddressModel extends AntModal {

    public BaseAddressModel(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//*[@id='country']]")
    public AntSelect country;

    @FindBy(css = "[data-testid='form-city-input']")
    public ForceClearTextBox city;

    @FindBy(css = "[data-testid='form-postcode-input']")
    public ForceClearTextBox postcode;

    @FindBy(css = "[data-testid='form-street-input']")
    public ForceClearTextBox street;

    @FindBy(css = "[data-testid='form-building-input']")
    public ForceClearTextBox buildingName;

    @FindBy(css = "[data-testid='form-building-no-input']")
    public ForceClearTextBox buildingNumber;

    @FindBy(css = "[data-testid='form-latitude-input']")
    public ForceClearTextBox latitude;

    @FindBy(css = "[data-testid='form-longitude-input']")
    public ForceClearTextBox longitude;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//*[@id='address_type']]")
    public AntSelect addressType;

    @FindBy(css = "[data-testid='form-region-input']")
    public ForceClearTextBox source;

    @FindBy(css = "[data-testid='form-province-input']")
    public ForceClearTextBox province;

    @FindBy(css = "[data-testid='form-district-input']")
    public ForceClearTextBox district;

    @FindBy(css = "[data-testid='form-community-input']")
    public ForceClearTextBox community;

    @FindBy(css = "[data-testid='form-subdistrict-input']")
    public ForceClearTextBox subdistrict;

    @FindBy(css = "[data-testid='form-ward-input']")
    public ForceClearTextBox ward;

    @FindBy(css = "[data-testid='form-area-input']")
    public ForceClearTextBox area;

    @FindBy(css = "[data-testid='form-subdivision-input']")
    public ForceClearTextBox subdivision;

    public void fill(Addressing address) {
      if (isNotBlank(address.getStreetName())) {
        street.setValue(address.getStreetName());
      }
      if (isNotBlank(address.getBuildingName())) {
        buildingName.setValue(address.getBuildingName());
      }
      if (isNotBlank(address.getBuildingNo())) {
        buildingNumber.setValue(address.getBuildingNo());
      }
      if (address.getLatitude() != null) {
        latitude.setValue(String.valueOf(address.getLatitude()));
      }
      if (address.getLongitude() != null) {
        longitude.setValue(String.valueOf(address.getLongitude()));
      }
      if (isNotBlank(address.getAddressType())) {
        addressType.selectValue(String.valueOf(address.getAddressType()));
      }
      if (isNotBlank(address.getProvince())) {
        province.setValue(address.getProvince());
      }
      if (isNotBlank(address.getCity())) {
        city.setValue(address.getCity());
      }
      if (isNotBlank(address.getDistrict())) {
        district.setValue(address.getDistrict());
      }
      if (isNotBlank(address.getCommunity())) {
        community.setValue(address.getCommunity());
      }
      if (isNotBlank(address.getSubdistrict())) {
        subdistrict.setValue(address.getSubdistrict());
      }
      if (isNotBlank(address.getWard())) {
        ward.setValue(address.getWard());
      }
      if (isNotBlank(address.getArea())) {
        area.setValue(address.getArea());
      }
      if (isNotBlank(address.getSubdivision())) {
        subdivision.setValue(address.getSubdivision());
      }
    }
  }

  public static class AddressCard extends PageElement {

    public AddressCard(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[./div/label='Building No']//input")
    public PageElement buildingNo;

    @FindBy(xpath = ".//div[./div/label='Street']//input")
    public PageElement street;

    @FindBy(xpath = ".//div[./div/label='Postcode']//input")
    public PageElement postcode;

    @FindBy(xpath = ".//div[./div/label='Latitude']//input")
    public PageElement latitude;

    @FindBy(xpath = ".//div[./div/label='Longitude']//input")
    public PageElement longitude;

    @FindBy(css = "[data-testid='edit-address-button']")
    public Button editAddress;

    @FindBy(css = "[data-testid='delete-address-button']")
    public Button deleteAddress;

    @FindBy(xpath = ".//div[./div/label='Province']//input")
    public PageElement province;

    @FindBy(xpath = ".//div[./div/label='City']//input")
    public PageElement city;

    @FindBy(xpath = ".//div[./div/label='District']//input")
    public PageElement district;

    @FindBy(xpath = ".//div[./div/label='Community']//input")
    public PageElement community;

    @FindBy(xpath = ".//div[./div/label='Subdistrict']//input")
    public PageElement subdistrict;

    @FindBy(xpath = ".//div[./div/label='Ward']//input")
    public PageElement ward;

    @FindBy(xpath = ".//div[./div/label='Area']//input")
    public PageElement area;

    @FindBy(xpath = ".//div[./div/label='Subdivision']//input")
    public PageElement subdivision;
    @FindBy(xpath = ".//div[./div/label='Source']//input")
    public PageElement source;
    @FindBy(xpath = ".//div[./div/label='Address Type']//input")
    public PageElement addresstype;
    @FindBy(xpath = ".//div[./div/label='Score']//input")
    public PageElement score;

  }

  public static class ConfirmDeleteModal extends AntModal {

    public ConfirmDeleteModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='confirm-button']")
    public Button delete;
  }
}