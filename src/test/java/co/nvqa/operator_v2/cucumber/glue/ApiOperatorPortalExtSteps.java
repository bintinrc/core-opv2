package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager>
{
    @Inject
    public ApiOperatorPortalExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @Given("^Operator V2 cleaning Tag Management by calling API endpoint directly$")
    public void cleaningTagManagement()
    {
        String tagName = TagManagementSteps.DEFAULT_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }

        tagName = TagManagementSteps.EDITED_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }
    }

    @Given("^API Operator retrieve routes using data below:$")
    public void apiOperatorRetrieveRoutesUsingDataBelow(Map<String,String> mapOfData)
    {
        String value = mapOfData.getOrDefault("from", "TODAY");
        Date fromDate = null;
        if (value.equalsIgnoreCase("TODAY")){
            Calendar fromCal = Calendar.getInstance();
            fromCal.setTime(getNextDate(-1));
            fromCal.set(Calendar.HOUR_OF_DAY, 16);
            fromCal.set(Calendar.MINUTE, 0);
            fromCal.set(Calendar.SECOND, 0);
            fromDate = fromCal.getTime();
        } else if (StringUtils.isNotBlank(value)){
            fromDate = Date.from(DateUtil.getDate(value).toInstant());
        }

        value = mapOfData.getOrDefault("to", "TODAY");
        Date toDate = null;
        if (value.equalsIgnoreCase("TODAY")){
            Calendar toCal = Calendar.getInstance();
            toCal.setTime(new Date());
            toCal.set(Calendar.HOUR_OF_DAY, 15);
            toCal.set(Calendar.MINUTE, 59);
            toCal.set(Calendar.SECOND, 59);
            toDate = toCal.getTime();
        } else if (StringUtils.isNotBlank(value)){
            toDate = Date.from(DateUtil.getDate(value).toInstant());
        }

        List<Integer> tags = null;
        value = mapOfData.get("tagIds");
        if (StringUtils.isNotBlank(value)){
            tags = Arrays.stream(value.split(",")).map(tag -> Integer.parseInt(tag.trim())).collect(Collectors.toList());
        }

        Route[] routes = getRouteClient().findPendingRoutesByTagsAndDates(fromDate, toDate, tags);
        put(KEY_LIST_OF_FOUND_ROUTES, Arrays.asList(routes));
    }
}
