

import mongodb from "mongodb";
const ObjectId = mongodb.ObjectId;

let users;

export default class UsersDAO {
  static async injectDB(conn) {
    if (users) {
      return;
    }
    try {
      users = await conn.db(process.env.MONGO_NS).collection("Users");

    } catch (e) {
      console.error(
        `Unable to establish a collection handle in usersDAO: ${e}`
      );
    }
  }

  static async getUser(email) {
    let cursor;
    try {
      cursor = await users.find({email: email});

      //const details = await cursor.toArray();
      return  await cursor.toArray() 
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { details: [] };
    }
  }

  static async addUser(username, email) {
    try {
      const userDoc = {
        username: username,
        email: email,
      };
      console.log(email)
      const result = await users.insertOne(userDoc);
      const insertedId = result.insertedId;
      const addedDocument = await users.findOne({ _id: insertedId });
      console.log(addedDocument)
      return addedDocument;
    } catch (e) {
      console.error(`Unable to add employee: ${e}`);
      return { Error: e };
    }
  }

  static async updateUser(username, email) {
    try {
      const updateResponse = await users.updateOne(
        { email: email },
        {
          $set: {
            username: username,
            email: email,
            },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update employee: ${e}`);
      return { Error: e };
    }
  }

  static async deleteUser(email) {
    try {
      const deleteResponse = await users.deleteOne({
        email: email,
      });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete employee: ${e}`);
      return { Error: e };
    }
  }
}
