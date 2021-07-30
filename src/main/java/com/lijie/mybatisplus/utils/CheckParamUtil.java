package com.lijie.mybatisplus.utils;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.ValidatorFactory;
import java.util.Set;

/**
 * 功能描述：参数校验
 *
 * @author: lijie
 * @date: 2021/1/20 8:57
 * @version: V1.0
 */
public class CheckParamUtil {

    /**
     * 数据校验，由于不负责aop结构，且目前不支持bean直接传参，所以更改为手动校验 暂且放入basecontroller
     * @param obj
     * @param clasz
     * @return
     */
    public static String checkparam(Object obj, Class<?>... clasz) {
        ValidatorFactory validator = Validation.buildDefaultValidatorFactory();
        Set<ConstraintViolation<Object>> vis = validator.getValidator().validate(obj, clasz);
        if (vis.size() > 0) {
            String info = "";
            for (ConstraintViolation cons : vis) {
                info += "参数" + cons.getPropertyPath().toString() + cons.getMessage() + ";";
            }
            return info;
        }
        return null;
    }
}
