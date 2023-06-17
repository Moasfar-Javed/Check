import EventsDAO from "../dao/eventsDAO.js";

export default class EventsControllerController {
  static async apiGetEvents(req, res, next) {
    const email = req.query.user;

    const details = await EventsDAO.getEvents(email);
    let response = details;

    res.json(response);
  }

  static async apiPostEvent(req, res, next) {
    try {
      const email = req.query.user;
      const startTime = req.body.start_time;
      const endTime = req.body.end_time;
      const subject = req.body.subject.toLowerCase();
      const color = req.body.color;
      const isAllDay = req.body.is_all_day;

      const eventResponse = await EventsDAO.addEvent(
        email,
        startTime,
        endTime,
        subject,
        color,
        isAllDay
      );
      res.json(eventResponse);
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  //   static async apiPutTodo(req, res, next) {
  //     try {
  //       const createdOn = req.body.completed_on;
  //       const todoResponse = await EventsDAO.updateTodo(req.query.id, createdOn);

  //       var { error } = todoResponse;
  //       if (error) {
  //         res.status(400).json({ error });
  //       }

  //       if (todoResponse.modifiedCount === 0) {
  //         throw new Error("Unable to update event");
  //       }

  //       res.json({ Status: "Success" });
  //     } catch (e) {
  //       res.status(500).json({ Error: e.message });
  //     }
  //   }

  static async apiDeleteEvent(req, res, next) {
    try {
      const id = req.query.id;
      const eventResponse = await EventsDAO.deleteEvent(id);
      res.json({ Status: "success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }
}
