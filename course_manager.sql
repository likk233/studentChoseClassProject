/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : course_manager

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 08/12/2025 14:55:48
*/

DROP DATABASE IF EXISTS `course_manager`;
CREATE DATABASE `course_manager` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `course_manager`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for rc_admin
-- ----------------------------
DROP TABLE IF EXISTS `rc_admin`;
CREATE TABLE `rc_admin`  (
  `admin_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `admin_username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `admin_password` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `admin_privilege` int NOT NULL,
  PRIMARY KEY (`admin_id`) USING BTREE,
  UNIQUE INDEX `idx_admin_username`(`admin_username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_admin
-- ----------------------------
INSERT INTO `rc_admin` VALUES (1, 'admin', '123456', 255);

-- ----------------------------
-- Table structure for rc_class
-- ----------------------------
DROP TABLE IF EXISTS `rc_class`;
CREATE TABLE `rc_class`  (
  `class_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_major_id` int UNSIGNED NOT NULL,
  `class_grade` int UNSIGNED NOT NULL,
  `class_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`class_id`) USING BTREE,
  INDEX `fk_major_id`(`class_major_id` ASC) USING BTREE,
  INDEX `idx_class_name`(`class_name` ASC) USING BTREE,
  CONSTRAINT `rc_class_ibfk_1` FOREIGN KEY (`class_major_id`) REFERENCES `rc_major` (`major_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_class
-- ----------------------------
INSERT INTO `rc_class` VALUES (1, 1, 2023, '计科2301班');
INSERT INTO `rc_class` VALUES (2, 1, 2023, '计科2302班');
INSERT INTO `rc_class` VALUES (3, 4, 2023, '应用数学1班');
INSERT INTO `rc_class` VALUES (4, 4, 2023, '应用数学2班');
INSERT INTO `rc_class` VALUES (5, 5, 2023, '数学师范1班');
INSERT INTO `rc_class` VALUES (6, 5, 2023, '数学师范2班');
INSERT INTO `rc_class` VALUES (7, 2, 2023, '软件工程1班');
INSERT INTO `rc_class` VALUES (8, 2, 2023, '软件工程2班');
INSERT INTO `rc_class` VALUES (9, 3, 2023, '信息工程1班');
INSERT INTO `rc_class` VALUES (10, 3, 2023, '信息工程2班');
INSERT INTO `rc_class` VALUES (11, 6, 2023, '应用化学1班');
INSERT INTO `rc_class` VALUES (12, 6, 2023, '应用化学2班');
INSERT INTO `rc_class` VALUES (13, 7, 2023, '理论物理1班');
INSERT INTO `rc_class` VALUES (14, 7, 2023, '理论物理2班');

-- ----------------------------
-- Table structure for rc_course
-- ----------------------------
DROP TABLE IF EXISTS `rc_course`;
CREATE TABLE `rc_course`  (
  `course_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_teacher_id` int UNSIGNED NOT NULL,
  `course_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `course_grade` int UNSIGNED NOT NULL,
  `course_time` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `course_location` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `course_credit` int UNSIGNED NOT NULL,
  `course_selected_count` int UNSIGNED NOT NULL DEFAULT 0,
  `course_max_size` int UNSIGNED NOT NULL,
  `course_exam_date` datetime NULL DEFAULT NULL,
  `course_exam_location` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`course_id`) USING BTREE,
  INDEX `fk_course_teacher_id`(`course_teacher_id` ASC) USING BTREE,
  INDEX `idx_course_name`(`course_name` ASC) USING BTREE,
  CONSTRAINT `rc_course_ibfk_1` FOREIGN KEY (`course_teacher_id`) REFERENCES `rc_teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_course
-- ----------------------------
INSERT INTO `rc_course` VALUES (9, 1, 'Java程序设计', 2023, '2-2-2', '第一教学楼201', 2, 1, 50, NULL, '第一教学楼201');
INSERT INTO `rc_course` VALUES (10, 1, '计算机组成原理', 2023, '3-5-2', '第二教学楼502', 2, 1, 50, NULL, '第二教学楼502');
INSERT INTO `rc_course` VALUES (11, 1, '计算机网络', 2023, '5-3-2', '第一教学楼202', 2, 1, 50, NULL, '第一教学楼202');
INSERT INTO `rc_course` VALUES (12, 3, '计算机导论', 2023, '4-3-2', '第一教学楼513', 2, 0, 50, NULL, '第一教学楼204');
INSERT INTO `rc_course` VALUES (13, 4, '原子物理学', 2023, '2-2-2', '第五教学楼103', 3, 0, 50, NULL, '第五教学楼103');
INSERT INTO `rc_course` VALUES (14, 5, '波谱分析', 2023, '3-5-2', '第二教学楼302', 2, 0, 50, NULL, '第二教学楼301');

-- ----------------------------
-- Table structure for rc_department
-- ----------------------------
DROP TABLE IF EXISTS `rc_department`;
CREATE TABLE `rc_department`  (
  `department_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`department_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_department
-- ----------------------------
INSERT INTO `rc_department` VALUES (1, '计算机系');
INSERT INTO `rc_department` VALUES (2, '数学系');
INSERT INTO `rc_department` VALUES (3, '物理系');
INSERT INTO `rc_department` VALUES (4, '化学系');

-- ----------------------------
-- Table structure for rc_major
-- ----------------------------
DROP TABLE IF EXISTS `rc_major`;
CREATE TABLE `rc_major`  (
  `major_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `major_department_id` int UNSIGNED NOT NULL,
  `major_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`major_id`) USING BTREE,
  INDEX `fk_major_department_id`(`major_department_id` ASC) USING BTREE,
  INDEX `idx_major_name`(`major_name` ASC) USING BTREE,
  CONSTRAINT `rc_major_ibfk_1` FOREIGN KEY (`major_department_id`) REFERENCES `rc_department` (`department_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_major
-- ----------------------------
INSERT INTO `rc_major` VALUES (1, 1, '计算机科学与技术');
INSERT INTO `rc_major` VALUES (2, 1, '软件工程');
INSERT INTO `rc_major` VALUES (3, 1, '信息工程');
INSERT INTO `rc_major` VALUES (4, 2, '应用数学');
INSERT INTO `rc_major` VALUES (5, 2, '数学师范');
INSERT INTO `rc_major` VALUES (6, 4, '应用化学');
INSERT INTO `rc_major` VALUES (7, 3, '理论物理');

-- ----------------------------
-- Table structure for rc_option
-- ----------------------------
DROP TABLE IF EXISTS `rc_option`;
CREATE TABLE `rc_option`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `option_key` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '枚举键',
  `option_value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '枚举值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_option
-- ----------------------------
INSERT INTO `rc_option` VALUES (1, 'ALLOW_STUDENT_SELECT', 'true');
INSERT INTO `rc_option` VALUES (2, 'ALLOW_TEACHER_GRADE', 'true');

-- ----------------------------
-- Table structure for rc_student
-- ----------------------------
DROP TABLE IF EXISTS `rc_student`;
CREATE TABLE `rc_student`  (
  `student_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_class_id` int UNSIGNED NOT NULL,
  `student_number` char(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `student_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `student_password` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `student_email` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `student_birthday` datetime NULL DEFAULT NULL,
  `student_sex` tinyint UNSIGNED NOT NULL,
  `student_last_login_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`student_id`) USING BTREE,
  UNIQUE INDEX `idx_student_number`(`student_number` ASC) USING BTREE,
  INDEX `fk_student_class_id`(`student_class_id` ASC) USING BTREE,
  INDEX `idx_student_name`(`student_name` ASC) USING BTREE,
  CONSTRAINT `rc_student_ibfk_1` FOREIGN KEY (`student_class_id`) REFERENCES `rc_class` (`class_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_student
-- ----------------------------
INSERT INTO `rc_student` VALUES (1, 1, '202307300101', '李湘', '123456', '123@qq.com', '2005-08-18 16:00:00', 0, '2025-12-06 07:50:35');
INSERT INTO `rc_student` VALUES (2, 2, '202307300102', '张锋益', '123456', '193@qq.com', '2006-09-12 16:00:00', 1, NULL);
INSERT INTO `rc_student` VALUES (3, 7, '202307300103', '陈立农', '123456', '124@qq.com', '2005-12-12 16:00:00', 1, '2025-12-06 03:27:21');
INSERT INTO `rc_student` VALUES (4, 8, '202307300104', '张梦瑶', '123456', '167@qq.com', '2006-12-13 16:00:00', 0, NULL);
INSERT INTO `rc_student` VALUES (5, 9, '202307300105', '张伟', '123456', '198@qq.com', '2005-12-04 16:00:00', 1, NULL);
INSERT INTO `rc_student` VALUES (7, 11, '202307300107', '蔡徐坤', '123456', '836@qq.com', '2005-08-15 16:00:00', 1, NULL);
INSERT INTO `rc_student` VALUES (8, 12, '202307300108', '李欣然', '123456', '375@qq.com', '2005-12-19 16:00:00', 0, NULL);
INSERT INTO `rc_student` VALUES (9, 10, '202307300106', '柳茹', '123456', '284@qq.com', '2006-11-29 16:00:00', 0, NULL);

-- ----------------------------
-- Table structure for rc_student_course
-- ----------------------------
DROP TABLE IF EXISTS `rc_student_course`;
CREATE TABLE `rc_student_course`  (
  `sc_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `sc_student_id` int UNSIGNED NOT NULL,
  `sc_course_id` int UNSIGNED NOT NULL,
  `sc_daily_score` int UNSIGNED NULL DEFAULT NULL,
  `sc_exam_score` int UNSIGNED NULL DEFAULT NULL,
  `sc_score` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`sc_id`) USING BTREE,
  INDEX `fk_sc_course_id`(`sc_course_id` ASC) USING BTREE,
  INDEX `fk_sc_student_id`(`sc_student_id` ASC) USING BTREE,
  CONSTRAINT `rc_student_course_ibfk_1` FOREIGN KEY (`sc_course_id`) REFERENCES `rc_course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `rc_student_course_ibfk_2` FOREIGN KEY (`sc_student_id`) REFERENCES `rc_student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_student_course
-- ----------------------------
INSERT INTO `rc_student_course` VALUES (23, 1, 9, 40, 55, 95);
INSERT INTO `rc_student_course` VALUES (28, 1, 11, 30, 60, 90);
INSERT INTO `rc_student_course` VALUES (29, 1, 10, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for rc_teacher
-- ----------------------------
DROP TABLE IF EXISTS `rc_teacher`;
CREATE TABLE `rc_teacher`  (
  `teacher_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `teacher_department_id` int UNSIGNED NOT NULL,
  `teacher_number` char(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `teacher_name` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `teacher_password` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`teacher_id`) USING BTREE,
  UNIQUE INDEX `idx_teacher_number`(`teacher_number` ASC) USING BTREE,
  INDEX `fk_teacher_department_id`(`teacher_department_id` ASC) USING BTREE,
  CONSTRAINT `rc_teacher_ibfk_1` FOREIGN KEY (`teacher_department_id`) REFERENCES `rc_department` (`department_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rc_teacher
-- ----------------------------
INSERT INTO `rc_teacher` VALUES (1, 1, '202307300201', '张武', '123456');
INSERT INTO `rc_teacher` VALUES (2, 2, '202307300202', '杨方亮', '123456');
INSERT INTO `rc_teacher` VALUES (3, 1, '202307300203', '范丞丞', '123456');
INSERT INTO `rc_teacher` VALUES (4, 3, '202307300204', '梁立鑫', '123456');
INSERT INTO `rc_teacher` VALUES (5, 4, '202307300205', '王灏童', '123456');

SET FOREIGN_KEY_CHECKS = 1;
