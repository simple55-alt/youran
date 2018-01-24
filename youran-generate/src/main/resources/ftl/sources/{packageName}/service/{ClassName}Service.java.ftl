<#include "/common.ftl">
<#include "/entity_common.ftl">

<#assign importOptimisticLock=false>
<#assign importArrayUtils=false>
<#assign importPageVO=false>
<#assign importList=false>
<#assign importCollectionUtils=false>
<#assign importOtherDAOStr="">
<#--定义主体代码-->
<#assign code>
<@classCom "【${title}】删改查服务"></@classCom>
@Service
public class ${CName}Service {

    @Autowired
    private ${CName}DAO ${cName}DAO;
<#if metaEntity.mtmHoldRefers??>
    <#list metaEntity.mtmHoldRefers as otherEntity>
        <#assign otherCName=otherEntity.className?capFirst>
        <#assign othercName=otherEntity.className?uncapFirst>
        <#assign importOtherDAOStr+="import ${packageName}.dao.${otherCName}DAO;\n">
    @Autowired
    private ${otherCName}DAO ${othercName}DAO;
    </#list>
</#if>

    /**
     * 新增【${title}】
     * @param ${cName}DTO
     * @return
     */
    @Transactional
    public ${CName}PO save(${CName}AddDTO ${cName}DTO) {
        ${CName}PO ${cName} = ${CName}Mapper.INSTANCE.fromAddDTO(${cName}DTO);
        ${cName}DAO.save(${cName});
<#if metaEntity.mtmHoldRefers??>
    <#list metaEntity.mtmHoldRefers as otherEntity>
        <#assign importList=true>
        <#assign importCollectionUtils=true>
        <#assign otherPk=otherEntity.pkField>
        <#assign otherCName=otherEntity.className?capFirst>
        <#assign othercName=otherEntity.className?uncapFirst>
        List<${otherPk.jfieldType}> ${othercName}List = ${cName}DTO.get${otherCName}List();
        if(CollectionUtils.isNotEmpty(${othercName}List)) {
            this.doAdd${otherCName}(${cName}.get${Id}(), ${othercName}List.toArray(new ${otherPk.jfieldType}[]{}));
        }
    </#list>
</#if>
        return ${cName};
    }

    /**
     * 修改【${title}】
     * @param ${cName}UpdateDTO
     * @return
     */
    @Transactional
    <#if metaEntity.versionField??>
        <#assign importOptimisticLock=true>
    @OptimisticLock
    </#if>
    public void update(${CName}UpdateDTO ${cName}UpdateDTO) {
        ${type} ${id} = ${cName}UpdateDTO.get${Id}();
        ${CName}PO ${cName} = ${cName}DAO.findById(${id});
        if(${cName}==null){
            throw new ${ProjectName}Exception("${id}有误");
        }
        ${CName}Mapper.INSTANCE.setUpdateDTO(${cName},${cName}UpdateDTO);
        ${cName}DAO.update(${cName});
<#if metaEntity.mtmHoldRefers??>
    <#list metaEntity.mtmHoldRefers as otherEntity>
        <#assign importList=true>
        <#assign importCollectionUtils=true>
        <#assign otherPk=otherEntity.pkField>
        <#assign otherCName=otherEntity.className?capFirst>
        <#assign othercName=otherEntity.className?uncapFirst>
        List<${otherPk.jfieldType}> ${othercName}List = ${cName}UpdateDTO.get${otherCName}List();
        if(${othercName}List != null) {
            this.set${otherCName}(${cName}.get${Id}(), ${othercName}List.toArray(new ${otherPk.jfieldType}[]{}));
        }
    </#list>
</#if>
    }
<#if pageSign == 1>
    <#assign importPageVO=true>
    /**
     * 查询分页列表
     * @param ${cName}QO
     * @return
     */
    public PageVO<${CName}ListVO> list(${CName}QO ${cName}QO) {
        PageVO<${CName}ListVO> page = ${cName}DAO.findByPage(${cName}QO);
        return page;
    }
<#else>
    <#assign importList=true>
    /**
     * 查询列表
     * @param ${cName}QO
     * @return
     */
    public List<${CName}ListVO> list(${CName}QO ${cName}QO) {
        List<${CName}ListVO> list = ${cName}DAO.findListByQuery(${cName}QO);
        return list;
    }
</#if>
    /**
     * 查询【${title}】详情
     * @param ${id}
     * @return
     */
    public ${CName}ShowVO show(${type} ${id}) {
        ${CName}PO ${cName} = ${cName}DAO.findById(${id});
        if(${cName}==null){
            throw new ${ProjectName}Exception("未查询到记录");
        }
        ${CName}ShowVO showVO = ${CName}Mapper.INSTANCE.toShowVO(${cName});
        return showVO;
    }

