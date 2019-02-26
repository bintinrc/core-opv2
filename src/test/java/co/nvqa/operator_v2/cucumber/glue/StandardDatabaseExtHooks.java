package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.StandardScenarioManager;
import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.UserManagement;
import co.nvqa.operator_v2.util.ScenarioStorageKeys;
import cucumber.api.java.After;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class StandardDatabaseExtHooks extends AbstractDatabaseSteps<StandardScenarioManager> implements ScenarioStorageKeys
{
    public StandardDatabaseExtHooks()
    {
    }

    @Override
    public void init()
    {
    }

    @After("@DeleteDpPartner")
    public void deleteDpPartner()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if(dpPartner!=null)
        {
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After("@DeleteDpAndPartner")
    public void deleteDp()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if(dpPartner!=null)
        {
            getDpJdbc().deleteDp(dpPartner.getName());
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After("@DeleteDpUserDpAndPartner")
    public void deleteDpUser()
    {
        DpPartner dpPartner = get(KEY_DP_PARTNER);

        if(dpPartner!=null)
        {
            getDpJdbc().deleteDpUser(dpPartner.getName());
            getDpJdbc().deleteDp(dpPartner.getName());
            getDpJdbc().deleteDpPartner(dpPartner.getName());
        }
    }

    @After("@SoftDeleteOauthClientByEmailAddress")
    public void dbOperatorSoftDeleteOauthClientByEmailAddress()
    {
        NvLogger.info("=============== SOFT DELETING OAUTH CLIENT BY EMAIL ADDRESS ===============");

        List<UserManagement> listOfUserManagement = new ArrayList<>();
        listOfUserManagement.add(get(KEY_CREATED_USER_MANAGEMENT));
        listOfUserManagement.add(get(KEY_UPDATED_USER_MANAGEMENT));

        Set<String> setOfEmailAddress = new HashSet<>();

        for(UserManagement userManagement : listOfUserManagement)
        {
            if(userManagement!=null && userManagement.getEmail()!=null)
            {
                setOfEmailAddress.add(userManagement.getEmail());
            }
        }

        for(String emailAddress : setOfEmailAddress)
        {
            if(emailAddress!=null)
            {
                NvLogger.warnf("Soft Deleting OAuth Client with Email Address: %s", emailAddress);
                getAuthJdbc().softDeleteOauthClientByEmailAddress(emailAddress);
            }
        }

        NvLogger.info("===========================================================================");
    }
}
