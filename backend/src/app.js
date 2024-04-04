const express = require('express');
const app = express();
const port = 3000;

// Importez votre contrôleur NFC ici
const nfcRoutes = require('./nfcReader');

// Utilisez votre contrôleur NFC comme middleware pour une certaine route
app.use('/nfc', nfcRoutes);

app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});
