package co.nvqa.operator_v2.selenium.page;

import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.CodTable.COLUMN_ROUTE_ID;
import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.ParcelTable.ACTION_CREATE_TICKET;
import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.ParcelTable.ACTION_SHOW_DETAIL;
import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.ParcelTable.COLUMN_TRACKING_ID;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteCleaningReportCodInfo;
import co.nvqa.operator_v2.model.RouteCleaningReportParcelInfo;
import com.google.common.collect.ImmutableMap;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("unused")
public class RouteCleaningReportPage extends OperatorV2SimplePage {

  private static final String COD_CSV_FILENAME_PATTERN = "COD";
  private static final String PARCEL_CSV_FILENAME_PATTERN = "Parcel";
  private CodTable codTable;
  private ParcelTable parcelTable;

  public RouteCleaningReportPage(WebDriver webDriver) {
    super(webDriver);
    codTable = new CodTable(webDriver);
    parcelTable = new ParcelTable(webDriver);
  }

  public CodTable codTable() {
    return codTable;
  }

  public ParcelTable parcelTable() {
    return parcelTable;
  }

  public void clickButtonDownloadCSVReport() {
    clickNvIconTextButtonByName("container.route-cleaning-report.download-report");
  }

  public void verifyCSVFileIsDownloadedSuccessfully() {
    verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(COD_CSV_FILENAME_PATTERN));
  }

  public void fetchByDate(Date date) {
    setMdDatepicker("ctrl.data.date", date);
    clickNvApiTextButtonByNameAndWaitUntilDone("container.route-cleaning-report.fetch");
  }

  public void selectCOD() {
    clickButtonByAriaLabel("COD");
  }


  public void selectParcel() {
    clickButtonByAriaLabel("Parcel");
  }

  public void selectReservation() {
    clickButtonByAriaLabel("Reservation");
  }

  public void downloadCsvForSelectedCOD(List<String> routeIds) {
    routeIds.forEach(routeId ->
    {
      codTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
      codTable.selectRow(1);
    });
    clickButtonDownloadCSVReport();
  }

  public void downloadCsvForSelectedParcel(List<String> trackingIds) {
    trackingIds.forEach(trackingId ->
    {
      parcelTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
      codTable.selectRow(1);
    });
    clickButtonDownloadCSVReport();
  }

  public void verifyDownloadedCodCsvFileContent(
      List<RouteCleaningReportCodInfo> expectedCodInfoRecords) {
    String fileName = getLatestDownloadedFilename(COD_CSV_FILENAME_PATTERN);
    verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<RouteCleaningReportCodInfo> actualCodInfoRecords = RouteCleaningReportCodInfo
        .fromCsvFile(RouteCleaningReportCodInfo.class, pathName, true);

    assertThat("Unexpected number of lines in CSV file", actualCodInfoRecords.size(),
        greaterThanOrEqualTo(expectedCodInfoRecords.size()));

    Map<Long, RouteCleaningReportCodInfo> actualMap = actualCodInfoRecords.stream()
        .collect(Collectors.toMap(
            RouteCleaningReportCodInfo::getRouteId,
            codInfo -> codInfo
        ));

    for (RouteCleaningReportCodInfo expectedCodInfo : expectedCodInfoRecords) {
      RouteCleaningReportCodInfo actualCodInfo = actualMap.get(expectedCodInfo.getRouteId());
      verifyCodInfo(expectedCodInfo, actualCodInfo);
    }
  }

  public void verifyParcelInfo(RouteCleaningReportParcelInfo expectedParcelInfo) {
    parcelTable.filterByColumn(COLUMN_TRACKING_ID, expectedParcelInfo.getTrackingId());
    RouteCleaningReportParcelInfo actualParcelInfo = parcelTable.readEntity(1);
    expectedParcelInfo.compareWithActual(actualParcelInfo);
  }

  public void createTicketForParcel(String trackingId) {
    parcelTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
    parcelTable.clickActionButton(1, ACTION_CREATE_TICKET);
    waitUntilInvisibilityOfToast("Ticket has been created!", true);
  }

  public void verifyTickedForParcelWasCreated(String trackingId) {
    parcelTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
    parcelTable.clickActionButton(1, ACTION_SHOW_DETAIL);
  }

  public void verifyDownloadedParcelCsvFileContent(
      List<RouteCleaningReportParcelInfo> expectedParcelInfoRecords) {
    String fileName = getLatestDownloadedFilename(PARCEL_CSV_FILENAME_PATTERN);
    verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<RouteCleaningReportParcelInfo> actualParcelInfoRecords = RouteCleaningReportParcelInfo
        .fromCsvFile(RouteCleaningReportParcelInfo.class, pathName, true);

    assertThat("Unexpected number of lines in CSV file", actualParcelInfoRecords.size(),
        greaterThanOrEqualTo(expectedParcelInfoRecords.size()));

    Map<String, RouteCleaningReportParcelInfo> actualMap = actualParcelInfoRecords.stream()
        .collect(Collectors.toMap(
            RouteCleaningReportParcelInfo::getTrackingId,
            parcelInfo -> parcelInfo
        ));

    for (RouteCleaningReportParcelInfo expectedParcelInfo : expectedParcelInfoRecords) {
      RouteCleaningReportParcelInfo actualParcelInfo = actualMap
          .get(expectedParcelInfo.getTrackingId());
      expectedParcelInfo.compareWithActual(actualParcelInfo);
    }
  }

  public void verifyCodInfo(RouteCleaningReportCodInfo expectedCodInfo) {
    codTable.filterByColumn(COLUMN_ROUTE_ID, String.valueOf(expectedCodInfo.getRouteId()));
    RouteCleaningReportCodInfo actualCodInfo = codTable.readEntity(1);
    verifyCodInfo(expectedCodInfo, actualCodInfo);
  }

  private void verifyCodInfo(RouteCleaningReportCodInfo expectedCodInfo,
      RouteCleaningReportCodInfo actualCodInfo) {
    if (expectedCodInfo.getCodInbound() != null) {
      assertThat("COD Inbound", actualCodInfo.getCodInbound(),
          Matchers.equalTo(expectedCodInfo.getCodInbound()));
    }
    if (expectedCodInfo.getCodExpected() != null) {
      assertThat("COD Expected", actualCodInfo.getCodInbound(),
          Matchers.equalTo(expectedCodInfo.getCodInbound()));
    }
    if (expectedCodInfo.getRouteId() != null) {
      assertThat("Route ID", actualCodInfo.getRouteId(),
          Matchers.equalTo(expectedCodInfo.getRouteId()));
    }
    if (StringUtils.isNotBlank(expectedCodInfo.getDriverName())) {
      assertThat("Driver Name", actualCodInfo.getDriverName(),
          Matchers.equalTo(expectedCodInfo.getDriverName()));
    }
  }

  /**
   * Accessor for COD table
   */
  @SuppressWarnings("WeakerAccess")
  public static class CodTable extends MdVirtualRepeatTable<RouteCleaningReportCodInfo> {

    public static final String COLUMN_COD_INBOUND = "codInbound";
    public static final String COLUMN_ROUTE_ID = "routeId";

    public CodTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_COD_INBOUND, "cod-inbounded")
          .put("codExpected", "cod-expected")
          .put(COLUMN_ROUTE_ID, "route-id")
          .put("driverName", "driver-name")
          .build()
      );
      setEntityClass(RouteCleaningReportCodInfo.class);
    }
  }

  /**
   * Accessor for Parcel table
   */
  @SuppressWarnings("WeakerAccess")
  public static class ParcelTable extends MdVirtualRepeatTable<RouteCleaningReportParcelInfo> {

    public static final String COLUMN_TRACKING_ID = "trackingId";
    public static final String ACTION_CREATE_TICKET = "Create Ticket";
    public static final String ACTION_SHOW_DETAIL = "Ticket Info";

    public ParcelTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_TRACKING_ID, "tracking-id")
          .put("granularStatus", "granular-status")
          .put("lastScanHubId", "last-scan-hub-id")
          .put("exception", "exception")
          .put("routeId", "route-id")
          .put("lastSeen", "last-seen")
          .put("shipperName", "shipper-name")
          .put("driverName", "driver-name")
          .put("lastScanType", "last-scan-type")
          .build()
      );
      setEntityClass(RouteCleaningReportParcelInfo.class);
      setActionButtonsLocators(ImmutableMap.of(ACTION_CREATE_TICKET,
          "//nv-api-icon-button[@name='container.route-cleaning-report.create-ticket']/button",
          ACTION_SHOW_DETAIL, "//button[@aria-label='Ticket Info']"));
    }
  }
}