    /**
     * 删除【${title}】
     * @param ${id}s
     * @return
     */
    @Transactional
    public int delete(${type}... ${id}s) {
        int count = 0;
        for (${type} ${id} : ${id}s) {
        <#if metaEntity.delField??>
            count += ${cName}DAO.delete(${id});
        <#else>
            count += ${cName}DAO.physicalDelete(${id});
        </#if>
        }
        return count;
    }

<#if metaEntity.mtmHoldRefers??>
    <#list metaEntity.mtmHoldRefers as otherEntity>
        <#assign importArrayUtils=true>
        <#assign otherPk=otherEntity.pkField>
        <#assign otherCName=otherEntity.className?capFirst>
        <#assign othercName=otherEntity.className?uncapFirst>
        <#assign otherPkId=MetadataUtil.getPkAlias(othercName,false)>
    /**
     * 执行【${otherEntity.title}】添加
     * @param ${id}
     * @param ${otherPkId}
     * @return
     */
    private int doAdd${otherCName}(${type} ${id}, ${otherPk.jfieldType}... ${otherPkId}) {
        int count = 0;
        for (Integer _id : ${otherPkId}) {
            if(${othercName}DAO.exist(_id)){
                count += ${cName}DAO.add${otherCName}(${id},_id);
            }
        }
        return count;
    }

    /**
     * 添加【${otherEntity.title}】
     * @param ${id}
     * @param ${otherPkId}
     * @return
     */
    @Transactional
    public int add${otherCName}(${type} ${id}, ${otherPk.jfieldType}... ${otherPkId}) {
        ${CName}PO ${cName} = ${cName}DAO.findById(${id});
        if(${cName}==null){
            throw new ${ProjectName}Exception("未查询到记录");
        }
        if(ArrayUtils.isEmpty(${otherPkId})){
            throw new ${ProjectName}Exception("${otherEntity.title}id参数为空");
        }
        return doAdd${otherCName}(${id}, ${otherPkId});
    }

    /**
     * 移除【${otherEntity.title}】
     * @param ${id}
     * @param ${otherPkId}
     * @return
     */
    @Transactional
    public int remove${otherCName}(${type} ${id}, ${otherPk.jfieldType}... ${otherPkId}) {
        ${CName}PO ${cName} = ${cName}DAO.findById(${id});
        if(${cName}==null){
            throw new ${ProjectName}Exception("未查询到记录");
        }
        if(ArrayUtils.isEmpty(${otherPkId})){
            throw new ${ProjectName}Exception("${otherEntity.title}id参数为空");
        }
        return ${cName}DAO.remove${otherCName}(${id}, ${otherPkId});
    }

    /**
     * 设置【${otherEntity.title}】
     * @param ${id}
     * @param ${otherPkId}
     * @return
     */
    @Transactional
    public int set${otherCName}(${type} ${id}, ${otherPk.jfieldType}[] ${otherPkId}) {
        ${CName}PO ${cName} = ${cName}DAO.findById(${id});
        if(${cName}==null){
            throw new ${ProjectName}Exception("未查询到记录");
        }
        ${cName}DAO.removeAll${otherCName}(${id});
        if(ArrayUtils.isEmpty(${otherPkId})){
            return 0;
        }
        return doAdd${otherCName}(${id}, ${otherPkId});
    }

    </#list>
</#if>

}

</#assign>
<#--开始渲染代码-->
package ${packageName}.service;

<#if importOptimisticLock>
import ${commonPackage}.optimistic.OptimisticLock;
</#if>
<#if importPageVO>
import ${commonPackage}.pojo.vo.PageVO;
</#if>
import ${packageName}.dao.${CName}DAO;
${importOtherDAOStr}
import ${packageName}.pojo.dto.${CName}AddDTO;
import ${packageName}.pojo.qo.${CName}QO;
import ${packageName}.pojo.vo.${CName}ListVO;
import ${packageName}.pojo.dto.${CName}UpdateDTO;
import ${packageName}.pojo.mapper.${CName}Mapper;
import ${packageName}.pojo.po.${CName}PO;
import ${packageName}.pojo.vo.${CName}ShowVO;
import ${packageName}.exception.${ProjectName}Exception;
<#if importCollectionUtils>
import org.apache.commons.collections.CollectionUtils;
</#if>
<#if importArrayUtils>
import org.apache.commons.lang3.ArrayUtils;
</#if>
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
<#if importList>
import java.util.List;
</#if>

${code}
