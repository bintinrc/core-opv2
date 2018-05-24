package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.io.File;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class BulkAddressVerificationPage extends OperatorV2SimplePage
{
    public BulkAddressVerificationPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void uploadCsv(File file){
        clickNvIconTextButtonByName("Upload CSV");
        waitUntilVisibilityOfMdDialogByTitle("Upload Address CSV");
        sendKeysByAriaLabel("Choose", file.getAbsolutePath());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        waitUntilInvisibilityOfMdDialogByTitle("Upload Address CSV");
    }
}
