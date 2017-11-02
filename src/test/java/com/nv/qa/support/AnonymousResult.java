package com.nv.qa.support;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AnonymousResult<T>
{
    private T value;

    public AnonymousResult()
    {
    }

    public AnonymousResult(T value)
    {
        this.value = value;
    }

    public T getValue()
    {
        return value;
    }

    public void setValue(T value)
    {
        this.value = value;
    }
}
