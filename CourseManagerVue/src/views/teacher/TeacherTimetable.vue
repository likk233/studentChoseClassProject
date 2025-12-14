<!--
 * @Description: 
 * @Author: Rabbiter
 * @Date: 2023-06-06 09:09:08
-->
<template>
  <div class="timetable-wrap">
    <div class="crumbs">
      <el-breadcrumb separator="/">
        <el-breadcrumb-item>
          <b style="font-size: 22px;"> 教师课表</b>
        </el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <div class="container">
      <time-table ref="timeTable"></time-table>
    </div>
  </div>
</template>

<script>
import * as api from "../../api/teacher/timetable";
import TimeTable from "../../components/TimeTable";

export default {
  name: "TeacherTimetable",
  components: { TimeTable },
  created() {
    api.get().then(res => {
      this.$refs.timeTable.updateData(res);
    });
  }
};
</script>

<style scoped></style>
