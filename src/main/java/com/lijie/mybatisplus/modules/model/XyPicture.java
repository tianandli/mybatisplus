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
@TableName("xy_picture")
@ApiModel(value="XyPicture对象", description="")
public class XyPicture implements Serializable {

    private static final long serialVersionUID=1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer status;

    private Long createtime;

    private Long updatetime;

    @ApiModelProperty(value = "图片url")
    private String imgurl;

    @ApiModelProperty(value = "小图url")
    private String simgurl;

    @ApiModelProperty(value = "item表的id")
    private Integer iid;

    @ApiModelProperty(value = "1，正文的图片；2，title的图片")
    private Integer type;

    @ApiModelProperty(value = "这个里面放的是图片的描述信息。如老兵心语里面的文字")
    private String descript;

    @ApiModelProperty(value = "这个字段对应老兵心语的名字")
    private String name;

    private Integer pictureleibie;

    private Integer picturexuhao;


}
