import express from "express";
import { Server } from "socket.io";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { NFC } from "nfc-pcsc";

const app = express();
const server = app.listen(3001, () => {
  console.log("Server started on port 3001");
});

const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

const nfc = new NFC();

const __dirname = dirname(fileURLToPath(import.meta.url));
console.log(__dirname);

app.get("/", (req, res) => {
  res.sendFile(join(__dirname, "index.html"));
});

nfc.on("reader", (reader) => {
  console.log(`${reader.reader.name} device attached`);

  reader.on("card", (card) => {
    const cardData = {
      type: card.type,
      standard: card.standard,
      uid: card.uid || null,
      data: card.data || null,
    };

    console.log(`${reader.reader.name} card detected`, cardData);
    io.emit("card_detected", cardData);
  });

  reader.on("card.off", (card) => {
    console.log(`${reader.reader.name} card removed`, card);
  });

  reader.on("error", (err) => {
    console.error(`${reader.reader.name} an error occurred`, err);
  });

  reader.on("end", () => {
    console.log(`${reader.reader.name} device removed`);
  });
});

nfc.on("error", (err) => {
  console.error("an error occurred", err);
});

io.on("connection", (socket) => {
  console.log("A user connected");

  socket.on("disconnect", () => {
    console.log("A user disconnected");
  });
});
