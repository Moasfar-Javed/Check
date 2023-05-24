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

  static async getUser(email, password) {
    let cursor;
    try {
      cursor = await users.find({ email: email, password: password });

      //const details = await cursor.toArray();
      return  await cursor.toArray() 
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { details: [] };
    }
  }

  static async addUser(username, email, password) {
    try {
      const userDoc = {
        username: username,
        email: email,
        password: password,
      };
      return await users.insertOne(userDoc);
    } catch (e) {
      console.error(`Unable to add employee: ${e}`);
      return { Error: e };
    }
  }

  static async updateUser(id, username, email, password) {
    try {
      const updateResponse = await users.updateOne(
        { _id: ObjectId(id) },
        {
          $set: {
            username: username,
            email: email,
            password: password,
          },
        }
      );
      return updateResponse;
    } catch (e) {
      console.error(`Unable to update employee: ${e}`);
      return { Error: e };
    }
  }

  static async deleteUser(id) {
    try {
      const deleteResponse = await users.deleteOne({
        _id: ObjectId(id),
      });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete employee: ${e}`);
      return { Error: e };
    }
  }
}
