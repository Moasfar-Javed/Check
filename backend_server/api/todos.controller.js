import TodosDAO from "../dao/todosDAO.js";

export default class TodosController {
  static async apiGetTodos(req, res, next) {
    const email = req.query.email;

    const details = await TodosDAO.getTodos(email);
    let response = details;

    res.json(response);
  }

  static async apiPostTodo(req, res, next) {
    try {
      const email = req.query.email;
      const description = req.body.description.toLowerCase();
      const created = req.body.created;
      const due = req.body.due;
      const tag = req.body.tag.toLowerCase();

      const todoResponse = await TodosDAO.addTodo(
        email,
        description,
        created,
        due,
        tag
      );
      res.json(todoResponse);
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiPutTodo(req, res, next) {
    try {
      const createdOn = req.body.completed_on;
      const todoResponse = await TodosDAO.updateTodo(req.query.id, createdOn);

      var { error } = todoResponse;
      if (error) {
        res.status(400).json({ error });
      }

      if (todoResponse.modifiedCount === 0) {
        throw new Error("Unable to update todo");
      }

      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiDeleteTodo(req, res, next) {
    try {
      const id = req.query.id;
      const todoResponse = await TodosDAO.deleteTodo(id);
      res.json({ Status: "success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }
}
