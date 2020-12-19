package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import java.util.Date;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterDateBox extends AbstractFilterBox {

  public NvFilterDateBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  @FindBy(xpath = ".//md-datepicker[1]")
  public MdDatepicker fromDate;

  @FindBy(xpath = ".//md-datepicker[2]")
  public MdDatepicker toDate;

  public void selectFromDate(String value) {
    fromDate.setValue(value);
  }

  public void selectFromDate(Date value) {
    fromDate.setDate(value);
  }

  public void selectToDate(String value) {
    toDate.setValue(value);
  }

  public void selectToDate(Date value) {
    toDate.setDate(value);
  }

  public void selectDates(String fromDate, String toDate) {
    selectFromDate(fromDate);
    selectToDate(toDate);
  }

  public void selectDates(Date fromDate, Date toDate) {
    selectFromDate(fromDate);
    selectToDate(toDate);
  }

  @Override
  void setValue(String... values) {
    selectDates(values[0], values[1]);
  }
}