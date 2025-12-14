import { createApp } from "vue";
import ElementPlus, { ElMessage } from "element-plus";
import "element-plus/lib/theme-chalk/index.css";
import App from "./App.vue";
import router from "./router";
import "./assets/font/iconfont.css";
import store from "./store";
import { vueInstance } from "./common/ajax";
import { registerIconFontMixin } from "./common/initialize";

const app = createApp(App);
registerIconFontMixin(app);

app.use(router);
app.use(store);
app.use(ElementPlus);
app.config.globalProperties.$message = ElMessage;

vueInstance.store = store;
vueInstance.router = router;

app.mount("#app");
