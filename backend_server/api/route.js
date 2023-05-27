import express from "express";
import UsersCtrl from "./users.controller.js";
import TodosController from "./todos.controller.js";

const router = express.Router();

router
  .route("/users")
  //http://<host_ip>:5000/api/users?email=<xyz>&password=<xyz>
  .get(UsersCtrl.apiGetUser)
  //http://<host_ip>:5000/api/users username, email, password in the body
  .post(UsersCtrl.apiPostUser)
  //http://<host_ip>:5000/api/users?id=<xyz> username, email, password in the body
  .put(UsersCtrl.apiPutUser)
  //http://<host_ip>:api/users?id=<xyz>
  .delete(UsersCtrl.apiDeleteUser);

router
  .route("/todos")
  //http://<host_ip>:5000/api/todos?id=<xyz> (id is the users id)
  .get(TodosController.apiGetTodos)
  //http://<host_ip>:5000/api/todos?id=<xyz> (id is the users id)
  //description, created, due, tag in the body
  .post(TodosController.apiPostTodo)
  //http://<host_ip>:5000/api/todos?id=<xyz> (id is the todo id)
  //completed_on in the body
  .put(TodosController.apiPutTodo)
  //http://<host_ip>:5000/api/todos?id=<xyz> (id is the todo id)
  .delete(TodosController.apiDeleteTodo);
  

export default router;
