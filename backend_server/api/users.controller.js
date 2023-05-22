import UsersDAO from "../dao/usersDAO.js";

export default class UsersController {
  static async apiGetUser(req, res, next) {
    const email = req.query.email;
    const password = req.query.password;

    const { details } = await UsersDAO.getUser(email, password);
    let response = { details };

    res.json(response);
  }

  static async apiPostUser(req, res, next) {
    try {
      const username = req.body.username.toLowerCase();
      const email = req.body.email;
      const password = req.body.password;

      const userResponse = await UsersDAO.addUser(
        username,
        email,
        password
      );
      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiPutUser(req, res, next) {
    try {
      const username = req.body.username.toLowerCase();
      const email = req.body.email;
      const password = req.body.password;
      const userResponse = await UsersDAO.updateUser(
        req.query.id,
        username,
        email,
        password
      );

      var { error } = userResponse;
      if (error) {
        res.status(400).json({ error });
      }

      if (userResponse.modifiedCount === 0) {
        throw new Error("Unable to update employee");
      }

      res.json({ Status: "Success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }

  static async apiDeleteUser(req, res, next) {
    try {
      const id = req.query.id;
      const userResponse = await UsersDAO.deleteUser(id);
      res.json({ Status: "success" });
    } catch (e) {
      res.status(500).json({ Error: e.message });
    }
  }
}
