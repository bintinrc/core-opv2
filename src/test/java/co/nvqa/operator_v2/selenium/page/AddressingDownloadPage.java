package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.AddressDownloadFilteringType;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.util.TestConstants;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class AddressingDownloadPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'address-download')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//button[contains(@class,'dropdown-trigger')]")
  public PageElement ellipses;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='plus']")
  public PageElement createNewPreset;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='pen']")
  public PageElement editPreset;

  @FindBy(xpath = "//label[text()='Name']/following-sibling::input")
  public PageElement inputPresetName;

  @FindBy(xpath = "//button[@data-testid='add-filter-button']")
  public PageElement filterButton;

  @FindBy(xpath = "//div[@label='Verified']")
  public PageElement verifiedOption;

  @FindBy(xpath = "//div[@label='Unverified']")
  public PageElement unverifiedOption;

  @FindBy(xpath = "//div[@label='Yes']")
  public PageElement yesRtsOption;

  @FindBy(xpath = "//div[@label='No']")
  public PageElement noRtsOption;

  @FindBy(xpath = "//div[contains(@class,'select-filter')]//input[contains(@id,'rc_select')]")
  public PageElement filterInput;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='check']/parent::button")
  public PageElement mainPresetButtonInModal;

  @FindBy(xpath = "//div[contains(@class,'content')]//input[contains(@id,'rc_select')]")
  public PageElement selectPresetEditModal;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='trash']/parent::button")
  public PageElement deletePresetButton;

  private static final String EXISTED_PRESET_SELECTION_XPATH = "//div[contains(@class,'address')]//input[contains(@id,'rc_select')]";
  private static final String DROP_DOWN_PRESET_XPATH = "//ul[contains(@class,'dropdown-menu-root')]";
  private static final String DIALOG_XPATH = "//div[contains(@id,'rcDialogTitle')]";
  private static final String PRESET_SELECTION_XPATH = "//li[contains(@data-testid,'%s')]";
  private static final String FILTER_SHOWN_XPATH = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]";
  private static final String RANDOM_CLICK_XPATH = "//div[contains(@class,'select-filters-holder')]/div[@class='section-header']";
  private static final String PRESET_TO_BE_SELECTED_XPATH = "//div[@title='%s']";
  private static final String PRESET_NOT_FOUND_XPATH = "//*[local-name()='svg' and contains(@class,'empty-img')]";
  private static final String FILTERING_RESULT_XPATH = "//div[contains(text(),'%s')]";

  private static final String ADDRESS_STATUS_DATA_TESTID = "av_statuses";
  private static final String SHIPPER_IDS_DATA_TESTID = "shipper_ids";
  private static final String MARKETPLACE_IDS_DATA_TESTID = "marketplace_ids";
  private static final String ZONE_IDS_DATA_TESTID = "zone_ids";
  private static final String HUB_IDS_DATA_TESTID = "hub_ids";
  private static final String RTS_DATA_TESTID = "rts";

  public AddressingDownloadPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void verifiesPageIsFullyLoaded() {
    isElementExist(EXISTED_PRESET_SELECTION_XPATH);
  }

  public void verifiesOptionIsShown() {
    isElementExist(DROP_DOWN_PRESET_XPATH);
  }

  public void verifiesModalIsShown() {
    waitUntilVisibilityOfElementLocated(DIALOG_XPATH);
  }

  public void setPresetFilter(AddressDownloadFilteringType addressDownloadFilteringType) {
    String shipperName = TestConstants.SHIPPER_V4_NAME;
    final String marketplaceName = "Niko Ninja fixed marketplace";
    final String zoneName = "ZZZ-All Zones";
    String hubName = TestConstants.HUB_NAME;

    switch (addressDownloadFilteringType) {
      case ADDRESS_STATUS_VERIFIED :
        click(f(PRESET_SELECTION_XPATH, ADDRESS_STATUS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        verifiedOption.click();
        break;

      case ADDRESS_STATUS_UNVERIFIED :
        click(f(PRESET_SELECTION_XPATH, ADDRESS_STATUS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        unverifiedOption.click();
        break;

      case SHIPPER_IDS :
        click(f(PRESET_SELECTION_XPATH, SHIPPER_IDS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        filterInput.sendKeys(shipperName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, shipperName));
        click(f(FILTERING_RESULT_XPATH, shipperName));
        break;

      case MARKETPLACE_IDS :
        click(f(PRESET_SELECTION_XPATH, MARKETPLACE_IDS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        filterInput.sendKeys(marketplaceName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, marketplaceName));
        click(f(FILTERING_RESULT_XPATH, marketplaceName));
        break;

      case ZONE_IDS :
        click(f(PRESET_SELECTION_XPATH, ZONE_IDS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        filterInput.sendKeys(zoneName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, zoneName));
        click(f(FILTERING_RESULT_XPATH, zoneName));
        break;

      case HUB_IDS :
        click(f(PRESET_SELECTION_XPATH, HUB_IDS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        filterInput.sendKeys(hubName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, hubName));
        click(f(FILTERING_RESULT_XPATH, hubName));
        break;

      case RTS_NO :
        click(f(PRESET_SELECTION_XPATH, RTS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        yesRtsOption.click();
        break;

      case RTS_YES :
        click(f(PRESET_SELECTION_XPATH, RTS_DATA_TESTID));
        waitUntilVisibilityOfElementLocated(FILTER_SHOWN_XPATH);
        click(FILTER_SHOWN_XPATH);
        noRtsOption.click();
        break;

      default :
        NvLogger.warn("Invalid Address Download Filter Type");
    }
    click(RANDOM_CLICK_XPATH);
    pause1s();
  }

  public void verifiesPresetIsExisted(String presetName) {
    getWebDriver().navigate().refresh();
    switchToIframe();
    click(EXISTED_PRESET_SELECTION_XPATH);
    sendKeys(EXISTED_PRESET_SELECTION_XPATH, presetName);
    waitUntilVisibilityOfElementLocated(f(PRESET_TO_BE_SELECTED_XPATH, presetName));
    assertTrue("Preset is Existed", isElementExist(f(PRESET_TO_BE_SELECTED_XPATH, presetName)));
  }

  public void verifiesPresetIsNotExisted(String presetName) {
    getWebDriver().navigate().refresh();
    switchToIframe();
    click(EXISTED_PRESET_SELECTION_XPATH);
    sendKeys(EXISTED_PRESET_SELECTION_XPATH, presetName);
    waitUntilVisibilityOfElementLocated(PRESET_NOT_FOUND_XPATH);
    assertTrue("Preset is Deleted", isElementExist(PRESET_NOT_FOUND_XPATH));
  }
}
