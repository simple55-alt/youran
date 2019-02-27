package com.youran.common.pojo.po;

import java.util.Date;

/**
 * Title:
 * Description:
 * Author: cbb
 * Create Time:2017/8/24 17:20
 */
public abstract class AbstractPO {

    public void preInsert(String createdBy){
        Date now=new Date();
        if(this instanceof Deleted) {
            ((Deleted)this).setDeleted(false);
        }
        if(this instanceof CreatedTime) {
            ((CreatedTime)this).setCreatedTime(now);
        }
        if(this instanceof OperatedTime) {
            ((OperatedTime)this).setOperatedTime(now);
        }
        if(this instanceof CreatedBy) {
            ((CreatedBy)this).setCreatedBy(createdBy);
        }
        if(this instanceof OperatedBy) {
            ((OperatedBy)this).setOperatedBy(createdBy);
        }
        if(this instanceof Version) {
            ((Version)this).setVersion(1);
        }
    }

    public void preUpdate(String operatedBy){
        if(this instanceof OperatedTime) {
            ((OperatedTime)this).setOperatedTime(new Date());
        }
        if(this instanceof OperatedBy) {
            ((OperatedBy)this).setOperatedBy(operatedBy);
        }
    }

    public void postUpdate() {
        if (this instanceof Version) {
            Version version = (Version) this;
            version.setVersion(version.getVersion() + 1);
        }
    }

}
