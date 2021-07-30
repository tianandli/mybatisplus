/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50543
Source Host           : localhost:3306
Source Database       : huasu

Target Server Type    : MYSQL
Target Server Version : 50543
File Encoding         : 65001

Date: 2021-07-30 13:31:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for net_role
-- ----------------------------
DROP TABLE IF EXISTS `net_role`;
CREATE TABLE `net_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) DEFAULT '0' COMMENT '0-正常，1-删除',
  `uid` bigint(20) DEFAULT '0' COMMENT '创建这个角色的用户ID，表示这个角色的拥有者\r\n只有超级管理员与系统管理员，可以创建角色',
  `type` tinyint(4) DEFAULT '0' COMMENT '0-普通用户,\r\n1-超级管理员\r\n,2-系统管理员(只对某些区域有所有的权限),\r\n3-网络管理员\r\n,4-客服,\r\n5-维修人员\r\n超级管理员在增加角色时，type可以是任意有效值，但是如果是系统管理员增加角色时，只能type=3\\4\\5',
  `readonly` tinyint(4) DEFAULT '0' COMMENT '1-只读管理员(只有读的权限，不能增删改，比如公安管理员，系统只给它读的权限)\r\n0-读写管理员',
  `rolename` varchar(64) DEFAULT '' COMMENT '角色名字',
  `roledesc` varchar(255) DEFAULT '' COMMENT '角色描述',
  `roleolt` tinyint(4) DEFAULT '0' COMMENT '0-对OLT没有管理权限，1-对OLT有管理权限',
  `roleonu` tinyint(4) DEFAULT '0' COMMENT '0-对ONU没有管理权限，1-对ONU有管理权限',
  `roleclt` tinyint(4) DEFAULT '0' COMMENT '0-对CLT没有管理权限，1-对CLT有管理权限',
  `rolecnu` tinyint(4) DEFAULT '0' COMMENT '0-对CNU没有管理权限，1-对CNU有管理权限',
  `rolehfc` tinyint(4) DEFAULT '0' COMMENT '0-对HFC没有管理权限，1-对HFC有管理权限',
  `defrole` tinyint(4) DEFAULT '0' COMMENT '1-系统自带角色，不可以删除\r\n0-超级管理员创建的角色，可以删除\r\n系统中自带的角色，需要有5个，分别是\r\n普通用户角色\r\n超级管理员角色\r\n系统管理员角色\r\n网络管理员角色\r\n客服角色\r\n维修人员角色',
  `rolemenu` text COMMENT '每个角色需要定义menu，使用JSON格式保存menu\r\n超级管理员默认有所有的menu，其它管理员，需要定义',
  `menumd5` varchar(64) DEFAULT '' COMMENT '保存net_menu.md5的值，如果net_menu.md5改变，每次用户登录的时候，检查一次。如果不同，需要更新rolemenu以及menumd5。如果相同则无需理会，说明菜单没有变动。\r\n如果管理员主动更新某个角色的菜单，也要及时更新menumd5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of net_role
-- ----------------------------

-- ----------------------------
-- Table structure for net_system
-- ----------------------------
DROP TABLE IF EXISTS `net_system`;
CREATE TABLE `net_system` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主健ID，自增',
  `type` varchar(32) DEFAULT '' COMMENT '服务的属性，分为：\r\ncore -- 核心服务\r\ndev -- 接入服务\r\napp -- APP服务（应用服务）',
  `name` varchar(64) DEFAULT '' COMMENT '默认情况填入服务的UUID，可以由系统管理员修改',
  `uuid` varchar(64) DEFAULT '' COMMENT '核心服务的UUID，不可更改，不可伪造（除非代码被反编译，破解）\r\n为了得到系统的UUID，计算方式是：获取目标系统的MAC地址，使用md5(系统硬件信息+SALT)计算得到，每个系统的UUID是唯一的，不可伪造，不可更改。\r\n接入服务和APP服务随机生成UUID且不需要授权，生成UUID后，保存在自己的数据库里面。\r\n\r\n在代码中已经封装了一个接口：\r\nSystemHelper.getSystemUUID()\r\n为了防止用户直接修改数据库里面的UUID，核心服务的UUID每次都需要从这个接口读取，而不是从数据库读取，但是authcode与authtime应该从数据库读取。',
  `authcode` varchar(64) DEFAULT '' COMMENT '系统授权码，核心服务启动后，由管理员从管理页面填写，如果系统授权时间到了，或者系统没有授权，管理员进入登录页面时，需要手动输入一次\r\ntype=core才有效',
  `authtime` bigint(20) DEFAULT '0' COMMENT '授权时间的截止有效时间戳，单位为秒，服务启动后，由管理从管理页面填写，在页面上显示的时候，只需要显示到日期即可\r\n有效期将至，需要通知管理员更换授权码\r\ntype=core才有效',
  `updatetime` bigint(20) DEFAULT '0' COMMENT '服务接入的时间，也就是服务启动的时间',
  `onlinetime` bigint(20) DEFAULT '0' COMMENT '每次收到心跳，记录一次时间戳，判断服务是否超时，可以使用当前时间和onlinetime比较，如果超出预设的在线时间，则认为掉线了',
  `online` tinyint(4) DEFAULT '0' COMMENT '0-服务不在线，1-服务在线\r\n心跳周期默认为10秒，超过心跳周期后，没心跳认为离线了',
  `uptime` int(11) DEFAULT '0' COMMENT '服务运行时长，由服务随心跳一起，主动发送到核心服务保存',
  `status` tinyint(4) DEFAULT '1' COMMENT '0-表示关闭服务，也就是管理员关闭服务\r\n1-表示开启服务\r\n一旦某个服务关闭，任何请求都会被核心服务拒绝',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index` (`name`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of net_system
-- ----------------------------
INSERT INTO `net_system` VALUES ('28', 'core', 'A5D329B10F4E4748DB59159476818992', 'A5D329B10F4E4748DB59159476818992', '-', '0', '1572759845', '1572759845', '1', '0', '1');
INSERT INTO `net_system` VALUES ('29', 'dev', '9A5521481B33ECD8FAB71F216DE63C78', '9A5521481B33ECD8FAB71F216DE63C78', '-', '0', '1572772972', '1572773443', '1', '470', '1');
INSERT INTO `net_system` VALUES ('30', 'core', '37627D3F51867A7AD9A4EEB5D1D0F613', '37627D3F51867A7AD9A4EEB5D1D0F613', '-', '0', '1575169750', '1575169750', '1', '0', '0');

-- ----------------------------
-- Table structure for net_user
-- ----------------------------
DROP TABLE IF EXISTS `net_user`;
CREATE TABLE `net_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主健ID，自增',
  `uid` bigint(20) DEFAULT '0' COMMENT '账号创建的用户id，系统用户与超级管理可以创建其它账号。系统管理员只能删除自己创建的账号，而超级用户可以删除任意账号。',
  `username` varchar(64) DEFAULT '' COMMENT '管理员名字',
  `phone` varchar(20) DEFAULT '' COMMENT '电话号码',
  `password` varchar(64) DEFAULT '' COMMENT '使用md5保存.用户从后台页面登录时候，输入的密码需要经过MD5处理，才可以传给后台',
  `sex` tinyint(4) DEFAULT '0' COMMENT '0-男，1-女',
  `recycle` tinyint(4) DEFAULT '0' COMMENT '0-正常，1-关闭，只有超级管理员与系统管理员才可以临时关闭其它管理员的账号，关闭后，将不能登录系统',
  `status` tinyint(4) DEFAULT '0' COMMENT '0-正常，1-删除',
  `logintime` int(11) DEFAULT '0' COMMENT '当前登录的时间戳，自1970年后的秒数',
  `lasttime` int(11) DEFAULT '0' COMMENT '上次登录的时间戳，自1970年后的秒数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of net_user
-- ----------------------------

-- ----------------------------
-- Table structure for net_user_role
-- ----------------------------
DROP TABLE IF EXISTS `net_user_role`;
CREATE TABLE `net_user_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rid` bigint(20) DEFAULT '0' COMMENT '用户所属角色，来自net_role.id',
  `uid` bigint(20) DEFAULT '0' COMMENT '管理员ID,自来net_user.id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of net_user_role
-- ----------------------------

-- ----------------------------
-- Table structure for xy_item
-- ----------------------------
DROP TABLE IF EXISTS `xy_item`;
CREATE TABLE `xy_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL DEFAULT '0',
  `createtime` bigint(20) DEFAULT NULL,
  `updatetime` bigint(20) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `introduce` varchar(2048) DEFAULT NULL COMMENT '内容',
  `wordandpic` text COMMENT '如果有富文本，插到这里',
  `mid` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL COMMENT '无用字段',
  `menutypeadd` int(11) DEFAULT NULL COMMENT '用来存menu表的类别，作用和id一样',
  `itemleibie` int(11) DEFAULT NULL,
  `itemxuhao` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xy_item
-- ----------------------------
INSERT INTO `xy_item` VALUES ('1', '1', '1578621427', '1578621427', null, null, null, '3', null, '3', '2', '10');
INSERT INTO `xy_item` VALUES ('2', '1', '1578621614', '1578621614', null, null, null, '3', null, '3', '2', '9');
INSERT INTO `xy_item` VALUES ('3', '1', '1578621846', '1578621846', null, null, null, '3', null, '3', '2', '8');
INSERT INTO `xy_item` VALUES ('4', '1', '1578622776', '1578622776', null, null, null, '3', null, '3', '3', '6');
INSERT INTO `xy_item` VALUES ('5', '1', '1578625548', '1578625548', null, null, null, '3', null, '3', '2', '6');
INSERT INTO `xy_item` VALUES ('6', '1', '1578634171', '1578634171', null, null, null, '3', null, '3', '3', '6');
INSERT INTO `xy_item` VALUES ('7', '1', '1578637283', '1578637283', null, null, null, '3', null, '3', '1', '6');
INSERT INTO `xy_item` VALUES ('8', '1', '1578883040', '1578883040', null, null, null, '1', null, '1', '2', '3');
INSERT INTO `xy_item` VALUES ('9', '1', '1578893040', '1578893040', null, null, null, '3', null, '3', '3', '6');
INSERT INTO `xy_item` VALUES ('10', '1', '1578893117', '1578893117', null, null, null, '3', null, '3', '2', '6');
INSERT INTO `xy_item` VALUES ('11', '1', '1578893166', '1578893166', null, null, null, '3', null, '3', '1', '6');
INSERT INTO `xy_item` VALUES ('12', '1', '1578893497', '1578893497', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('13', '1', '1578893745', '1578893745', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('14', '1', '1578894258', '1578894258', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('15', '1', '1578895150', '1578895150', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('16', '1', '1578895457', '1578895457', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('17', '1', '1578896652', '1578896652', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('18', '1', '1578897282', '1578897282', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('19', '1', '1578897373', '1578897373', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('20', '1', '1578897408', '1578897408', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('21', '1', '1578897433', '1578897433', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('22', '1', '1578897518', '1578897518', null, null, null, '4', null, '4', '3', '10');
INSERT INTO `xy_item` VALUES ('23', '1', '1578897588', '1578897588', null, null, null, '4', null, '4', '2', '10');
INSERT INTO `xy_item` VALUES ('24', '1', '1578897797', '1578897797', null, null, null, '5', null, '5', '4', '3');
INSERT INTO `xy_item` VALUES ('25', '1', '1578897831', '1578897831', null, null, null, '5', null, '5', '2', '3');
INSERT INTO `xy_item` VALUES ('26', '0', '1578897901', '1578897901', null, null, null, '6', null, '6', '3', '4');
INSERT INTO `xy_item` VALUES ('27', '0', '1578900281', '1578900281', null, null, null, '7', null, '7', '1', '3');
INSERT INTO `xy_item` VALUES ('28', '1', '1578900352', '1578900352', null, null, null, '7', null, '7', '1', '3');
INSERT INTO `xy_item` VALUES ('29', '0', '1578900417', '1578900417', null, null, null, '8', null, '8', '1', '2');
INSERT INTO `xy_item` VALUES ('30', '0', '1578900468', '1578900468', null, null, null, '8', null, '8', '1', '1');
INSERT INTO `xy_item` VALUES ('31', '1', '1578900564', '1578900564', null, null, null, '9', null, '9', '1', '11');
INSERT INTO `xy_item` VALUES ('32', '1', '1578900600', '1578900600', null, null, null, '10', null, '10', '1', '2');
INSERT INTO `xy_item` VALUES ('33', '0', '1578900654', '1578900654', null, null, null, '11', null, '11', '1', '1');
INSERT INTO `xy_item` VALUES ('34', '1', '1578901424', '1578901424', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('35', '1', '1578968850', '1578968850', null, null, null, '2', null, '2', '5', '31');
INSERT INTO `xy_item` VALUES ('36', '0', '1578969002', '1578969002', null, null, null, '2', null, '2', '5', '30');
INSERT INTO `xy_item` VALUES ('37', '0', '1578969243', '1578969243', null, null, null, '2', null, '2', '5', '29');
INSERT INTO `xy_item` VALUES ('38', '0', '1578969325', '1578969325', null, null, null, '2', null, '2', '5', '28');
INSERT INTO `xy_item` VALUES ('39', '0', '1578969396', '1578969396', null, null, null, '2', null, '2', '5', '27');
INSERT INTO `xy_item` VALUES ('40', '0', '1578969464', '1578969464', null, null, null, '2', null, '2', '5', '26');
INSERT INTO `xy_item` VALUES ('41', '0', '1578969521', '1578969521', null, null, null, '2', null, '2', '5', '25');
INSERT INTO `xy_item` VALUES ('42', '0', '1578969581', '1578969581', null, null, null, '2', null, '2', '5', '24');
INSERT INTO `xy_item` VALUES ('43', '0', '1578969627', '1578969627', null, null, null, '2', null, '2', '5', '23');
INSERT INTO `xy_item` VALUES ('44', '0', '1578969699', '1578969699', null, null, null, '2', null, '2', '5', '22');
INSERT INTO `xy_item` VALUES ('45', '0', '1578970029', '1578970029', null, null, null, '5', null, '5', '4', '1');
INSERT INTO `xy_item` VALUES ('46', '1', '1578970203', '1578970203', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('47', '1', '1578970228', '1578970228', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('48', '0', '1578970359', '1578970359', null, null, null, '5', null, '5', '2', '2');
INSERT INTO `xy_item` VALUES ('49', '1', '1578970435', '1578970435', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('50', '1', '1578970467', '1578970467', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('51', '0', '1578970636', '1578970636', null, null, null, '9', null, '9', '1', '1');
INSERT INTO `xy_item` VALUES ('52', '0', '1578970719', '1578970719', null, null, null, '9', null, '9', '1', '2');
INSERT INTO `xy_item` VALUES ('53', '0', '1578970834', '1578970834', null, null, null, '9', null, '9', '1', '3');
INSERT INTO `xy_item` VALUES ('54', '0', '1578970866', '1578970866', null, null, null, '9', null, '9', '1', '4');
INSERT INTO `xy_item` VALUES ('55', '0', '1578970896', '1578970896', null, null, null, '9', null, '9', '1', '5');
INSERT INTO `xy_item` VALUES ('56', '0', '1578970923', '1578970923', null, null, null, '9', null, '9', '1', '6');
INSERT INTO `xy_item` VALUES ('57', '0', '1578970953', '1578970953', null, null, null, '9', null, '9', '1', '7');
INSERT INTO `xy_item` VALUES ('58', '0', '1578971227', '1578971227', null, null, null, '9', null, '9', '1', '8');
INSERT INTO `xy_item` VALUES ('59', '1', '1578971277', '1578971277', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('60', '1', '1578971355', '1578971355', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('61', '0', '1578974094', '1578974094', null, null, null, '2', null, '2', '5', '21');
INSERT INTO `xy_item` VALUES ('62', '1', '1578975028', '1578975028', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('63', '1', '1578975574', '1578975574', null, null, null, '1', null, '1', '6', '3');
INSERT INTO `xy_item` VALUES ('64', '0', '1584672780', '1584672780', null, null, null, '1', null, '1', '1', '2');
INSERT INTO `xy_item` VALUES ('65', '0', '1584674529', '1584674529', null, null, null, '1', null, '1', '6', '1');
INSERT INTO `xy_item` VALUES ('66', '0', '1584683660', '1584683660', null, null, null, '2', null, '2', '5', '20');
INSERT INTO `xy_item` VALUES ('67', '1', '1584683696', '1584683696', null, null, null, '2', null, '2', '5', '20');
INSERT INTO `xy_item` VALUES ('68', '0', '1584683724', '1584683724', null, null, null, '2', null, '2', '5', '19');
INSERT INTO `xy_item` VALUES ('69', '0', '1584684086', '1584684086', null, null, null, '2', null, '2', '5', '18');
INSERT INTO `xy_item` VALUES ('70', '0', '1584684113', '1584684113', null, null, null, '2', null, '2', '5', '17');
INSERT INTO `xy_item` VALUES ('71', '1', '1584684138', '1584684138', null, null, null, '2', null, '2', '5', '17');
INSERT INTO `xy_item` VALUES ('72', '0', '1584684163', '1584684163', null, null, null, '2', null, '2', '5', '16');
INSERT INTO `xy_item` VALUES ('73', '0', '1584684186', '1584684186', null, null, null, '2', null, '2', '5', '15');
INSERT INTO `xy_item` VALUES ('74', '0', '1584684251', '1584684251', null, null, null, '2', null, '2', '5', '14');
INSERT INTO `xy_item` VALUES ('75', '0', '1584684280', '1584684280', null, null, null, '2', null, '2', '5', '13');
INSERT INTO `xy_item` VALUES ('76', '0', '1584684305', '1584684305', null, null, null, '2', null, '2', '5', '12');
INSERT INTO `xy_item` VALUES ('77', '0', '1584684329', '1584684329', null, null, null, '2', null, '2', '5', '11');
INSERT INTO `xy_item` VALUES ('78', '0', '1584684351', '1584684351', null, null, null, '2', null, '2', '5', '10');
INSERT INTO `xy_item` VALUES ('79', '0', '1584684384', '1584684384', null, null, null, '2', null, '2', '5', '9');
INSERT INTO `xy_item` VALUES ('80', '0', '1584684408', '1584684408', null, null, null, '2', null, '2', '5', '8');
INSERT INTO `xy_item` VALUES ('81', '0', '1584684451', '1584684451', null, null, null, '2', null, '2', '5', '7');
INSERT INTO `xy_item` VALUES ('82', '0', '1584684492', '1584684492', null, null, null, '2', null, '2', '5', '6');
INSERT INTO `xy_item` VALUES ('83', '0', '1584684519', '1584684519', null, null, null, '2', null, '2', '5', '5');
INSERT INTO `xy_item` VALUES ('84', '0', '1584684542', '1584684542', null, null, null, '2', null, '2', '5', '4');
INSERT INTO `xy_item` VALUES ('85', '0', '1584684567', '1584684567', null, null, null, '2', null, '2', '5', '3');
INSERT INTO `xy_item` VALUES ('86', '0', '1584688118', '1584688118', null, null, null, '3', null, '3', '1', '7');
INSERT INTO `xy_item` VALUES ('87', '0', '1584688196', '1584688196', null, null, null, '3', null, '3', '1', '1');
INSERT INTO `xy_item` VALUES ('88', '0', '1584688289', '1584688289', null, null, null, '3', null, '3', '1', '2');
INSERT INTO `xy_item` VALUES ('89', '0', '1584688358', '1584688358', null, null, null, '3', null, '3', '1', '3');
INSERT INTO `xy_item` VALUES ('90', '1', '1584688713', '1584688713', null, null, null, '3', null, '3', '1', '1');
INSERT INTO `xy_item` VALUES ('91', '0', '1584688840', '1584688840', null, null, null, '3', null, '3', '2', '4');
INSERT INTO `xy_item` VALUES ('92', '0', '1584688918', '1584688918', null, null, null, '3', null, '3', '1', '5');
INSERT INTO `xy_item` VALUES ('93', '0', '1584689144', '1584689144', null, null, null, '4', null, '4', '1', '1');
INSERT INTO `xy_item` VALUES ('94', '0', '1584689197', '1584689197', null, null, null, '4', null, '4', '1', '2');
INSERT INTO `xy_item` VALUES ('95', '0', '1584689319', '1584689319', null, null, null, '4', null, '4', '1', '3');
INSERT INTO `xy_item` VALUES ('96', '0', '1584689400', '1584689400', null, null, null, '4', null, '4', '1', '4');
INSERT INTO `xy_item` VALUES ('97', '0', '1584689468', '1584689468', null, null, null, '4', null, '4', '1', '5');
INSERT INTO `xy_item` VALUES ('98', '0', '1584689602', '1584689602', null, null, null, '7', null, '7', '3', '2');
INSERT INTO `xy_item` VALUES ('99', '0', '1584689611', '1584689611', null, null, null, '4', null, '4', '1', '6');
INSERT INTO `xy_item` VALUES ('100', '0', '1584689682', '1584689682', null, null, null, '7', null, '7', '3', '1');
INSERT INTO `xy_item` VALUES ('101', '0', '1584689699', '1584689699', null, null, null, '4', null, '4', '3', '7');
INSERT INTO `xy_item` VALUES ('102', '0', '1584689932', '1584689932', null, null, null, '8', null, '8', '3', '3');
INSERT INTO `xy_item` VALUES ('103', '0', '1584690154', '1584690154', null, null, null, '9', null, '9', '3', '9');
INSERT INTO `xy_item` VALUES ('104', '0', '1584690213', '1584690213', null, null, null, '9', null, '9', '3', '10');
INSERT INTO `xy_item` VALUES ('105', '0', '1584690565', '1584690565', null, null, null, '10', null, '10', '3', '1');
INSERT INTO `xy_item` VALUES ('106', '0', '1584690956', '1584690956', null, null, null, '6', null, '6', '3', '3');
INSERT INTO `xy_item` VALUES ('107', '0', '1584690981', '1584690981', null, null, null, '4', null, '4', '1', '8');
INSERT INTO `xy_item` VALUES ('108', '0', '1584691002', '1584691002', null, null, null, '6', null, '6', '3', '2');
INSERT INTO `xy_item` VALUES ('109', '0', '1584691042', '1584691042', null, null, null, '4', null, '4', '1', '9');
INSERT INTO `xy_item` VALUES ('110', '0', '1584691042', '1584691042', null, null, null, '6', null, '6', '3', '1');
INSERT INTO `xy_item` VALUES ('111', '1', '1584695133', '1584695133', null, null, null, '2', null, '2', '5', '3');
INSERT INTO `xy_item` VALUES ('112', '1', '1584695597', '1584695597', null, null, null, '2', null, '2', '5', '3');
INSERT INTO `xy_item` VALUES ('113', '0', '1584697404', '1584697404', null, null, null, '2', null, '2', '5', '2');
INSERT INTO `xy_item` VALUES ('114', '0', '1584697512', '1584697512', null, null, null, '2', null, '2', '5', '1');
INSERT INTO `xy_item` VALUES ('115', '1', '1584697529', '1584697529', null, null, null, '2', null, '2', '5', '1');
INSERT INTO `xy_item` VALUES ('116', '1', '1584712906', '1584712906', null, null, null, '2', null, '2', '5', '2');
INSERT INTO `xy_item` VALUES ('117', '1', '1585059525', '1585059525', null, null, null, '2', null, '2', '5', '3');
INSERT INTO `xy_item` VALUES ('118', '1', '1585059749', '1585059749', null, null, null, '3', null, '3', '3', '1');
INSERT INTO `xy_item` VALUES ('119', '1', '1585119545', '1585119545', null, null, null, '2', null, '2', '5', '3');
INSERT INTO `xy_item` VALUES ('120', '1', '1585119757', '1585119757', null, null, null, '3', null, '3', '3', '1');
INSERT INTO `xy_item` VALUES ('121', '1', '1585121504', '1585121504', null, null, null, '2', null, '2', '5', '1');
INSERT INTO `xy_item` VALUES ('122', '1', '1585182688', '1585182688', null, null, null, '2', null, '2', '5', '1');
INSERT INTO `xy_item` VALUES ('123', '1', '1585182818', '1585182818', null, null, null, '3', null, '3', '3', '1');
INSERT INTO `xy_item` VALUES ('124', '1', '1585183005', '1585183005', null, null, null, '2', null, '2', '5', '1');

-- ----------------------------
-- Table structure for xy_menu
-- ----------------------------
DROP TABLE IF EXISTS `xy_menu`;
CREATE TABLE `xy_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '0，正常；1，删除',
  `createtime` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(20) DEFAULT NULL COMMENT '修改时间',
  `maintitle` varchar(256) DEFAULT NULL COMMENT '首页标题',
  `type` int(11) DEFAULT NULL COMMENT '这个字段来表示是哪个类型的，如：老兵心语',
  `vid` int(11) DEFAULT NULL COMMENT '版本id',
  `uid` int(11) DEFAULT NULL COMMENT '创建者id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xy_menu
-- ----------------------------
INSERT INTO `xy_menu` VALUES ('1', '0', '1575292432', '1575292432', '概况', '1', '1', '1');
INSERT INTO `xy_menu` VALUES ('2', '0', '1575292432', '1575292432', '立功军人', '2', '1', '1');
INSERT INTO `xy_menu` VALUES ('3', '0', '1575292432', '1575292432', '优抚帮扶', '3', '1', '1');
INSERT INTO `xy_menu` VALUES ('4', '0', '1575292432', '1575292432', '关注老兵', '4', '1', '1');
INSERT INTO `xy_menu` VALUES ('5', '0', '1575292432', '1575292432', '老兵心语', '5', '1', '1');
INSERT INTO `xy_menu` VALUES ('6', '0', '1575292432', '1575292432', '政策文件', '6', '1', '1');
INSERT INTO `xy_menu` VALUES ('7', '0', '1575292432', '1575292432', '政治工作', '7', '1', '1');
INSERT INTO `xy_menu` VALUES ('8', '0', '1575292432', '1575292432', '军事训练', '8', '1', '1');
INSERT INTO `xy_menu` VALUES ('9', '0', '1575292432', '1575292432', '征兵工作', '9', '1', '1');
INSERT INTO `xy_menu` VALUES ('10', '0', '1575292432', '1575292432', '组织建设', '10', '1', '1');
INSERT INTO `xy_menu` VALUES ('11', '0', '1575292432', '1575292432', '备战工作', '11', '1', '1');
INSERT INTO `xy_menu` VALUES ('12', '0', '1575292432', '1575292432', '国防动员', '12', '1', '1');
INSERT INTO `xy_menu` VALUES ('14', '0', '1620800977083', '1620800977083', '政治要问', '2', '1', '1');
INSERT INTO `xy_menu` VALUES ('25', '0', '1620807595825', '1620807595825', 'string', '0', '0', '0');
INSERT INTO `xy_menu` VALUES ('26', '0', '1620807596034', '1620807596034', 'string', '0', '0', '0');
INSERT INTO `xy_menu` VALUES ('27', '0', '1620807596126', '1620807596126', 'string', '0', '0', '0');
INSERT INTO `xy_menu` VALUES ('28', '0', '1620807596305', '1620807596305', 'string', '0', '0', '0');
INSERT INTO `xy_menu` VALUES ('29', '0', '1620807596494', '1620808359567', '国家概要', '0', '0', '0');

-- ----------------------------
-- Table structure for xy_picture
-- ----------------------------
DROP TABLE IF EXISTS `xy_picture`;
CREATE TABLE `xy_picture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) DEFAULT '0',
  `createtime` bigint(20) DEFAULT NULL,
  `updatetime` bigint(20) DEFAULT NULL,
  `imgurl` varchar(512) DEFAULT NULL COMMENT '图片url',
  `simgurl` varchar(512) DEFAULT NULL COMMENT '小图url',
  `iid` int(11) DEFAULT NULL COMMENT 'item表的id',
  `type` int(11) DEFAULT NULL COMMENT '1，正文的图片；2，title的图片',
  `descript` varchar(2048) DEFAULT NULL COMMENT '这个里面放的是图片的描述信息。如老兵心语里面的文字',
  `name` varchar(512) DEFAULT NULL COMMENT '这个字段对应老兵心语的名字',
  `pictureleibie` int(11) DEFAULT NULL,
  `picturexuhao` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=428 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xy_picture
-- ----------------------------
INSERT INTO `xy_picture` VALUES ('1', '1', '1578621424', '1578621424', '/upload/xiaying/imgs/2020-01-10/1578621424435title.webp', '/upload/xiaying/imgs/2020-01-10/1578621424435title.webp', '1', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('2', '1', '1578621612', '1578621612', '/upload/xiaying/imgs/2020-01-10/1578621612727title.webp', '/upload/xiaying/imgs/2020-01-10/1578621612727title.webp', '2', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('3', '1', '1578621631', '1578621631', '/upload/xiaying/imgs/2020-01-10/1578621631431content_zip.webp', '/upload/xiaying/imgs/2020-01-10/1578621631431content_zip.webp', '2', '1', '123', '121', '2', '1');
INSERT INTO `xy_picture` VALUES ('4', '1', '1578621844', '1578621844', '/upload/xiaying/imgs/2020-01-10/1578621844087title.webp', '/upload/xiaying/imgs/2020-01-10/1578621844087title.webp', '3', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('5', '1', '1578621854', '1578621854', '/upload/xiaying/imgs/2020-01-10/1578621854726content_zip.webp', '/upload/xiaying/imgs/2020-01-10/1578621854726content_zip.webp', '2', '1', '12', '12', '2', '1');
INSERT INTO `xy_picture` VALUES ('6', '0', '1578621995', '1578621995', '/upload/xiaying/imgs/2020-01-10/1578621995224content_zip.webp', '/upload/xiaying/imgs/2020-01-10/1578621995224content_zip.webp', '3', '1', '122', '123', '2', '1');
INSERT INTO `xy_picture` VALUES ('7', '1', '1578622775', '1578622775', '/upload/xiaying/imgs/2020-01-10/1578629423048zbingz_muce_b_3.webp', '/upload/xiaying/imgs/2020-01-10/1578629423048zbingz_muce_b_3.webp', '4', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('8', '1', '1578625547', '1578625547', '/upload/xiaying/imgs/2020-01-10/1578625547641zbingz_title_muce.webp', '/upload/xiaying/imgs/2020-01-10/1578625547641zbingz_title_muce.webp', '5', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('9', '1', '1578630114', '1578630114', '/upload/xiaying/imgs/2020-01-10/1578630114297zbingz_muce_2.webp', '/upload/xiaying/imgs/2020-01-10/1578630114297zbingz_muce_2.webp', '4', '1', '33', '33', '2', '2');
INSERT INTO `xy_picture` VALUES ('10', '1', '1578632955', '1578632955', '/upload/xiaying/imgs/2020-01-10/1578632955664zbingz_muce_b_3.webp', '/upload/xiaying/imgs/2020-01-10/1578632955664zbingz_muce_b_3.webp', '4', '1', '34', '34', '2', '4');
INSERT INTO `xy_picture` VALUES ('11', '1', '1578633176', '1578633176', '/upload/xiaying/imgs/2020-01-10/1578633176116zbingz_muce_1.webp', '/upload/xiaying/imgs/2020-01-10/1578633176116zbingz_muce_1.webp', '4', '1', '66', '66', '2', '1');
INSERT INTO `xy_picture` VALUES ('12', '1', '1578634170', '1578634170', '/upload/xiaying/imgs/2020-01-10/1578634170939zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-10/1578634170939zbingz_title_fujian.webp', '6', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('13', '1', '1578634183', '1578634183', '/upload/xiaying/imgs/2020-01-10/1578637048468zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-10/1578637048468zbingz_title_fujian.webp', '6', '1', '33', '', '2', '4');
INSERT INTO `xy_picture` VALUES ('14', '1', '1578634212', '1578634212', '/upload/xiaying/imgs/2020-01-10/1578634212423zbingz_fujian_b_2.webp', '/upload/xiaying/imgs/2020-01-10/1578634212423zbingz_fujian_b_2.webp', '6', '1', '111', '', '2', '1');
INSERT INTO `xy_picture` VALUES ('15', '1', '1578634272', '1578634272', '/upload/xiaying/imgs/2020-01-10/1578634272410zbingz_fujian_1.webp', '/upload/xiaying/imgs/2020-01-10/1578634272410zbingz_fujian_1.webp', '6', '1', '22', '', '2', '4');
INSERT INTO `xy_picture` VALUES ('16', '1', '1578637282', '1578637282', '/upload/xiaying/imgs/2020-01-10/1578637282269zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-10/1578637282269zbingz_title_fujian.webp', '7', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('17', '1', '1578639623', '1578639623', '/upload/xiaying/imgs/2020-01-10/1578639623786zbingz_fujian_2.webp', '/upload/xiaying/imgs/2020-01-10/1578639623786zbingz_fujian_2.webp', '4', '1', '555', '', '2', '3');
INSERT INTO `xy_picture` VALUES ('18', '1', '1578639711', '1578639711', '/upload/xiaying/imgs/2020-01-10/1578639711465zbingz_fujian_3.webp', '/upload/xiaying/imgs/2020-01-10/1578639711465zbingz_fujian_3.webp', '6', '1', '22', '', '2', '4');
INSERT INTO `xy_picture` VALUES ('19', '1', '1578639740', '1578639740', '/upload/xiaying/imgs/2020-01-10/1578639740193zbingz_fujian_b_2.webp', '/upload/xiaying/imgs/2020-01-10/1578639740193zbingz_fujian_b_2.webp', '6', '1', '33', '', '2', '3');
INSERT INTO `xy_picture` VALUES ('20', '1', '1578645499', '1578645499', '/upload/xiaying/imgs/2020-01-10/1578645499612zbingz_fujian_3.webp', '/upload/xiaying/imgs/2020-01-10/1578645499612zbingz_fujian_3.webp', '4', '1', '111', '111', '2', '2');
INSERT INTO `xy_picture` VALUES ('21', '1', '1578645521', '1578645521', '/upload/xiaying/imgs/2020-01-10/1578645521885zbingz_fujian_3.webp', '/upload/xiaying/imgs/2020-01-10/1578645521885zbingz_fujian_3.webp', '4', '1', '222', '', '2', '1');
INSERT INTO `xy_picture` VALUES ('22', '1', '1578645534', '1578645534', '/upload/xiaying/imgs/2020-01-10/1578645534078zbingz_fujian_b_3.webp', '/upload/xiaying/imgs/2020-01-10/1578645534078zbingz_fujian_b_3.webp', '4', '1', '333', '', '2', '2');
INSERT INTO `xy_picture` VALUES ('23', '0', '1578647197', '1578647197', '/upload/xiaying/imgs/2020-01-10/1578647197344zbingz_fujian_2.webp', '/upload/xiaying/imgs/2020-01-10/1578647197344zbingz_fujian_2.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('24', '0', '1578647243', '1578647243', '/upload/xiaying/imgs/2020-01-10/1578647243955zbingz_fujian_b_2.webp', '/upload/xiaying/imgs/2020-01-10/1578647243955zbingz_fujian_b_2.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('25', '1', '1578883039', '1578883039', '/upload/xiaying/imgs/2020-01-13/1578883039048zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-13/1578883039048zbingz_title_fujian.webp', '8', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('26', '1', '1578887114', '1578887114', '/upload/xiaying/imgs/2020-01-13/1578887114963zbingz_fujian_3.webp', '/upload/xiaying/imgs/2020-01-13/1578887114963zbingz_fujian_3.webp', '7', '1', '这是左图右文的', '', '1', '2');
INSERT INTO `xy_picture` VALUES ('27', '0', '1578887159', '1578887159', '/upload/xiaying/imgs/2020-01-13/1578887159966zbingz_fujian_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578887159966zbingz_fujian_b_2.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('28', '1', '1578887183', '1578887183', '/upload/xiaying/imgs/2020-01-13/1578887183061zbingz_fujian_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578887183061zbingz_fujian_b_2.webp', '7', '1', '2222222222222222222222222222222222', '', '1', '1');
INSERT INTO `xy_picture` VALUES ('29', '1', '1578889119', '1578889119', '/upload/xiaying/imgs/2020-01-13/1578889119881zbingz_fujian_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578889119881zbingz_fujian_b_3.webp', '8', '1', '', null, '1', '1');
INSERT INTO `xy_picture` VALUES ('30', '1', '1578893040', '1578893040', '/upload/xiaying/imgs/2020-01-13/1578893040133zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-13/1578893040133zbingz_title_fujian.webp', '9', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('31', '1', '1578893048', '1578893048', '/upload/xiaying/imgs/2020-01-13/1578893048663zbingz_fujian_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578893048663zbingz_fujian_b_3.webp', '9', '1', '21233333', '', null, '2');
INSERT INTO `xy_picture` VALUES ('32', '1', '1578893068', '1578893068', '/upload/xiaying/imgs/2020-01-13/1578893068417zbingz_fujian_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578893068417zbingz_fujian_b_3.webp', '9', '1', '45555555555', '', null, '1');
INSERT INTO `xy_picture` VALUES ('33', '1', '1578893115', '1578893115', '/upload/xiaying/imgs/2020-01-13/1578893115969zbingz_title_chujian.webp', '/upload/xiaying/imgs/2020-01-13/1578893115969zbingz_title_chujian.webp', '10', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('34', '1', '1578893135', '1578893135', '/upload/xiaying/imgs/2020-01-13/1578893135383zbingz_chujian_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578893135383zbingz_chujian_b_3.webp', '10', '1', '222222222222222222222222222222222222', '', null, '2');
INSERT INTO `xy_picture` VALUES ('35', '1', '1578893147', '1578893147', '/upload/xiaying/imgs/2020-01-13/1578893147639zbingz_chujian_b_1.webp', '/upload/xiaying/imgs/2020-01-13/1578893147639zbingz_chujian_b_1.webp', '10', '1', 'ttttttttttttttttttttttttttttttt', '', null, '1');
INSERT INTO `xy_picture` VALUES ('36', '1', '1578893165', '1578893165', '/upload/xiaying/imgs/2020-01-13/1578893165934zbingz_title_sb.webp', '/upload/xiaying/imgs/2020-01-13/1578893165934zbingz_title_sb.webp', '11', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('37', '1', '1578893174', '1578893174', '/upload/xiaying/imgs/2020-01-13/1578893174054zbingz_sb_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578893174054zbingz_sb_b_3.webp', '11', '1', '343434344', '', null, '1');
INSERT INTO `xy_picture` VALUES ('38', '1', '1578893491', '1578893491', '/upload/xiaying/imgs/2020-01-13/1578893491642zbingz_title_sb.webp', '/upload/xiaying/imgs/2020-01-13/1578893491642zbingz_title_sb.webp', '12', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('39', '1', '1578893739', '1578893739', '/upload/xiaying/imgs/2020-01-13/1578893739031zbingz_title_sb.webp', '/upload/xiaying/imgs/2020-01-13/1578893739031zbingz_title_sb.webp', '13', '2', '<p>eeeeeee</p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('40', '1', '1578894254', '1578894254', '/upload/xiaying/imgs/2020-01-13/1578894254222zbingz_title_sb.webp', '/upload/xiaying/imgs/2020-01-13/1578894254222zbingz_title_sb.webp', '14', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('41', '1', '1578895146', '1578895146', '/upload/xiaying/imgs/2020-01-13/1578895146895zbingz_title_sb.webp', '/upload/xiaying/imgs/2020-01-13/1578895146895zbingz_title_sb.webp', '15', '2', '<p>2222222444</p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('42', '1', '1578897261', '1578897261', '/upload/xiaying/imgs/2020-01-13/1578897261399zbingz_sb_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578897261399zbingz_sb_b_3.webp', '18', '2', '1997.092.23', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('43', '1', '1578897361', '1578897361', '/upload/xiaying/imgs/2020-01-13/1578897719221ligongjunren1.webp', '/upload/xiaying/imgs/2020-01-13/1578897719221ligongjunren1.webp', '19', '2', '1111111111', '张铁泉', '1', '0');
INSERT INTO `xy_picture` VALUES ('44', '1', '1578897396', '1578897396', '/upload/xiaying/imgs/2020-01-13/1578897709038ligongjunren1.webp', '/upload/xiaying/imgs/2020-01-13/1578897709038ligongjunren1.webp', '20', '2', '1111111111111111111111', '王瑞康', '1', '0');
INSERT INTO `xy_picture` VALUES ('45', '1', '1578897422', '1578897422', '/upload/xiaying/imgs/2020-01-13/1578897693546ligongjunren1.webp', '/upload/xiaying/imgs/2020-01-13/1578897693546ligongjunren1.webp', '21', '2', '22', '张红跟', '1', '0');
INSERT INTO `xy_picture` VALUES ('46', '1', '1578897451', '1578897451', '/upload/xiaying/imgs/2020-01-13/1578897451919zbingz_sb_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578897451919zbingz_sb_b_3.webp', '21', '1', '', '', null, '1');
INSERT INTO `xy_picture` VALUES ('47', '1', '1578897504', '1578897504', '/upload/xiaying/imgs/2020-01-13/1578897595348yfbf_title_4.webp', '/upload/xiaying/imgs/2020-01-13/1578897595348yfbf_title_4.webp', '22', '2', '李四', '', '1', '0');
INSERT INTO `xy_picture` VALUES ('48', '1', '1578897534', '1578897534', '/upload/xiaying/imgs/2020-01-13/1578897534008gk_4.webp', '/upload/xiaying/imgs/2020-01-13/1578897534008gk_4.webp', '22', '1', '', '', null, '2');
INSERT INTO `xy_picture` VALUES ('49', '1', '1578897552', '1578897552', '/upload/xiaying/imgs/2020-01-13/1578897552635gk_wz_laifang_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578897552635gk_wz_laifang_b_2.webp', '22', '1', '333', '', null, '1');
INSERT INTO `xy_picture` VALUES ('50', '0', '1578897572', '1578897572', '/upload/xiaying/imgs/2020-01-13/1578897572032yfbf_zoufang_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578897572032yfbf_zoufang_b_2.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('51', '1', '1578897587', '1578897587', '/upload/xiaying/imgs/2020-01-13/1578897587101gk_wz_title.webp', '/upload/xiaying/imgs/2020-01-13/1578897587101gk_wz_title.webp', '23', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('52', '1', '1578897604', '1578897604', '/upload/xiaying/imgs/2020-01-13/1578897604309yfbf_b_11.webp', '/upload/xiaying/imgs/2020-01-13/1578897604309yfbf_b_11.webp', '23', '1', '3333333', '', null, '1');
INSERT INTO `xy_picture` VALUES ('53', '1', '1578897796', '1578897796', '/upload/xiaying/imgs/2020-01-13/1578897796042lbxy_title_1.webp', '/upload/xiaying/imgs/2020-01-13/1578897796042lbxy_title_1.webp', '24', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('54', '1', '1578897805', '1578897805', '/upload/xiaying/imgs/2020-01-13/1578897805253lbxy_b_7.webp', '/upload/xiaying/imgs/2020-01-13/1578897805253lbxy_b_7.webp', '24', '1', '2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222', '', null, '1');
INSERT INTO `xy_picture` VALUES ('55', '1', '1578897828', '1578897828', '/upload/xiaying/imgs/2020-01-13/1578897828848lbxy_title_1.webp', '/upload/xiaying/imgs/2020-01-13/1578897828848lbxy_title_1.webp', '25', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('56', '1', '1578897840', '1578897840', '/upload/xiaying/imgs/2020-01-13/1578897840072lbxy_b_1.webp', '/upload/xiaying/imgs/2020-01-13/1578897840072lbxy_b_1.webp', '25', '1', '666666666666666666666666666666666666666666666666666', '', null, '1');
INSERT INTO `xy_picture` VALUES ('57', '0', '1578897900', '1578897900', '/upload/xiaying/imgs/2020-03-20/1584690917756zcwj_title_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690917756zcwj_title_1 拷贝.webp', '26', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('58', '0', '1578897920', '1578897920', '/upload/xiaying/imgs/2020-01-13/1578897920744zbingz_yqsl_3.webp', '/upload/xiaying/imgs/2020-01-13/1578897920744zbingz_yqsl_3.webp', '26', '1', '', '', null, '2');
INSERT INTO `xy_picture` VALUES ('59', '0', '1578897932', '1578897932', '/upload/xiaying/imgs/2020-03-20/1584690928227zcwj_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690928227zcwj_b_1 拷贝.webp', '26', '1', '', '', null, '1');
INSERT INTO `xy_picture` VALUES ('60', '1', '1578900294', '1578900294', '/upload/xiaying/imgs/2020-01-13/1578900294315zbingz_yqsl_b_1.webp', '/upload/xiaying/imgs/2020-01-13/1578900294315zbingz_yqsl_b_1.webp', '27', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('61', '1', '1578900320', '1578900320', '/upload/xiaying/imgs/2020-01-13/1578900320359zbingz_yqsl_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578900320359zbingz_yqsl_b_2.webp', '27', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('62', '1', '1578900329', '1578900329', '/upload/xiaying/imgs/2020-01-13/1578900329728zbingz_yqsl_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578900329728zbingz_yqsl_b_3.webp', '27', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('63', '1', '1578900350', '1578900350', '/upload/xiaying/imgs/2020-01-13/1578900350809zbingz_title_xbjf.webp', '/upload/xiaying/imgs/2020-01-13/1578900350809zbingz_title_xbjf.webp', '28', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('64', '1', '1578900359', '1578900359', '/upload/xiaying/imgs/2020-01-13/1578900358999zbingz_xbjf_b_1.webp', '/upload/xiaying/imgs/2020-01-13/1578900358999zbingz_xbjf_b_1.webp', '28', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('65', '1', '1578900368', '1578900368', '/upload/xiaying/imgs/2020-01-13/1578900368328zbingz_xbjf_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578900368328zbingz_xbjf_b_2.webp', '28', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('66', '1', '1578900377', '1578900377', '/upload/xiaying/imgs/2020-01-13/1578900377015zbingz_xbjf_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578900377015zbingz_xbjf_b_3.webp', '28', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('67', '0', '1578900416', '1578900416', '/upload/xiaying/imgs/2020-03-20/1584689876179jsxl_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689876179jsxl_title_2 拷贝.webp', '29', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('68', '0', '1578900423', '1578900423', '/upload/xiaying/imgs/2020-03-20/1584690027910jsxl_b_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690027910jsxl_b_6 拷贝.webp', '29', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('69', '0', '1578900434', '1578900434', '/upload/xiaying/imgs/2020-03-20/1584690009542jsxl_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690009542jsxl_b_5 拷贝.webp', '29', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('70', '0', '1578900444', '1578900444', '/upload/xiaying/imgs/2020-03-20/1584689985988jsxl_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689985988jsxl_b_4 拷贝.webp', '29', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('71', '0', '1578900467', '1578900467', '/upload/xiaying/imgs/2020-03-20/1584694852442lgjr_p_12.webp', '/upload/xiaying/imgs/2020-03-20/1584694852442lgjr_p_12.webp', '30', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('72', '0', '1578900474', '1578900474', '/upload/xiaying/imgs/2020-03-20/1584689249361jsxl_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689249361jsxl_b_2 拷贝.webp', '30', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('73', '0', '1578900506', '1578900506', '/upload/xiaying/imgs/2020-01-13/1578900506197zbingz_xbhs_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578900506197zbingz_xbhs_b_3.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('74', '1', '1578900519', '1578900519', '/upload/xiaying/imgs/2020-03-20/1584689036123jsxl_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689036123jsxl_1 拷贝.webp', '30', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('75', '1', '1578900563', '1578900563', '/upload/xiaying/imgs/2020-01-13/1578900563174zbingz_title_xbhs.webp', '/upload/xiaying/imgs/2020-01-13/1578900563174zbingz_title_xbhs.webp', '31', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('76', '1', '1578900571', '1578900571', '/upload/xiaying/imgs/2020-01-13/1578900571328zbingz_xbhs_b_1.webp', '/upload/xiaying/imgs/2020-01-13/1578900571328zbingz_xbhs_b_1.webp', '31', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('77', '1', '1578900581', '1578900581', '/upload/xiaying/imgs/2020-01-13/1578900581898zbingz_xbhs_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578900581898zbingz_xbhs_b_3.webp', '31', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('78', '1', '1578900599', '1578900599', '/upload/xiaying/imgs/2020-01-13/1578900599942zbingz_title_xbjf.webp', '/upload/xiaying/imgs/2020-01-13/1578900599942zbingz_title_xbjf.webp', '32', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('79', '1', '1578900608', '1578900608', '/upload/xiaying/imgs/2020-01-13/1578900608724zbingz_xbjf_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578900608724zbingz_xbjf_b_2.webp', '32', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('80', '1', '1578900619', '1578900619', '/upload/xiaying/imgs/2020-01-13/1578900619585zbingz_xbjf_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578900619585zbingz_xbjf_b_3.webp', '32', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('81', '0', '1578900653', '1578900653', '/upload/xiaying/imgs/2020-01-13/1578900653995title.webp', '/upload/xiaying/imgs/2020-01-13/1578900653995title.webp', '33', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('82', '0', '1578900660', '1578900660', '/upload/xiaying/imgs/2020-01-13/1578900660565content_zip.webp', '/upload/xiaying/imgs/2020-01-13/1578900660565content_zip.webp', '33', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('83', '1', '1578901323', '1578901323', '/upload/xiaying/imgs/2020-01-13/1578901323268zbingz_yqsl_b_2.webp', '/upload/xiaying/imgs/2020-01-13/1578901323268zbingz_yqsl_b_2.webp', '32', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('84', '1', '1578901333', '1578901333', '/upload/xiaying/imgs/2020-01-13/1578901333582zbingz_yqsl_b_3.webp', '/upload/xiaying/imgs/2020-01-13/1578901333582zbingz_yqsl_b_3.webp', '32', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('85', '1', '1578901419', '1578901419', '/upload/xiaying/imgs/2020-01-13/1578901419870zbingz_title_yqsl.webp', '/upload/xiaying/imgs/2020-01-13/1578901419870zbingz_title_yqsl.webp', '34', '2', '<p>333333333333333333333333333333333333333333333333</p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('86', '1', '1578968578', '1578968578', '/upload/xiaying/imgs/2020-01-14/1578968578579lgjr_p_1.webp', '/upload/xiaying/imgs/2020-01-14/1578968578579lgjr_p_1.webp', '35', '2', '1987年1月出生，现居下应街道中海国际社区，于2003年入伍，2017年退伍，期间荣获二等功1次、三等功1次。', '张铁泉', '1', '0');
INSERT INTO `xy_picture` VALUES ('87', '1', '1578968881', '1578968881', '/upload/xiaying/imgs/2020-01-14/1578968881267jrxq_x1_1.webp', '/upload/xiaying/imgs/2020-01-14/1578968881267jrxq_x1_1.webp', '35', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('88', '1', '1578968897', '1578968897', '/upload/xiaying/imgs/2020-01-14/1578968897771jrxq_x1_3.webp', '/upload/xiaying/imgs/2020-01-14/1578968897771jrxq_x1_3.webp', '35', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('89', '1', '1578968905', '1578968905', '/upload/xiaying/imgs/2020-01-14/1578968905484jrxq_x1_4.webp', '/upload/xiaying/imgs/2020-01-14/1578968905484jrxq_x1_4.webp', '35', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('90', '1', '1578968912', '1578968912', '/upload/xiaying/imgs/2020-01-14/1578968912958jrxq_x1_5.webp', '/upload/xiaying/imgs/2020-01-14/1578968912958jrxq_x1_5.webp', '35', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('91', '1', '1578968918', '1578968918', '/upload/xiaying/imgs/2020-01-14/1578968918391jrxq_x1_6.webp', '/upload/xiaying/imgs/2020-01-14/1578968918391jrxq_x1_6.webp', '35', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('92', '0', '1578968964', '1578968964', '/upload/xiaying/imgs/2020-01-14/1578968964512lgjr_p_2.webp', '/upload/xiaying/imgs/2020-01-14/1578968964512lgjr_p_2.webp', '36', '2', '1980年5月出生，现居下应街道东兴社区社区，于1998年入伍，2015年退伍，期间荣获二等功1次、三等功1次。', '廖蒲云', '1', '0');
INSERT INTO `xy_picture` VALUES ('93', '0', '1578969028', '1578969028', '/upload/xiaying/imgs/2020-01-14/1578969028765jrxq_x2_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969028765jrxq_x2_1.webp', '36', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('94', '0', '1578969035', '1578969035', '/upload/xiaying/imgs/2020-01-14/1578969035218jrxq_x2_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969035218jrxq_x2_2.webp', '36', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('95', '0', '1578969226', '1578969226', '/upload/xiaying/imgs/2020-01-14/1578969226819lgjr_p_3.webp', '/upload/xiaying/imgs/2020-01-14/1578969226819lgjr_p_3.webp', '37', '2', '1938年10月出生，现居下应街道河东村，于1959年入伍，1964年退伍，期间荣获三等功1次。', '王瑞康', '1', '0');
INSERT INTO `xy_picture` VALUES ('96', '0', '1578969253', '1578969253', '/upload/xiaying/imgs/2020-01-14/1578969253006jrxq_x3_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969253006jrxq_x3_1.webp', '37', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('97', '0', '1578969259', '1578969259', '/upload/xiaying/imgs/2020-01-14/1578969259779jrxq_x3_3.webp', '/upload/xiaying/imgs/2020-01-14/1578969259779jrxq_x3_3.webp', '37', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('98', '0', '1578969312', '1578969312', '/upload/xiaying/imgs/2020-01-14/1578969312391lgjr_p_4.webp', '/upload/xiaying/imgs/2020-01-14/1578969312391lgjr_p_4.webp', '38', '2', '1966年4月出生，现居下应街道天宫社区，于1984年入伍，1993年退伍，期间荣获三等功1次。', '张洪根', '1', '0');
INSERT INTO `xy_picture` VALUES ('99', '0', '1578969333', '1578969333', '/upload/xiaying/imgs/2020-01-14/1578969333226jrxq_x4_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969333226jrxq_x4_1.webp', '38', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('100', '0', '1578969340', '1578969340', '/upload/xiaying/imgs/2020-01-14/1578969340245jrxq_x4_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969340245jrxq_x4_2.webp', '38', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('101', '0', '1578969345', '1578969345', '/upload/xiaying/imgs/2020-01-14/1578969345972jrxq_x4_3.webp', '/upload/xiaying/imgs/2020-01-14/1578969345972jrxq_x4_3.webp', '38', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('102', '0', '1578969374', '1578969374', '/upload/xiaying/imgs/2020-01-14/1578969374833lgjr_p_5.webp', '/upload/xiaying/imgs/2020-01-14/1578969374833lgjr_p_5.webp', '39', '2', '1965年6月出生，现居下应街道天宫社区，于1983年入伍，2004年退伍，期间荣获三等功1次。', '吴炫德', '1', '0');
INSERT INTO `xy_picture` VALUES ('103', '0', '1578969404', '1578969404', '/upload/xiaying/imgs/2020-01-14/1578969404538jrxq_x5_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969404538jrxq_x5_1.webp', '39', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('104', '0', '1578969410', '1578969410', '/upload/xiaying/imgs/2020-01-14/1578969410724jrxq_x5_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969410724jrxq_x5_2.webp', '39', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('105', '0', '1578969415', '1578969415', '/upload/xiaying/imgs/2020-01-14/1578969415705jrxq_x5_3.webp', '/upload/xiaying/imgs/2020-01-14/1578969415705jrxq_x5_3.webp', '39', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('106', '0', '1578969420', '1578969420', '/upload/xiaying/imgs/2020-01-14/1578969420468jrxq_x5_4.webp', '/upload/xiaying/imgs/2020-01-14/1578969420468jrxq_x5_4.webp', '39', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('107', '0', '1578969451', '1578969451', '/upload/xiaying/imgs/2020-01-14/1578969451998lgjr_p_6.webp', '/upload/xiaying/imgs/2020-01-14/1578969451998lgjr_p_6.webp', '40', '2', '1983年12月出生，现居下应街道天宫社区，于2001年入伍，2014年退伍，期间荣获三等功1次。', '冯殿波', '1', '0');
INSERT INTO `xy_picture` VALUES ('108', '0', '1578969472', '1578969472', '/upload/xiaying/imgs/2020-01-14/1578969472466jrxq_x6_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969472466jrxq_x6_1.webp', '40', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('109', '0', '1578969478', '1578969478', '/upload/xiaying/imgs/2020-01-14/1578969478964jrxq_x6_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969478964jrxq_x6_2.webp', '40', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('110', '0', '1578969484', '1578969484', '/upload/xiaying/imgs/2020-01-14/1578969484152jrxq_x6_4.webp', '/upload/xiaying/imgs/2020-01-14/1578969484152jrxq_x6_4.webp', '40', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('111', '0', '1578969507', '1578969507', '/upload/xiaying/imgs/2020-01-14/1578969507764lgjr_p_7.webp', '/upload/xiaying/imgs/2020-01-14/1578969507764lgjr_p_7.webp', '41', '2', '1968年9月出生，现居下应街道海创社区，于1987年入伍，2000年退伍，期间荣获三等功1次。', '秦真勇', '1', '0');
INSERT INTO `xy_picture` VALUES ('112', '0', '1578969529', '1578969529', '/upload/xiaying/imgs/2020-01-14/1578969529500jrxq_x7_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969529500jrxq_x7_1.webp', '41', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('113', '0', '1578969535', '1578969535', '/upload/xiaying/imgs/2020-01-14/1578969535618jrxq_x7_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969535618jrxq_x7_2.webp', '41', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('114', '0', '1578969540', '1578969540', '/upload/xiaying/imgs/2020-01-14/1578969540557jrxq_x7_3.webp', '/upload/xiaying/imgs/2020-01-14/1578969540557jrxq_x7_3.webp', '41', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('115', '0', '1578969561', '1578969561', '/upload/xiaying/imgs/2020-01-14/1578969561404lgjr_p_8.webp', '/upload/xiaying/imgs/2020-01-14/1578969561404lgjr_p_8.webp', '42', '2', '1955年9月出生，现居下应街道天宫社区，于1973年入伍，1986年退伍，期间荣获三等功1次。', '张芳敏', '1', '0');
INSERT INTO `xy_picture` VALUES ('116', '0', '1578969591', '1578969591', '/upload/xiaying/imgs/2020-01-14/1578969591037jrxq_x8_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969591037jrxq_x8_1.webp', '42', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('117', '0', '1578969612', '1578969612', '/upload/xiaying/imgs/2020-01-14/1578969612048lgjr_p_9.webp', '/upload/xiaying/imgs/2020-01-14/1578969612048lgjr_p_9.webp', '43', '2', '1971年1月出生，现居下应街道海创社区，于1989年入伍，2015年退伍，期间荣获三等功1次。', '黄志民', '1', '0');
INSERT INTO `xy_picture` VALUES ('118', '0', '1578969635', '1578969635', '/upload/xiaying/imgs/2020-01-14/1578969635114jrxq_x9_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969635114jrxq_x9_1.webp', '43', '1', '', null, null, '7');
INSERT INTO `xy_picture` VALUES ('119', '0', '1578969640', '1578969640', '/upload/xiaying/imgs/2020-01-14/1578969640037jrxq_x9_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969640037jrxq_x9_2.webp', '43', '1', '', null, null, '6');
INSERT INTO `xy_picture` VALUES ('120', '0', '1578969644', '1578969644', '/upload/xiaying/imgs/2020-01-14/1578969644993jrxq_x9_3.webp', '/upload/xiaying/imgs/2020-01-14/1578969644993jrxq_x9_3.webp', '43', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('121', '0', '1578969649', '1578969649', '/upload/xiaying/imgs/2020-01-14/1578969649864jrxq_x9_4.webp', '/upload/xiaying/imgs/2020-01-14/1578969649864jrxq_x9_4.webp', '43', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('122', '0', '1578969654', '1578969654', '/upload/xiaying/imgs/2020-01-14/1578969654355jrxq_x9_5.webp', '/upload/xiaying/imgs/2020-01-14/1578969654355jrxq_x9_5.webp', '43', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('123', '0', '1578969659', '1578969659', '/upload/xiaying/imgs/2020-01-14/1578969659129jrxq_x9_6.webp', '/upload/xiaying/imgs/2020-01-14/1578969659129jrxq_x9_6.webp', '43', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('124', '0', '1578969663', '1578969663', '/upload/xiaying/imgs/2020-01-14/1578969663715jrxq_x9_7.webp', '/upload/xiaying/imgs/2020-01-14/1578969663715jrxq_x9_7.webp', '43', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('125', '0', '1578969688', '1578969688', '/upload/xiaying/imgs/2020-01-14/1578969688352lgjr_p_10.webp', '/upload/xiaying/imgs/2020-01-14/1578969688352lgjr_p_10.webp', '44', '2', '1979年12月出生，现居下应街道海创社区，于1998年入伍，2016年退伍，期间荣获三等功1次。', '徐永平', '1', '0');
INSERT INTO `xy_picture` VALUES ('126', '0', '1578969706', '1578969706', '/upload/xiaying/imgs/2020-01-14/1578969706534jrxq_x10_1.webp', '/upload/xiaying/imgs/2020-01-14/1578969706534jrxq_x10_1.webp', '44', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('127', '0', '1578969711', '1578969711', '/upload/xiaying/imgs/2020-01-14/1578969711162jrxq_x10_2.webp', '/upload/xiaying/imgs/2020-01-14/1578969711162jrxq_x10_2.webp', '44', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('128', '0', '1578970025', '1578970025', '/upload/xiaying/imgs/2020-03-20/1584671482583lbxy_title_1.webp', '/upload/xiaying/imgs/2020-03-20/1584671482583lbxy_title_1.webp', '45', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('129', '0', '1578970039', '1578970039', '/upload/xiaying/imgs/2020-03-20/1584671406472lbxy_b_1.webp', '/upload/xiaying/imgs/2020-03-20/1584671406472lbxy_b_1.webp', '45', '1', '  曾经当过兵，不是一段飘渺的梦幻，因为，那是一生难忘的体验，那是一种生命深处的眷恋。曾经当过兵就是一种生命的机缘，曾经当过兵，就是一种永远的怀恋。是的，光阴如箭，是的，日月如梭的青年，记得在部队那种团结坚如刚，军令如山倒的战斗集体里，尘封往事，渐次揭开，相同的经历，似曾相似。我想把时间回到公元一九七六年二月二十日那天，我穿上了崭新的65式军装，从湖西河（现为月湖）宁波市新老兵中转站出发，步行至宁波轮船码头，乘坐“ 工农兵3号 ”轮船去上海十六铺码头，后来再乘部队的军车到上海市南汇县东海农场上海警备区警备团新兵集训基地。开始感觉到了部队这所大学校是如此的温暖，团结紧张、严肃、活泼的战斗作风，那种 军人的符号已注入进我的灵魂，军人的情节已融入进我的血液，经过血与火的洗礼，锻造了我的青春，生与死的考验，铸就了我的芳华，这就是属于我的芳华。', null, null, '1');
INSERT INTO `xy_picture` VALUES ('130', '0', '1578970060', '1578970060', '/upload/xiaying/imgs/2020-01-14/1578970060229lbxy_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970060229lbxy_b_3.webp', '45', '1', '芳华正茂的年轻军人，当祖国需要的时候，他们都义无反顾地奔赴前线，1978年底中越关系紧张，部队接到军区的调兵命令，就快速进行宣传教育，其中我也积极响应，报名参战并写了血书，“坚决要求上前线，把自己的一切交给党和人民，直至生命。”虽然是一滴血书，实际上我是向党和人民作保证，用自己的实际行动保卫我国边境和平安宁。最后领导批准了我的请求，同意我去前线参战，当时的要求也比较高的，要求精通军事技术，政治上要求是党员骨干优先。 1979年2月初的上午军列从上海真如车站，出发开往昆明的列车开动了。我们坐的是闷罐的运货列车，我们很开心，因为出发前团里专门为我们开欢送大会，还放了电影，一路上每到一次兵站吃饭时，我看到很多群众自发地为我们送行，他们手里拿着鸡蛋、水果等东西为我们送行，真的感觉很激动，经过三天三夜的长途奔波，终于到达了云南昆明车站。下车后我们马上转乘了昆明当地的小火车直奔云南开远市蒙自县，后来到河口下车，火车靠近边境时，一下子战争的气氛变浓了。 到了前线后，我们一起来的同志分别按照各自的档案材料分配到各个前线连队，我们要克服心理上的恐惧和压力，气氛紧张是可以想象的。我们分配到连队后，经历了从不认识到认识的过程，但很快就马上互相配合了，因为我们知道这里是生与死的考验的兄弟了。', null, null, '2');
INSERT INTO `xy_picture` VALUES ('131', '0', '1578970074', '1578970074', '/upload/xiaying/imgs/2020-01-14/1578970074880lbxy_b_5.webp', '/upload/xiaying/imgs/2020-01-14/1578970074880lbxy_b_5.webp', '45', '1', '吃了午饭后，部队接到命令要急行军穿插包围越军的任务，我们走了半天一夜的路程，走的都是小路山路，随时都有越军放下的地雷、暗堡的射击。我们红军团的每一位战士都很勇敢，晚上睡在猫儿洞里，自己挖的，有时还要轮到站岗一小时，记得当天晚上我军的各种火箭炮等武器万炮齐轰，大地在颤抖，一眼看去，越军方向的天被染红了，我的眼里留下了激动的泪水。 战斗打响后，前方送下来的大批烈士和伤员，快速向野战医院送去，这的确是一场残酷和激烈的战争。这在战场上看到都属于正常现象了，刚到越南时，我们水土不服，晕车、拉肚子，体力消耗特别大，但大家都管不上，领导说过“ 轻伤不下火线 ”的名词在战场上用到了。越南这个地方温差相当大，太阳又毒，每位战士的军装都是血渍汗渍，因为没有时间去洗，也是很正常。在战场上吃不好，睡不好这都是常态，有时吃点随身携带的压缩饼干充饥，水也很难喝到，我们出发前，每个人发了一瓶药片，说是为了防止敌人水中投毒，这个药片放到水里能起到消毒作用。 我们云南战场上的每一位士兵都打了绑腿，同时还发了一双防止穿脚底的钢板军鞋，这次我发的三角巾急救包没用上，打尽的子弹、炮弹壳留了下来，当做纪念。可是第二天上午，新的战斗打响了，我随着步兵在公路上疾跑，看到了越军的炮弹子弹到处飞，真的是非常激烈的一幕，后来我们班马上进入山脚下阵地对准越军开炮，但没过几分钟，敌人的炮弹又马上飞了过来，辛亏我们马上转移阵地，否则肯定不是死就是伤了。', null, null, '3');
INSERT INTO `xy_picture` VALUES ('132', '0', '1578970087', '1578970087', '/upload/xiaying/imgs/2020-01-14/1578970087147lbxy_b_7.webp', '/upload/xiaying/imgs/2020-01-14/1578970087147lbxy_b_7.webp', '45', '1', '一九七九年三月五日，中国政府向全世界宣布，从三月五日开始所有参战部队从越南撤军的消息，当时我们十三军三十七师一零九团（红军团）于三月十一日顺利返回祖国，云南蒙自县，然后部队进行休整，地方上的人民送来了鱼、肉、鸡等食品，我们每个士兵还发了两包大重九香烟，因为我们这仗打得非常漂亮，中央慰问团由团长方毅副总理带领召开慰问大会，东方歌舞团团长王昆带领演员远征等优秀演员为我们表演了很多的优秀节目，我们心里很感动，带来了党中央以及全国人民的关怀，决心以实际行动再次为国杀敌立功，做一名优秀的人民解放军，做新一代最可爱的人。回国后，部队进行了总结和评功活动，我别的要求是没有的，活着从战场上走下来，已经比在战场上死去的烈士和伤员要幸运，功劳应该归功于他们。我所在的团队是以班为单位，我们班荣立了二等功一次，三等功一次，我本人是从当兵开始到退伍一共受连队加奖四次，一次被评为学雷锋先进标兵，从一个无知的青年，经过党的培养，成长为中国共产党党员，入伍第二个年头就被连队选中担任班长职务，这就是我人生的芳华吧！', null, null, '4');
INSERT INTO `xy_picture` VALUES ('133', '1', '1578970299', '1578970299', '/upload/xiaying/imgs/2020-01-14/1578970299439lbxy_title_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970299439lbxy_title_2.webp', '45', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('134', '0', '1578970351', '1578970351', '/upload/xiaying/imgs/2020-03-20/1584671526877lbxy_title_2.webp', '/upload/xiaying/imgs/2020-03-20/1584671526877lbxy_title_2.webp', '48', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('135', '0', '1578970383', '1578970383', '/upload/xiaying/imgs/2020-03-20/1584671541093lbxy_b_9.webp', '/upload/xiaying/imgs/2020-03-20/1584671541093lbxy_b_9.webp', '48', '1', ' 芳华已逝，记忆犹存。我怀着对十三军37师（109团）红军团的感情，从东海之滨宁波，终于踏上了多年的梦想思念已久的重庆市，铜梁县，现改为铜梁区，这里还是战斗英雄邱少云的故乡呢，我于17年3月15日下午4点从宁波机场出发，经过2个多小时的飞行，终于到达了重庆江北机场，当天在重庆市区住一个晚上，第二天在重庆玩了一天，参观了红岩革命烈士纪念馆，然后晚上乘车到达目的地铜梁区，见到熟悉又陌生的城市，因为三十多年过去，变化实在太大了，参观了邱少云纪念馆后真正到达红军团。首先我要做的第一件事就是把行李包内的65式军装拿出来并穿上身，向团部营房大门敬了标准的军礼，并对自己内心说：“三十多年了，我的红军团，你的退役士兵，今天终于来看你了。”当时的心情无比激动，凡是在红军团服役过的老兵，首先要参观的是部队的荣誉室， 因为我们红军团在战争年代是英雄辈出，百战百胜的部队，我们的先辈有王树声、王近山、洪学志、秦基伟等110多名的将军，他们都是从红军团走出去的，在和平年代，特别是在1979年2月17日对越自卫反击打响后，红军团从河口的瓦窑一线跨越红河，在越南横扫谷柳、保胜穿插追敌至外波河......全团荣立集体二等功。        一切都已经成为过去，尘封往事，并不如烟，正是一代又一代的红军团战士在不同的历史时期，在血与火的战场上，能听党指挥，忠于祖国，坚韧不拔，勇往直前的战斗作风，永远是克敌制胜的法宝，永远是激励我们、哺育我们的胜利之魂。', null, null, '1');
INSERT INTO `xy_picture` VALUES ('136', '0', '1578970396', '1578970396', '/upload/xiaying/imgs/2020-01-14/1578970396772lbxy_b_11.webp', '/upload/xiaying/imgs/2020-01-14/1578970396772lbxy_b_11.webp', '48', '1', '将军，他们都是从红军团走出去的，在和平年代，特别是在1979年2月17日对越自卫反击打响后，红军团从河口的瓦窑一线跨越红河，在越南横扫谷柳、保胜穿插追敌至外波河......全团荣立集体二等功。        一切都已经成为过去，尘封往事，并不如烟，正是一代又一代的红军团战士在不同的历史时期，在血与火的战场上，能听党指挥，忠于祖国，坚韧不拔，勇往直前的战斗作风，永远是克敌制胜的法宝，永远是激励我们、哺育我们的胜利之魂。我来到了连队后，连长指导员他们非常热情的招待，并派出了士官专门为我讲解部队的建设情况，陪我一起参观了部队的连史室，为我专门配备了一名士兵，为我拍照留念，中午饭也是在部队营房内食堂一起吃的，遇见士兵，他们很有礼貌的举起右手为我敬礼，看到部队士气高扬，使我留下了深刻的印象，让我很感动。我们原来的营房都是平房，现在都是三层楼房，条件比我们当兵时好多了，记得那时，我们在越南作战时，8元一月的津贴费，伙食费只有0.47元一天。我这次重回老部队，还有一个目的，也就是我们红军团马上要进行军改了，部队的番号要改了，以习近平同志为核心的党中央军委高瞻远瞩，把握未来战争的趋势，大刀阔斧的进行军改，所以，我能在军改之前到部队，回部队看望，意义重大，因为我也是从红军团里走出来的一名老兵，要永远珍惜红军团战士的这个称谓，永远做无愧于红军传人，红军团，我们永远为你骄傲。青春无悔，芳华已逝。', null, null, '2');
INSERT INTO `xy_picture` VALUES ('137', '1', '1578970459', '1578970459', '/upload/xiaying/imgs/2020-01-14/1578970459992zbingz_title_yqsl.webp', '/upload/xiaying/imgs/2020-01-14/1578970459992zbingz_title_yqsl.webp', '50', '2', '<p>456877<img src=\"http://wgtest.inteink.com/upload/xiaying/imgs/2020-01-14/1578970783415zbingz_fujian_b_1.webp\" style=\"max-width: 100%;\"></p><p>55</p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('138', '0', '1578970626', '1578970626', '/upload/xiaying/imgs/2020-01-14/1578970626030zbingz_title_muce.webp', '/upload/xiaying/imgs/2020-01-14/1578970626030zbingz_title_muce.webp', '51', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('139', '0', '1578970688', '1578970688', '/upload/xiaying/imgs/2020-01-14/1578970688723zbingz_muce_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970688723zbingz_muce_b_1.webp', '51', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('140', '0', '1578970695', '1578970695', '/upload/xiaying/imgs/2020-01-14/1578970695548zbingz_muce_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970695548zbingz_muce_b_2.webp', '51', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('141', '0', '1578970700', '1578970700', '/upload/xiaying/imgs/2020-01-14/1578970700816zbingz_muce_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970700816zbingz_muce_b_3.webp', '51', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('142', '0', '1578970718', '1578970718', '/upload/xiaying/imgs/2020-01-14/1578970718421zbingz_title_chujian.webp', '/upload/xiaying/imgs/2020-01-14/1578970718421zbingz_title_chujian.webp', '52', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('143', '0', '1578970729', '1578970729', '/upload/xiaying/imgs/2020-01-14/1578970729500zbingz_chujian_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970729500zbingz_chujian_b_1.webp', '52', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('144', '0', '1578970735', '1578970735', '/upload/xiaying/imgs/2020-01-14/1578970735333zbingz_chujian_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970735333zbingz_chujian_b_2.webp', '52', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('145', '0', '1578970740', '1578970740', '/upload/xiaying/imgs/2020-01-14/1578970740477zbingz_chujian_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970740477zbingz_chujian_b_3.webp', '52', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('146', '0', '1578970766', '1578970766', '/upload/xiaying/imgs/2020-01-14/1578970766544zbingz_fujian_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970766544zbingz_fujian_2.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('147', '0', '1578970783', '1578970783', '/upload/xiaying/imgs/2020-01-14/1578970783415zbingz_fujian_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970783415zbingz_fujian_b_1.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('148', '0', '1578970831', '1578970831', '/upload/xiaying/imgs/2020-01-14/1578970831746zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578970831746zbingz_title_fujian.webp', '53', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('149', '0', '1578970842', '1578970842', '/upload/xiaying/imgs/2020-01-14/1578970842712zbingz_fujian_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970842712zbingz_fujian_b_3.webp', '53', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('150', '0', '1578970847', '1578970847', '/upload/xiaying/imgs/2020-01-14/1578970847909zbingz_fujian_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970847909zbingz_fujian_b_2.webp', '53', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('151', '0', '1578970852', '1578970852', '/upload/xiaying/imgs/2020-01-14/1578970852066zbingz_fujian_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970852066zbingz_fujian_b_1.webp', '53', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('152', '0', '1578970865', '1578970865', '/upload/xiaying/imgs/2020-01-14/1578970865797zbingz_title_yqsl.webp', '/upload/xiaying/imgs/2020-01-14/1578970865797zbingz_title_yqsl.webp', '54', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('153', '0', '1578970872', '1578970872', '/upload/xiaying/imgs/2020-01-14/1578970872901zbingz_yqsl_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970872901zbingz_yqsl_b_3.webp', '54', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('154', '0', '1578970878', '1578970878', '/upload/xiaying/imgs/2020-01-14/1578970878518zbingz_yqsl_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970878518zbingz_yqsl_b_2.webp', '54', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('155', '0', '1578970882', '1578970882', '/upload/xiaying/imgs/2020-01-14/1578970882990zbingz_yqsl_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970882990zbingz_yqsl_b_1.webp', '54', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('156', '0', '1578970896', '1578970896', '/upload/xiaying/imgs/2020-01-14/1578970896032zbingz_title_xbjf.webp', '/upload/xiaying/imgs/2020-01-14/1578970896032zbingz_title_xbjf.webp', '55', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('157', '0', '1578970901', '1578970901', '/upload/xiaying/imgs/2020-01-14/1578970901878zbingz_xbjf_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970901878zbingz_xbjf_b_3.webp', '55', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('158', '0', '1578970906', '1578970906', '/upload/xiaying/imgs/2020-01-14/1578970906999zbingz_xbjf_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970906999zbingz_xbjf_b_2.webp', '55', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('159', '0', '1578970911', '1578970911', '/upload/xiaying/imgs/2020-01-14/1578970911749zbingz_xbjf_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970911749zbingz_xbjf_b_1.webp', '55', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('160', '0', '1578970922', '1578970922', '/upload/xiaying/imgs/2020-01-14/1578970922613zbingz_title_xbhs.webp', '/upload/xiaying/imgs/2020-01-14/1578970922613zbingz_title_xbhs.webp', '56', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('161', '0', '1578970928', '1578970928', '/upload/xiaying/imgs/2020-01-14/1578970928614zbingz_xbhs_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970928614zbingz_xbhs_b_3.webp', '56', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('162', '0', '1578970934', '1578970934', '/upload/xiaying/imgs/2020-01-14/1578970934080zbingz_xbhs_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970934080zbingz_xbhs_b_2.webp', '56', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('163', '0', '1578970938', '1578970938', '/upload/xiaying/imgs/2020-01-14/1578970938723zbingz_xbhs_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970938723zbingz_xbhs_b_1.webp', '56', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('164', '0', '1578970952', '1578970952', '/upload/xiaying/imgs/2020-01-14/1578970952147zbingz_title_sb.webp', '/upload/xiaying/imgs/2020-01-14/1578970952147zbingz_title_sb.webp', '57', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('165', '0', '1578970958', '1578970958', '/upload/xiaying/imgs/2020-01-14/1578970958709zbingz_sb_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578970958709zbingz_sb_b_3.webp', '57', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('166', '0', '1578970963', '1578970963', '/upload/xiaying/imgs/2020-01-14/1578970963549zbingz_sb_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578970963549zbingz_sb_b_2.webp', '57', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('167', '0', '1578970968', '1578970968', '/upload/xiaying/imgs/2020-01-14/1578970968064zbingz_sb_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578970968064zbingz_sb_b_1.webp', '57', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('168', '0', '1578971098', '1578971098', '/upload/xiaying/imgs/2020-01-14/1578971098828zbingz_title_1.webp', '/upload/xiaying/imgs/2020-01-14/1578971098828zbingz_title_1.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('169', '0', '1578971224', '1578971224', '/upload/xiaying/imgs/2020-01-14/1578971224355zbingz_title_1.webp', '/upload/xiaying/imgs/2020-01-14/1578971224355zbingz_title_1.webp', '58', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('170', '0', '1578971235', '1578971235', '/upload/xiaying/imgs/2020-01-14/1578971235064zbingz_b_6.webp', '/upload/xiaying/imgs/2020-01-14/1578971235064zbingz_b_6.webp', '58', '1', null, null, null, '8');
INSERT INTO `xy_picture` VALUES ('171', '0', '1578971240', '1578971240', '/upload/xiaying/imgs/2020-01-14/1578971240213zbingz_b_5.webp', '/upload/xiaying/imgs/2020-01-14/1578971240213zbingz_b_5.webp', '58', '1', null, null, null, '7');
INSERT INTO `xy_picture` VALUES ('172', '0', '1578971245', '1578971245', '/upload/xiaying/imgs/2020-01-14/1578971245140zbingz_b_4.webp', '/upload/xiaying/imgs/2020-01-14/1578971245140zbingz_b_4.webp', '58', '1', null, null, null, '6');
INSERT INTO `xy_picture` VALUES ('173', '0', '1578971250', '1578971250', '/upload/xiaying/imgs/2020-01-14/1578971250656zbingz_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578971250656zbingz_b_3.webp', '58', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('174', '0', '1578971254', '1578971254', '/upload/xiaying/imgs/2020-01-14/1578971254676zbingz_b_2.webp', '/upload/xiaying/imgs/2020-01-14/1578971254676zbingz_b_2.webp', '58', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('175', '0', '1578971258', '1578971258', '/upload/xiaying/imgs/2020-01-14/1578971258737zbingz_b_1.webp', '/upload/xiaying/imgs/2020-01-14/1578971258737zbingz_b_1.webp', '58', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('176', '1', '1578971270', '1578971270', '/upload/xiaying/imgs/2020-01-14/1578971270851zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578971270851zbingz_title_fujian.webp', '59', '2', '', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('177', '1', '1578971350', '1578971350', '/upload/xiaying/imgs/2020-01-14/1578971350425zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578971350425zbingz_title_fujian.webp', '60', '2', '<p><img src=\"http://xydptest.inteink.com/upload/xiaying/imgs/2020-03-20/1584672674096gk_1.webp\" style=\"max-width:100%;\"><img src=\"http://xydptest.inteink.com/upload/xiaying/imgs/2020-03-20/1584672688483gk_2.webp\" style=\"max-width: 100%;\"><br></p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('178', '0', '1578974085', '1578974085', '/upload/xiaying/imgs/2020-03-20/1584683586655lgjr_p_1.webp', '/upload/xiaying/imgs/2020-03-20/1584683586655lgjr_p_1.webp', '61', '2', '1987年1月出生，现居下应街道中海国际社区，于2003年入伍，2017年退伍，期间荣获二等功1次、三等功1次。', '张铁泉', '1', '0');
INSERT INTO `xy_picture` VALUES ('179', '1', '1578975025', '1578975025', '/upload/xiaying/imgs/2020-01-14/1578975025459zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578975025459zbingz_title_fujian.webp', '62', '2', '', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('180', '0', '1578975108', '1578975108', '/upload/xiaying/imgs/2020-01-14/1578975108144zbingz_fujian_b_3.webp', '/upload/xiaying/imgs/2020-01-14/1578975108144zbingz_fujian_b_3.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('181', '0', '1578975148', '1578975148', '/upload/xiaying/imgs/2020-01-14/1578975148848zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578975148848zbingz_title_fujian.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('182', '0', '1578975462', '1578975462', '/upload/xiaying/imgs/2020-01-14/1578975462486zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578975462486zbingz_title_fujian.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('183', '0', '1578975534', '1578975534', '/upload/xiaying/imgs/2020-01-14/1578975534189zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578975534189zbingz_title_fujian.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('184', '1', '1578975568', '1578975568', '/upload/xiaying/imgs/2020-01-14/1578975568322zbingz_title_fujian.webp', '/upload/xiaying/imgs/2020-01-14/1578975568322zbingz_title_fujian.webp', '63', '2', '<p>333222</p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('185', '0', '1584672674', '1584672674', '/upload/xiaying/imgs/2020-03-20/1584672674096gk_1.webp', '/upload/xiaying/imgs/2020-03-20/1584672674096gk_1.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('186', '0', '1584672688', '1584672688', '/upload/xiaying/imgs/2020-03-20/1584672688483gk_2.webp', '/upload/xiaying/imgs/2020-03-20/1584672688483gk_2.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('187', '0', '1584672797', '1584672797', '/upload/xiaying/imgs/2020-03-20/1584672797807gk_1.webp', '/upload/xiaying/imgs/2020-03-20/1584672797807gk_1.webp', '64', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('188', '0', '1584672819', '1584672819', '/upload/xiaying/imgs/2020-03-20/1584672819608gk_2.webp', '/upload/xiaying/imgs/2020-03-20/1584672819608gk_2.webp', '64', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('189', '0', '1584674362', '1584674362', '/upload/xiaying/imgs/2020-03-20/1584674362038gk_wz_title.webp', '/upload/xiaying/imgs/2020-03-20/1584674362038gk_wz_title.webp', '65', '2', '<p style=\"text-align: center;\">下应街道建成退役军人服务站，退役军人有新“家”啦！&nbsp;</p><p style=\"text-align: left;\">&nbsp; &nbsp; &nbsp; &nbsp;昨天上午，省委政法委副书记卫中强一行来鄞调研。市委常委、区委书记褚银良，区委副书记、政法委书记朱法传参加相关活动。&nbsp;<br></p><p style=\"text-align: left;\">&nbsp; &nbsp; &nbsp; &nbsp;调研组一行来到下应街道退役军人服务站调研，通过现场参观、深入交流，了解服务站运行情况。该服务站于今年5月试运行，并于7月11日正式投用，按照退役军人“五有”服务保障体系建设的要求，秉持“懂军人、爱军人、全心全意服务退役军人”的理念，为辖区退役军人提供政策咨询、帮扶援助、沟通联系、学习交流等服务。&nbsp;&nbsp;<br></p><p>&nbsp; &nbsp; &nbsp; &nbsp; 调研组对该服务站突出面对面、个性化、一对一服务的做法表示肯定，并强调，要带着感情做工作，着力提升退役军人荣誉感、归属感、获得感。</p><p><img src=\"http://xydptest.inteink.com/upload/xiaying/imgs/2020-03-20/1584674472423gk_3.webp\" style=\"max-width:100%;\"><br></p><p>&nbsp; &nbsp; &nbsp; &nbsp; 据了解，下应街道退役军人服务站归口街道武装部，建有行政村（社区）退役军人服务站15个。街道本级服务站现有工作人员2名，在册退役军人572人，其中重点优抚对象23人，老复员军人2人，涉核参战退役人员19人，伤残军人2人，99年进藏兵1人；60周岁以上农村籍退役士兵7人，60周岁以上自缴城镇职工养老保险退役士兵139人，现役军人25人。572人在册退役军人中，立过二、三等功的共有30人，党员262人，享受抚恤补助的优抚对象180人。</p><p>&nbsp; &nbsp; &nbsp; &nbsp;下应街道高度重视退役军人服务工作，全面落实有机构、有场地、有人员、有经费、有保障“五有”工作目标，全力打造下应街道退役军人服务网络新体系。</p><p><img src=\"http://xydptest.inteink.com/upload/xiaying/imgs/2020-03-20/1584674504981gk_4.webp\" style=\"max-width:100%;\"><br></p><p>&nbsp; &nbsp; &nbsp; &nbsp;在机构设置方面，设立街道和行政村（社区）两级退役军人服务站机构，做到了街道辖区全覆盖，且每个机构均进行挂牌，明确服务职责；在场地设置方面，在街道本级专门打造军人服务站，各行政村（社区）结合自身实际情况，均已设立不同面积的场地；在后勤保障方面，街道结合历年来针对退役军人开展的优抚帮扶活动，继续深化和完善对于退役军人的相关服务，努力在维度、广度、深度、高度等四方面做到全面服务。</p><p><br></p>', null, '1', '0');
INSERT INTO `xy_picture` VALUES ('190', '0', '1584674472', '1584674472', '/upload/xiaying/imgs/2020-03-20/1584674472423gk_3.webp', '/upload/xiaying/imgs/2020-03-20/1584674472423gk_3.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('191', '0', '1584674504', '1584674504', '/upload/xiaying/imgs/2020-03-20/1584674504981gk_4.webp', '/upload/xiaying/imgs/2020-03-20/1584674504981gk_4.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('192', '0', '1584683627', '1584683627', '/upload/xiaying/imgs/2020-03-20/1584683627304lgjr_p_11.webp', '/upload/xiaying/imgs/2020-03-20/1584683627304lgjr_p_11.webp', '66', '2', '1982年8月出生，现居下应街道海创社区，于2001年入伍，2018年退伍，期间荣获三等功1次。', '袁国刚', '1', '0');
INSERT INTO `xy_picture` VALUES ('193', '0', '1584683709', '1584683709', '/upload/xiaying/imgs/2020-03-20/1584684041130lgjr_p_13.webp', '/upload/xiaying/imgs/2020-03-20/1584684041130lgjr_p_13.webp', '68', '2', '1961年10月出生，现居下应街道海创社区，于1979年入伍，2001年退伍，期间荣获三等功1次。', '钱松枝', '1', '0');
INSERT INTO `xy_picture` VALUES ('194', '0', '1584684064', '1584684064', '/upload/xiaying/imgs/2020-03-20/1584684064062lgjr_p_14 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684064062lgjr_p_14 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('195', '0', '1584684080', '1584684080', '/upload/xiaying/imgs/2020-03-20/1584684080268lgjr_p_14 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684080268lgjr_p_14 拷贝.webp', '69', '2', '1964年12月出生，现居下应街道海创社区，于1982年入伍，2001年退伍，期间荣获三等功1次。', '蒋世君', '1', '0');
INSERT INTO `xy_picture` VALUES ('196', '0', '1584684101', '1584684101', '/upload/xiaying/imgs/2020-03-20/1584684101488lgjr_p_15 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684101488lgjr_p_15 拷贝.webp', '70', '2', '1987年4月出生，现居下应街道海创社区，于2005年入伍，2010年退伍，期间荣获三等功1次。', '裘雄宏', '1', '0');
INSERT INTO `xy_picture` VALUES ('197', '0', '1584684151', '1584684151', '/upload/xiaying/imgs/2020-03-20/1584684151164lgjr_p_17 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684151164lgjr_p_17 拷贝.webp', '72', '2', '1968年9月出生，现居下应街道海创社区，于1987年入伍，2000年退伍，期间荣获三等功1次。', '陈其祥', '1', '0');
INSERT INTO `xy_picture` VALUES ('198', '0', '1584684176', '1584684176', '/upload/xiaying/imgs/2020-03-20/1584684176688lgjr_p_18 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684176688lgjr_p_18 拷贝.webp', '73', '2', '1958年11月出生，现居下应街道东兴社区，于1978年入伍，1983年退伍，期间荣获三等功1次。', '朱永康', '1', '0');
INSERT INTO `xy_picture` VALUES ('199', '0', '1584684244', '1584684244', '/upload/xiaying/imgs/2020-03-20/1584684244113lgjr_p_19 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684244113lgjr_p_19 拷贝.webp', '74', '2', '1976年6月出生，现居下应街道东兴社区，于1995年入伍，2003年退伍，期间荣获三等功1次。', '杜二军', '1', '0');
INSERT INTO `xy_picture` VALUES ('200', '0', '1584684267', '1584684267', '/upload/xiaying/imgs/2020-03-20/1584684267981lgjr_p_20 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684267981lgjr_p_20 拷贝.webp', '75', '2', '1968年10月出生，现居下应街道蔚蓝水岸小区，于1986年入伍，1990年退伍，期间荣获三等功1次。', '施晓君', '1', '0');
INSERT INTO `xy_picture` VALUES ('201', '0', '1584684294', '1584684294', '/upload/xiaying/imgs/2020-03-20/1584684294602lgjr_p_21 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684294602lgjr_p_21 拷贝.webp', '76', '2', '1959年2月出生，现居下应街道江六村，于1979年入伍，1982年退伍，期间荣获三等功1次。', '陈爱国', '1', '0');
INSERT INTO `xy_picture` VALUES ('202', '0', '1584684320', '1584684320', '/upload/xiaying/imgs/2020-03-20/1584684320768lgjr_p_22 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684320768lgjr_p_22 拷贝.webp', '77', '2', '1943年9月出生，现居下应街道史家码村，于1962年入伍，1968年退伍，期间荣获三等功1次。', '史济阳', '1', '0');
INSERT INTO `xy_picture` VALUES ('203', '0', '1584684344', '1584684344', '/upload/xiaying/imgs/2020-03-20/1584684344285lgjr_p_23 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684344285lgjr_p_23 拷贝.webp', '78', '2', '1954年9月出生，现居下应街道史家码村，于1973年入伍，1980年退伍，期间荣获三等功1次。', '史智慧', '1', '0');
INSERT INTO `xy_picture` VALUES ('204', '0', '1584684370', '1584684370', '/upload/xiaying/imgs/2020-03-20/1584684370147lgjr_p_24 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684370147lgjr_p_24 拷贝.webp', '79', '2', '1958年9月出生，现居下应街道史家码村，于1976年入伍，1981年退伍，期间荣获三等功1次。', '史美祥', '1', '0');
INSERT INTO `xy_picture` VALUES ('205', '0', '1584684399', '1584684399', '/upload/xiaying/imgs/2020-03-20/1584684399252lgjr_p_25 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684399252lgjr_p_25 拷贝.webp', '80', '2', '1958年8月出生，现居中河街道东裕社区，于1976年入伍，1982年退伍，期间荣获三等功1次。', '康明浩', '1', '0');
INSERT INTO `xy_picture` VALUES ('206', '0', '1584684421', '1584684421', '/upload/xiaying/imgs/2020-03-20/1584684421231lgjr_p_26 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684421231lgjr_p_26 拷贝.webp', '81', '2', '1997年3月出生，现居东钱湖镇东湖观邸小区，于2016年入伍，2018年退伍，期间荣获三等功1次。', '乐俊勇', '1', '0');
INSERT INTO `xy_picture` VALUES ('207', '0', '1584684483', '1584684483', '/upload/xiaying/imgs/2020-03-20/1584684483461lgjr_p_27 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684483461lgjr_p_27 拷贝.webp', '82', '2', '1989年10月出生，现居潘火街道金谷小区，于2009年入伍，2011年退伍，期间荣获三等功1次。', '陆贤达', '1', '0');
INSERT INTO `xy_picture` VALUES ('208', '0', '1584684508', '1584684508', '/upload/xiaying/imgs/2020-03-20/1584684508173lgjr_p_28 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684508173lgjr_p_28 拷贝.webp', '83', '2', '1934年11月出生，现居下应街道东升村，于1953年入伍，1957年退伍，期间荣获三等功1次。', '孙忠华', '1', '0');
INSERT INTO `xy_picture` VALUES ('209', '0', '1584684532', '1584684532', '/upload/xiaying/imgs/2020-03-20/1584684532668lgjr_p_29 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684532668lgjr_p_29 拷贝.webp', '84', '2', '1960年2月出生，现居下应街道东升村，于1978年入伍，1982年退伍，期间荣获三等功1次。', '孙国财', '1', '0');
INSERT INTO `xy_picture` VALUES ('210', '0', '1584684558', '1584684558', '/upload/xiaying/imgs/2020-03-20/1584684558142lgjr_p_30 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684558142lgjr_p_30 拷贝.webp', '85', '2', '1964年6月出生，现居下应街道天宫社区，于1981年入伍，2000年退伍，期间荣获三等功1次。', '方建军', '1', '0');
INSERT INTO `xy_picture` VALUES ('211', '1', '1584684798', '1584684798', '/upload/xiaying/imgs/2020-03-20/1584684798070jrxq_x18_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684798070jrxq_x18_1 拷贝.webp', '85', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('212', '1', '1584684808', '1584684808', '/upload/xiaying/imgs/2020-03-20/1584684808209jrxq_x18_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684808209jrxq_x18_2 拷贝.webp', '85', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('213', '1', '1584684816', '1584684816', '/upload/xiaying/imgs/2020-03-20/1584684816815jrxq_x18_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684816815jrxq_x18_3 拷贝.webp', '85', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('214', '1', '1584684825', '1584684825', '/upload/xiaying/imgs/2020-03-20/1584684825530jrxq_x18_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684825530jrxq_x18_4 拷贝.webp', '85', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('215', '1', '1584684833', '1584684833', '/upload/xiaying/imgs/2020-03-20/1584684833896jrxq_x18_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684833896jrxq_x18_6 拷贝.webp', '85', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('216', '0', '1584684962', '1584684962', '/upload/xiaying/imgs/2020-03-20/1584684962146jrxq_x30_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584684962146jrxq_x30_1 拷贝.webp', '85', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('217', '0', '1584685072', '1584685072', '/upload/xiaying/imgs/2020-03-20/1584685072794jrxq_x30_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685072794jrxq_x30_2 拷贝.webp', '85', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('218', '0', '1584685081', '1584685081', '/upload/xiaying/imgs/2020-03-20/1584685081629jrxq_x30_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685081629jrxq_x30_3 拷贝.webp', '85', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('219', '0', '1584685089', '1584685089', '/upload/xiaying/imgs/2020-03-20/1584685089200jrxq_x30_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685089200jrxq_x30_4 拷贝.webp', '85', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('220', '0', '1584685102', '1584685102', '/upload/xiaying/imgs/2020-03-20/1584685102829jrxq_x30_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685102829jrxq_x30_5 拷贝.webp', '85', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('221', '0', '1584685133', '1584685133', '/upload/xiaying/imgs/2020-03-20/1584685133238jrxq_x29_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685133238jrxq_x29_1 拷贝.webp', '84', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('222', '0', '1584685140', '1584685140', '/upload/xiaying/imgs/2020-03-20/1584685140367jrxq_x29_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685140367jrxq_x29_4 拷贝.webp', '84', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('223', '0', '1584685168', '1584685168', '/upload/xiaying/imgs/2020-03-20/1584685168486jrxq_x28_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685168486jrxq_x28_1 拷贝.webp', '83', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('224', '0', '1584685182', '1584685182', '/upload/xiaying/imgs/2020-03-20/1584685182500jrxq_x27_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685182500jrxq_x27_1 拷贝.webp', '82', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('225', '0', '1584685189', '1584685189', '/upload/xiaying/imgs/2020-03-20/1584685189844jrxq_x27_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685189844jrxq_x27_2 拷贝.webp', '82', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('226', '0', '1584685207', '1584685207', '/upload/xiaying/imgs/2020-03-20/1584685207785jrxq_x26_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685207785jrxq_x26_1 拷贝.webp', '81', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('227', '0', '1584685216', '1584685216', '/upload/xiaying/imgs/2020-03-20/1584685216362jrxq_x26_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685216362jrxq_x26_2 拷贝.webp', '81', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('228', '0', '1584685224', '1584685224', '/upload/xiaying/imgs/2020-03-20/1584685224403jrxq_x26_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685224403jrxq_x26_3 拷贝.webp', '81', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('229', '0', '1584685233', '1584685233', '/upload/xiaying/imgs/2020-03-20/1584685233217jrxq_x26_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685233217jrxq_x26_4 拷贝.webp', '81', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('230', '0', '1584685250', '1584685250', '/upload/xiaying/imgs/2020-03-20/1584685250709jrxq_x25_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685250709jrxq_x25_1 拷贝.webp', '80', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('231', '0', '1584685264', '1584685264', '/upload/xiaying/imgs/2020-03-20/1584685264467jrxq_x25_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685264467jrxq_x25_2 拷贝.webp', '80', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('232', '0', '1584685294', '1584685294', '/upload/xiaying/imgs/2020-03-20/1584685294562jrxq_x24_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685294562jrxq_x24_1 拷贝.webp', '79', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('233', '0', '1584685311', '1584685311', '/upload/xiaying/imgs/2020-03-20/1584685311372jrxq_x23_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685311372jrxq_x23_1 拷贝.webp', '78', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('234', '0', '1584685320', '1584685320', '/upload/xiaying/imgs/2020-03-20/1584685320599jrxq_x23_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685320599jrxq_x23_3 拷贝.webp', '78', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('235', '0', '1584685336', '1584685336', '/upload/xiaying/imgs/2020-03-20/1584685336873jrxq_x22_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584685336873jrxq_x22_1 拷贝.webp', '77', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('236', '0', '1584686107', '1584686107', '/upload/xiaying/imgs/2020-03-20/1584686107446jrxq_x21_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584686107446jrxq_x21_1 拷贝.webp', '76', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('237', '0', '1584686118', '1584686118', '/upload/xiaying/imgs/2020-03-20/1584686118797jrxq_x21_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584686118797jrxq_x21_2 拷贝.webp', '76', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('238', '0', '1584686126', '1584686126', '/upload/xiaying/imgs/2020-03-20/1584686126092jrxq_x21_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584686126092jrxq_x21_3 拷贝.webp', '76', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('239', '0', '1584686133', '1584686133', '/upload/xiaying/imgs/2020-03-20/1584686133227jrxq_x21_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584686133227jrxq_x21_4 拷贝.webp', '76', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('240', '0', '1584688117', '1584688117', '/upload/xiaying/imgs/2020-03-20/1584688117632yfbf_title_zoufang 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688117632yfbf_title_zoufang 拷贝.webp', '86', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('241', '1', '1584688129', '1584688129', '/upload/xiaying/imgs/2020-03-20/1584688129916yfbf_zoufang_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688129916yfbf_zoufang_1 拷贝.webp', '86', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('242', '1', '1584688137', '1584688137', '/upload/xiaying/imgs/2020-03-20/1584688137454yfbf_zoufang_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688137454yfbf_zoufang_2 拷贝.webp', '86', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('243', '1', '1584688142', '1584688142', '/upload/xiaying/imgs/2020-03-20/1584688142107yfbf_zoufang_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688142107yfbf_zoufang_3 拷贝.webp', '86', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('244', '0', '1584688147', '1584688147', '/upload/xiaying/imgs/2020-03-20/1584688147009yfbf_zoufang_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688147009yfbf_zoufang_b_1 拷贝.webp', '86', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('245', '0', '1584688151', '1584688151', '/upload/xiaying/imgs/2020-03-20/1584688151407yfbf_zoufang_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688151407yfbf_zoufang_b_2 拷贝.webp', '86', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('246', '0', '1584688155', '1584688155', '/upload/xiaying/imgs/2020-03-20/1584688155748yfbf_zoufang_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688155748yfbf_zoufang_b_3 拷贝.webp', '86', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('247', '0', '1584688195', '1584688195', '/upload/xiaying/imgs/2020-03-20/1584688195817yfbf_title_tuiyi 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688195817yfbf_title_tuiyi 拷贝.webp', '87', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('248', '1', '1584688241', '1584688241', '/upload/xiaying/imgs/2020-03-20/1584688241214yfbf_tuiyi_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688241214yfbf_tuiyi_1 拷贝.webp', '87', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('249', '1', '1584688245', '1584688245', '/upload/xiaying/imgs/2020-03-20/1584688245779yfbf_tuiyi_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688245779yfbf_tuiyi_2 拷贝.webp', '87', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('250', '1', '1584688249', '1584688249', '/upload/xiaying/imgs/2020-03-20/1584688249572yfbf_tuiyi_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688249572yfbf_tuiyi_3 拷贝.webp', '87', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('251', '0', '1584688253', '1584688253', '/upload/xiaying/imgs/2020-03-20/1584688253537yfbf_tuiyi_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688253537yfbf_tuiyi_b_1 拷贝.webp', '87', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('252', '0', '1584688257', '1584688257', '/upload/xiaying/imgs/2020-03-20/1584688257841yfbf_tuiyi_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688257841yfbf_tuiyi_b_2 拷贝.webp', '87', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('253', '0', '1584688264', '1584688264', '/upload/xiaying/imgs/2020-03-20/1584688264742yfbf_tuiyi_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688264742yfbf_tuiyi_b_3 拷贝.webp', '87', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('254', '0', '1584688284', '1584688284', '/upload/xiaying/imgs/2020-03-20/1584688284897yfbf_title_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688284897yfbf_title_1 拷贝.webp', '88', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('255', '1', '1584688315', '1584688315', '/upload/xiaying/imgs/2020-03-20/1584688315212yfbf_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688315212yfbf_1 拷贝.webp', '88', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('256', '1', '1584688319', '1584688319', '/upload/xiaying/imgs/2020-03-20/1584688319304yfbf_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688319304yfbf_2 拷贝.webp', '88', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('257', '1', '1584688323', '1584688323', '/upload/xiaying/imgs/2020-03-20/1584688323924yfbf_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688323924yfbf_3 拷贝.webp', '88', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('258', '1', '1584688328', '1584688328', '/upload/xiaying/imgs/2020-03-20/1584688328304yfbf_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688328304yfbf_b_1 拷贝.webp', '88', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('259', '1', '1584688332', '1584688332', '/upload/xiaying/imgs/2020-03-20/1584688332654yfbf_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688332654yfbf_b_2 拷贝.webp', '88', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('260', '1', '1584688337', '1584688337', '/upload/xiaying/imgs/2020-03-20/1584688337434yfbf_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688337434yfbf_b_3 拷贝.webp', '88', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('261', '0', '1584688357', '1584688357', '/upload/xiaying/imgs/2020-03-20/1584688357251yfbf_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688357251yfbf_title_2 拷贝.webp', '89', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('262', '1', '1584688377', '1584688377', '/upload/xiaying/imgs/2020-03-20/1584688377947yfbf_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688377947yfbf_4 拷贝.webp', '89', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('263', '1', '1584688382', '1584688382', '/upload/xiaying/imgs/2020-03-20/1584688382629yfbf_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688382629yfbf_5 拷贝.webp', '89', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('264', '1', '1584688392', '1584688392', '/upload/xiaying/imgs/2020-03-20/1584688392383yfbf_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688392383yfbf_6 拷贝.webp', '89', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('265', '1', '1584688582', '1584688582', '/upload/xiaying/imgs/2020-03-20/1584688582451yfbf_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688582451yfbf_b_1 拷贝.webp', '88', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('266', '0', '1584688613', '1584688613', '/upload/xiaying/imgs/2020-03-20/1584688613361yfbf_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688613361yfbf_b_1 拷贝.webp', '88', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('267', '0', '1584688617', '1584688617', '/upload/xiaying/imgs/2020-03-20/1584688617830yfbf_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688617830yfbf_b_2 拷贝.webp', '88', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('268', '0', '1584688622', '1584688622', '/upload/xiaying/imgs/2020-03-20/1584688622118yfbf_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688622118yfbf_b_3 拷贝.webp', '88', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('269', '0', '1584688674', '1584688674', '/upload/xiaying/imgs/2020-03-20/1584688674435yfbf_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688674435yfbf_b_4 拷贝.webp', '89', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('270', '0', '1584688684', '1584688684', '/upload/xiaying/imgs/2020-03-20/1584688684893yfbf_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688684893yfbf_b_5 拷贝.webp', '89', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('271', '0', '1584688689', '1584688689', '/upload/xiaying/imgs/2020-03-20/1584688689980yfbf_b_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688689980yfbf_b_6 拷贝.webp', '89', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('272', '1', '1584688700', '1584688700', '/upload/xiaying/imgs/2020-03-20/1584688700312zzgz_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688700312zzgz_1 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('273', '1', '1584688709', '1584688709', '/upload/xiaying/imgs/2020-03-20/1584688709668yfbf_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688709668yfbf_title_3 拷贝.webp', '90', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('274', '1', '1584688709', '1584688709', '/upload/xiaying/imgs/2020-03-20/1584688709878zzgz_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688709878zzgz_2 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('275', '1', '1584688721', '1584688721', '/upload/xiaying/imgs/2020-03-20/1584688721319zzgz_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688721319zzgz_3 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('276', '1', '1584688738', '1584688738', '/upload/xiaying/imgs/2020-03-20/1584688738157zzgz_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688738157zzgz_4 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('277', '1', '1584688747', '1584688747', '/upload/xiaying/imgs/2020-03-20/1584688747528zzgz_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688747528zzgz_5 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('278', '1', '1584688756', '1584688756', '/upload/xiaying/imgs/2020-03-20/1584688756150zzgz_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688756150zzgz_6 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('279', '1', '1584688766', '1584688766', '/upload/xiaying/imgs/2020-03-20/1584688766461zzgz_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688766461zzgz_b_1 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('280', '1', '1584688787', '1584688787', '/upload/xiaying/imgs/2020-03-20/1584688787668zzgz_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688787668zzgz_b_3 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('281', '0', '1584688840', '1584688840', '/upload/xiaying/imgs/2020-03-20/1584688840029yfbf_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688840029yfbf_title_3 拷贝.webp', '91', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('282', '0', '1584688868', '1584688868', '/upload/xiaying/imgs/2020-03-20/1584688868633yfbf_b_7 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688868633yfbf_b_7 拷贝.webp', '91', '1', '2019年1月9日，街道军属家庭“光荣之家”\n安装，街道武装部长张亚平走访慰问，与军属\n合影。', null, null, '1');
INSERT INTO `xy_picture` VALUES ('283', '0', '1584688914', '1584688914', '/upload/xiaying/imgs/2020-03-20/1584688914864zzgz_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688914864zzgz_b_1 拷贝.webp', '27', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('284', '0', '1584688916', '1584688916', '/upload/xiaying/imgs/2020-03-20/1584688916331yfbf_title_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688916331yfbf_title_4 拷贝.webp', '92', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('285', '0', '1584688927', '1584688927', '/upload/xiaying/imgs/2020-03-20/1584688927008zzgz_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688927008zzgz_b_2 拷贝.webp', '27', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('286', '0', '1584688934', '1584688934', '/upload/xiaying/imgs/2020-03-20/1584688934858yfbf_b_9 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688934858yfbf_b_9 拷贝.webp', '92', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('287', '0', '1584688935', '1584688935', '/upload/xiaying/imgs/2020-03-20/1584688935118zzgz_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688935118zzgz_b_3 拷贝.webp', '27', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('288', '0', '1584688939', '1584688939', '/upload/xiaying/imgs/2020-03-20/1584688939267yfbf_b_10 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688939267yfbf_b_10 拷贝.webp', '92', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('289', '0', '1584688942', '1584688942', '/upload/xiaying/imgs/2020-03-20/1584688942868zzgz_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688942868zzgz_b_4 拷贝.webp', '27', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('290', '0', '1584688943', '1584688943', '/upload/xiaying/imgs/2020-03-20/1584688943174yfbf_b_11 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688943174yfbf_b_11 拷贝.webp', '92', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('291', '0', '1584688951', '1584688951', '/upload/xiaying/imgs/2020-03-20/1584688951046zzgz_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688951046zzgz_b_5 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('292', '0', '1584688957', '1584688957', '/upload/xiaying/imgs/2020-03-20/1584688957823zzgz_b_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584688957823zzgz_b_6 拷贝.webp', '27', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('293', '0', '1584689086', '1584689086', '/upload/xiaying/imgs/2020-03-20/1584689086636jsxl_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689086636jsxl_b_3 拷贝.webp', '30', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('294', '0', '1584689111', '1584689111', '/upload/xiaying/imgs/2020-03-20/1584689191373jsxl_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689191373jsxl_b_1 拷贝.webp', '30', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('295', '0', '1584689143', '1584689143', '/upload/xiaying/imgs/2020-03-20/1584689143078gzlb_title_9 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689143078gzlb_title_9 拷贝.webp', '93', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('296', '0', '1584689158', '1584689158', '/upload/xiaying/imgs/2020-03-20/1584689158142gzlb_b_52 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689158142gzlb_b_52 拷贝.webp', '93', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('297', '0', '1584689162', '1584689162', '/upload/xiaying/imgs/2020-03-20/1584689162416gzlb_b_53 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689162416gzlb_b_53 拷贝.webp', '93', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('298', '0', '1584689167', '1584689167', '/upload/xiaying/imgs/2020-03-20/1584689167478gzlb_b_54 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689167478gzlb_b_54 拷贝.webp', '93', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('299', '0', '1584689171', '1584689171', '/upload/xiaying/imgs/2020-03-20/1584689171736gzlb_b_55 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689171736gzlb_b_55 拷贝.webp', '93', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('300', '0', '1584689175', '1584689175', '/upload/xiaying/imgs/2020-03-20/1584689175523gzlb_b_56 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689175523gzlb_b_56 拷贝.webp', '93', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('301', '0', '1584689195', '1584689195', '/upload/xiaying/imgs/2020-03-20/1584689195418gzlb_title_7 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689195418gzlb_title_7 拷贝.webp', '94', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('302', '0', '1584689223', '1584689223', '/upload/xiaying/imgs/2020-03-20/1584689223018gzlb_b_32 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689223018gzlb_b_32 拷贝.webp', '94', '1', null, null, null, '9');
INSERT INTO `xy_picture` VALUES ('303', '0', '1584689228', '1584689228', '/upload/xiaying/imgs/2020-03-20/1584689228272gzlb_b_33 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689228272gzlb_b_33 拷贝.webp', '94', '1', null, null, null, '8');
INSERT INTO `xy_picture` VALUES ('304', '0', '1584689232', '1584689232', '/upload/xiaying/imgs/2020-03-20/1584689232406gzlb_b_34 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689232406gzlb_b_34 拷贝.webp', '94', '1', null, null, null, '7');
INSERT INTO `xy_picture` VALUES ('305', '0', '1584689239', '1584689239', '/upload/xiaying/imgs/2020-03-20/1584689239824gzlb_b_35 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689239824gzlb_b_35 拷贝.webp', '94', '1', null, null, null, '6');
INSERT INTO `xy_picture` VALUES ('306', '0', '1584689243', '1584689243', '/upload/xiaying/imgs/2020-03-20/1584689243942gzlb_b_36 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689243942gzlb_b_36 拷贝.webp', '94', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('307', '0', '1584689247', '1584689247', '/upload/xiaying/imgs/2020-03-20/1584689247832gzlb_b_37 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689247832gzlb_b_37 拷贝.webp', '94', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('308', '0', '1584689252', '1584689252', '/upload/xiaying/imgs/2020-03-20/1584689252091gzlb_b_38 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689252091gzlb_b_38 拷贝.webp', '94', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('309', '0', '1584689255', '1584689255', '/upload/xiaying/imgs/2020-03-20/1584689255691gzlb_b_39 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689255691gzlb_b_39 拷贝.webp', '94', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('310', '0', '1584689259', '1584689259', '/upload/xiaying/imgs/2020-03-20/1584689259146gzlb_b_40 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689259146gzlb_b_40 拷贝.webp', '94', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('311', '0', '1584689315', '1584689315', '/upload/xiaying/imgs/2020-03-20/1584689315777gzlb_title_8 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689315777gzlb_title_8 拷贝.webp', '95', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('312', '0', '1584689337', '1584689337', '/upload/xiaying/imgs/2020-03-20/1584689337636gzlb_b_41 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689337636gzlb_b_41 拷贝.webp', '95', '1', null, null, null, '8');
INSERT INTO `xy_picture` VALUES ('313', '0', '1584689343', '1584689343', '/upload/xiaying/imgs/2020-03-20/1584689343832gzlb_b_42 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689343832gzlb_b_42 拷贝.webp', '95', '1', null, null, null, '7');
INSERT INTO `xy_picture` VALUES ('314', '0', '1584689350', '1584689350', '/upload/xiaying/imgs/2020-03-20/1584689350490gzlb_b_43 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689350490gzlb_b_43 拷贝.webp', '95', '1', null, null, null, '6');
INSERT INTO `xy_picture` VALUES ('315', '0', '1584689353', '1584689353', '/upload/xiaying/imgs/2020-03-20/1584689353867gzlb_b_44 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689353867gzlb_b_44 拷贝.webp', '95', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('316', '0', '1584689359', '1584689359', '/upload/xiaying/imgs/2020-03-20/1584689359135gzlb_b_45 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689359135gzlb_b_45 拷贝.webp', '95', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('317', '0', '1584689362', '1584689362', '/upload/xiaying/imgs/2020-03-20/1584689362481gzlb_b_47 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689362481gzlb_b_47 拷贝.webp', '95', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('318', '0', '1584689366', '1584689366', '/upload/xiaying/imgs/2020-03-20/1584689366478gzlb_b_49 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689366478gzlb_b_49 拷贝.webp', '95', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('319', '0', '1584689371', '1584689371', '/upload/xiaying/imgs/2020-03-20/1584689371077gzlb_b_50 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689371077gzlb_b_50 拷贝.webp', '95', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('320', '0', '1584689397', '1584689397', '/upload/xiaying/imgs/2020-03-20/1584689397502gzlb_title_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689397502gzlb_title_1 拷贝.webp', '96', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('321', '0', '1584689431', '1584689431', '/upload/xiaying/imgs/2020-03-20/1584689431585gzlb_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689431585gzlb_b_1 拷贝.webp', '96', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('322', '0', '1584689435', '1584689435', '/upload/xiaying/imgs/2020-03-20/1584689435632gzlb_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689435632gzlb_b_2 拷贝.webp', '96', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('323', '0', '1584689438', '1584689438', '/upload/xiaying/imgs/2020-03-20/1584689438849gzlb_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689438849gzlb_b_3 拷贝.webp', '96', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('324', '0', '1584689454', '1584689454', '/upload/xiaying/imgs/2020-03-20/1584689454746gzlb_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689454746gzlb_title_2 拷贝.webp', '97', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('325', '0', '1584689496', '1584689496', '/upload/xiaying/imgs/2020-03-20/1584689496664gzlb_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689496664gzlb_b_4 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('326', '0', '1584689523', '1584689523', '/upload/xiaying/imgs/2020-03-20/1584689523996gzlb_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689523996gzlb_b_4 拷贝.webp', '97', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('327', '0', '1584689544', '1584689544', '/upload/xiaying/imgs/2020-03-20/1584689544247gzlb_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689544247gzlb_b_5 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('328', '0', '1584689563', '1584689563', '/upload/xiaying/imgs/2020-03-20/1584689563373gzlb_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689563373gzlb_b_5 拷贝.webp', '97', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('329', '0', '1584689580', '1584689580', '/upload/xiaying/imgs/2020-03-20/1584689580119gzlb_b_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689580119gzlb_b_6 拷贝.webp', '97', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('330', '0', '1584689601', '1584689601', '/upload/xiaying/imgs/2020-03-20/1584689601592zbingz_title_kjtf 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689601592zbingz_title_kjtf 拷贝.webp', '98', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('331', '0', '1584689609', '1584689609', '/upload/xiaying/imgs/2020-03-20/1584689609402gzlb_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689609402gzlb_title_3 拷贝.webp', '99', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('332', '0', '1584689615', '1584689615', '/upload/xiaying/imgs/2020-03-20/1584689615778zzgz_kjtf_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689615778zzgz_kjtf_b_1 拷贝.webp', '98', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('333', '0', '1584689624', '1584689624', '/upload/xiaying/imgs/2020-03-20/1584689624008zzgz_kjtf_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689624008zzgz_kjtf_b_2 拷贝.webp', '98', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('334', '0', '1584689626', '1584689626', '/upload/xiaying/imgs/2020-03-20/1584689626320gzlb_b_7 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689626320gzlb_b_7 拷贝.webp', '99', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('335', '0', '1584689630', '1584689630', '/upload/xiaying/imgs/2020-03-20/1584689630486gzlb_b_8 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689630486gzlb_b_8 拷贝.webp', '99', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('336', '0', '1584689633', '1584689633', '/upload/xiaying/imgs/2020-03-20/1584689633532zzgz_kjtf_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689633532zzgz_kjtf_b_3 拷贝.webp', '98', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('337', '0', '1584689635', '1584689635', '/upload/xiaying/imgs/2020-03-20/1584689635267gzlb_b_9 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689635267gzlb_b_9 拷贝.webp', '99', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('338', '0', '1584689641', '1584689641', '/upload/xiaying/imgs/2020-03-20/1584689641073zzgz_kjtf_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689641073zzgz_kjtf_b_4 拷贝.webp', '98', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('339', '0', '1584689649', '1584689649', '/upload/xiaying/imgs/2020-03-20/1584689649502zzgz_kjtf_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689649502zzgz_kjtf_b_5 拷贝.webp', '98', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('340', '0', '1584689663', '1584689663', '/upload/xiaying/imgs/2020-03-20/1584689663243gzlb_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689663243gzlb_title_3 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('341', '0', '1584689681', '1584689681', '/upload/xiaying/imgs/2020-03-20/1584689681580zbingz_title_tfmn 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689681580zbingz_title_tfmn 拷贝.webp', '100', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('342', '0', '1584689693', '1584689693', '/upload/xiaying/imgs/2020-03-20/1584689693495gzlb_title_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689693495gzlb_title_4 拷贝.webp', '101', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('343', '0', '1584689719', '1584689719', '/upload/xiaying/imgs/2020-03-20/1584689719724zzgz_tfmn_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689719724zzgz_tfmn_b_1 拷贝.webp', '100', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('344', '0', '1584689740', '1584689740', '/upload/xiaying/imgs/2020-03-20/1584689740595zzgz_tfmn_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689740595zzgz_tfmn_b_2 拷贝.webp', '100', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('345', '0', '1584689747', '1584689747', '/upload/xiaying/imgs/2020-03-20/1584689747904zzgz_tfmn_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689747904zzgz_tfmn_b_3 拷贝.webp', '100', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('346', '0', '1584689750', '1584689750', '/upload/xiaying/imgs/2020-03-20/1584689750639gzlb_b_10 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689750639gzlb_b_10 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('347', '0', '1584689769', '1584689769', '/upload/xiaying/imgs/2020-03-20/1584689769038gzlb_b_10 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689769038gzlb_b_10 拷贝.webp', '101', '1', '2019年1月，下应街道主要领导与相关村（社区）负责人召开会议，街道党工委书记夏国芬高度重视退役军人服务工作，强调要把退役军人服务工作做实、做细、做好。', null, null, '5');
INSERT INTO `xy_picture` VALUES ('348', '0', '1584689926', '1584689926', '/upload/xiaying/imgs/2020-03-20/1584689926481gzlb_b_12 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689926481gzlb_b_12 拷贝.webp', '101', '1', '“警卫无小事，事事连政治”，下应街道退役军人金志成在2014年服役期间，参加警卫任务出任前动员会。在部队服役期间，金志成多次参加警卫任务。', null, null, '4');
INSERT INTO `xy_picture` VALUES ('349', '0', '1584689931', '1584689931', '/upload/xiaying/imgs/2020-03-20/1584689931476jsxl_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584689931476jsxl_title_3 拷贝.webp', '102', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('350', '0', '1584690054', '1584690054', '/upload/xiaying/imgs/2020-03-20/1584690054807gzlb_b_14 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690054807gzlb_b_14 拷贝.webp', '101', '1', '2017年八一建军节前夕，下应街道办事处主任郁柏其、武装部长张亚平对区人武装部军人进行走访慰问，了解、倾听区人武装部驻军的思想生活状况，为他们排忧解难。', null, null, '3');
INSERT INTO `xy_picture` VALUES ('351', '0', '1584690055', '1584690055', '/upload/xiaying/imgs/2020-03-20/1584690055018jsxl_b_7 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690055018jsxl_b_7 拷贝.webp', '102', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('352', '0', '1584690063', '1584690063', '/upload/xiaying/imgs/2020-03-20/1584690063111jsxl_b_8 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690063111jsxl_b_8 拷贝.webp', '102', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('353', '0', '1584690073', '1584690073', '/upload/xiaying/imgs/2020-03-20/1584690073831jsxl_b_9 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690073831jsxl_b_9 拷贝.webp', '102', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('354', '0', '1584690153', '1584690153', '/upload/xiaying/imgs/2020-03-20/1584690153848zbingz_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690153848zbingz_title_2 拷贝.webp', '103', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('355', '0', '1584690212', '1584690212', '/upload/xiaying/imgs/2020-03-20/1584690212878zbingz_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690212878zbingz_title_3 拷贝.webp', '104', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('356', '0', '1584690318', '1584690318', '/upload/xiaying/imgs/2020-03-20/1584690318104zbingz_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690318104zbingz_b_4 拷贝.webp', '58', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('357', '0', '1584690328', '1584690328', '/upload/xiaying/imgs/2020-03-20/1584690328629zbingz_b_8 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690328629zbingz_b_8 拷贝.webp', '58', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('358', '0', '1584690361', '1584690361', '/upload/xiaying/imgs/2020-03-20/1584690361225zbingz_b_9 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690361225zbingz_b_9 拷贝.webp', '103', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('359', '0', '1584690368', '1584690368', '/upload/xiaying/imgs/2020-03-20/1584690368456zbingz_b_10 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690368456zbingz_b_10 拷贝.webp', '103', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('360', '0', '1584690439', '1584690439', '/upload/xiaying/imgs/2020-03-20/1584690439546zbingz_b_11 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690439546zbingz_b_11 拷贝.webp', '104', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('361', '0', '1584690460', '1584690460', '/upload/xiaying/imgs/2020-03-20/1584690460219zbingz_b_13 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690460219zbingz_b_13 拷贝.webp', '104', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('362', '0', '1584690492', '1584690492', '/upload/xiaying/imgs/2020-03-20/1584690492365zbingz_b_12 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690492365zbingz_b_12 拷贝.webp', '104', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('363', '0', '1584690584', '1584690584', '/upload/xiaying/imgs/2020-03-20/1584690584535zzjs_b_1 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690584535zzjs_b_1 拷贝.webp', '105', '1', '', null, null, '6');
INSERT INTO `xy_picture` VALUES ('364', '0', '1584690591', '1584690591', '/upload/xiaying/imgs/2020-03-20/1584690591845zzjs_b_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690591845zzjs_b_2 拷贝.webp', '105', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('365', '0', '1584690599', '1584690599', '/upload/xiaying/imgs/2020-03-20/1584690599420zzjs_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690599420zzjs_b_3 拷贝.webp', '105', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('366', '0', '1584690608', '1584690608', '/upload/xiaying/imgs/2020-03-20/1584690608091zzjs_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690608091zzjs_b_4 拷贝.webp', '105', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('367', '0', '1584690615', '1584690615', '/upload/xiaying/imgs/2020-03-20/1584690615076zzjs_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690615076zzjs_b_5 拷贝.webp', '105', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('368', '0', '1584690615', '1584690615', '/upload/xiaying/imgs/2020-03-20/1584690615393gzlb_b_16 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690615393gzlb_b_16 拷贝.webp', '101', '1', '2018年12月，下应街道组织退役军人到余姚市四门镇退役军人服务站进行参观学习。图为退役军人正在认真参观服务站陈列展览。', null, null, '2');
INSERT INTO `xy_picture` VALUES ('369', '0', '1584690622', '1584690622', '/upload/xiaying/imgs/2020-03-20/1584690622692zzjs_b_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690622692zzjs_b_6 拷贝.webp', '105', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('370', '0', '1584690750', '1584690750', '/upload/xiaying/imgs/2020-03-20/1584690750884gzlb_b_18 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690750884gzlb_b_18 拷贝.webp', '101', '1', '2017年9月，下应街道举行新兵入伍欢送会，部分往届老兵为新兵讲述部队生活，街道党工委书记夏国芬勉励新兵脚踏实地，在部队磨砺自己，为国防建设贡献自己的力量。', null, null, '1');
INSERT INTO `xy_picture` VALUES ('371', '0', '1584690955', '1584690955', '/upload/xiaying/imgs/2020-03-20/1584690955918zcwj_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690955918zcwj_title_2 拷贝.webp', '106', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('372', '0', '1584690978', '1584690978', '/upload/xiaying/imgs/2020-03-20/1584690978403zcwj_b_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690978403zcwj_b_3 拷贝.webp', '106', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('373', '0', '1584690980', '1584690980', '/upload/xiaying/imgs/2020-03-20/1584690980053gzlb_title_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690980053gzlb_title_5 拷贝.webp', '107', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('374', '0', '1584690987', '1584690987', '/upload/xiaying/imgs/2020-03-20/1584690987220zcwj_b_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584690987220zcwj_b_4 拷贝.webp', '106', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('375', '0', '1584691002', '1584691002', '/upload/xiaying/imgs/2020-03-20/1584691002264zcwj_title_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691002264zcwj_title_3 拷贝.webp', '108', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('376', '0', '1584691005', '1584691005', '/upload/xiaying/imgs/2020-03-20/1584691005187gzlb_b_20 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691005187gzlb_b_20 拷贝.webp', '107', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('377', '0', '1584691009', '1584691009', '/upload/xiaying/imgs/2020-03-20/1584691009411gzlb_b_21 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691009411gzlb_b_21 拷贝.webp', '107', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('378', '0', '1584691012', '1584691012', '/upload/xiaying/imgs/2020-03-20/1584691012972zcwj_b_5 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691012972zcwj_b_5 拷贝.webp', '108', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('379', '0', '1584691014', '1584691014', '/upload/xiaying/imgs/2020-03-20/1584691014506gzlb_b_22 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691014506gzlb_b_22 拷贝.webp', '107', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('380', '0', '1584691020', '1584691020', '/upload/xiaying/imgs/2020-03-20/1584691020367zcwj_b_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691020367zcwj_b_6 拷贝.webp', '108', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('381', '0', '1584691027', '1584691027', '/upload/xiaying/imgs/2020-03-20/1584691027598zcwj_b_7 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691027598zcwj_b_7 拷贝.webp', '108', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('382', '0', '1584691039', '1584691039', '/upload/xiaying/imgs/2020-03-20/1584691039460gzlb_title_6 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691039460gzlb_title_6 拷贝.webp', '109', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('383', '0', '1584691041', '1584691041', '/upload/xiaying/imgs/2020-03-20/1584691041552zcwj_title_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691041552zcwj_title_4 拷贝.webp', '110', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('384', '0', '1584691051', '1584691051', '/upload/xiaying/imgs/2020-03-20/1584691051870zcwj_b_8 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691051870zcwj_b_8 拷贝.webp', '110', '1', '', null, null, '7');
INSERT INTO `xy_picture` VALUES ('385', '0', '1584691058', '1584691058', '/upload/xiaying/imgs/2020-03-20/1584691058621zcwj_b_9 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691058621zcwj_b_9 拷贝.webp', '110', '1', '', null, null, '6');
INSERT INTO `xy_picture` VALUES ('386', '0', '1584691064', '1584691064', '/upload/xiaying/imgs/2020-03-20/1584691064992gzlb_b_23 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691064992gzlb_b_23 拷贝.webp', '109', '1', null, null, null, '9');
INSERT INTO `xy_picture` VALUES ('387', '0', '1584691065', '1584691065', '/upload/xiaying/imgs/2020-03-20/1584691065756zcwj_b_10 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691065756zcwj_b_10 拷贝.webp', '110', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('388', '0', '1584691069', '1584691069', '/upload/xiaying/imgs/2020-03-20/1584691069473gzlb_b_24 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691069473gzlb_b_24 拷贝.webp', '109', '1', null, null, null, '8');
INSERT INTO `xy_picture` VALUES ('389', '0', '1584691073', '1584691073', '/upload/xiaying/imgs/2020-03-20/1584691073186zcwj_b_11 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691073186zcwj_b_11 拷贝.webp', '110', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('390', '0', '1584691073', '1584691073', '/upload/xiaying/imgs/2020-03-20/1584691073228gzlb_b_25 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691073228gzlb_b_25 拷贝.webp', '109', '1', null, null, null, '7');
INSERT INTO `xy_picture` VALUES ('391', '0', '1584691076', '1584691076', '/upload/xiaying/imgs/2020-03-20/1584691076667gzlb_b_26 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691076667gzlb_b_26 拷贝.webp', '109', '1', null, null, null, '6');
INSERT INTO `xy_picture` VALUES ('392', '0', '1584691080', '1584691080', '/upload/xiaying/imgs/2020-03-20/1584691080079zcwj_b_12 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691080079zcwj_b_12 拷贝.webp', '110', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('393', '0', '1584691080', '1584691080', '/upload/xiaying/imgs/2020-03-20/1584691080590gzlb_b_27 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691080590gzlb_b_27 拷贝.webp', '109', '1', null, null, null, '5');
INSERT INTO `xy_picture` VALUES ('394', '0', '1584691083', '1584691083', '/upload/xiaying/imgs/2020-03-20/1584691083804gzlb_b_28 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691083804gzlb_b_28 拷贝.webp', '109', '1', null, null, null, '4');
INSERT INTO `xy_picture` VALUES ('395', '0', '1584691087', '1584691087', '/upload/xiaying/imgs/2020-03-20/1584691087217gzlb_b_29 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691087217gzlb_b_29 拷贝.webp', '109', '1', null, null, null, '3');
INSERT INTO `xy_picture` VALUES ('396', '0', '1584691087', '1584691087', '/upload/xiaying/imgs/2020-03-20/1584691087773zcwj_b_13 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691087773zcwj_b_13 拷贝.webp', '110', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('397', '0', '1584691090', '1584691090', '/upload/xiaying/imgs/2020-03-20/1584691090632gzlb_b_30 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691090632gzlb_b_30 拷贝.webp', '109', '1', null, null, null, '2');
INSERT INTO `xy_picture` VALUES ('398', '0', '1584691094', '1584691094', '/upload/xiaying/imgs/2020-03-20/1584691094773gzlb_b_31 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691094773gzlb_b_31 拷贝.webp', '109', '1', null, null, null, '1');
INSERT INTO `xy_picture` VALUES ('399', '0', '1584691095', '1584691095', '/upload/xiaying/imgs/2020-03-20/1584691095519zcwj_b_14 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584691095519zcwj_b_14 拷贝.webp', '110', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('400', '0', '1584695194', '1584695194', '/upload/xiaying/imgs/2020-03-20/1584695194153gk_wz_title.webp', '/upload/xiaying/imgs/2020-03-20/1584695194153gk_wz_title.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('401', '0', '1584695556', '1584695556', '/upload/xiaying/imgs/2020-03-20/1584695556949gk_wz_jiedai9.webp', '/upload/xiaying/imgs/2020-03-20/1584695556949gk_wz_jiedai9.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('402', '0', '1584695562', '1584695562', '/upload/xiaying/imgs/2020-03-20/1584695562214gk_wz_laifang.webp', '/upload/xiaying/imgs/2020-03-20/1584695562214gk_wz_laifang.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('403', '1', '1584695596', '1584695596', '/upload/xiaying/imgs/2020-03-20/1584695596014gk_wz_jiedai9.webp', '/upload/xiaying/imgs/2020-03-20/1584695596014gk_wz_jiedai9.webp', '112', '2', '', '', '1', '0');
INSERT INTO `xy_picture` VALUES ('404', '0', '1584697402', '1584697402', '/upload/xiaying/imgs/2020-03-20/1584697402734lgjr_p_16 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584697402734lgjr_p_16 拷贝.webp', '113', '2', '1972年2月出生，现居下应街道海创社区，于1991年入伍，2008年退伍，期间荣获三等功1次。', '林咸立', '1', '0');
INSERT INTO `xy_picture` VALUES ('405', '0', '1584697481', '1584697481', '/upload/xiaying/imgs/2020-03-20/1584697481108jrxq_title.webp', '/upload/xiaying/imgs/2020-03-20/1584697481108jrxq_title.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('406', '0', '1584697484', '1584697484', '/upload/xiaying/imgs/2020-03-20/1584697484793lgjr_p_12.webp', '/upload/xiaying/imgs/2020-03-20/1584697484793lgjr_p_12.webp', '114', '2', '1976年11月出生，现居下应街道海创社区，于1996年入伍，2013年退伍，期间荣获三等功1次。', '潘月光', '1', '0');
INSERT INTO `xy_picture` VALUES ('407', '1', '1584697526', '1584697526', '/upload/xiaying/imgs/2020-03-20/1584697526778jrxq_x12_3.webp', '/upload/xiaying/imgs/2020-03-20/1584697526778jrxq_x12_3.webp', '115', '2', 'q', 'q', '1', '0');
INSERT INTO `xy_picture` VALUES ('408', '0', '1584697554', '1584697554', '/upload/xiaying/imgs/2020-03-20/1584697554975jrxq_x12_1.webp', '/upload/xiaying/imgs/2020-03-20/1584697554975jrxq_x12_1.webp', '114', '1', '', null, null, '6');
INSERT INTO `xy_picture` VALUES ('409', '0', '1584697559', '1584697559', '/upload/xiaying/imgs/2020-03-20/1584697559865jrxq_x12_2.webp', '/upload/xiaying/imgs/2020-03-20/1584697559865jrxq_x12_2.webp', '114', '1', '', null, null, '5');
INSERT INTO `xy_picture` VALUES ('410', '0', '1584697564', '1584697564', '/upload/xiaying/imgs/2020-03-20/1584697564718jrxq_x12_3.webp', '/upload/xiaying/imgs/2020-03-20/1584697564718jrxq_x12_3.webp', '114', '1', '', null, null, '4');
INSERT INTO `xy_picture` VALUES ('411', '0', '1584697569', '1584697569', '/upload/xiaying/imgs/2020-03-20/1584697569413jrxq_x12_4.webp', '/upload/xiaying/imgs/2020-03-20/1584697569413jrxq_x12_4.webp', '114', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('412', '0', '1584697573', '1584697573', '/upload/xiaying/imgs/2020-03-20/1584697573847jrxq_x12_5.webp', '/upload/xiaying/imgs/2020-03-20/1584697573847jrxq_x12_5.webp', '114', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('413', '0', '1584697577', '1584697577', '/upload/xiaying/imgs/2020-03-20/1584697577618jrxq_x12_6.webp', '/upload/xiaying/imgs/2020-03-20/1584697577618jrxq_x12_6.webp', '114', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('414', '0', '1584697598', '1584697598', '/upload/xiaying/imgs/2020-03-20/1584697598593jrxq_x16_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584697598593jrxq_x16_2 拷贝.webp', '113', '1', '', null, null, '3');
INSERT INTO `xy_picture` VALUES ('415', '0', '1584697603', '1584697603', '/upload/xiaying/imgs/2020-03-20/1584697603618jrxq_x16_3 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584697603618jrxq_x16_3 拷贝.webp', '113', '1', '', null, null, '2');
INSERT INTO `xy_picture` VALUES ('416', '0', '1584697608', '1584697608', '/upload/xiaying/imgs/2020-03-20/1584697608137jrxq_x16_4 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/1584697608137jrxq_x16_4 拷贝.webp', '113', '1', '', null, null, '1');
INSERT INTO `xy_picture` VALUES ('417', '0', '1584712875', '1584712875', '/upload/xiaying/imgs/2020-03-20/15847128755501584689876179jsxl_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/15847128755501584689876179jsxl_title_2 拷贝.webp', null, null, null, null, null, null);
INSERT INTO `xy_picture` VALUES ('418', '1', '1584712888', '1584712888', '/upload/xiaying/imgs/2020-03-20/15847128886551584694852442lgjr_p_12.webp', '/upload/xiaying/imgs/2020-03-20/15847128886551584694852442lgjr_p_12.webp', '116', '2', '个人三等功', '张国才', '1', '0');
INSERT INTO `xy_picture` VALUES ('419', '1', '1584713010', '1584713010', '/upload/xiaying/imgs/2020-03-20/15847130107231584689876179jsxl_title_2 拷贝.webp', '/upload/xiaying/imgs/2020-03-20/15847130107231584689876179jsxl_title_2 拷贝.webp', '116', '1', '训练标兵', null, null, '1');
INSERT INTO `xy_picture` VALUES ('420', '1', '1585059487', '1585059487', '/upload/xiaying/imgs/2020-03-24/1585059487704照片.webp', '/upload/xiaying/imgs/2020-03-24/1585059487704照片.webp', '117', '2', '集体二等功', '沈立功', '1', '0');
INSERT INTO `xy_picture` VALUES ('421', '1', '1585059559', '1585059559', '/upload/xiaying/imgs/2020-03-24/1585059559065照片2.webp', '/upload/xiaying/imgs/2020-03-24/1585059559065照片2.webp', '117', '1', '二等功勋章', null, null, '1');
INSERT INTO `xy_picture` VALUES ('422', '1', '1585059747', '1585059747', '/upload/xiaying/imgs/2020-03-24/1585059747270照片2.webp', '/upload/xiaying/imgs/2020-03-24/1585059747270照片2.webp', '118', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('423', '1', '1585059775', '1585059775', '/upload/xiaying/imgs/2020-03-24/1585059775979照片欢送.webp', '/upload/xiaying/imgs/2020-03-24/1585059775979照片欢送.webp', '118', '1', '集体留念', null, null, '1');
INSERT INTO `xy_picture` VALUES ('424', '1', '1585119528', '1585119528', '/upload/xiaying/imgs/2020-03-25/1585119528151照片.webp', '/upload/xiaying/imgs/2020-03-25/1585119528151照片.webp', '119', '2', '集体共', '张三', '1', '0');
INSERT INTO `xy_picture` VALUES ('425', '1', '1585119585', '1585119585', '/upload/xiaying/imgs/2020-03-25/1585119585154照片2.webp', '/upload/xiaying/imgs/2020-03-25/1585119585154照片2.webp', '119', '1', '三等功', null, null, '1');
INSERT INTO `xy_picture` VALUES ('426', '1', '1585119755', '1585119755', '/upload/xiaying/imgs/2020-03-25/1585119755094照片欢送.webp', '/upload/xiaying/imgs/2020-03-25/1585119755094照片欢送.webp', '120', '2', null, null, '1', '0');
INSERT INTO `xy_picture` VALUES ('427', '1', '1585119805', '1585119805', '/upload/xiaying/imgs/2020-03-25/1585119805045照片欢送.webp', '/upload/xiaying/imgs/2020-03-25/1585119805045照片欢送.webp', '120', '1', '欢送新兵', null, null, '1');

-- ----------------------------
-- Table structure for xy_user
-- ----------------------------
DROP TABLE IF EXISTS `xy_user`;
CREATE TABLE `xy_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xy_user
-- ----------------------------
INSERT INTO `xy_user` VALUES ('1');
INSERT INTO `xy_user` VALUES ('2');

-- ----------------------------
-- Table structure for xy_version
-- ----------------------------
DROP TABLE IF EXISTS `xy_version`;
CREATE TABLE `xy_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xy_version
-- ----------------------------
INSERT INTO `xy_version` VALUES ('1');
INSERT INTO `xy_version` VALUES ('2');

-- ----------------------------
-- Table structure for xy_video
-- ----------------------------
DROP TABLE IF EXISTS `xy_video`;
CREATE TABLE `xy_video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `videourl` varchar(256) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `createtime` bigint(20) DEFAULT NULL,
  `updatetime` bigint(20) DEFAULT NULL,
  `type` int(4) DEFAULT '1',
  `md5` varchar(50) DEFAULT NULL,
  `sn` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xy_video
-- ----------------------------
INSERT INTO `xy_video` VALUES ('2', '/videos/xiaying/MainConceptEncoded-sample.mpg', '0', '1584685134', '1584685134', '1', 'f4da4646aa0236bae1525cc76e4217ec', 'xiaying');
