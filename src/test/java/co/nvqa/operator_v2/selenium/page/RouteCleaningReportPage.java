package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteCleaningReportCodInfo;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.CodTable.COLUMN_ROUTE_ID;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCleaningReportPage extends OperatorV2SimplePage
{
    private static final String CSV_FILENAME_PATTERN = "COD";
    private CodTable codTable;

    public RouteCleaningReportPage(WebDriver webDriver)
    {
        super(webDriver);
        codTable = new CodTable(webDriver);
    }

    public CodTable codTable()
    {
        return codTable;
    }

    public void clickButtonDownloadCSVReport()
    {
        clickNvIconTextButtonByName("container.route-cleaning-report.download-report");
    }

    public void verifyCSVFileIsDownloadedSuccessfully()
    {
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
    }

    public void fetchByDate(Date date)
    {
        setMdDatepicker("ctrl.data.date", date);
        clickNvApiTextButtonByNameAndWaitUntilDone("container.route-cleaning-report.fetch");
    }

    public void selectCOD()
    {
        clickButtonByAriaLabel("COD");
    }

    public void selectParcel()
    {
        clickButtonByAriaLabel("Parcel");
    }

    public void selectReservation()
    {
        clickButtonByAriaLabel("Reservation");
    }

    public void downloadCsvForSelectedCOD(List<String> routeIds)
    {
        routeIds.forEach(routeId -> {
            codTable.filterByColumn(COLUMN_ROUTE_ID, routeId);
            codTable.selectRow(1);
        });
        clickButtonDownloadCSVReport();
    }

    public void verifyDownloadedCodCsvFileContent(List<RouteCleaningReportCodInfo> expectedCodInfoRecords)
    {
        String fileName = getLatestDownloadedFilename(CSV_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<RouteCleaningReportCodInfo> actualCodInfoRecords = RouteCleaningReportCodInfo.fromCsvFile(RouteCleaningReportCodInfo.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualCodInfoRecords.size(), greaterThanOrEqualTo(expectedCodInfoRecords.size()));

        Map<Long, RouteCleaningReportCodInfo> actualMap = actualCodInfoRecords.stream().collect(Collectors.toMap(
                RouteCleaningReportCodInfo::getRouteId,
                codInfo -> codInfo
        ));

        for (RouteCleaningReportCodInfo expectedCodInfo : expectedCodInfoRecords)
        {
            RouteCleaningReportCodInfo actualCodInfo = actualMap.get(expectedCodInfo.getRouteId());
            verifyCodInfo(expectedCodInfo, actualCodInfo);
        }
    }

    public void verifyCodInfo(RouteCleaningReportCodInfo expectedCodInfo)
    {
        codTable.filterByColumn(COLUMN_ROUTE_ID, String.valueOf(expectedCodInfo.getRouteId()));
        RouteCleaningReportCodInfo actualCodInfo = codTable.readEntity(1);
        verifyCodInfo(expectedCodInfo, actualCodInfo);
    }

    private void verifyCodInfo(RouteCleaningReportCodInfo expectedCodInfo, RouteCleaningReportCodInfo actualCodInfo)
    {
        if (expectedCodInfo.getCodInbound() != null)
        {
            Assert.assertThat("COD Inbound", actualCodInfo.getCodInbound(), Matchers.equalTo(expectedCodInfo.getCodInbound()));
        }
        if (expectedCodInfo.getCodExpected() != null)
        {
            Assert.assertThat("COD Expected", actualCodInfo.getCodInbound(), Matchers.equalTo(expectedCodInfo.getCodInbound()));
        }
        if (expectedCodInfo.getRouteId() != null)
        {
            Assert.assertThat("Route ID", actualCodInfo.getRouteId(), Matchers.equalTo(expectedCodInfo.getRouteId()));
        }
        if (StringUtils.isNotBlank(expectedCodInfo.getDriverName()))
        {
            Assert.assertThat("Driver Name", actualCodInfo.getDriverName(), Matchers.equalTo(expectedCodInfo.getDriverName()));
        }
    }

    /**
     * Accessor for COD table
     */
    public static class CodTable extends MdVirtualRepeatTable<RouteCleaningReportCodInfo>
    {
        public static final String COLUMN_COD_INBOUND = "codInbound";
        public static final String COLUMN_ROUTE_ID = "routeId";

        public CodTable(WebDriver webDriver)
        {
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
}
