package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.address.Address;
import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.commons.model.order_create.v4.Marketplace;
import co.nvqa.commons.model.shipper.v2.Pricing;
import co.nvqa.commons.model.shipper.v2.Reservation;
import co.nvqa.commons.model.shipper.v2.Shipper;
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
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.junit.Assert;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.AllShippersPage.ShippersTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.AllShippersPage.ShippersTable.COLUMN_NAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class AllShippersPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(AllShippersPage.class);

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
  public static final String XPATH_SEARCH_SHIPPER_BY_NAME_LIST_PAGE = "//nv-search-input-filter[@search-text='filter.name']//input";

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
    waitUntilPageLoaded(120);
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

  public void unsetPickupAddressesAsMilkrun(Shipper shipper) {
    searchShipper(shipper.getName());
    Shipper actualShipper = shippersTable.readEntity(1);
    shipper.setLegacyId(actualShipper.getLegacyId());
    openEditShipperPage();
    allShippersCreateEditPage.unsetPickupAddressesAsMilkrun(shipper);
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

   Assertions.assertThat(actualShipper.getName()).as("Name").isEqualTo(shipper.getName());
   Assertions.assertThat(actualShipper.getEmail()).as("Email").isEqualTo(shipper.getEmail());
   Assertions.assertThat(actualShipper.getIndustryName()).as("Industry").isEqualTo(shipper.getIndustryName());
   Assertions.assertThat(actualShipper.getLiaisonEmail()).as("Liaison Email").isEqualTo(shipper.getLiaisonEmail());
   Assertions.assertThat(actualShipper.getContact()).as("Contact").isEqualTo(shipper.getContact());
   Assertions.assertThat(        actualShipper.getSalesPerson()).as("Sales Person").isEqualTo(        shipper.getSalesPerson().substring(0, shipper.getSalesPerson().lastIndexOf("-")));
   Assertions.assertThat(actualShipper.getActive()).as("Expected Status = Inactive").isEqualTo(shipper.getActive());

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
   Assertions.assertThat(isTableEmpty()).as("Table should be empty.").isTrue();
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
   Assertions.assertThat(        text.toLowerCase().contains(keyword.toLowerCase())).as("The keyword is found on the respective column").isTrue();
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

  public void searchShipperByNameOnShipperListPage(String keyword) {
    retryIfAssertionErrorOccurred(() -> {
      getWebDriver().navigate()
          .to(f("%s/%s/shippers/list?keyword=%s", TestConstants.OPERATOR_PORTAL_BASE_URL,
              TestConstants.NV_SYSTEM_ID, keyword));
     Assertions.assertThat(!shippersTable.isTableEmpty()).as("Shipper table is empty").isTrue();
     Assertions.assertThat(shippersTable.getRowsCount()).as("Shipper table has more than one row").isEqualTo(1);
    }, "Search specific shipper in shipper table", 100, 5);
  }

  public void editShipperOnShipperListPage() {
    shippersTable.clickActionButton(1, ACTION_EDIT);
    pause10ms();
    allShippersCreateEditPage.switchToNewWindow();
    allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
  }

  public void editShipper(Shipper shipper) {
    quickSearchShipper(getSearchKeyword(shipper));
    shippersTable.clickActionButton(1, ACTION_EDIT);
    allShippersCreateEditPage.switchToNewWindow();
    allShippersCreateEditPage.waitUntilShipperCreateEditPageIsLoaded();
  }

  public void editShipper(Marketplace marketplace) {
    searchShipperByNameOnShipperListPage(getSearchKeyword(marketplace));
    editShipperOnShipperListPage();
  }

  private String getSearchKeyword(Shipper shipper) {
    String shipperName = shipper.getName();
    String shipperLegacyId = Objects.toString(shipper.getLegacyId(), null);
    LOGGER.info("Created Shipper name : {} ", shipperName);
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
    LOGGER.info("Created seller id : {} ", marketplaceSellerId);
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
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(pricingProfile.getScriptName()).as("Script id is correct")
        .contains(pricingProfileFromDb.getScriptId().toString());
    softAssertions.assertThat(pricingProfileFromOPV2.getTemplateId()).as("Pricing profile id is correct")
        .isEqualTo(pricingProfileFromDb.getTemplateId());
    softAssertions.assertThat(pricingProfileFromDb.getShipperDiscountId())
        .as("Shipper discount Id is not null")
        .isNotNull();
    softAssertions.assertThat(pricingProfile.getComments()).as("Comments are the same")
        .isEqualTo(pricingProfileFromDb.getComments());
    softAssertions.assertThat(pricingProfileFromOPV2.getEffectiveDate())
        .as("Start Date is not null")
        .isNotNull();
    final Date endDate = pricingProfile.getContractEndDate();
    if (Objects.isNull(endDate)) {
      softAssertions.assertThat(pricingProfileFromOPV2.getContractEndDate()).as("End Date is null")
          .isNull();
    } else {
      softAssertions.assertThat(pricingProfileFromOPV2.getContractEndDate())
          .as("End Date is not null")
          .isNotNull();
    }

    final String discount = pricingProfile.getDiscount();
    if (Objects.isNull(discount)) {
      softAssertions.assertThat(pricingProfileFromOPV2.getDiscount()).as("Discount amount is blank")
          .isEqualTo("-");
      softAssertions.assertThat(pricingProfileFromOPV2.getType()).as("Type is blank")
          .isNull();
    } else if (Double.parseDouble(discount) * 100 % 1 > 0) {
      double expectedDiscount = Math.round(Double.parseDouble(discount) * 100.0) / 100.0;
      softAssertions.assertThat(pricingProfileFromOPV2.getDiscount())
          .as("Discount amount is rounded")
          .isEqualTo(Double.toString(expectedDiscount));
      softAssertions.assertThat(pricingProfileFromOPV2.getType()).as("Type is correct")
          .isEqualTo(pricingProfileFromDb.getType());
    } else {
      softAssertions.assertThat(pricingProfileFromDb.getDiscount()).as("Discount amount same")
          .contains(pricingProfile.getDiscount());
      softAssertions.assertThat(pricingProfile.getType()).as("Type is correct")
          .isEqualTo(pricingProfileFromDb.getType());
    }
    if (Objects.isNull(pricingProfile.getCodMin())) {
      softAssertions.assertThat(pricingProfileFromOPV2.getCodMin()).as("COD min fee is -")
          .isEqualTo("-");
    } else {
      softAssertions.assertThat(pricingProfileFromOPV2.getCodMin()).as("COD min fee is correct")
          .isEqualTo(pricingProfile.getCodMin());
    }
    if (Objects.isNull(pricingProfile.getCodMin())) {
      softAssertions.assertThat(pricingProfileFromOPV2.getCodPercentage())
          .as("COD percentage fee is -")
          .isEqualTo("-");
    } else {
      softAssertions.assertThat(pricingProfileFromOPV2.getCodPercentage())
          .as("COD percentage fee is correct")
          .isEqualTo(pricingProfile.getCodPercentage() + "%");
    }
    if (Objects.isNull(pricingProfile.getInsMin())) {
      softAssertions.assertThat(pricingProfileFromOPV2.getInsMin()).as("INS min fee is -")
          .isEqualTo("-");
    } else {
      softAssertions.assertThat(pricingProfileFromOPV2.getInsMin()).as("INS min fee is correct")
          .isEqualTo(pricingProfile.getInsMin());
    }
    if (Objects.isNull(pricingProfile.getInsPercentage())) {
      softAssertions.assertThat(pricingProfileFromOPV2.getInsPercentage())
          .as("INS percentage fee is -")
          .isEqualTo("-");
    } else {
      softAssertions.assertThat(pricingProfileFromOPV2.getInsPercentage())
          .as("INS percentage fee is correct")
          .isEqualTo(pricingProfile.getInsPercentage() + "%");
    }
    if (Objects.isNull(pricingProfile.getInsThreshold())) {
      softAssertions.assertThat(pricingProfileFromOPV2.getInsThreshold()).as("INS Threshold is -")
          .isEqualTo("-");
    } else {
      softAssertions.assertThat(pricingProfileFromOPV2.getInsThreshold())
          .as("INS Threshold is correct")
          .isEqualTo(NO_TRAILING_ZERO_DF.format(Double.valueOf(pricingProfile.getInsThreshold())));
    }
    softAssertions.assertAll();
  }

  public void verifyPricingProfileDetails(Pricing pricingProfile, Pricing pricingProfileFromOPV2) {
    String scriptName = pricingProfile.getScriptName();
    if (Objects.nonNull(scriptName)) {
     Assertions.assertThat(          scriptName.contains(pricingProfileFromOPV2.getScriptName())).as("Script Name is not same: ").isTrue();
    }
    Long discount = pricingProfile.getShipperDiscountId();
    if (Objects.nonNull(discount)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getShipperDiscountId()).as("Shipper Discount is not the same: ").isEqualTo(discount);
    }
    String comments = pricingProfile.getComments();
    if (Objects.nonNull(discount)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getComments()).as("Comments are not the same: ").isEqualTo(comments);
    }
   Assertions.assertThat(pricingProfileFromOPV2.getEffectiveDate()).as("Start Date is null:").isNotNull();
    Date endDate = pricingProfile.getContractEndDate();
    if (Objects.nonNull(endDate)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getContractEndDate()).as("End Date is not the same: ").isEqualTo(endDate);
    }
    String codMin = pricingProfile.getCodMin();
    if (Objects.nonNull(codMin)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getCodMin()).as("COD min fee is not the same: ").isEqualTo(codMin);
    }
    String codPercentage = pricingProfile.getCodPercentage();
    if (Objects.nonNull(codPercentage)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getCodPercentage()).as("COD percentage is not the same: ").isEqualTo(codPercentage + "%");
    }
    String insMin = pricingProfile.getInsMin();
    if (Objects.nonNull(insMin)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getInsMin()).as("INS min fee is not the same: ").isEqualTo(insMin);
    }
    String insPercentage = pricingProfile.getInsPercentage();
    if (Objects.nonNull(insPercentage)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getInsPercentage()).as("INS min percentage is not the same: ").isEqualTo(insPercentage + "%");
    }
    String insThreshold = pricingProfile.getInsThreshold();
    if (Objects.nonNull(insThreshold)) {
     Assertions.assertThat(          pricingProfileFromOPV2.getInsThreshold()).as("INS min threshold is not the same: ").isEqualTo(insThreshold);
    }
  }

  public void changeCountry(String country) {
    click(XPATH_PROFILE);
    selectValueFromMdSelect("domain.current", country);
    pause2s();
  }

  public void verifyAddNewPricingProfileButtonIsDisplayed() {
    waitUntilPageLoaded();
    allShippersCreateEditPage.verifyAddNewPricingProfileButtonIsDisplayed();
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