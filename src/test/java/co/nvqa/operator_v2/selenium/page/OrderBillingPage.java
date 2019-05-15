package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.NvLogger;
import org.openqa.selenium.WebDriver;

import java.io.IOException;
import java.net.URL;
import java.util.Date;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingPage extends OperatorV2SimplePage {

    private static final String REPORT_ATTACHMENT_FILE_EXTENSION = ".csv";
    private static final String REPORT_ATTACHMENT_NAME_PATTERN = "https://.*ninjavan.*billing.*zip";
    private static final String REPORT_EMAIL_SUBJECT = "Success Billings CSV";

    public OrderBillingPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void selectStartDate(Date startDate) {
        setMdDatepicker("ctrl.data.startDate", startDate);
    }

    public void selectEndDate(Date endDate) {
        setMdDatepicker("ctrl.data.endDate", endDate);
    }

    public void tickGenerateTheseFilesOption(String option) {
        click(f("//md-input-container[@label = '%s']/md-checkbox", option));
    }

    public void setEmailAddress(String emailAddress) {
        sendKeysAndEnterByAriaLabel("Email", emailAddress);
    }

    public void clickGenerateSuccessBillingsButton() {
        clickButtonByAriaLabelAndWaitUntilDone("Generate Success Billings");
    }

    public void verifyOrderBillingAttachment(String startDate, String endDate) {
        pause5s();

        GmailClient gmailClient = new GmailClient();

        AtomicBoolean isFound = new AtomicBoolean();
        gmailClient.readUnseenMessage(message ->
        {
            String subject = message.getSubject();
            if (subject.equals(REPORT_EMAIL_SUBJECT) && !isFound.get()) {
                String body = gmailClient.getSimpleContentBody(message);

                Pattern pattern = Pattern.compile(REPORT_ATTACHMENT_NAME_PATTERN);
                Matcher matcher = pattern.matcher(body);

                String attachmentUrl;
                if (matcher.find()) {
                    attachmentUrl = matcher.group();

                    NvLogger.infof("Success Billings file received in mail - %s", attachmentUrl);

                    checkListOfFilesInZip(attachmentUrl, startDate, endDate);
                    isFound.set(Boolean.TRUE);
                }
            }
        });
        assertTrue(f("No email with '%s' subject in the mailbox", REPORT_EMAIL_SUBJECT), isFound.get());
    }

    private void checkListOfFilesInZip(String filePath, String startDate, String endDate) {
        try (ZipInputStream zipIs = new ZipInputStream(new URL(filePath).openStream())) {
            int filesNumber = 0;
            ZipEntry zEntry;
            while ((zEntry = zipIs.getNextEntry()) != null) {
                String fileName = zEntry.getName();
                assertTrue(f("One of the files in Success Billings zip is wrong. Expected to have: startDate = %s, endDate = %s, extension = %s. But was %s",
                        startDate, endDate, REPORT_ATTACHMENT_FILE_EXTENSION, fileName),
                        fileName.contains(startDate) && fileName.contains(endDate) && fileName.endsWith(REPORT_ATTACHMENT_FILE_EXTENSION));
                filesNumber++;
            }
            NvLogger.infof("Total number of files in Success Billings - %s", filesNumber);
        } catch (IOException e) {
            NvLogger.errorf("Could not read file from %s. Cause: %s", filePath, e);
            throw new RuntimeException(e.getMessage());
        }
    }
}
