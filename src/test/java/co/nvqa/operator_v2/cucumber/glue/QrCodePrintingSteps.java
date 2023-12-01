package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.QrCodePrintingPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class QrCodePrintingSteps extends AbstractSteps {

  private QrCodePrintingPage qrCodePrintingPage;

  public QrCodePrintingSteps() {
  }

  @Override
  public void init() {
    qrCodePrintingPage = new QrCodePrintingPage(getWebDriver());
  }

  @When("Operator create QR Code from random text on QRCode Printing page")
  public void operatorCreateQrCodeFromRandomTextOnQrCodePrintingPage() {
    String qrCodeText = "AUTOM" + StandardTestUtils.generateDateUniqueString();
    qrCodePrintingPage.generateQrCode(qrCodeText);
    put(CoreScenarioStorageKeys.KEY_CORE_QR_CODE_TEXT, qrCodeText);
  }

  @Then("Operator verify the created QR Code is correct")
  public void operatorVerifyTheCreatedQrCodeIsCorrect() {
    String qrCodeText = get(CoreScenarioStorageKeys.KEY_CORE_QR_CODE_TEXT);
    qrCodePrintingPage.verifyGeneratedQrCodeIsContainsCorrectText(qrCodeText);
  }
}
