DROP TABLE IF EXISTS menu;
CREATE TABLE IF NOT EXISTS menu
(
    id                 BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '流水号',
    code               VARCHAR(200) NOT NULL COMMENT '编号',
    path               VARCHAR(200) NOT NULL COMMENT '路径',
    name               VARCHAR(200) NOT NULL COMMENT '名称',
    icon               VARCHAR(200) NULL     DEFAULT NULL COMMENT '图标',
    menu_render        BOOLEAN      NOT NULL DEFAULT TRUE COMMENT '是否渲染为菜单',
    hide_in_menu       BOOLEAN      NOT NULL DEFAULT FALSE COMMENT '是否隐藏',
    parent_id          BIGINT       NOT NULL DEFAULT -1 COMMENT '父ID',
    sort_value         INT          NOT NULL DEFAULT 10000 COMMENT '排序值',
    attributes         JSON         NULL COMMENT '扩展属性',
    version            INT          NOT NULL DEFAULT 1 COMMENT '版本号',
    creator_id         BIGINT       NULL     DEFAULT NULL COMMENT '创建人ID',
    creator_name       VARCHAR(50)  NULL     DEFAULT NULL COMMENT '创建人名称',
    last_modifier_id   BIGINT       NULL     DEFAULT NULL COMMENT '修改人ID',
    last_modifier_name VARCHAR(50)  NULL     DEFAULT NULL COMMENT '修改人名称',
    created            DATETIME     NOT NULL DEFAULT NOW() COMMENT '创建时间',
    last_modified      DATETIME     NOT NULL DEFAULT NOW() ON UPDATE NOW() COMMENT '最后修改时间',
    yn                 TINYINT      NOT NULL DEFAULT 1 COMMENT '有效标记，1：有效，0：无效'
);

INSERT INTO menu (code, path, name, icon, parent_id,menu_render, sort_value)
VALUES ('welcome', '/welcome', '欢迎', 'home', -1,true, 10000),
       ('domain-resources', '/admin/domain-resources', '资源管理', 'setting', -1,true, 10000),
       ('setting', '/admin/setting', '设置', 'setting', -1, true,10000),
       ('security', '/admin/security', '权限管理', 'setting', -1, true,10000),
       ('data', '/data', '数据中心', 'setting', -1, true,10000);

# SET @menu_resources = (SELECT id
#                        FROM menu
#                        WHERE code = 'resources');
# INSERT INTO menu (code, path, name, icon, menu_render,hide_in_menu, parent_id)
# VALUES ('resources.value-types', '/admin/resources/value-types', '值类型', 'setting', true,false, @menu_resources),
#        ('resources.domain-entities', '/admin/resources/domain-entities', '领域实体', 'setting', true,false, @menu_resources),
#        ('resources.domain-entities.resource', '/admin/resources/domain-entities/:resource', '领域实体', 'setting', false,true, @menu_resources);

SET @menu_setting = (SELECT id
                     FROM menu
                     WHERE code = 'setting');
INSERT INTO menu (code, path, name, icon, menu_render, parent_id)
VALUES ('setting.menu', '/admin/setting/menu', '菜单设置', 'setting', false, @menu_setting);

SET @menu_data = (SELECT id
                  FROM menu
                  WHERE code = 'data');
INSERT INTO menu (code, path, name, icon, menu_render, parent_id)
VALUES ('data.table', '/data/table', '数据表', 'setting', false, @menu_data),
       ('data.redis', '/data/redis', '缓存', 'setting', false, @menu_data);

SET @menu_security = (SELECT id
                      FROM menu
                      WHERE code = 'security');
INSERT INTO menu (code, path, name, icon, menu_render, parent_id)
VALUES ('security.authorities', '/admin/security/authorities', '权限码', 'setting', true, @menu_security),
       ('security.roles', '/admin/security/roles', '角色', 'setting', true, @menu_security);





