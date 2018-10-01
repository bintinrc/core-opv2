package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.awt.*;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Random;

/**
 *
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class DriverStrengthPage extends OperatorV2SimplePage
{
    public static final String COLUMN_CLASS_DATA_USERNAME = "username";
    public static final String COLUMN_CLASS_DATA_DRIVER_TYPE = "driver-type";
    public static final String COLUMN_CLASS_DATA_ZONE = "zone-preferences-zone-id";

    private final static String FILENAME = "drivers.csv";
    private String driverType;
    private String zone;

    public DriverStrengthPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadFile()
    {
        click("//button[@filename='" + FILENAME + "']");
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    public void verifyDownloadedFile()
    {
        File f = new File(TestConstants.TEMP_DIR + FILENAME);
        boolean isFileExisted = f.exists();

        if(isFileExisted)
        {
            f.delete();
        }

        Assert.assertTrue(isFileExisted);
    }

    public void filteredBy(String type)
    {
        String filterKey;

        if("zone".equals(type))
        {
            filterKey = zone!=null ? zone : "z-out of zone";
            sendKeys("//th[contains(@class, 'zone-preferences-zone-id')]/nv-search-input-filter/md-input-container/div/input", filterKey);
        }
        else if("driver-type".equals(type))
        {
            filterKey = driverType!=null ? driverType : "Ops";
            sendKeys("//th[contains(@class, 'driver-type')]/nv-search-input-filter/md-input-container/div/input", filterKey);
        }

        List<WebElement> listDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']");
        pause100ms();
        Assert.assertTrue(listDriver.size() > 0);
    }

    public void findZoneAndType()
    {
        try
        {
            pause100ms();
            driverType = getTextOnTable(1, COLUMN_CLASS_DATA_DRIVER_TYPE);
            zone = getTextOnTable(1, COLUMN_CLASS_DATA_ZONE);
        }
        catch(Exception ex)
        {
            NvLogger.warn("An error occurred when getting 'Drive Type' and 'Zone' from table.");
        }
    }

    public void searchDriver()
    {
        String driverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        clickNvIconTextButtonByNameAndWaitUntilDone("container.driver-strength.load-everything");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", driverUsername);
    }

    public void verifyDriver()
    {
        boolean isFound = false;

        List<WebElement> listDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']");

        for(WebElement d : listDriver)
        {
            List<WebElement> el = d.findElements(By.tagName("td"));

            for(WebElement e : el)
            {
                if(e.getText().trim().length() > 0)
                {
                    if(e.getText().trim().equalsIgnoreCase("Driver " + SingletonStorage.getInstance().getTmpId()))
                    {
                        isFound = true;
                        break;
                    }
                }
            }
        }

        Assert.assertTrue(isFound);
    }

    public void changeComingStatus()
    {
        WebElement firstDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']").get(0);
        String before = getComingStatusState(firstDriver);
        changeComingStatusState(firstDriver);
        String after = getComingStatusState(firstDriver);
        Assert.assertTrue(!before.equals(after));
    }

    public void clickViewContactButton()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/md-menu/button");
        pause1s();

        String expectedLicenseNo = "D" + SingletonStorage.getInstance().getTmpId();
        String actualLicenseNo = getText("//div[@aria-hidden='false']/md-menu-content/md-menu-item[@class='contact-info-details' and @role='menuitem']/div[2]/div[2]");
        Assert.assertEquals("License No. is not equal.", expectedLicenseNo, actualLicenseNo);
        closeModal();
    }

    public void clickAddNewDriver()
    {
        clickNvIconTextButtonByName("Add New Driver");
        pause1s();
    }

    public void enterDefaultValue()
    {
        String tmpId = DateUtil.getTimestamp();
        SingletonStorage.getInstance().setTmpId(tmpId);

        sendKeys("//input[@type='text'][@aria-label='First Name']", "Driver");
        sendKeys("//input[@type='text'][@aria-label='Last Name']", tmpId);
        sendKeys("//input[@type='text'][@aria-label='Driver License Number']", "D"+tmpId);
        sendKeys("//input[@type='number'][@aria-label='COD Limit']", "100");

        // Add vehicle.
        clickButtonByAriaLabel("Add More Vehicles");
        sendKeys("//input[@type='text'][@aria-label='License Number']", "D"+tmpId);
        sendKeys("//input[@type='number'][@aria-label='Vehicle Capacity']", "100");

        // Add contact.
        clickButtonByAriaLabel("Add More Contacts");
        sendKeys("//input[@type='text'][@aria-label='Contact']", "D"+tmpId+"@NV.CO");

        // Add zone.
        clickButtonByAriaLabel("Add More Zones");
        sendKeys("//input[@type='number'][@aria-label='Min']", "1");
        sendKeys("//input[@type='number'][@aria-label='Max']", "1");
        sendKeys("//input[@type='number'][@aria-label='Cost']", "1");

        // Username + password.
        sendKeys("//input[@type='text'][@aria-label='Username']", "D"+tmpId);
        sendKeys("//input[@type='text'][@aria-label='Password']", "D00"+tmpId);

        // Comments.
        sendKeys("//textarea[@aria-label='Comments']", "This driver is created by \"Automation Test\" for testing purpose.");

        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyNewDriver()
    {
        String expectedUsername = "D"+ SingletonStorage.getInstance().getTmpId();

        clickNvIconTextButtonByNameAndWaitUntilDone("container.driver-strength.load-everything");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", expectedUsername);

        String actualUsername = getTextOnTable(1, COLUMN_CLASS_DATA_USERNAME);
        Assert.assertEquals(expectedUsername, actualUsername);
    }

    public void searchingNewDriver()
    {
        String driverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        clickNvIconTextButtonByNameAndWaitUntilDone("container.driver-strength.load-everything");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", driverUsername);
    }

    public void editNewDriver()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/nv-icon-button[1]/button");
        pause1s();
        sendKeys("//textarea[@aria-label='Comments']", "This driver is created by \"Automation Test\" for testing purpose. [EDITED]");
        sendKeys("//input[@type='number'][@aria-label='Vehicle Capacity']", "1000");
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        pause1s();
        closeModal();
    }

    public void deleteNewDriver()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/nv-icon-button[2]/button");
        pause1s();

        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        pause1s();
    }

    public void createdDriverShouldNotExist()
    {
        // Check first row does not contain deleted driver.
        String expectedDriverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        String actualDriverUsername = getTextOnTable(1, COLUMN_CLASS_DATA_USERNAME);
        Assert.assertNotEquals(expectedDriverUsername, actualDriverUsername);
    }

    private void changeComingStatusState(WebElement el)
    {
        pause1s();
        el.findElement(By.xpath("//td[contains(@class, 'availability')]/nv-toggle-button/button")).click();
        pause1s();
    }

    private String getComingStatusState(WebElement el)
    {
        return el.findElement(By.xpath("//td[contains(@class, 'availability')]/nv-toggle-button")).getAttribute("md-theme");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, "driver in getTableData()");
    }


    public static void main(String[] args) throws AWTException
    {
        Robot r = new Robot();
        Date start = new Date();
        r.delay(10000);
        while (new Date().getTime() - start.getTime() < 4 * 60 * 60 * 1000){
            simulateAction(r);
            r.delay(random.nextInt(5000) + 5000);
        }
    }

    public static void simulateAction(Robot robot){
        int action = random.nextInt(5);
        switch(action){
            case 0: simulateKeybord(robot, random.nextInt(40) + 10); break;
            case 1: simulateMouse(robot); break;
            case 2: simulateLeft(robot); break;
            case 3: simulateLeft(robot); break;
            case 4: makePause(robot); break;
            //case 3: mouseWheel(robot, random.nextInt(40) - 20);
        }
    }

    public static void makePause(Robot robot){
        int duration = 20000 + random.nextInt(30000);
        System.out.println("make pause " + duration);
        robot.delay(duration);
    }

    public static void simulateLeft(Robot robot){
        System.out.println("simulate left");
        int x = random.nextInt(20)+200;
        int y = random.nextInt(50)+300;
        moveMouse(robot, x, y);
        //mouseClick(robot);
        mouseWheel(robot, random.nextInt(60) - 30);
        moveMouseRandom(robot);
        //mouseClick(robot);
    }

    public static void moveMouse(Robot robot, int x, int y){
        System.out.println("move mouse to " + x + "," + y);
        robot.mouseMove(x, y);
        robot.delay(1000);
    }

    public static void simulateMouse(Robot robot){
        simulateMouse(robot, random.nextInt(10) + 10);
    }

    public static void simulateKeybord(Robot robot, int count){
        for (int i=0; i<=count; i++){
            simulateKey(robot);
        }
    }

    public static void simulateKey(Robot robot){
        int key = random.nextInt(10);
        switch(key){
            case 0: simulateType(robot, KeyEvent.VK_LEFT); break;
            case 1: simulateType(robot, KeyEvent.VK_RIGHT); break;
            case 2: simulateType(robot, KeyEvent.VK_UP); break;
            case 3: simulateType(robot, KeyEvent.VK_DOWN); break;
            case 4: simulateType(robot, KeyEvent.VK_META, KeyEvent.VK_SHIFT, ']'); break;
            case 5: simulateType(robot, KeyEvent.VK_META, KeyEvent.VK_SHIFT, '['); break;
            case 6: simulateType(robot, KeyEvent.VK_META, KeyEvent.VK_SHIFT, ']'); break;
            case 7: simulateType(robot, KeyEvent.VK_META, KeyEvent.VK_SHIFT, '['); break;
            case 8: simulateType(robot, KeyEvent.VK_META, KeyEvent.VK_SHIFT, ']'); break;
            case 9: simulateType(robot, KeyEvent.VK_META, KeyEvent.VK_SHIFT, '['); break;
        }
        robot.delay(300);
    }

    public static void simulateType(Robot robot, int... keycodes){
        System.out.print("type ");
        for (int keycode: keycodes)
        {
            System.out.print(keycode);
            robot.keyPress(keycode);
        }
        System.out.println();
        for (int keycode: keycodes)
        {
            robot.keyRelease(keycode);
        }
    }

    public static void simulateMouse(Robot robot, int count){
        for (int i=0; i<count; i++){
            moveMouseRandom(robot);
            if (random.nextBoolean()){
                mouseClick(robot);
            }
            if (random.nextBoolean()){
                mouseWheel(robot, random.nextInt(60) - 30);
            }
            robot.delay(random.nextInt(5000) + 5000);
        }
    }

    public static void mouseClick(Robot robot){
        System.out.println("Mouse click");
        robot.mousePress(InputEvent.BUTTON1_MASK);
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
    }

    public static void mouseWheel(Robot robot, int wheelAmount){
        System.out.println("Mouse wheel " + wheelAmount);
        robot.mouseWheel(wheelAmount);
    }

    public static void moveMouseRandom(Robot robot){
        int x = random.nextInt(400)+500;
        int y = random.nextInt(300)+200;
        moveMouse(robot, x, y);
    }

    private static Random random = new Random();

}
