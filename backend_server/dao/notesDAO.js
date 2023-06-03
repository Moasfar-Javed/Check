import mongodb from "mongodb";
const ObjectId = mongodb.ObjectId;

let notes;

export default class TodosDAO {
  static async injectDB(conn) {
    if (notes) {
      return;
    }
    try {
      notes = await conn.db(process.env.MONGO_NS).collection("Notes");
    } catch (e) {
      console.error(
        `Unable to establish a collection handle in tasksDAO: ${e}`
      );
    }
  }

  static async getNotes(email) {
    let cursor;
    try {
      cursor = await notes.find({ user: email });

      return await cursor.toArray();
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { details: [] };
    }
  }

  static async addNote(
    email,
    title,
    note,
    isHidden,
    isFavourite,
    created_on,
    accessed_on
  ) {
    try {
      const noteDoc = {
        user: email,
        title: title,
        note: note,
        isHidden: isHidden,
        isFavourite: isFavourite,
        created_on: created_on,
        accessed_on: accessed_on,
      };
      const result = await notes.insertOne(noteDoc);
      const insertedId = result.insertedId;
      const addedDocument = await notes.findOne({ _id: insertedId });

      return addedDocument;
    } catch (e) {
      console.error(`Unable to add todo: ${e}`);
      return { Error: e };
    }
  }

  //mark as completed
  static async updateNote(id, title, note, isHidden, isFavourite, accessed_on) {
    try {
      const updateResponse = await notes.updateOne(
        { _id: ObjectId(id) },
        {
          $set: {
            title: title,
            note: note,
            isHidden: isHidden,
            isFavourite: isFavourite,
            accessed_on: accessed_on,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update todo: ${e}`);
      return { Error: e };
    }
  }

  static async deleteNote(id) {
    try {
      const deleteResponse = await notes.deleteOne({
        _id: ObjectId(id),
      });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete todo: ${e}`);
      return { Error: e };
    }
  }
}