package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.DpBulkUpdateInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class DpBulkUpdatePage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'dp-bulk-update')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[contains(@class,'BaseTable__table')]")
  private PageElement tableXpath;

  @FindBy(xpath = "//button[@data-testid='button_select_dp_ids']")
  public Button selectDpIdsButton;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public PageElement inputDpIdsModal;

  @FindBy(xpath = "//textarea[@class='ant-input']")
  public PageElement inputDpIdsTextArea;

  @FindBy(xpath = "//button[@data-testid='button_load_selection']")
  public Button loadSelectionButton;

  @FindBy(xpath = "//button[@data-testid='button_apply_actions']")
  public Button applyActionButton;

  @FindBy(xpath = "//li[@data-testid='button_bulk_update']")
  public Button bulkUpdateButton;

  @FindBy(xpath = "(//input[@type='checkbox'])[1]/..")
  public Button firstCheckbox;

  @FindBy(xpath = "//li[@data-testid='button_set_public']")
  public Button setPublic;

  @FindBy(xpath = "//li[@data-testid='button_set_not_public']")
  public Button setNotPublic;

  @FindBy(xpath = "//div[contains(@id,'rcDialogTitle')]")
  public PageElement bulkUpdateDialog;

  @FindBy(xpath = "//input[@placeholder='Max']")
  public PageElement maxCapacity;

  @FindBy(xpath = "//input[@placeholder='Buffer']")
  public PageElement bufferCapacity;

  @FindBy(xpath = "//span[text()='XS']/following-sibling::input")
  public PageElement maxPickCapacityXs;

  @FindBy(xpath = "//span[text()='S']/following-sibling::input")
  public PageElement maxPickCapacityS;

  @FindBy(xpath = "//input[@data-testid='toggle_enable_cust_collect']")
  public PageElement canCustomerCollectEnable;
  @FindBy(xpath = "//input[@data-testid='toggle_disable_cust_collect']")
  public PageElement canCustomerCollectDisable;

  @FindBy(xpath = "//input[@data-testid='toggle_enable_cust_return']")
  public PageElement canCustomerReturnEnable;

  @FindBy(xpath = "//input[@data-testid='toggle_disable_cust_return']")
  public PageElement canCustomerReturnDisable;

  @FindBy(xpath = "//input[@data-testid='toggle_enable_shipper_send']")
  public PageElement allowShipperSendEnable;

  @FindBy(xpath = "//input[@data-testid='toggle_disable_shipper_send']")
  public PageElement allowShipperSendDisable;

  @FindBy(xpath = "//input[@data-testid='toggle_enable_packs_sold']")
  public PageElement packsSoldEnable;

  @FindBy(xpath = "//input[@data-testid='toggle_disable_packs_sold']")
  public PageElement packsSoldDisable;

  @FindBy(xpath = "//button[@data-testid='button_save']")
  public Button saveButton;

  @FindBy(xpath = "//span[text()='Download CSV']/parent::button")
  public Button downloadButton;

  private static final String DP_ID_XPATH = "//tr[%d]/td[@class='dpId']";
  private static final String DP_NAME_XPATH = "//tr[%d]/td[@class='name']";
  private static final String DP_SHORTNAME_XPATH = "//tr[%d]/td[@class='shortName']";
  private static final String DP_FORMATTED_ADDRESS_XPATH = "//tr[%d]/td[@class='formattedAddress']";
  private static final String DP_DIRECTION_XPATH = "//tr[%d]/td[@class='directions']";
  private static final String DP_IS_ACTIVE_XPATH = "//tr[%d]/td[@class='isActive']";
  private static final String DP_IS_PUBLIC_XPATH = "//tr[%d]/td[@class='isPublic']";

  private static final String ERROR_TOAST_WITH_MESSAGE = "//div[contains(@class,'notification-notice') and text()='%s']";

  private static final String DP_BULK_UPDATE_FILENAME_PATTERN = "dp-bulk-update";

  public DpBulkUpdatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void checkPageIsFullyLoaded() {
    waitUntilVisibilityOfElementLocated(tableXpath.getWebElement());
  }

  public void dpVerification(DpDetailsResponse dpDetails, int index) {
    Long actualDpId = Long.parseLong(getText(f(DP_ID_XPATH, index)));
    String actualDpName = getText(f(DP_NAME_XPATH, index));
    String actualDpShortname = getText(f(DP_SHORTNAME_XPATH, index));
    String actualDpAddress = getText(f(DP_FORMATTED_ADDRESS_XPATH, index));
    String actualDpDirection = getText(f(DP_DIRECTION_XPATH, index));
    String actualDpActivity = getText(f(DP_IS_ACTIVE_XPATH, index));
    String actualDpPublicity = getText(f(DP_IS_PUBLIC_XPATH, index));

    Long expectedDpId = dpDetails.getId();
    String expectedDpName = dpDetails.getName();
    String expectedDpShortname = dpDetails.getShortName();
    String expectedDpAddress = dpDetails.getAddress1() + ", " + dpDetails.getAddress2();
    String expectedDpDirection = dpDetails.getDirections();
    Boolean dpActivity = dpDetails.getIsActive();
    Boolean dpPublicity = dpDetails.getIsPublic();

    String expectedDpActivity = "";
    String expectedDpPublicity = "";

    if (dpActivity) {
      expectedDpActivity = "Active";
    } else {
      expectedDpActivity = "Inactive";
    }
    if (dpPublicity) {
      expectedDpPublicity = "Public";
    } else {
      expectedDpPublicity = "Private";
    }

    Assertions.assertThat(actualDpId).as("DP ID is the same").isEqualTo(expectedDpId);
    Assertions.assertThat(actualDpName).as("DP Name is the same").isEqualTo(expectedDpName);
    Assertions.assertThat(actualDpShortname).as("DP Short Name is the same")
        .isEqualTo(expectedDpShortname);
    Assertions.assertThat(actualDpAddress).as("DP Address the same").isEqualTo(expectedDpAddress);
    Assertions.assertThat(actualDpDirection).as("DP Direction  is the same")
        .isEqualTo(expectedDpDirection);
    Assertions.assertThat(actualDpActivity).as("DP Activity  is the same")
        .isEqualTo(expectedDpActivity);
    Assertions.assertThat(actualDpPublicity).as("DP Publicity is the same")
        .isEqualTo(expectedDpPublicity);
  }

  public void errorToastVerification(String errorMessage) {
    pause1s();
    Boolean isErrorToastShown = isElementExist(f(ERROR_TOAST_WITH_MESSAGE, errorMessage));
    Assertions.assertThat(isErrorToastShown).as("Error Toast Shown").isTrue();
  }

  public void verifyDownloadedCsvFile(String status) {
    String fileName = getLatestDownloadedFilename(DP_BULK_UPDATE_FILENAME_PATTERN);
    boolean flag = false;
    verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<DpBulkUpdateInfo> contentsOfCsv = DpBulkUpdateInfo.fromCsvFile(DpBulkUpdateInfo.class, pathName, true);
    if("SUCCESS".equalsIgnoreCase(status)) {
      for(DpBulkUpdateInfo dpBulkUpdateInfo: contentsOfCsv) {
       Assertions.assertThat("SUCCESS").as("Status is Success").isEqualTo(dpBulkUpdateInfo.getStatus());
      }
    } else {
      for(DpBulkUpdateInfo dpBulkUpdateInfo: contentsOfCsv) {
        if(dpBulkUpdateInfo.getStatus().equalsIgnoreCase("ERROR")) {
         Assertions.assertThat("ERROR").as("Status is Error").isEqualTo(dpBulkUpdateInfo.getStatus());
          flag = true;
          break;
        }
      }
     Assertions.assertThat(flag).isTrue();
    }
  }
}
