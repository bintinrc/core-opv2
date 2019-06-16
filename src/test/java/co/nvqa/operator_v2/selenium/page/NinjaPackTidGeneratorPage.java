package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.StandardTestConstants;
import org.openqa.selenium.WebDriver;
import org.opentest4j.AssertionFailedError;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.stream.Stream;

public class NinjaPackTidGeneratorPage extends OperatorV2SimplePage {

    private final static String SERVICE_SCOPE_ID = "Service Scope";
    private final static String PARCEL_SIZE_ID = "Parcel Size";
    private final static String XLSX_GENERATED_TID_FILENAME_PATTERN = "ninja_pack_tracking_id_%s.xlsx";
    private final static String XLSX_GENERATED_TID_EXPECTED_TEXT = "si><t>%s</t></si><si><t>%s</t></si>";
    private final static String XLSX_DATE_FORMAT = "yyyy-MM-dd HH_mm_ss";

    private final static String CONFIRMATION_POPUP_XPATH = "//md-dialog[contains(@class, 'ninja-pack-tid-generator-confirmation-dialog')]";
    private final static String GENERATED_SUCCESSFULLY_TOAST_TEXT = "Tracking ID generated successfully";

    public NinjaPackTidGeneratorPage(WebDriver webDriver) {
        super(webDriver);
    }

    private enum ParcelSize {
        EXTRA_SMALL("Extra-Small", "xs"),
        EXTRA_LARGE("Extra-Large", "xl");

        private String fullName;
        private String shortName;

        ParcelSize(String fullName, String shortName) {
            this.fullName = fullName;
            this.shortName = shortName;
        }

        public String getFullName() {
            return fullName;
        }

        public String getShortName() {
            return shortName;
        }

        public static ParcelSize fromFullName(String description) {
            return Stream.of(ParcelSize.values())
                    .filter(instance -> instance.getFullName().equals(description))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("No value found for ParcelSize - " + description));
        }
    }

    public void selectParcelSize(String value){
        selectValueFromMdSelectById(PARCEL_SIZE_ID, value);
    }

    public void selectServiceScope(String value){
        selectValueFromMdSelectById(SERVICE_SCOPE_ID, value);
    }

    public void sendKeysToQuantity(String value){
        sendKeysByAriaLabel("quantity", value);
    }

    public void clickGenerateButton(){
        clickButtonByAriaLabelAndWaitUntilDone("Generate");
    }

    public void confirmPopGenerationInPopUp(){
        waitUntilVisibilityOfElementLocated(CONFIRMATION_POPUP_XPATH);
        clickButtonOnMdDialogByAriaLabel("Confirm");
        waitUntilVisibilityOfToast(GENERATED_SUCCESSFULLY_TOAST_TEXT);
    }

    public void verifyXlsx(String parcelSizeText, String serviceScope){
        ParcelSize parcelSize = ParcelSize.fromFullName(parcelSizeText);
        ZonedDateTime time = DateUtil.getDate(ZoneId.of(StandardTestConstants.DEFAULT_TIMEZONE));
        int retry = 0;
        while (true){
            if (retry == 3) break;
            findFileOrRetry(parcelSize, time, serviceScope);
            time = time.minusSeconds(1);
            retry++;
        }
    }

    private void findFileOrRetry(ParcelSize parcelSize, ZonedDateTime time, String serviceScope){
        String timeFormatted = DateTimeFormatter.ofPattern(XLSX_DATE_FORMAT).format(time);
        try {
            verifyFileDownloadedSuccessfully(f(XLSX_GENERATED_TID_FILENAME_PATTERN, timeFormatted),
                    f(XLSX_GENERATED_TID_EXPECTED_TEXT, parcelSize.getShortName(), serviceScope));
        }
        catch (AssertionFailedError assertError){
            if (!assertError.getMessage().contains("not exists")){
                throw new AssertionFailedError(assertError.getMessage());
            }
        }
    }
}
