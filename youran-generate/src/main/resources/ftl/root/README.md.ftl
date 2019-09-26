<#include "/common.ftl">
# ${this.projectDesc}

## 关于项目

- web项目启动类：[${this.projectNameUpper}App.java](/${this.projectNameSplit}-web/src/main/java/${this.packageName?replace('.','/')}/${this.projectNameUpper}App.java)
- 单元测试入口类：[Main.java](/${this.projectNameSplit}-web/src/test/java/${this.packageName?replace('.','/')}/Main.java)
- mysql建表语句：[${this.projectName}.sql](/${this.projectNameSplit}-web/src/test/resources/DB/${this.projectName}.sql)

## 表结构
<#list this.metaEntities as metaEntity>

### ${metaEntity.desc?replace('\'','"')?replace('\n','\\n')}【${metaEntity.tableName}】
|字段名 | 类型 | 非空 | 键 | 注释 |
|------ | ---- | --- | --- | ---- |
    <#list metaEntity.fields as fieldId,field>
        <#assign pk_display><#if isTrue(field.primaryKey)>主键</#if></#assign>
        <#assign notNull_display><#if isTrue(field.notNull)>是<#elseif field.defaultValue=='NULL'> 否 </#if></#assign>
| ${field.fieldName} | ${field.fieldType}${MetadataUtil.getLengthDisplay(field)} | ${notNull_display} | ${pk_display} | ${MetadataUtil.convertCommentDisplay(field.fieldComment)} |
    </#list>
</#list>
<#list this.mtms! as mtm>

    <#assign field1=mtm.refer1.pkField>
    <#assign field2=mtm.refer2.pkField>
### ${mtm.desc?replace('\'','"')?replace('\n','\\n')}【${mtm.tableName}】
|字段名 | 类型 | 非空 | 键 | 注释 |
|------ | ---- | --- | --- | ---- |
| ${mtm.fkAliasForSql1} | ${field1.fieldType}${MetadataUtil.getLengthDisplay(field1)} | 是 |  | ${MetadataUtil.convertCommentDisplay(field1.fieldComment)} |
| ${mtm.fkAliasForSql2} | ${field2.fieldType}${MetadataUtil.getLengthDisplay(field2)} | 是 |  | ${MetadataUtil.convertCommentDisplay(field2.fieldComment)} |
</#list>
