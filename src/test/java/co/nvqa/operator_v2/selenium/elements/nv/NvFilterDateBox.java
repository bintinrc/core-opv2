package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import java.util.Date;
import java.util.List;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NvFilterDateBox extends AbstractFilterBox {

  public NvFilterDateBox(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public NvFilterDateBox(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
    super(webDriver, searchContext, webElement);
  }

  @FindBy(xpath = ".//md-datepicker[1]")
  public MdDatepicker fromDate;

  @FindBy(xpath = ".//md-datepicker[2]")
  public MdDatepicker toDate;

  public void selectFromDate(String value) {
    fromDate.simpleSetValue(value);
  }

  public void selectFromDate(Date value) {
    fromDate.setDate(StandardTestUtils.convertToZonedDateTime(value));
  }

  public void selectToDate(String value) {
    toDate.simpleSetValue(value);
  }

  public void selectToDate(Date value) {
    toDate.setDate(StandardTestUtils.convertToZonedDateTime(value));
  }

  public void selectDates(String fromDate, String toDate) {
    selectFromDate(fromDate);
    selectToDate(toDate);
  }

  public void selectDates(Date fromDate, Date toDate) {
    selectFromDate(fromDate);
    selectToDate(toDate);
  }

  public void selectFilter(String value) {
    List<String> vals = DataEntity.splitAndNormalize(value);
    Date from = DataEntity.toDateTime(vals.get(0));
    selectFromDate(from);
    Date to = DataEntity.toDateTime(vals.get(1));
    selectToDate(to);
  }

  @Override
  public void setValue(String... values) {
    selectDates(values[0], values[1]);
  }
}