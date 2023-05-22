import express from "express";
import UsersCtrl from "./users.controller.js";

const router = express.Router();

router
  .route("/users")
  //localhost:5000/api/users?email=<xyz>&password=<xyz>
  .get(UsersCtrl.apiGetUser)
  //localhost:5000/api/users username, email, password in the body
  .post(UsersCtrl.apiPostUser)
  //localhost:5000/api/users?id=<xyz> username, email, password in the body
  .put(UsersCtrl.apiPutUser)
  //localhost:5000/api/users?id=<xyz>
  .delete(UsersCtrl.apiDeleteUser);

export default router;
