package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VehicleInformationPage extends OperatorV2SimplePage{
  private static final Logger LOGGER = LoggerFactory.getLogger(VehicleInformationPage.class);

  @FindBy(xpath = "//h4[contains(text(), 'Search by Vehicle Number')]")
  private PageElement searchByVehicleNumberText;

  @FindBy(xpath = "//h4[contains(text(), 'Search by Vehicle Type')]")
  private PageElement searchByVehicleTypeText;

  @FindBy(xpath = "//textarea[@data-testid='vehicle-number-textarea']")
  private TextBox searchByVehicleNumberTextarea;

  public VehicleInformationPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyPageIsLoaded() {
    switchTo();
    waitUntilVisibilityOfElementLocated(searchByVehicleNumberText.getWebElement());
    waitUntilVisibilityOfElementLocated(searchByVehicleTypeText.getWebElement());

    Assertions.assertThat(searchByVehicleNumberText.isDisplayed() && searchByVehicleTypeText.isDisplayed())
        .as("Vehicle Information page is loaded.")
        .isTrue();
  }

  public void searchByVehicleNumbers(List<String> vehicleNumbers) {
    String vehicleNumbersAsSearchStr = String.join("\n", vehicleNumbers);

    searchByVehicleNumberTextarea.waitUntilVisible();
    sendKeys(searchByVehicleNumberTextarea.getWebElement(), vehicleNumbersAsSearchStr);
  }
}
