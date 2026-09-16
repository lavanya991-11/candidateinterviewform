const express = require('express');
const validateCandidate = require('../middleware/validateCandidate');
const { acceptAttachments, unpackApplication, uploadErrorHandler } = require('../middleware/uploads');
const controller = require('../contrallers/candidateController');

const router = express.Router();

router.post(
  '/candidates',
  acceptAttachments,
  uploadErrorHandler,
  unpackApplication,
  validateCandidate,
  controller.createCandidate,
);
router.get('/candidates', controller.listCandidates);
router.get('/registrations/:token', controller.getRegistration);

module.exports = router;
