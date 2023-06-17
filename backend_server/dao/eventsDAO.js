import mongodb from "mongodb";
const ObjectId = mongodb.ObjectId;

let events;

export default class EventsDAO {
  static async injectDB(conn) {
    if (events) {
      return;
    }
    try {
      events = await conn.db(process.env.MONGO_NS).collection("Events");
    } catch (e) {
      console.error(
        `Unable to establish a collection handle in eventsDAO: ${e}`
      );
    }
  }

  static async getEvents(email) {
    let cursor;
    try {
      cursor = await events.find({ user: email });

      return await cursor.toArray();
    } catch (e) {
      console.error(`Unable to issue find command, ${e}`);
      return { details: [] };
    }
  }

  static async addEvent(
    email,
    startTime,
    endTime,
    subject,
    color,
    isAllDay
  ) {
    try {
      const eventDoc = {
        user: email,
        start_time: startTime,
        end_time: endTime,
        subject: subject,
        color: color,
        is_all_day: isAllDay,
      };
      const result = await events.insertOne(eventDoc);
      const insertedId = result.insertedId;
      const addedDocument = await events.findOne({ _id: insertedId });

      return addedDocument;
    } catch (e) {
      console.error(`Unable to add event: ${e}`);
      return { Error: e };
    }
  }

//   static async updateNote(id, title, note, isHidden, isFavourite, accessed_on) {
//     try {
//       const updateResponse = await events.updateOne(
//         { _id: ObjectId(id) },
//         {
//           $set: {
//             title: title,
//             note: note,
//             isHidden: isHidden,
//             isFavourite: isFavourite,
//             accessed_on: accessed_on,
//           },
//         }
//       );
//       return updateResponse;
//     } catch (e) {
//       console.error(`Unable to update todo: ${e}`);
//       return { Error: e };
//     }
//   }

  static async deleteEvent(id) {
    try {
      const deleteResponse = await events.deleteOne({
        _id: ObjectId(id),
      });
      return deleteResponse;
    } catch (e) {
      console.error(`Unable to delete todo: ${e}`);
      return { Error: e };
    }
  }
}
