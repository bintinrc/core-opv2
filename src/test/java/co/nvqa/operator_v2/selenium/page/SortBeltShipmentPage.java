package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.ShipmentManagementPage.ShipmentsTable.COLUMN_SHIPMENT_ID;

public class SortBeltShipmentPage extends OperatorV2SimplePage {

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[label[text()='Select Hub']]//div[contains(@class,'selector')]")
  public PageElement selectHubComboBox;

  @FindBy(xpath = "//div[label[text()='Select Device ID']]//div[contains(@class,'selector')]")
  public PageElement selectDeviceIdComboBox;

  @FindBy(xpath = "//div[contains(@class,'select-open')]//input[contains(@id,'rc_select')]")
  public PageElement activeDropDownInput;

  @FindBy(xpath = "//span[contains(@class,'stats')]")
  public PageElement tableStats;

  @FindBy(xpath = "//button[contains(@class,'btn-primary')]")
  public Button createShipmentButton;

  @FindBy(xpath = "//div[contains(@id,'rcDialogTitle')]")
  public PageElement dialog;

  @FindBy(xpath = "//div[label[div[text()='Arm Output(s)']]]//div[contains(@class,'selector')]")
  public PageElement armOutputDropdown;

  @FindBy(xpath = "//input[contains(@class,'number-input')]")
  public PageElement shipmentOutput;

  @FindBy(xpath = "//label[contains(@class,'label')]/following-sibling::input")
  public PageElement comment;

  @FindBy(xpath = "//button[contains(@class,'primary')]//*[local-name()='svg' and @data-icon='check']/ancestor::button")
  public Button createShipment;

  @FindBy(xpath = "//button[span[@aria-label='close']]")
  public Button backButton;

  @FindBy(xpath = "//th[contains(@class,'comment')]//input")
  public PageElement commentTextBox;

  @FindBy(xpath = "//td[contains(@class,'action')]/button")
  public Button viewShipmentButton;

  private static final String OPTION_TO_BE_SELECTED = "//div[@label='%s']";
  private static final String SHIPMENT_IDS_XPATH = "//td[@class='id']";
  private static final String HIGHLIGHTED_FILTER_INPUT_XPATH = "//mark[text()='%s']";

  public ShipmentsTable shipmentsTable;

  public SortBeltShipmentPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void selectOption(String value) {
    click(f(OPTION_TO_BE_SELECTED, value));
  }

  public List<Long> getCreatedShipmentIds() {
    List<Long> shipmentIds = new ArrayList<>();
    List<WebElement> shipmentIdsWebElement;

    shipmentIdsWebElement = webDriver.findElements(By.xpath(SHIPMENT_IDS_XPATH));

    for (WebElement we : shipmentIdsWebElement) {
      shipmentIds.add(Long.parseLong(we.getText()));
    }
    return shipmentIds;
  }

  public void validateShipmentDetails(Long shipmentId) {
    final String BELT = "BELT";

    shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, String.valueOf(shipmentId));
    String expectedShipmentId = getText("//td[@nv-table-highlight='filter.id']");
    assertEquals("Shipment ID", expectedShipmentId, String.valueOf(shipmentId));

    String expectedShipmentEntrySource = getText(
        "//td[@nv-table-highlight='filter.shipment_entry_source']");
    assertEquals("Shipment Entry Source", expectedShipmentEntrySource, BELT);
  }

  public void verifiesHighlightedFilterIsShown(String value) {
    retryIfAssertionErrorOccurred(() ->
        assertTrue(isElementExist(f(HIGHLIGHTED_FILTER_INPUT_XPATH, value))),
        f("Finding Sort Belt Shipment with comment %s", value));
  }
}
