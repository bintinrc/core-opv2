package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class DpBulkUpdatePage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'dp-bulk-update')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[contains(@class,'nv-table')]")
  private PageElement tableXpath;

  @FindBy(xpath = "//button[contains(@class,'ant-btn-text')]")
  public Button selectDpIdsButton;

  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public PageElement inputDpIdsModal;

  @FindBy(xpath = "//textarea[@class='ant-input']")
  public PageElement inputDpIdsTextArea;

  @FindBy(xpath = "//button[contains(@class,'ant-btn-primary')]")
  public Button loadSelectionButton;

  @FindBy(xpath = "//button[contains(@class,'ant-dropdown-trigger')]")
  public Button applyActionButton;

  @FindBy(xpath = "//li[text()='Bulk Update']")
  public Button bulkUpdateButton;

  @FindBy(xpath = "//div[contains(@id,'rcDialogTitle')]")
  public PageElement bulkUpdateDialog;

  @FindBy(xpath = "//input[@placeholder='Max']")
  public PageElement maxCapacity;

  @FindBy(xpath = "//input[@placeholder='Buffer']")
  public PageElement bufferCapacity;

  @FindBy(xpath = "//div[contains(@class,'flex')]/button[contains(@class,'ant-btn-primary')]")
  public Button saveButton;

  private static final String DP_ID_XPATH = "//tr[%d]/td[@class='dpId']";
  private static final String DP_NAME_XPATH = "//tr[%d]/td[@class='name']";
  private static final String DP_SHORTNAME_XPATH = "//tr[%d]/td[@class='shortName']";
  private static final String DP_FORMATTED_ADDRESS_XPATH = "//tr[%d]/td[@class='formattedAddress']";
  private static final String DP_DIRECTION_XPATH = "//tr[%d]/td[@class='directions']";
  private static final String DP_IS_ACTIVE_XPATH = "//tr[%d]/td[@class='isActive']";
  private static final String DP_IS_PUBLIC_XPATH = "//tr[%d]/td[@class='isPublic']";

  private static final String ERROR_TOAST_WITH_MESSAGE = "//div[contains(@class,'notification-notice') and text()='%s']";

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
}
