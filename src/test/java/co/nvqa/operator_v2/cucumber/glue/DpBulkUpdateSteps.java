package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.client.dp.DpClient;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.support.AuthHelper;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpBulkUpdateType;
import co.nvqa.operator_v2.selenium.page.DpBulkUpdatePage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DpBulkUpdateSteps extends AbstractSteps {

  private DpBulkUpdatePage dpBulkUpdatePage;
  private DpClient dpClient;

  private static final Logger LOGGER = LoggerFactory.getLogger(DpBulkUpdateSteps.class);

  public DpBulkUpdateSteps() {
  }

  @Override
  public void init() {
    dpBulkUpdatePage = new DpBulkUpdatePage(getWebDriver());
    dpClient = new DpClient(TestConstants.API_BASE_URL, AuthHelper.getOperatorAuthToken());
  }

  @Then("Operator verifies that the DP Bulk Update is loaded completely")
  public void operatorVerifiesThatTheDPBulkUpdateIsLoadedCompletely() {
    dpBulkUpdatePage.switchToIframe();
    dpBulkUpdatePage.checkPageIsFullyLoaded();
    takesScreenshot();
  }

  @When("Operator clicks on Select DP ID Button")
  public void operatorClicksOnSelectDPIDButton() {
    dpBulkUpdatePage.selectDpIdsButton.click();
    dpBulkUpdatePage.inputDpIdsModal.isDisplayed();
  }

  @And("Operator inputs DP with {string} condition into the textbox")
  public void operatorInputsDPWithConditionIntoTheTextbox(String type) {
    List<Long> dpIds = new ArrayList<>();
    Dp dp = null;
    DpBulkUpdateType dpBulkUpdateType = DpBulkUpdateType.fromString(type);

    switch (dpBulkUpdateType) {
      case VALID_DIFFERENT_PARTNER:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        dpIds.add(TestConstants.OPV2_DP_DP_ID);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case VALID_SAME_PARTNER:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        dpIds.add(TestConstants.OPV2_DP_BULK_UPDATE_SAME_PARTNER_ID);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case VALID_INACTIVE:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        dpIds.add(TestConstants.OPV2_DP_BULK_UPDATE_INACTIVE_ID);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case INVALID:
        dpIds.add(131313L);
        dpIds.add(111111L);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case MORE_THAN_30:
        dpIds = get(KEY_LIST_OF_DP_IDS);
        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case VALID_INVALID:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        dpIds.add(11111L);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case SPECIAL_CHAR:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        dpIds.add(TestConstants.OPV2_DP_DP_ID);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + ",");
        }
        break;

      case BLANK:
        dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(" ");
        break;

      case SAME_PARTNER_3_DPS:
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_1_ID);
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_2_ID);
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_3_ID);
        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case DUPLICATE_VALID:
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_1_ID);
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_1_ID);
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_3_ID);
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_3_ID);
        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case DP_DELETE_LATER:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_1_ID);
        dpIds.add(TestConstants.SAME_PARTNER_BULK_UPDATE_OPV2_DP_2_ID);
        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case DP_DELETE_LATER_1:
        dp = get(KEY_DISTRIBUTION_POINT);
        dpIds.add(dp.getId());
        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      case PICK_DP:
        dpIds.add(TestConstants.IMDA_PICK_BULK_UPDATE_OPV2_DP_1_ID);
        dpIds.add(TestConstants.IMDA_PICK_BULK_UPDATE_OPV2_DP_2_ID);
        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + "\n");
        }
        break;

      default:
        LOGGER.warn("DP Bulk Update Type is not valid!");
    }
    pause1s();
    dpBulkUpdatePage.loadSelectionButton.click();
  }

  @Then("Operator verifies the data shown in DP Bulk Update Page is correct")
  public void operatorVerifiesTheDataShownInDPBulkUpdatePageIsCorrect() {
    List<WebElement> dpIdWe = getWebDriver().findElements(By.className("dpId"));
    for (int i = 1; i < dpIdWe.size(); i++) {
      pause1s();
      DpDetailsResponse dpDetails = dpClient.getDpDetails(Long.parseLong(dpIdWe.get(i).getText()));
      dpBulkUpdatePage.dpVerification(dpDetails, i);
    }
  }

  @Then("Operator verifies that the toast of {string} will be shown")
  public void operatorVerifiesThatTheErrorToastOfWillBeShown(String toastMessage) {
    dpBulkUpdatePage.errorToastVerification(toastMessage);
    takesScreenshot();
  }

  @Then("Operator verifies error toast with invalid error message is shown")
  public void operatorVerifiesErrorToastWithInvalidErrorMessageIsShown() {
    pause1s();
    getWebDriver().switchTo().parentFrame();
    dpBulkUpdatePage.waitUntilVisibilityOfToast("Network Request Error");
  }

  @Then("Operator verifies error toast with {string} message is shown")
  public void operatorVerifiesErrorToastWithInvalidErrorMessageIsShown(String message) {
    pause1s();
    dpBulkUpdatePage.waitUntilNoticeMessage(message);
  }

  @When("Operator clicks on Bulk Update on Apply Action Drop Down")
  public void operatorClicksOnBulkUpdateOnApplyActionDropDown() {
    dpBulkUpdatePage.applyActionButton.click();
    pause2s();
    dpBulkUpdatePage.bulkUpdateButton.click();
    dpBulkUpdatePage.bulkUpdateDialog.isDisplayed();
  }

  @When("Operator clicks on Set Public on Apply Action Drop Down")
  public void operatorClicksOnSetPublicOnApplyActionDropDown() {
    dpBulkUpdatePage.applyActionButton.click();
    dpBulkUpdatePage.setPublic.click();
    pause1s();
  }

  @When("Operator clicks on Set Not Public on Apply Action Drop Down")
  public void operatorClicksOnSetNotPublicOnApplyActionDropDown() {
    dpBulkUpdatePage.applyActionButton.click();
    dpBulkUpdatePage.setNotPublic.click();
    pause1s();
  }

  @And("Operator edits the capacity of DP via DP Bulk Update Page")
  public void operatorEditsTheCapacityOfDPViaDPBulkUpdatePage() {
    dpBulkUpdatePage.maxCapacity.sendKeys(10000000);
    dpBulkUpdatePage.bufferCapacity.sendKeys(10000000);
    pause1s();
    dpBulkUpdatePage.saveButton.click();
  }

  @And("Operator edits the capacity and enable customer collect of DP via DP Bulk Update Page")
  public void operatorEditsTheCapacityAndEnableCustomerCollectOfDPViaDPBulkUpdatePage() {
    dpBulkUpdatePage.canCustomerCollectEnable.click();
    dpBulkUpdatePage.maxCapacity.sendKeys(65);
    dpBulkUpdatePage.bufferCapacity.sendKeys(90);
    pause1s();
    dpBulkUpdatePage.saveButton.click();
  }

  @And("Operator edits the {string} capacity to {long} of DP via DP Bulk Update Page")
  public void operatorEditsTheCapacityToOfDPViaDPBulkUpdatePage(String column, long capacity) {
    if("Max Capacity".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.maxCapacity.sendKeys(capacity);
    } else {
      dpBulkUpdatePage.bufferCapacity.sendKeys(capacity);
    }
    pause1s();
  }

  @And("Operator enables {string} of DP via DP Bulk Update Page")
  public void operatorEnablesTheToOfDPViaDPBulkUpdatePage(String column) {
    if("can_customer_collect".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.canCustomerCollectEnable.click();
    } else if("allow_customer_return".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.canCustomerReturnEnable.click();
    } else if("shipper_send".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.allowShipperSendEnable.click();
    } else if("packs_sold_here".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.packsSoldEnable.click();
    }
    pause1s();
  }

  @And("Operator enables all settings of DP via DP Bulk Update Page")
  public void OperatorEnablesAllSettingsOfDpViaDpBulkUpdatePage() {
    dpBulkUpdatePage.canCustomerCollectEnable.click();
    dpBulkUpdatePage.canCustomerReturnEnable.click();
    dpBulkUpdatePage.allowShipperSendEnable.click();
    dpBulkUpdatePage.packsSoldEnable.click();
  }

  @And("Operator disables all settings of DP via DP Bulk Update Page")
  public void OperatorDisablesAllSettingsOfDpViaDpBulkUpdatePage() {
    dpBulkUpdatePage.canCustomerCollectDisable.click();
    dpBulkUpdatePage.canCustomerReturnDisable.click();
    dpBulkUpdatePage.allowShipperSendDisable.click();
    dpBulkUpdatePage.packsSoldDisable.click();
  }

  @And("Operator disables {string} of DP via DP Bulk Update Page")
  public void operatorDisablesTheToOfDPViaDPBulkUpdatePage(String column) {
    if("can_customer_collect".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.canCustomerCollectDisable.click();
    } else if("allow_customer_return".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.canCustomerReturnDisable.click();
    } else if("shipper_send".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.allowShipperSendDisable.click();
    } else if("packs_sold_here".equalsIgnoreCase(column)) {
      dpBulkUpdatePage.packsSoldDisable.click();
    }
    pause1s();
  }

  @And("Operator saves the updated settings via DP Bulk Update Page")
  public void OperatorSavesTheUpdatedSettingsViaDpBulkUpdatePage() {
    dpBulkUpdatePage.saveButton.click();
  }

  @Then("Operator download CSV for bulk update")
  public void operatorDownloadCSVForBulkUpdate() {
    pause2s();
    dpBulkUpdatePage.downloadButton.click();
  }

  @Then("Operator verifies data is correct in downloaded csv file = {string}")
  public void operatorVerifiesDataIsCorrectInDownloadedCsvFile(String status) {
    dpBulkUpdatePage.verifyDownloadedCsvFile(status);
  }

  @Then("Operator edits the Max Capacity of pick DP via DP Bulk Update Page for {string}")
  public void operatorEditsTheMaxCapacityOfPickDPViaDPBulkUpdatePageFor(String pickDp) {
    if("XS".equalsIgnoreCase(pickDp)) {
      dpBulkUpdatePage.maxPickCapacityXs.sendKeys(100L);
    } else if ("XL".equalsIgnoreCase(pickDp)){
      dpBulkUpdatePage.maxPickCapacityXL.sendKeys(100L);
    }else if ("L".equalsIgnoreCase(pickDp)){
      dpBulkUpdatePage.maxPickCapacityL.sendKeys(100L);
    }else if ("M".equalsIgnoreCase(pickDp)){
      dpBulkUpdatePage.maxPickCapacityM.sendKeys(100L);
    }
    else {
      dpBulkUpdatePage.maxPickCapacityS.sendKeys(100L);
    }
  }

  @Then("Operator edits the Max Capacity of pick DP via DP Bulk Update Page for {string} to {string}")
  public void operatorEditsTheMaxCapacityOfPickDPViaDPBulkUpdatePageFor(String pickDp, String maxCapacity) {
    if("XS".equalsIgnoreCase(pickDp)) {
      dpBulkUpdatePage.maxPickCapacityXs.sendKeys(Integer.parseInt(maxCapacity));
    } else if ("XL".equalsIgnoreCase(pickDp)){
      dpBulkUpdatePage.maxPickCapacityXL.sendKeys(Integer.parseInt(maxCapacity));
    }else if ("L".equalsIgnoreCase(pickDp)){
      dpBulkUpdatePage.maxPickCapacityL.sendKeys(Integer.parseInt(maxCapacity));
    }else if ("M".equalsIgnoreCase(pickDp)){
      dpBulkUpdatePage.maxPickCapacityM.sendKeys(Integer.parseInt(maxCapacity));
    }
    else {
      dpBulkUpdatePage.maxPickCapacityS.sendKeys(Integer.parseInt(maxCapacity));
    }
  }

  @And("Operator clicks on first checkbox")
  public void operatorClicksOnFirstCheckbox() {
    pause1s();
    dpBulkUpdatePage.firstCheckbox.click();
  }
}