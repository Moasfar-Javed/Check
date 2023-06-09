import app from "./server.js";
import mongodb from "mongodb";
import dotenv from "dotenv";
import UsersDAO from "./dao/usersDAO.js";
import TodosDAO from "./dao/todosDAO.js";
import NotesDAO from "./dao/notesDAO.js";
import EventsDAO from "./dao/eventsDAO.js";


dotenv.config();

const MongoClient = mongodb.MongoClient;

const port = process.env.PORT || 8000;

MongoClient.connect(process.env.MONGO_DB_URI, {
  maxPoolSize: 50,
  wtimeoutMS: 2500,
  useNewUrlParser: true,
})
  .catch((err) => {
    console.error(err.stack);
    process.exit(1);
  })
  .then(async (client) => {
    await UsersDAO.injectDB(client);
    await TodosDAO.injectDB(client);
    await NotesDAO.injectDB(client);
    await EventsDAO.injectDB(client);
    //await LogisticsDAO.injectDB(client);
    app.listen(port, () => {
      console.log(`listening on port ${port}`);
    });
  });
