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
        dpIds.add(TestConstants.DP_ID);

        for (Long dpId : dpIds) {
          dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(dpId + ",");
        }
        break;

      case BLANK:
        dpBulkUpdatePage.inputDpIdsTextArea.sendKeys(" ");
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
  }

  @Then("Operator verifies error toast with invalid error message is shown")
  public void operatorVerifiesErrorToastWithInvalidErrorMessageIsShown() {
    pause1s();
    getWebDriver().switchTo().parentFrame();
    dpBulkUpdatePage.waitUntilVisibilityOfToast("Network Request Error");
  }

  @When("Operator clicks on Bulk Update on Apply Action Drop Down")
  public void operatorClicksOnBulkUpdateOnApplyActionDropDown() {
    dpBulkUpdatePage.applyActionButton.click();
    dpBulkUpdatePage.bulkUpdateButton.click();
    dpBulkUpdatePage.bulkUpdateDialog.isDisplayed();
  }

  @And("Operator edits the capacity of DP via DP Bulk Update Page")
  public void operatorEditsTheCapacityOfDPViaDPBulkUpdatePage() {
    dpBulkUpdatePage.maxCapacity.sendKeys(10000000);
    dpBulkUpdatePage.bufferCapacity.sendKeys(10000000);
    pause1s();
    dpBulkUpdatePage.saveButton.click();
  }
}
