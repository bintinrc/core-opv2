package co.nvqa.operator_v2.selenium.page.mm;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class ShipmentWeightDimensionPage extends SimpleReactPage<ShipmentWeightDimensionPage> {

  @FindBy(xpath = "//*[@class='ant-space-item'][1]/h4")
  public PageElement header;

  @FindBy(xpath = "//*[@class='ant-space-item'][2]/button")
  public AntButton newRecordBtn;

  public ShipmentWeightDimensionPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyUI() {
    Assertions.assertThat(header.getText()).as("is header message correct").isEqualTo("Add New Weight & Dimension");
    Assertions.assertThat(newRecordBtn.isDisplayedFast()).as("is New Record button is visible").isTrue();
  }

  public ShipmentWeightDimensionAddPage openNewRecord() {
    newRecordBtn.click();
    ShipmentWeightDimensionAddPage addPage = new ShipmentWeightDimensionAddPage(this.webDriver);
    return addPage;
  }

}
