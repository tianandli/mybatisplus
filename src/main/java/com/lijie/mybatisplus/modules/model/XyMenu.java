package com.lijie.mybatisplus.modules.model;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.lijie.mybatisplus.param.XyMenuAdd;
import com.lijie.mybatisplus.param.XyMenuUpdate;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * 
 * </p>
 *
 * @author lijie
 * @since 2021-05-12
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("xy_menu")
@ApiModel(value="XyMenu对象", description="")
public class XyMenu implements Serializable {

    private static final long serialVersionUID=1L;

    @ApiModelProperty(value = "主键")
    @TableId(value = "id", type = IdType.AUTO)
    @NotNull(groups = {XyMenuUpdate.class})
    private Integer id;

    @ApiModelProperty(value = "0，正常；1，删除")
    @NotNull(groups = {XyMenuAdd.class})
    private Integer status;

    @ApiModelProperty(value = "创建时间")
    private Long createtime;

    @ApiModelProperty(value = "修改时间")
    private Long updatetime;

    @ApiModelProperty(value = "首页标题")
    @NotBlank(groups = {XyMenuAdd.class})
    private String maintitle;

    @ApiModelProperty(value = "这个字段来表示是哪个类型的，如：老兵心语")
    @NotNull(groups = {XyMenuAdd.class})
    private Integer type;

    @ApiModelProperty(value = "版本id")
    @NotNull(groups = {XyMenuAdd.class})
    private Integer vid;

    @ApiModelProperty(value = "创建者id")
    @NotNull(groups = {XyMenuAdd.class})
    private Integer uid;

    public void init(){
        this.createtime = new Date().getTime();
        this.updatetime = new Date().getTime();
    }

}
