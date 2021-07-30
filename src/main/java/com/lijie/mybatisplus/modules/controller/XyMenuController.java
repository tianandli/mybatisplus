package com.lijie.mybatisplus.modules.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lijie.mybatisplus.common.CommonPage;
import com.lijie.mybatisplus.common.CommonResult;
import com.lijie.mybatisplus.modules.model.XyMenu;
import com.lijie.mybatisplus.modules.service.XyMenuService;
import com.lijie.mybatisplus.param.XyMenuAdd;
import com.lijie.mybatisplus.param.XyMenuUpdate;
import com.lijie.mybatisplus.utils.CheckParamUtil;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author lijie
 * @since 2021-05-12
 */
@Slf4j
@RestController
@RequestMapping("/modules/xyMenu")
public class XyMenuController {

    @Autowired
    private XyMenuService xyMenuService;

    @ApiOperation("查询所有的菜单")
    @GetMapping(value = "/queryAll")
    public CommonResult queryAll() {
        try {
            List<XyMenu> list = xyMenuService.list();
            return CommonResult.success(list);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("根据id查询")
    @GetMapping(value = "/queryById")
    public CommonResult queryById(@RequestParam Long id) {
        return CommonResult.success(xyMenuService.getById(id));
    }

    @ApiOperation("分页查询菜单")
    @PostMapping(value = "/queryByPage")
    public CommonResult queryByPage(@RequestParam(value = "pageNum", defaultValue = "1") @ApiParam("页码") Integer pageNum,
                                   @RequestParam(value = "pageSize", defaultValue = "10") @ApiParam("每页数量") Integer pageSize,
                                   @RequestBody XyMenu xyMenu) {
        try {
            Page<XyMenu> page = new Page<>(pageNum, pageSize);

            QueryWrapper<XyMenu> queryWrapper = new QueryWrapper<>();
            queryWrapper
                    .like(StringUtils.isNotEmpty(xyMenu.getMaintitle()), "maintitle", xyMenu.getMaintitle())
                    .eq(xyMenu.getType() != null, "type", xyMenu.getType())
                    .orderBy(true, false, "id");
            Page<XyMenu> pageResult = xyMenuService.page(page, queryWrapper);

            return CommonResult.success(CommonPage.restPage(pageResult));
        } catch (Exception e) {
            log.error("系统异常{}", e);
            return CommonResult.failed("系统异常");
        }
    }


    @ApiOperation("添加菜单")
    @PostMapping(value = "/add")
    public CommonResult add(@RequestBody XyMenu xyMenu) {
        try {
            log.info("xyMenu的值是====", xyMenu);
            //参数校验
            String res = CheckParamUtil.checkparam(xyMenu, XyMenuAdd.class);
            if (res != null) {
                return CommonResult.failed(res);
            }
            xyMenu.init();
            boolean result = xyMenuService.save(xyMenu);
            if (result) {
                return CommonResult.success(null);
            } else {
                return CommonResult.failed("操作失败");
            }
        } catch (Exception e) {
            log.error("系统异常{}", e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("根据id删除一条")
    @GetMapping(value = "/delete")
    public CommonResult delete(@RequestParam Long id) {
        try {
            boolean result = xyMenuService.removeById(id);
            if (result) {
                return CommonResult.success(null);
            } else {
                return CommonResult.failed("操作失败");
            }
        } catch (Exception e) {
            log.error("系统异常{}", e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("根据id批量删除")
    @GetMapping(value = "/deleteMany")
    public CommonResult deleteMany(@RequestParam List<Long> ids) {
        try {
            boolean result = xyMenuService.removeByIds(ids);
            if (result) {
                return CommonResult.success(null);
            } else {
                return CommonResult.failed("操作失败");
            }
        } catch (Exception e) {
            log.error("系统异常{}", e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("更新指定id品牌信息")
    @PostMapping(value = "/update")
    public CommonResult updateBrand(@RequestBody XyMenu xyMenu) {
        try {
            log.info("xyMenu的值是====", xyMenu);
            //参数校验
            String res = CheckParamUtil.checkparam(xyMenu, XyMenuUpdate.class);
            if (res != null) {
                return CommonResult.failed(res);
            }
            xyMenu.setUpdatetime(new Date().getTime());
            boolean result = xyMenuService.updateById(xyMenu);
            if (result) {
                return CommonResult.success(null);
            } else {
                return CommonResult.failed("操作失败");
            }
        } catch (Exception e) {
            log.error("系统异常{}", e);
            return CommonResult.failed("系统异常");
        }
    }

}

