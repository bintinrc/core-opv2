package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class BulkAddressVerificationPage extends OperatorV2SimplePage
{
    private SuccessfulMatchesTable successfulMatchesTable;

    public BulkAddressVerificationPage(WebDriver webDriver)
    {
        super(webDriver);
        successfulMatchesTable = new SuccessfulMatchesTable(webDriver);
    }

    private File generateWaypointsFile(List<JaroScore> jaroScores)
    {
        List<String> csvLines = new ArrayList<>();
        csvLines.add("\"waypoint\",\"latitude\",\"longitude\"");
        jaroScores.forEach(jaroScore -> csvLines.add(jaroScore.getWaypointId() + "," + jaroScore.getLatitude() + "," + jaroScore.getLongitude()));
        File file = TestUtils.createFileOnTempFolder(String.format("bulk_address_verification_%s.csv", generateDateUniqueString()));
        try
        {
            FileUtils.writeLines(file, csvLines);
        } catch (IOException ex)
        {
            NvLogger.warnf("File '%s' failed to write. Cause: %s", file.getAbsolutePath(), ex.getMessage());
        }
        return file;
    }

    public void uploadWaypointsData(List<JaroScore> jaroScores)
    {
        File file = generateWaypointsFile(jaroScores);
        uploadCsv(file);

        int actualSuccessfulMatches = successfulMatchesTable.getRowsCount();
        Assert.assertEquals("Number of successful matches", jaroScores.size(), actualSuccessfulMatches);

        Map<Long, JaroScore> jsMapByWaypointId = jaroScores.stream().collect(Collectors.toMap(
                JaroScore::getWaypointId,
                jaroScore -> jaroScore
        ));

        for (int rowIndex = 1; rowIndex <= actualSuccessfulMatches; rowIndex++)
        {
            String actualWaypointID = successfulMatchesTable.getWaypointId(rowIndex);
            JaroScore jaroScore = jsMapByWaypointId.get(Long.parseLong(actualWaypointID));
            Assert.assertThat("[" + rowIndex + "] Unexpected Waypoint ID " + actualWaypointID, jaroScore, Matchers.notNullValue());
            Assert.assertEquals("[" + rowIndex + "] Waypoint ID", String.valueOf(jaroScore.getWaypointId()), actualWaypointID);
            Assert.assertThat("[" + rowIndex + " Address] ", successfulMatchesTable.getAddress(rowIndex), Matchers.equalToIgnoringCase(jaroScore.getAddress1()));
            String expectedCoordinates =
                    StringUtils.left(String.valueOf(jaroScore.getLatitude()), 6) +
                            "," +
                            StringUtils.left(String.valueOf(jaroScore.getLongitude()), 6);
            Assert.assertThat("[" + rowIndex + " Coordinates] ", successfulMatchesTable.getCoordinates(rowIndex), Matchers.equalToIgnoringCase(expectedCoordinates));
        }

        updateSuccessfulMatches();
        String toastMessage = String.format("%d Waypoint(s) Updated", jaroScores.size());
        waitUntilInvisibilityOfToast(toastMessage);

    }

    public void uploadCsv(File file)
    {
        clickNvIconTextButtonByName("Upload CSV");
        waitUntilVisibilityOfMdDialogByTitle("Upload Address CSV");
        sendKeysByAriaLabel("Choose", file.getAbsolutePath());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        waitUntilInvisibilityOfMdDialogByTitle("Upload Address CSV");
    }

    public void updateSuccessfulMatches()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Update Successful Matches");
    }

    /**
     * Accessor for Successful Matches table
     */
    public static class SuccessfulMatchesTable extends OperatorV2SimplePage
    {
        private static final String NG_REPEAT = "scs in ctrl.success track by $index";
        private static final String COLUMN_CLASS_WP_ID = "wp-id";
        private static final String COLUMN_CLASS_ADDRESS = "address";
        private static final String COLUMN_CLASS_COORDINATES = "coordinate";

        public SuccessfulMatchesTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getWaypointId(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_WP_ID);
        }

        public String getAddress(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_ADDRESS);
        }

        public String getCoordinates(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_COORDINATES);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        public int getRowsCount()
        {
            return getRowsCountOfTableWithNgRepeat(NG_REPEAT);
        }
    }
}
