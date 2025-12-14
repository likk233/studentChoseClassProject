/*
 * @Description: 
 * @Author: Rabbiter
 * @Date: 2023-07-08 21:30:02
 */
module.exports = {
    lintOnSave: false, // 关闭eslint校验
    devServer: {
        host: "127.0.0.1",
        port: 3000,
        // 关闭 eslint 报错/警告的浏览器遮罩层
        client: {
            overlay: false
        }
    }
};


