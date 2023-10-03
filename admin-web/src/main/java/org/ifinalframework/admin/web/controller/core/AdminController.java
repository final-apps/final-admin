package org.ifinalframework.admin.web.controller.core;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.ifinalframework.admin.domain.security.service.SecurityMenuService;
import org.ifinalframework.admin.entity.core.User;
import org.ifinalframework.admin.entity.security.SecurityMenu;
import org.ifinalframework.admin.model.antd.MenuDataItem;
import org.ifinalframework.admin.repository.security.query.QSecurityMenu;
import org.ifinalframework.data.query.Query;

import jakarta.annotation.Resource;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * AdminController
 *
 * @author mik
 * @since 1.5.4
 **/
@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Resource
    private SecurityMenuService securityMenuService;


    @GetMapping("/menus")
    @PreAuthorize("isAuthenticated()")
    public List<MenuDataItem> menus(User user) {
        return menus(-1L, user);
    }

    private List<MenuDataItem> menus(Long parentId, User user) {
        // TODO 找到用户授权菜单
        final List<SecurityMenu> securityMenus = securityMenuService.select(new Query().where(QSecurityMenu.parentId.eq(parentId)).asc(QSecurityMenu.sortValue));
        return securityMenus.stream()
                .map(it -> {
                    final MenuDataItem menuDataItem = new MenuDataItem();
                    menuDataItem.setKey(it.getId().toString());
                    menuDataItem.setIcon(it.getIcon());
                    menuDataItem.setPath(it.getPath());

                    if(Objects.nonNull(it.getCode())){
                        // 找到最后一个.后面的内容
                        String[] split = it.getCode().split("\\.");
                        menuDataItem.setName(split[split.length - 1]);
                    }else {
                        menuDataItem.setName(it.getName());
                    }

                    menuDataItem.setRoutes(menus(it.getId(), user));
                    menuDataItem.setMenuRender(it.getMenuRender());
                    return menuDataItem;
                })
                .collect(Collectors.toList());


    }

}