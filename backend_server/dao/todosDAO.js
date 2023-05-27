import mongodb from "mongodb";
const ObjectId = mongodb.ObjectId;

let todos;

export default class TodosDAO {
  static async injectDB(conn) {
    if (todos) {
      return;
    }
    try {
      todos = await conn.db(process.env.MONGO_NS).collection("Todos");
    } catch (e) {
      console.error(
        `Unable to establish a collection handle in tasksDAO: ${e}`
      );
    }
  }

  static async getTodos(id) {
    let cursor;
    try {
      cursor = await todos.find({ user_id: id });

      return await cursor.toArray();
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { details: [] };
    }
  }

  static async addTodo(id, description, created, due, tag) {
    try {
      const todoDoc = {
        user_id: id,
        description: description,
        created: created,
        due: due,
        status: "pending",
        completed_on: null,
        tag: tag,
      };
      return await todos.insertOne(todoDoc);
    } catch (e) {
      console.error(`Unable to add todo: ${e}`);
      return { Error: e };
    }
  }

  //mark as completed
  static async updateTodo(id, completedOn) {
    try {
      const updateResponse = await todos.updateOne(
        { _id: ObjectId(id) },
        {
          $set: {
            status: "done",
            completed_on: completedOn,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update todo: ${e}`);
      return { Error: e };
    }
  }

  static async deleteTodo(id) {
    try {
      const deleteResponse = await todos.deleteOne({
        _id: ObjectId(id),
      });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete todo: ${e}`);
      return { Error: e };
    }
  }
}
