import express from "express";
import UsersCtrl from "./users.controller.js";

const router = express.Router();

router
  .route("/users")
  //http://192.168.100.8:5000/api/users?email=<xyz>&password=<xyz>
  .get(UsersCtrl.apiGetUser)
  //http://192.168.100.8:5000/api/users username, email, password in the body
  .post(UsersCtrl.apiPostUser)
  //http://192.168.100.8:5000/api/users?id=<xyz> username, email, password in the body
  .put(UsersCtrl.apiPutUser)
  //http://192.168.100.8:api/users?id=<xyz>
  .delete(UsersCtrl.apiDeleteUser);

export default router;
