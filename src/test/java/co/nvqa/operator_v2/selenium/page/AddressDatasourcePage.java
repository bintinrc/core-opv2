package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
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

  @FindBy(xpath = "//span[contains(text(), 'Province')] /following-sibling::span")
  public PageElement provinceAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Kota / Kabupaten')] /following-sibling::span")
  public PageElement kotaAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Kecamatan')] /following-sibling::span")
  public PageElement kecamatanAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Hub')] /following-sibling::span")
  public PageElement hubAddRow;

  @FindBy(xpath = "//span[contains(text(), 'Zone')] /following-sibling::span")
  public PageElement zoneAddRow;

  @FindBy(css = ".ant-notification")
  public AntNotification notification;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='state']")
  public PageElement createdProvince;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='city']")
  public PageElement createdKota;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='district']")
  public PageElement createdKecamatan;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='latLng']")
  public PageElement createdLatlong;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[1]/td[@class='id']")
  public PageElement createdRawId;

  @FindBy(css = "[data-testid='search-input-state']")
  public TextBox provinceTextBox;

  @FindBy(css = "[data-testid='search-input-city']")
  public TextBox kotaTextBox;

  @FindBy(css = "[data-testid='search-input-district']")
  public TextBox kecamatanTextBox;

  @FindBy(css = "[data-testid='search-button']")
  public Button searchButton;

  @FindBy(css = "[for='state']")
  public TextBox provinceTextField;

  @FindBy(css = "[for='city']")
  public TextBox cityTextField;

  @FindBy(css = "[for='district']")
  public TextBox districtTextField;

  @FindBy(xpath = "//div[@class='ant-card ant-card-bordered table-listing']//tr[15]/td[@class='state']")
  public PageElement tableRow;

  public AddressDatasourcePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddRowButton() {
    addRow.waitUntilVisible();
    addRow.click();
  }
}