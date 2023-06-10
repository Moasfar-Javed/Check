import express from "express";
import UsersController from "./users.controller.js";
import TodosController from "./todos.controller.js";
import NotesController from "./notes.controller.js";

const router = express.Router();

router
  .route("/users")
  //http://<host_ip>:5000/api/users?email=<xyz>
  .get(UsersController.apiGetUser)
  //http://<host_ip>:5000/api/users username, email in the body
  .post(UsersController.apiPostUser)
  //http://<host_ip>:5000/api/users?email=<xyz> username in the body
  .put(UsersController.apiPutUser)
  //http://<host_ip>:api/users?email=<xyz>
  .delete(UsersController.apiDeleteUser);

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
  
router
  .route("/notes")
  //http://<host_ip>:5000/api/notess?user=<xyz> (user is the user's email)
  .get(NotesController.apiGetNotes)
  //http://<host_ip>:5000/api/notes?user=<xyz> (user is the user's email)
  //title, note, isHidden, isFavourite, created_on, accessed_on in the body
  .post(NotesController.apiPostNote)
  //http://<host_ip>:5000/api/notes?id=<xyz> (id is the note id)
  //title, note, isHidden, isFavourite, accessed_on in the body
  .put(NotesController.apiPutNote)
  //http://<host_ip>:5000/api/notes?id=<xyz> (id is the note id)
  .delete(NotesController.apiDeleteNote);


export default router;
