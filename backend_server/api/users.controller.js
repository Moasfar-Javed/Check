import UsersDAO from "../dao/usersDAO.js";

export default class UsersController {
  static async apiGetUser(req, res, next) {
    const email = req.query.email;

    const details = await UsersDAO.getUser(email);
    let response = details;

    res.json(response);
  }

  static async apiPostUser(req, res, next) {
    try {
      const username = req.body.username.toLowerCase();
      const email = req.body.email;
      const pin = req.body.pin;
      const userResponse = await UsersDAO.addUser(username, email, pin);
      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiPutUser(req, res, next) {
    try {
      const username = req.body.username.toLowerCase();
      const notesPin = req.body.pin;
      const userResponse = await UsersDAO.updateUser(req.query.email, username, notesPin);

      var { error } = userResponse;
      if (error) {
        res.status(400).json({ error });
      }

      if (userResponse.modifiedCount === 0) {
        throw new Error("Unable to update user");
      }

      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiDeleteUser(req, res, next) {
    try {
      const email = req.query.email;
      const userResponse = await UsersDAO.deleteUser(email);
      res.json({ Status: "success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }
}
