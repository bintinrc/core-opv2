package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class AddressDatasourcePage extends SimpleReactPage<AddressDatasourcePage> {


  @FindBy(css = "[data-testid='add-a-row-button']")
  public Button addRow;

  @FindBy(css = "[data-testid='form-dialog-save-button']")
  public Button add;

  @FindBy(css = "[data-testid='row-details-proceed-button']")
  public Button proceed;

  @FindBy(css = "[data-testid='form-dialog-replace-button']")
  public Button replace;

  @FindBy(css = "[data-testid='form-dialog-delete-button']")
  public Button delete;

  @FindBy(css = "[data-testid='confirm-button']")
  public Button confirmReplace;

  @FindBy(css = "[data-testid='form-input-state']")
  public TextBox province;

  @FindBy(css = "[data-testid='form-input-city']")
  public TextBox kota;

  @FindBy(css = "[data-testid='form-input-district']")
  public TextBox kecamatan;

  @FindBy(css = "[data-testid='form-input-latlong']")
  public TextBox latlong;

  @FindBy(css = ".ant-btn-loading-icon")
  public PageElement loadingIcon;

  @FindBy(css = "[data-testid='form-input-city']")
  public TextBox municipality;

  @FindBy(css = "[data-testid='form-input-district']")
  public TextBox barangay;

  @FindBy(css = "[data-testid='form-input-postcode']")
  public TextBox postcode;

  @FindBy(css = "[data-testid='form-input-whitelist']")
  public AntSelect whitelisted;

  @FindBy(xpath = "//span[contains(text(), 'Province')] /following-sibling::span")
  public PageElement provinceAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Kota / Kabupaten')] /following-sibling::span")
  public PageElement kotaAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Kecamatan')] /following-sibling::span")
  public PageElement kecamatanAddRow;

  @FindBy(xpath = "//span[contains(text(), 'District')] /following-sibling::span")
  public PageElement districtAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Subdistrict')] /following-sibling::span")
  public PageElement subdistrictAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Ward')] /following-sibling::span")
  public PageElement wardAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Municipality')] /following-sibling::span")
  public PageElement municipalityAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Barangay')] /following-sibling::span")
  public PageElement barangayAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Hub')] /following-sibling::span")
  public PageElement hubAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Zone')] /following-sibling::span")
  public PageElement zoneAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Postcode')] /following-sibling::span")
  public PageElement zoneAddPostcode;

  @FindBy(css = ".ant-notification")
  public AntNotification notification;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='state']")
  public PageElement createdProvince;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='city']")
  public PageElement createdKota;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='district']")
  public PageElement createdKecamatan;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='city']")
  public PageElement createdMunicipality;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='district']")
  public PageElement createdBarangay;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='postcode']")
  public PageElement createdPostcode;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='whitelistDisplay']")
  public PageElement createdWhitelisted;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='latLng']")
  public PageElement createdLatlong;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='id']")
  public PageElement createdRawId;

  @FindBy(css = "[data-testid='search-input-state']")
  public TextBox provinceTextBox;

  @FindBy(css = "[data-testid='search-input-city']")
  public TextBox kotaTextBox;

  @FindBy(xpath = "//h3[contains(text(),'Find Match')]")
  public PageElement findMatch;

  @FindBy(css = "[data-testid='search-input-district']")
  public TextBox kecamatanTextBox;

  @FindBy(css = "[data-testid='search-input-city']")
  public TextBox municipalityTextBox;

  @FindBy(css = "[data-testid='search-input-district']")
  public TextBox barangayTextBox;

  @FindBy(css = "[data-testid='search-input-postcode']")
  public TextBox postcodeTextBox;

  @FindBy(css = "[data-testid='search-button']")
  public Button searchButton;

  @FindBy(css = "[for='state']")
  public TextBox provinceTextField;

  @FindBy(css = "[for='postcode']")
  public TextBox postcodeTextField;

  @FindBy(css = "[for='city']")
  public TextBox cityTextField;

  @FindBy(css = "[for='district']")
  public TextBox districtTextField;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[15]/td[@class='state']")
  public PageElement tableRow;

  @FindBy(xpath = "//button[contains(@data-testid,'edit-button')]")
  public Button editButton;

  @FindBy(xpath = "//div[text()='No Results Found']")
  public PageElement noResultsFound;

  @FindBy(xpath = "//button[contains(@class, 'view-zone-and-hub-button')]")
  public Button viewZoneAndHubButton;

  @FindBy(xpath = "//div[@class='zone-and-hub-match-dialog']//span[@class='value']")
  public PageElement viewHubAndZoneLatlong;

  @FindBy(xpath = "//div[@class='zone-and-hub-match-dialog']//td[@colspan=1]/span")
  public PageElement viewHubAndZoneZone;

  @FindBy(xpath = "//div[@class='zone-and-hub-match-dialog']//td[@colspan=2]/span")
  public PageElement viewHubAndZoneHub;

  @FindBy(xpath = "//div[@class='ant-form-item-explain-error']")
  public PageElement invalidLatlong;

  @FindBy(xpath = "//div[text()='Required to fill in']")
  public PageElement emptyFieldError;

  @FindBy(css = "[data-testid='search-input-city']")
  public TextBox districtTextBox;

  @FindBy(css = "[data-testid='search-input-district']")
  public TextBox subdistrictTextBox;


  public AddressDatasourcePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddRowButton() {
    addRow.waitUntilVisible();
    addRow.click();
  }
}