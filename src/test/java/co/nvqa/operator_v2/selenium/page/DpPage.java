package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class DpPage extends OperatorV2SimplePage
{
    private static final int MAX_RETRY = 10;

    //-- refer to the data-title-text attribute on the cell. see getTextOnTable for detail
    public static final String DP_PARTNER_NAME_COL = "Name";
    public static final String DP_PARTNER_RESTRICTION_COL = "Restrictions";

    public static final String DP_NAME_COL = "Name";
    public static final String DP_DIRECTION_COL = "Directions";

    public static final String DP_USER_USERNAME_COL = "Username";
    public static final String DP_USER_CONTACT_NO_COL = "Contact";

    private static final Map<String, String> BTN_NAME_FILENAME = new HashMap<String,String>()
    {
        {
            put("dp-partners","dp-partners.csv");
            put("dps","dps.csv");
            put("dp-users","dp-users.csv");
        }
    };

    public DpPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadFile(String type)
    {
        TestUtils.deleteFile(TestConstants.TEMP_DIR + BTN_NAME_FILENAME.get(type));
        click("//div[@filename='" + BTN_NAME_FILENAME.get(type) + "']/nv-download-csv-button/div/nv-api-text-button/button");
        pause1s();
    }

    public void verifyDownloadedFile(String type)
    {
        String pathname = TestConstants.TEMP_DIR + BTN_NAME_FILENAME.get(type);
        int counter = 0;
        boolean isFileExists;

        do
        {
            isFileExists = new File(pathname).exists();

            if(!isFileExists)
            {
                pause1s();
            }

            counter++;
        }
        while(!isFileExists && counter<MAX_RETRY);

        TestUtils.deleteFile(pathname);
        Assert.assertTrue(pathname + " not exist.", isFileExists);
    }

    public void search(String type)
    {
        String placeHolder = null;
        String prefix = null;
        String ngRepeat = null;
        String columnClass = null;

        if(type.equals("dp-partners"))
        {
            placeHolder = "Search Distribution Point Partners...";
            prefix = "Partner %s";
            ngRepeat = "dpPartner in $data";
            columnClass = DP_PARTNER_NAME_COL;
        }
        else if(type.equals("dps"))
        {
            placeHolder = "Search Distribution Points...";
            prefix = "DP %s";
            ngRepeat = "dp in $data";
            columnClass = DP_NAME_COL;
        }
        else if(type.equals("dp-users"))
        {
            placeHolder = "Search Distribution Point Users...";
            prefix = "user%s";
            ngRepeat = "dpUser in $data";
            columnClass = DP_USER_USERNAME_COL;
        }

        String keywords = String.format(prefix, SingletonStorage.getInstance().getTmpId());
        searchTable(keywords);
        //sendKeys("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']", keywords);
        pause1s();

        String expectedValue = String.format(prefix, SingletonStorage.getInstance().getTmpId());
        String actualValue = getTextOnTable(ngRepeat, 1, columnClass);
        Assert.assertEquals(expectedValue, actualValue);
    }

    public void verifyResult(String type)
    {
        String ngRepeat = null;
        String columnClass = null;
        String expectedValue = null;

        if(type.equals("add dp-partners"))
        {
            ngRepeat = "dpPartner in $data";
            columnClass = DP_PARTNER_NAME_COL;
            expectedValue = String.format("Partner %s", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("edit dp-partners"))
        {
            ngRepeat = "dpPartner in $data";
            columnClass = DP_PARTNER_RESTRICTION_COL;
            expectedValue = String.format("No restrictions enforced. [%s]", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("add dps"))
        {
            ngRepeat = "dp in $data";
            columnClass = DP_NAME_COL;
            expectedValue = String.format("DP %s", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("edit dps"))
        {
            ngRepeat = "dp in $data";
            columnClass = DP_DIRECTION_COL;
            expectedValue = String.format("No directions provided. [%s]", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("add dp-users"))
        {
            ngRepeat = "dpUser in $data";
            columnClass = DP_USER_USERNAME_COL;
            expectedValue = String.format("user%s", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("edit dp-users"))
        {
            ngRepeat = "dpUser in $data";
            columnClass = DP_USER_CONTACT_NO_COL;
            expectedValue = String.format("+65 %s", SingletonStorage.getInstance().getTmpId());
        }

        searchTable(expectedValue);
        pause100ms();
        String actualValue = getTextOnTable(ngRepeat, 1, columnClass);
        Assert.assertEquals(expectedValue, actualValue);
    }

    public void clickAddBtn(String type)
    {
        String btnXpath = null;

        if(type.equals("dp-partners"))
        {
            btnXpath = "//button[@aria-label='Add Partner']";
        }
        else if(type.equals("dps"))
        {
            btnXpath = "//button[@type='button'][@aria-label='Add DP']";
        }
        else if(type.equals("dp-users"))
        {
            btnXpath = "//button[@type='button'][@aria-label='Add Users']";
        }

        click(btnXpath);
    }

    public void enterDefaultValue(String type)
    {
        if(type.equals("dp-partners"))
        {
            String tmpId = DateUtil.getTimestamp();
            SingletonStorage.getInstance().setTmpId(tmpId);

            sendKeys("//input[@type='text'][@aria-label='Partner Name']", String.format("Partner %s", tmpId));
            sendKeys("//input[@type='text'][@aria-label='POC Name']", String.format("Poc %s", tmpId));
            sendKeys("//input[@type='tel'][@aria-label='POC No.']", String.format("+65 %s", tmpId));
            sendKeys("//input[@type='email'][@aria-label='POC Email']", String.format("%s@poc.co", tmpId));
            sendKeys("//textarea[@name='restrictions'][@aria-label='Restrictions']", "NA");
        }
        else if(type.equals("dps"))
        {
            sendKeys("//input[@type='text'][@aria-label='Name']", String.format("DP %s", SingletonStorage.getInstance().getTmpId()));
            sendKeys("//input[@type='text'][@aria-label='Shortname']", String.format("DP%s", SingletonStorage.getInstance().getTmpId()));
            sendKeys("//input[@type='tel'][@aria-label='Contact No.']", String.format("+65 %s", SingletonStorage.getInstance().getTmpId()));
            sendKeys("//div[label[text()='Shipper Account']]//input", "QA\n");
            sendKeys("//input[@type='text'][@aria-label='Address Line 1']", "Jl. Utan Kayu Raya No. 76");
            sendKeys("//input[@type='text'][@aria-label='Address Line 2']", "Rawamangun");
            sendKeys("//input[@type='text'][@aria-label='City']", "Jakarta");
            sendKeys("//input[@type='text'][@aria-label='Country']", "Indonesia");
            sendKeys("//input[@type='text'][@aria-label='Postcode']", "13120");
            sendKeys("//input[@type='text'][@aria-label='Latitude']", "-6.1981719");
            sendKeys("//input[@type='text'][@aria-label='Longitude']", "106.8628021");
        }
        else if(type.equals("dp-users"))
        {
            sendKeys("//input[@type='text'][@aria-label='First Name']", "User");
            sendKeys("//input[@type='text'][@aria-label='Last Name']", SingletonStorage.getInstance().getTmpId());
            sendKeys("//input[@type='tel'][@aria-label='Contact No.']", String.format("+65 %s", SingletonStorage.getInstance().getTmpId()));
            sendKeys("//input[@type='email'][@aria-label='Email']", String.format("%s@poc.co", SingletonStorage.getInstance().getTmpId()));
            sendKeys("//input[@type='text'][@aria-label='Username']", String.format("user%s", SingletonStorage.getInstance().getTmpId()));
            sendKeys("//input[@type='password'][@aria-label='Password']", "Ninjitsu89");
        }

        click("//button[@type='submit'][@aria-label='Save Button']");
        pause3s();
    }


    public void clickEditBtn(String type)
    {
        String ngRepeat = null;
        String columnClass = null;
        String placeHolder = null;
        String textAreaXpath = null;
        String editValue = null;

        if(type.equals("dp-partners"))
        {
            ngRepeat = "dpPartner in $data";
            columnClass = DP_PARTNER_NAME_COL;
            placeHolder = "Search Distribution Point Partners...";
            textAreaXpath = "//textarea[@name='restrictions'][@aria-label='Restrictions']";
            editValue = String.format("No restrictions enforced. [%s]", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("dps"))
        {
            ngRepeat = "dp in $data";
            columnClass = DP_NAME_COL;

            placeHolder = "Search Distribution Points...";
            textAreaXpath = "//textarea[@name='directions'][@aria-label='Directions']";
            editValue = String.format("No directions provided. [%s]", SingletonStorage.getInstance().getTmpId());
        }
        else if(type.equals("dp-users"))
        {
            ngRepeat = "dpUser in $data";
            columnClass = DP_USER_USERNAME_COL;

            placeHolder = "Search Distribution Point Users...";
            textAreaXpath = "//input[@type='tel'][@aria-label='Contact No.']";
            editValue = String.format("+65 %s", SingletonStorage.getInstance().getTmpId());
        }

        /*
          Verify searching results.
         */
        String expectedValue = findElementByXpath("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']").getAttribute("value");
        String actualValue = getTextOnTable(ngRepeat, 1, columnClass);
        Assert.assertEquals(expectedValue, actualValue);

        pause100ms();
        click("//nv-icon-button[@name='Edit']");
        pause100ms();

        if(type.equals("dp-users"))
        {
            /*
              Since 9 January 2017, we cannot change DP User password from edit dialog.

              Password:
              Please contact it-support if you want to change the password.
             */
            //sendKeys("//input[@type='password'][@aria-label='Password']", "Ninjitsu89");
        }
        else if(type.equals("dps"))
        {
            sendKeys("//div[label[text()='Shipper Account']]//input", "QA\n");
        }

        sendKeys(textAreaXpath, editValue);
        click("//button[@type='submit'][@aria-label='Save Button']");
        pause3s();
    }

    public void clickViewBtn(String type)
    {
        if(type.equals("dps"))
        {
            click("//nv-icon-button[@name='View DPs']");
        }
        else if(type.equals("dp-users"))
        {
            click("//nv-icon-button[@name='View Users']");
        }

        pause100ms();
    }

    public void verifyPage(String type)
    {
        String mainTitle = null;

        if(type.equals("dps"))
        {
            //--
            //-- <h4>Distribution Points</h4>
            mainTitle = "Distribution Points";
        }
        else if(type.equals("dp-users"))
        {
            //-- <h4>Distribution Point Users</h4>
            mainTitle = "Distribution Point Users";
        }

        waitUntilVisibilityOfElementLocated(String.format("//h4[text() = '%s']", mainTitle));
    }

    public void searchTable(String keyword)
    {
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    /**
     *  refer to the data-title-text attribute on the cell.
     *  since class are inconsistent and data-title value are too long.
     *
     *  e.g.:
     *  <tr ng-repeat="dpPartner in $data">
     *     <td data-title="'commons.id' | translate" sortable="'id'" class="id" data-title-text="Id"> 1223 </td>
     *     <td data-title="'commons.name' | translate" sortable="'name'" class="name" data-title-text="Name"> Partner 1505289247109 </td>
     *     <td data-title="'container.dp-administration.dp-partners.header-poc-name' | translate" sortable="'pocName'" class="poc-name" data-title-text="POC Name"> Poc 1505289247109 </td>
     *     <td data-title="'container.dp-administration.dp-partners.header-poc-no' | translate" sortable="'pocTel'" class="poc-tel" data-title-text="POC No."> +65 1505289247109 </td>
     *     <td data-title="'container.dp-administration.dp-partners.header-poc-email' | translate" sortable="'pocEmail'" class="poc-email" data-title-text="POC Email"> 1505289247109@poc.co </td>
     *     <td data-title="'container.dp-administration.dp-partners.header-restrictions' | translate" data-title-text="Restrictions"> No restrictions enforced. [1505289247109] </td>
     *     <td data-title="'commons.actions' | translate" class="actions" data-title-text="Actions">
     *         <div class="nv-icon-button-group layout-align-center-center layout-row" layout="row" layout-align="center center">
     *             <nv-icon-button md-theme="nvBlue" class="" name="Edit" icon="edit" on-click="ctrl.editDPPartner($event, dpPartner.id)">
     *                 <button class="nv-button md-button md-nvBlue-theme md-ink-ripple raised" type="button" ng-transclude="" aria-label="Edit" ng-class="ngChildClass" ng-click="onClick({$event: $event})" ng-disabled="disabled">
     *                     <i class="material-icons">edit</i>
     *                     <div class="md-ripple-container"></div>
     *                 </button>
     *             </nv-icon-button>
     *             <nv-icon-button md-theme="nvGreen" class="" name="View DPs" icon="arrow_forward" on-click="ctrl.viewDPs(dpPartner)">
     *                 <button class="nv-button md-button md-nvGreen-theme md-ink-ripple raised" type="button" ng-transclude="" aria-label="View DPs" ng-class="ngChildClass" ng-click="onClick({$event: $event})" ng-disabled="disabled">
     *                     <i class="material-icons">arrow_forward</i>
     *                 </button>
     *             </nv-icon-button>
     *         </div>
     *     </td> </tr>
     */
    public String getTextOnTable(String ngRepeat, int rowNumber, String dataTitleText)
    {
        //-- e.g.: //tr[@ng-repeat='dpPartner in $data'][1]/td[@data-title-text='Restrictions']
        WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[@data-title-text='%s']", ngRepeat, rowNumber, dataTitleText));
        return we.getText().trim();
    }
}
