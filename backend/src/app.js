import express, { json } from 'express';
import { NFC } from 'nfc-pcsc';

const app = express();
const nfc = new NFC();

app.use(json());

const scannedCards = [];

nfc.on('reader', reader => {
  console.log(`${reader.reader.name} device attached`);

  reader.on('card', card => {
    const cardData = {
      type: card.type,
      standard: card.standard,
      uid: card.uid || null,
      data: card.data || null,
    };

    scannedCards.push(cardData);
    console.log(`${reader.reader.name} card detected`, cardData);
  });

  reader.on('card.off', card => {
    console.log(`${reader.reader.name} card removed`, card);
  });

  reader.on('error', err => {
    console.log(`${reader.reader.name} an error occurred`, err);
  });

  reader.on('end', () => {
    console.log(`${reader.reader.name} device removed`);
  });
});

nfc.on('error', err => {
  console.log('an error occurred', err);
});

app.get('/scanned-cards', (req, res) => {
  res.json(scannedCards);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});