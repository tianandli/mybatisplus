package com.lijie.mybatisplus.modules.controller;

import com.lijie.mybatisplus.common.CommonResult;
import com.lijie.mybatisplus.modules.model.XyMenu;
import com.lijie.mybatisplus.modules.service.XyMenuService;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 功能描述：lambda的学习放在这里
 *
 * @author: lijie
 * @date: 2021/5/12 17:10
 * @version: V1.0
 */
@Slf4j
@RestController
@RequestMapping("/modules/lambda")
public class LambdaController {
    @Autowired
    private XyMenuService xyMenuService;

    @ApiOperation("filter方法：对Stream中的元素进行过滤操作")
    @GetMapping(value = "/filter")
    public CommonResult filter() {
        try {
            List<XyMenu> list = xyMenuService.list();
            //对查询出来的结果集合做过滤，id<3的处理成一个新的集合
            List<XyMenu> resultList = list.stream().filter(xyMenu -> xyMenu.getId() < 3)
                    .collect(Collectors.toList());
            return CommonResult.success(resultList);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("map方法：对Stream中的元素进行转换处理后获取")
    @GetMapping(value = "/map")
    public CommonResult map() {
        try {
            List<XyMenu> list = xyMenuService.list();
            //对查询出来的结果集合做提前，将id提取出来组成一个集合
            List<Integer> resultList = list.stream().map(xyMenu -> xyMenu.getId())
                    .collect(Collectors.toList());
            return CommonResult.success(resultList);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("limit方法：从Stream中获取指定数量的元素")
    @GetMapping(value = "/limit")
    public CommonResult limit() {
        try {
            List<XyMenu> list = xyMenuService.list();
            //查询出来的结果集合，取前3条
            List<XyMenu> resultList = list.stream()
                    .limit(3)
                    .collect(Collectors.toList());
            return CommonResult.success(resultList);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("count方法：获取Stream中元素的个数")
    @GetMapping(value = "/count")
    public CommonResult count() {
        try {
            List<XyMenu> list = xyMenuService.list();

            long count = list.stream().count();
            return CommonResult.success("集合中元素的个数是："+count);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("sort方法：对Stream中元素按指定规则进行排序")
    @GetMapping(value = "/sort")
    public CommonResult sort() {
        try {
            List<XyMenu> list = xyMenuService.list();

            List<XyMenu> resultList = list.stream()
                    .sorted((xyMenu1, xyMenu2) -> { return xyMenu1.getMaintitle().compareTo(xyMenu2.getMaintitle()); })
                    .collect(Collectors.toList());
            return CommonResult.success(resultList);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("skip方法：跳过指定个数的Stream中元素，获取后面的元素")
    @GetMapping(value = "/skip")
    public CommonResult skip() {
        try {
            List<XyMenu> list = xyMenuService.list();

            List<XyMenu> resultList = list.stream()
                    .skip(3)
                    .collect(Collectors.toList());
            return CommonResult.success(resultList);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }

    @ApiOperation("list转map，key是id，value是主题")
    @GetMapping(value = "/listToMap")
    public CommonResult listToMap() {
        try {
            List<XyMenu> list = xyMenuService.list();
            //集合转map，key是id，value是主题
            Map<Integer, String> resultMap = list.stream()
                    .collect(Collectors.toMap(xyMenu -> xyMenu.getId(), xyMenu -> xyMenu.getMaintitle()));
            return CommonResult.success(resultMap);
        } catch (Exception e) {
            log.error("系统异常{}",e);
            return CommonResult.failed("系统异常");
        }
    }
}
