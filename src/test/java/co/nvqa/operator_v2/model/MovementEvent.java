package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;

import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class MovementEvent extends DataEntity<MovementEvent>
{
    private String source;
    private String status;
    private String createdAt;
    private String comments;

    public MovementEvent()
    {
    }

    public MovementEvent(Map<String, ?> dataMap)
    {
        fromMap(dataMap);
    }

    public String getSource()
    {
        return source;
    }

    public void setSource(String source)
    {
        this.source = source;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getCreatedAt()
    {
        return createdAt;
    }

    public void setCreatedAt(String createdAt)
    {
        this.createdAt = createdAt;
    }

    public String getComments()
    {
        return comments;
    }

    public void setComments(String comments)
    {
        this.comments = comments;
    }
}
