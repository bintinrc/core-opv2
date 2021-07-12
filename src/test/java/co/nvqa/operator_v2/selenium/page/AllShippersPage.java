package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.order_create.v4.Marketplace;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.Objects;
import org.junit.Assert;
import org.openqa.selenium.Keys;
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
  @FindBy(name = "container.shippers.edit-conditions")
  public NvIconTextButton editConditions;
  @FindBy(name = "commons.search")
  public NvApiTextButton search;
  @FindBy(name = "container.shippers.create-shipper")
  public NvIconTextButton createShipper;
  @FindBy(name = "Clear All Selections")
  public NvIconTextButton clearAllSelections;
  @FindBy(xpath = "//md-progress-circular/following-sibling::div[text()='Loading shippers...']")
  public PageElement loadingShippers;
  @FindBy(xpath = "//div[@id='hint-text']/p")
  public PageElement referParentsProfileText;
  @FindBy(id = "hint-link")
  public PageElement referParentsProfileLink;

  public ShippersTable shippersTable;

  private static final String MD_VIRTUAL_REPEAT = "shipper in getTableData()";

  public static final String ACTION_BUTTON_EDIT = "commons.edit";
  public static final String ACTION_BUTTON_LOGIN = "container.shippers.shipper-dashboard-login";
  public static final String XPATH_SELECT_FILTER = "//input[@aria-label='Select Filter']";
  public static final String ARIA_LABEL_LOAD_SELECTION = "Load Selection";
  public static final String XPATH_FOR_FILTER = "//span[text()='%s']/ancestor::li";
  public static final String XPATH_FOR_INDIVIDUAL_FILTER = "//p[text()='%s']/parent::div/following-sibling::div//input";
  public static final String XPATH_FOR_COLUMNS = "//table[@class='table-body']//tr[1]/td[@class='%s']";
  public static final String XPATH_ACTIVE_FILTER = "//p[text()='Active']/parent::div/following-sibling::div//span[text()='Yes']/parent::button";
  public static final String XPATH_HIDE_BUTTON = "//div[contains(text(),'Hide')]/following-sibling::i";
  public static final String XPATH_PROFILE = "//button[@aria-label='Profile']";
  public static final String XPATH_SEARCH_SHIPPER_BY_KEYWORD_DROPDOWN = "//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[contains(text(),'%s')]";

  private static final DecimalFormat NO_TRAILING_ZERO_DF = new DecimalFormat("###.##");

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

  public void clearBrowserCacheAndReloadPage() {
    clearCache();
    refreshPage();
    waitUntilPageLoaded();
  }

  public void createNewShipper(Shipper shipper) {
    waitUntilPageLoaded();
    createShipper.click();
    allShippersCreateEditPage.createNewShipper(shipper);
  }

  public void createNewShipperFail(Shipper shipper) {
    waitUntilPageLoaded();
    createShipper.click();
    switchToNewWindow();
    allShippersCreateEditPage.createNewShipperSteps(shipper);
  }

  public void createNewShipperWithUpdatedPricingScript(Shipper shipper) {
    waitUntilPageLoaded();
    createShipper.click();
    allShippersCreateEditPage.createNewShipperWithUpdatedPricingScript(shipper);
  }

  public void createNewShipperWithoutPricingScript(Shipper shipper) {
    waitUntilPageLoaded();
    createShipper.click();
    allShippersCreateEditPage.createNewShipperWithoutPricingScript(shipper);
  }

  public Pricing getCreatedPricingProfile() throws ParseException {
    return allShippersCreateEditPage.getAddedPricingProfileDetails();
  }

  public void verifyNewShipperIsCreatedSuccessfully(Shipper shipper) {
    verifyShipperInfoIsCorrect(shipper.getName(), shipper);
  }

  public void loginToShipperDashboard(Shipper shipper) {
    searchShipper(shipper.getName());
    clickActionButtonOnTable(1, ACTION_BUTTON_LOGIN);
    waitUntilNewWindowOrTabOpened();
    switchToOtherWindowAndWaitWhileLoading("/orders/management/");
  }

  public void setPickupAddressesAsMilkrun(Shipper shipper) {
    searchShipper(shipper.getName());
    Shipper actualShipper = shippersTable.readEntity(1);
    shipper.setLegacyId(actualShipper.getLegacyId());
    openEditShipperPage();
    allShippersCreateEditPage.setPickupAddressesAsMilkrun(shipper);
  }

  public void removeMilkrunReservarion(Shipper shipper, int addressIndex,
      int milkrunReservationIndex) {
    searchShipper(shipper.getName());
    Shipper actualShipper = shippersTable.readEntity(1);
    shipper.setLegacyId(actualShipper.getLegacyId());
    openEditShipperPage();
    allShippersCreateEditPage
        .removeMilkrunReservarion(shipper, addressIndex, milkrunReservationIndex);
  }

  public void removeAllMilkrunReservarions(Shipper shipper, int addressIndex) {
    searchShipper(shipper.getName());
    Shipper actualShipper = shippersTable.readEntity(1);
    shipper.setLegacyId(actualShipper.getLegacyId());
    openEditShipperPage();
    allShippersCreateEditPage.removeAllMilkrunReservations(shipper, addressIndex);
  }

  public void verifyShipperInfoIsCorrect(String shipperNameKeyword, Shipper shipper) {
    searchShipper(shipperNameKeyword);
    Shipper actualShipper = shippersTable.readEntity(1);
    shipper.setLegacyId(actualShipper.getLegacyId());

    assertEquals("Name", shipper.getName(), actualShipper.getName());
    assertEquals("Email", shipper.getEmail(), actualShipper.getEmail());
    assertEquals("Industry", shipper.getIndustryName(), actualShipper.getIndustryName());
    assertEquals("Liaison Email", shipper.getLiaisonEmail(), actualShipper.getLiaisonEmail());
    assertEquals("Contact", shipper.getContact(), actualShipper.getContact());
    assertEquals("Sales Person",
        shipper.getSalesPerson().substring(0, shipper.getSalesPerson().lastIndexOf("-")),
        actualShipper.getSalesPerson());
    assertEquals("Expected Status = Inactive", shipper.getActive(), actualShipper.getActive());

    openEditShipperPage();
    allShippersCreateEditPage.verifyNewShipperIsCreatedSuccessfully(shipper);
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

  public void updateShipper(Shipper oldShipper, Shipper updatedShipper) {
    searchTableByNameAndGoToEditPage(oldShipper);
    allShippersCreateEditPage.updateShipper(updatedShipper);
  }

  public void updateShipperBasicSettings(Shipper oldShipper, Shipper updatedShipper) {
    searchTableByNameAndGoToEditPage(oldShipper);
    allShippersCreateEditPage.updateShipperBasicSettings(updatedShipper);
  }

  public void verifyShipperIsUpdatedSuccessfully(Shipper oldShipper, Shipper shipper) {
    verifyShipperInfoIsCorrect(oldShipper.getName(), shipper);
  }

  public void verifyShipperIsDeletedSuccessfully(Shipper shipper) {
    searchTableByName(shipper.getShortName());
    assertTrue("Table should be empty.", isTableEmpty());
  }

  public void enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(Shipper shipper,
      Address address, Reservation reservation) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage
        .enableAutoReservationAndChangeShipperDefaultAddressToTheNewAddress(shipper, address,
            reservation);
  }

  public void updateShipperLabelPrinterSettings(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.updateShipperLabelPrinterSettings(shipper);
  }

  public void verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.verifyShipperLabelPrinterSettingsIsUpdatedSuccessfully(shipper);
  }

  public void updateShipperDistributionPointSettings(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.updateShipperDistributionPointSettings(shipper);
  }

  public void verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.verifyShipperDistributionPointSettingsIsUpdatedSuccessfully(shipper);
  }

  public void updateShipperReturnsSettings(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.updateShipperReturnsSettings(shipper);
  }

  public void verifyShipperReturnsSettingsIsUpdatedSuccessfully(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.verifyShipperReturnsSettingsIsUpdatedSuccessfully(shipper);
  }

  public void updateShipperQoo10Settings(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.updateShipperQoo10Settings(shipper);
  }

  public void verifyShipperQoo10SettingsIsUpdatedSuccessfully(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.verifyShipperQoo10SettingsIsUpdatedSuccessfully(shipper);
  }

  public void updateShipperShopifySettings(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.updateShipperShopifySettings(shipper);
  }

  public void verifyShipperShopifySettingsIsUpdatedSuccessfuly(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.verifyShipperShopifySettingsIsUpdatedSuccessfully(shipper);
  }

  public void updateShipperMagentoSettings(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.updateShipperMagentoSettings(shipper);
  }

  public void verifyShipperMagentoSettingsIsUpdatedSuccessfuly(Shipper shipper) {
    searchTableByNameAndGoToEditPage(shipper);
    allShippersCreateEditPage.verifyShipperMagentoSettingsIsUpdatedSuccessfully(shipper);
  }

  public void searchTableByNameAndGoToEditPage(Shipper shipper) {
    searchShipper(shipper.getName());
    openEditShipperPage();
  }

  public void searchTableByName(String name) {
    searchTableCustom1("name", name);
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
  }

  public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
    clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
  }

  public void clearAllSelections() {
    pause1s();
    clearAllSelections.click();
  }

  public void chooseFilter(String filter) {
    click(XPATH_SELECT_FILTER);
    clickf(XPATH_FOR_FILTER, filter);
  }

  public void searchByFilterWithKeyword(String filter, String keyword) {
    String xpathForFilter = f(XPATH_FOR_INDIVIDUAL_FILTER, filter);
    click(xpathForFilter);
    sendKeys(xpathForFilter, keyword);
    pause1s();
    sendKeysWithoutClear(xpathForFilter, Keys.RETURN);
    if (isElementVisible(XPATH_HIDE_BUTTON)) {
      click(XPATH_HIDE_BUTTON);
    }
    clickButtonByAriaLabel(ARIA_LABEL_LOAD_SELECTION);
  }

  public void searchActiveFilter() {
    click(XPATH_ACTIVE_FILTER);
    clickButtonByAriaLabel(ARIA_LABEL_LOAD_SELECTION);
  }

  public void verifiesResultsOfColumn(String keyword, String column) {
    String columnXpath = null;
    if (column.equalsIgnoreCase("Liaison Email")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "liaison_email");
    } else if (column.equalsIgnoreCase("Email")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "email");
    } else if (column.equalsIgnoreCase("Contact")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "contact");
    } else if (column.equalsIgnoreCase("Status")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "_status");
    } else if (column.equalsIgnoreCase("Industry")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "_industry");
    } else if (column.equalsIgnoreCase("Salesperson")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "sales_person");
    } else if (column.equalsIgnoreCase("Name")) {
      columnXpath = f(XPATH_FOR_COLUMNS, "name");
    }
    String text = getText(columnXpath);
    assertTrue("The keyword is found on the respective column",
        text.toLowerCase().contains(keyword.toLowerCase()));
  }

  public void quickSearchShipper(String keyword) {
    String currentURL = getWebDriver().getCurrentUrl();
    String editShipperPageURL = (f("%s/%s/shippers", TestConstants.OPERATOR_PORTAL_BASE_URL,
        TestConstants.COUNTRY_CODE));

    if (currentURL.contains(editShipperPageURL)) {
      getWebDriver().navigate().to(editShipperPageURL);
    }

    searchTerm.setValue(keyword);
    clickAndWaitUntilDone(f(XPATH_SEARCH_SHIPPER_BY_KEYWORD_DROPDOWN, keyword));
    loadingShippers.waitUntilInvisible();
  }

  public void searchShipperByName(String keyword) {
    getWebDriver().navigate()
        .to(f("%s/%s/shippers/list?keyword=%s", TestConstants.OPERATOR_PORTAL_BASE_URL,
            TestConstants.COUNTRY_CODE, keyword));
    sendKeys(
        "//nv-table[@param='ctrl.tableParam']//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input",
        keyword);
  }

  public void editShipper(Shipper shipper) {
    quickSearchShipper(getSearchKeyword(shipper));
    shippersTable.clickActionButton(1, ACTION_EDIT);
    allShippersCreateEditPage.switchToNewWindow();
    allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
  }

  public void editShipper(Marketplace marketplace) {
    searchShipperByName(getSearchKeyword(marketplace));
    shippersTable.clickActionButton(1, ACTION_EDIT);
    allShippersCreateEditPage.switchToNewWindow();
    allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
  }

  private String getSearchKeyword(Shipper shipper) {
    String shipperName = shipper.getName();
    String shipperLegacyId = Objects.toString(shipper.getLegacyId(), null);
    NvLogger.infof("Created Shipper name : %s ", shipperName);
    String searchValue;
    if (Objects.isNull(shipperName) && Objects.isNull(shipperLegacyId)) {
      throw new NvTestRuntimeException("Shipper legacy id and/or shipper name not saved");
    } else if (Objects.isNull(shipperName)) {
      searchValue = shipperLegacyId;
    } else if (Objects.isNull(shipperLegacyId)) {
      searchValue = shipperName;
    } else {
      searchValue = shipperLegacyId.concat("-").concat(shipperName);
    }
    return searchValue;
  }

  private String getSearchKeyword(Marketplace marketplace) {
    String marketplaceSellerId = marketplace.getSellerId();
    String marketplaceSellerCompanyName = marketplace.getSellerCompanyName();
    NvLogger.infof("Created seller id : %s ", marketplaceSellerId);
    String searchValue;
    if (Objects.isNull(marketplaceSellerId) && Objects.isNull(marketplaceSellerCompanyName)) {
      throw new NvTestRuntimeException(
          "marketplace shipper marketplaceSellerId and/or marketplaceSellerCompanyName not saved");
    } else {
      searchValue = marketplaceSellerId;
    }
    return searchValue;
  }

  public String addNewPricingProfile(Shipper shipper) {
    waitUntilPageLoaded();
    return allShippersCreateEditPage.addNewPricingProfileAndSave(shipper);
  }

  public void addNewPricingProfileWithoutSaving(Shipper shipper) {
    waitUntilPageLoaded();
    allShippersCreateEditPage.addNewPricingProfileWithoutSave(shipper);
  }

  public void editPricingScript(Shipper shipper) {
    waitUntilPageLoaded();
    allShippersCreateEditPage.editPricingScript(shipper);
  }

  public void verifyPricingScriptIsActive(String status, String status1) {
    waitUntilPageLoaded();
    allShippersCreateEditPage.verifyPricingScriptIsActive(status, status1);
  }

  public void verifyPricingScriptAndShipperDiscountDetails(Pricing pricingProfile,
      Pricing pricingProfileFromDb, Pricing pricingProfileFromOPV2) {
    assertTrue("Script id is not same: ",
        pricingProfile.getScriptName().contains(pricingProfileFromDb.getScriptId().toString()));
    assertEquals("Pricing profile id is not same: ", pricingProfileFromOPV2.getTemplateId(),
        pricingProfileFromDb.getTemplateId());
    assertTrue("Shipper discount Id is null:", pricingProfileFromDb.getShipperDiscountId() != null);
    assertEquals("Comments are not the same: ", pricingProfile.getComments(),
        pricingProfileFromDb.getComments());
    assertNotNull("Start Date is null:", pricingProfileFromOPV2.getEffectiveDate());
    final Date endDate = pricingProfile.getContractEndDate();
    if (Objects.isNull(endDate)) {
      assertNull("End Date is not the same: ", pricingProfileFromOPV2.getContractEndDate());
    } else {
      assertNotNull("End Date is not the same: ", pricingProfileFromOPV2.getContractEndDate());
    }

    final String discount = pricingProfile.getDiscount();
    if (Objects.isNull(discount)) {
      assertEquals("Discount amount is not blank:", "-", pricingProfileFromOPV2.getDiscount());
      assertNull("Type is not not null", pricingProfileFromDb.getType());
    } else if (Double.parseDouble(discount) * 100 % 1 > 0) {
      double expectedDiscount = Math.round(Double.parseDouble(discount) * 100.0) / 100.0;
      assertEquals("Discount amount is not rounded:", Double.toString(expectedDiscount),
          pricingProfileFromOPV2.getDiscount());
      assertEquals("Type is not the same:", pricingProfile.getType(),
          pricingProfileFromDb.getType());
    } else {
      assertTrue("Discount amount is not same:",
          pricingProfileFromDb.getDiscount().contains(pricingProfile.getDiscount()));
      assertEquals("Type is not the same:", pricingProfile.getType(),
          pricingProfileFromDb.getType());
    }
    if (Objects.isNull(pricingProfile.getCodMin())) {
      assertEquals("COD min fee is not - ", "-",
          pricingProfileFromOPV2.getCodMin());
    } else {
      assertEquals("COD min fee is not the same: ", pricingProfile.getCodMin(),
          pricingProfileFromOPV2.getCodMin());
    }
    if (Objects.isNull(pricingProfile.getCodMin())) {
      assertEquals("COD percentage is - ", "-",
          pricingProfileFromOPV2.getCodPercentage());
    } else {
      assertEquals("COD percentage is not the same: ", pricingProfile.getCodPercentage(),
          pricingProfileFromOPV2.getCodPercentage());
    }
    if (Objects.isNull(pricingProfile.getInsMin())) {
      assertEquals("INS min fee is not - ", "-",
          pricingProfileFromOPV2.getInsMin());
    } else {
      assertEquals("INS min fee is not the same: ", pricingProfile.getInsMin(),
          pricingProfileFromOPV2.getInsMin());
    }
    if (Objects.isNull(pricingProfile.getInsPercentage())) {
      assertEquals("INS percentage is - ", "-",
          pricingProfileFromOPV2.getInsPercentage());
    } else {
      assertEquals("INS percentage is not the same: ", pricingProfile.getInsPercentage(),
          pricingProfileFromOPV2.getInsPercentage());
    }
    if (Objects.isNull(pricingProfile.getInsThreshold())) {
      assertEquals("INS threshold is - ", "-",
          pricingProfileFromOPV2.getInsThreshold());
    } else {
      assertEquals("INS threshold is not the same: ",
          NO_TRAILING_ZERO_DF.format(Double.valueOf(pricingProfile.getInsThreshold())),
          pricingProfileFromOPV2.getInsThreshold());
    }
  }

  public void verifyPricingProfileDetails(Pricing pricingProfile, Pricing pricingProfileFromOPV2) {
    String scriptName = pricingProfile.getScriptName();
    if (Objects.nonNull(scriptName)) {
      assertTrue("Script Name is not same: ",
          scriptName.contains(pricingProfileFromOPV2.getScriptName()));
    }
    Long discount = pricingProfile.getShipperDiscountId();
    if (Objects.nonNull(discount)) {
      assertEquals("Shipper Discount is not the same: ", discount,
          pricingProfileFromOPV2.getShipperDiscountId());
    }
    String comments = pricingProfile.getComments();
    if (Objects.nonNull(discount)) {
      assertEquals("Comments are not the same: ", comments,
          pricingProfileFromOPV2.getComments());
    }
    assertNotNull("Start Date is null:", pricingProfileFromOPV2.getEffectiveDate());
    Date endDate = pricingProfile.getContractEndDate();
    if (Objects.nonNull(endDate)) {
      assertEquals("End Date is not the same: ", endDate,
          pricingProfileFromOPV2.getContractEndDate());
    }
    String codMin = pricingProfile.getCodMin();
    if (Objects.nonNull(codMin)) {
      assertEquals("COD min fee is not the same: ", codMin,
          pricingProfileFromOPV2.getCodMin());
    }
    String codPercentage = pricingProfile.getCodPercentage();
    if (Objects.nonNull(codPercentage)) {
      assertEquals("COD percentage is not the same: ", codPercentage,
          pricingProfileFromOPV2.getCodPercentage());
    }
    String insMin = pricingProfile.getInsMin();
    if (Objects.nonNull(insMin)) {
      assertEquals("INS min fee is not the same: ", insMin,
          pricingProfileFromOPV2.getInsMin());
    }
    String insPercentage = pricingProfile.getInsPercentage();
    if (Objects.nonNull(insPercentage)) {
      assertEquals("INS min percentage is not the same: ", insPercentage,
          pricingProfileFromOPV2.getInsPercentage());
    }
    String insThreshold = pricingProfile.getInsThreshold();
    if (Objects.nonNull(insThreshold)) {
      assertEquals("INS min threshold is not the same: ", insThreshold,
          pricingProfileFromOPV2.getInsThreshold());
    }
  }

  public void changeCountry(String country) {
    click(XPATH_PROFILE);
    selectValueFromMdSelect("domain.current", country);
    pause2s();
  }

  public void verifyEditPendingProfileIsDisplayed() {
    waitUntilPageLoaded();
    allShippersCreateEditPage.verifyEditPendingProfileIsDisplayed();
  }

  public void addNewPricingScriptAndVerifyErrorMessage(Shipper shipper, String errorMessage) {
    waitUntilPageLoaded();
    allShippersCreateEditPage.addNewPricingScriptAndVerifyErrorMessage(shipper, errorMessage);
  }

  public void addPricingProfileAndVerifySaveButtonIsDisabled(Shipper shipper) {
    waitUntilPageLoaded();
    allShippersCreateEditPage.addPricingProfileAndVerifySaveButtonIsDisabled(shipper);
  }

  public String getReferParentsProfileText() {
    return referParentsProfileText.getText();
  }

  public String getReferParentsProfileLink() {
    return referParentsProfileLink.getAttribute("href");
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
