const express = require('express');
const router = express.Router();

// Importez votre script NFC modifié ici
const nfcReader = require('../nfcReader');

router.get('/read', (req, res) => {

  res.send('Information NFC lue');
});

module.exports = router;
