package com.lijie.mybatisplus.modules.model;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
@TableName("xy_item")
@ApiModel(value="XyItem对象", description="")
public class XyItem implements Serializable {

    private static final long serialVersionUID=1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer status;

    private Long createtime;

    private Long updatetime;

    @ApiModelProperty(value = "标题")
    private String title;

    @ApiModelProperty(value = "内容")
    private String introduce;

    @ApiModelProperty(value = "如果有富文本，插到这里")
    private String wordandpic;

    private Integer mid;

    @ApiModelProperty(value = "无用字段")
    private Integer type;

    @ApiModelProperty(value = "用来存menu表的类别，作用和id一样")
    private Integer menutypeadd;

    private Integer itemleibie;

    private Integer itemxuhao;


}
