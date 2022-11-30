package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class StationRoutingPage extends SimpleReactPage<StationRoutingPage> {

  public AssignmentsTable assignmentsTable;

  @FindBy(xpath = ".//div[contains(@class,'ant-select')]")
  public AntSelect3 hub;

  @FindBy(xpath = ".//div[@data-key='isRemoved']//div[contains(@class,'ant-select')]")
  public AntSelect actions;

  @FindBy(css = "[data-testid='next-button']")
  public Button next;

  @FindBy(css = "[data-pa-action='Back to CSV upload']")
  public Button back;

  @FindBy(css = "[data-testId='check-assignment']")
  public Button checkAssignment;

  @FindBy(xpath = ".//div[./span[.='Driver count']]/span[2]")
  public PageElement driverCount;

  @FindBy(xpath = ".//div[./span[.='Parcel count']]/span[2]")
  public PageElement parcelCount;

  @FindBy(css = "[type='file']")
  public FileInput upload;

  @FindBy(css = "[data-datakey='0']")
  public List<PageElement> driverIds;

  @FindBy(css = "[data-datakey='1']")
  public List<PageElement> trackingIds;

  public StationRoutingPage(WebDriver webDriver) {
    super(webDriver);

    assignmentsTable = new AssignmentsTable(webDriver);
  }

  public void selectAction(String action) {
    actions.click();
    clickf(".//div[@class='BaseTable__row-cell-text'][.='%s']", action);
  }

  public static class AssignmentsTable extends AntTableV2<Assignment> {

    public AssignmentsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "id")
          .put("address", "address")
          .put("driverId",
              "//div[@class='BaseTable__body']//div[@role='row'][%d]//div[@role='gridcell'][@data-datakey='driverId']//span[contains(@class,'ant-select-selection-item')]")
          .build()
      );
      setColumnValueProcessors(ImmutableMap.<String, Function<String, String>>builder()
          .put("driverId", v -> StringUtils.isNotBlank(v) ? v.split(" ")[0] : v)
          .build()
      );
      setActionButtonsLocators(ImmutableMap.<String, String>builder()
          .put("Remove", "//div[@role='row'][%d]//button[@data-pa-label='Remove']")
          .build()
      );
      setEntityClass(Assignment.class);
    }

    public boolean isRowDisabled(int index) {
      return StringUtils.contains(getAttribute("class", "//div[@role='row'][%d]", index),
          "base-row-disabled");
    }
  }

  public static class Assignment extends DataEntity<Assignment> {

    private String trackingId;
    private String address;
    private String driverId;

    public Assignment() {
    }

    public Assignment(Map<String, ?> data) {
      super(data);
    }

    public String getTrackingId() {
      return trackingId;
    }

    public void setTrackingId(String trackingId) {
      this.trackingId = trackingId;
    }

    public String getAddress() {
      return address;
    }

    public void setAddress(String address) {
      this.address = address;
    }

    public String getDriverId() {
      return driverId;
    }

    public void setDriverId(String driverId) {
      this.driverId = driverId;
    }

    @Override
    public boolean equals(Object o) {
      if (this == o) {
        return true;
      }
      if (o == null || getClass() != o.getClass()) {
        return false;
      }
      return matchedTo((Assignment) o);
    }
  }
}
