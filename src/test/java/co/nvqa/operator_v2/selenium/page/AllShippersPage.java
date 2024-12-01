package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.address.Address;
import co.nvqa.common.shipper.model.Shipper;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.AllShippersPage.ShippersTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.AllShippersPage.ShippersTable.COLUMN_NAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AllShippersPage extends OperatorV2SimplePage {

  @FindBy(name = "searchTerm")
  public TextBox searchTerm;
  @FindBy(name = "commons.search")
  public NvApiTextButton search;
  @FindBy(name = "container.shippers.create-shipper")
  public NvIconTextButton createShipper;
  public ShippersTable shippersTable;
  @FindBy(xpath = "//md-progress-circular/following-sibling::div[text()='Loading shippers...']")
  public PageElement loadingShippers;


  private static final String MD_VIRTUAL_REPEAT = "shipper in getTableData()";
  public static final String XPATH_SEARCH_SHIPPER_BY_KEYWORD_DROPDOWN = "//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[contains(text(),'%s')]";

  public final AllShippersCreateEditPage allShippersCreateEditPage;

  public AllShippersPage(WebDriver webDriver) {
    super(webDriver);
    allShippersCreateEditPage = new AllShippersCreateEditPage(webDriver);
    shippersTable = new ShippersTable(webDriver);
  }

  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    loadingShippers.waitUntilInvisible();
  }

  public void createNewShipper(Shipper shipper) {
    waitUntilPageLoaded(120);
    createShipper.click();
    allShippersCreateEditPage.createNewShipper(shipper);
  }

  public void unsetPickupAddressesAsMilkrun(String shipperName, Address shipperPickupAddress) {
    searchShipper(shipperName);
    openEditShipperPage();
    allShippersCreateEditPage.unsetPickupAddressesAsMilkrun(shipperPickupAddress);
  }

  public void openEditShipperPage() {
    shippersTable.clickActionButton(1, ACTION_EDIT);
    allShippersCreateEditPage.switchToNewWindow();
    allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
  }

  public void searchShipper(String shipperName) {
    if (!searchTerm.isDisplayedFast()) {
      shippersTable.filterByColumn(COLUMN_NAME, shipperName);
    } else {
      quickSearchShipper(shipperName);
    }
    Assert.assertFalse(f("Shipper [%s] was not found", shipperName), shippersTable.isEmpty());
  }


  public void quickSearchShipper(String keyword) {
    String currentURL = getWebDriver().getCurrentUrl();
    String editShipperPageURL = (f("%s/%s/shippers", TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.NV_SYSTEM_ID));

    if (currentURL.contains(editShipperPageURL)) {
      getWebDriver().navigate().to(editShipperPageURL);
    }

    searchTerm.setValue(keyword);
    clickAndWaitUntilDone(f(XPATH_SEARCH_SHIPPER_BY_KEYWORD_DROPDOWN, keyword));
    loadingShippers.waitUntilInvisible();
  }

  public static class ShippersTable extends MdVirtualRepeatTable<Shipper> {

    public static final String MD_VIRTUAL_REPEAT = "shipper in getTableData()";
    public static final String COLUMN_NAME = "name";
    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_DASH_LOGIN = "Dash login";

    public ShippersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "id")
          .put(COLUMN_NAME, "name")
          .put("email", "email")
          .put("industryName", "_industry")
          .put("liaisonEmail", "liaison_email")
          .put("contact", "contact")
          .put("salesPerson", "sales_person")
          .put("active", "_status")
          .build()
      );
      setEntityClass(Shipper.class);
      setMdVirtualRepeat(MD_VIRTUAL_REPEAT);
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT, "commons.edit",
          ACTION_DASH_LOGIN, "container.shippers.ninja-dashboard-login-new"
      ));
    }
  }
}

