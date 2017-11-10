package co.nvqa.operator_v2.support;

/**
 * Created by ferdinand on 3/30/16.
 */
public class ScenarioHelper {

    private static ScenarioHelper singleton = new ScenarioHelper();

    private ScenarioHelper() {
    }

    public static ScenarioHelper getInstance() {
        return singleton;
    }

    private String tmpId = null;

    public void setTmpId(String tmpId) {
        this.tmpId = tmpId;
    }

    public String getTmpId() {
        return this.tmpId;
    }

}
