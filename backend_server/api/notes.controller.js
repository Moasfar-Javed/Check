import NotesDAO from "../dao/notesDAO.js";

export default class NotesController {
  static async apiGetNotes(req, res, next) {
    const user = req.query.user;

    const details = await NotesDAO.getNotes(user);
    let response = details;

    res.json(response);
  }

  static async apiPostNote(req, res, next) {
    try {
      const email = req.query.user;
      const title = req.body.title;
      const note = req.body.note;
      const isHidden = req.body.isHidden;
      const isFavourite = req.body.isFavourite;
      const created_on = req.body.created_on;
      const accessed_on = req.body.accessed_on;

      const noteResponse = await NotesDAO.addNote(
        email,
        title,
        note,
        isHidden,
        isFavourite,
        created_on,
        accessed_on
      );
      res.json(noteResponse);
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiPutNote(req, res, next) {
    try {
      const title = req.body.title;
      const note = req.body.note;
      const isHidden = req.body.isHidden;
      const isFavourite = req.body.isFavourite;
      const accessed_on = req.body.accessed_on;
      const noteResponse = await NotesDAO.updateNote(
        req.query.id,
        title,
        note,
        isHidden,
        isFavourite,
        accessed_on
      );

      var { error } = noteResponse;
      if (error) {
        res.status(400).json({ error });
      }

      if (noteResponse.modifiedCount === 0) {
        throw new Error("Unable to update todo");
      }

      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiDeleteNote(req, res, next) {
    try {
      const id = req.query.id;
      const todoResponse = await NotesDAO.deleteNote(id);
      res.json({ Status: "success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }
}
