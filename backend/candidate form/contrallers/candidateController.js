const Candidate = require('../models/candidate');
const config = require('../config');

async function createCandidate(req, res, next) {
  try {
    const saved = await Candidate.create(req.candidate);

    // saved.submitted is false when the record reached BC in full but is still a
    // draft, so the applicant is told it arrived without being promised a status
    // that the record does not have.
    const message = config.bc.enabled
      ? `Thank you. Your application has been ${saved.submitted === false ? 'received' : 'submitted'} successfully. `
        + `Please quote reference number ${saved.entryNo} in any future correspondence.`
      : 'Application saved locally (Business Central is not configured).';

    // No email is sent from here. Business Central owns the acknowledgement: the
    // submit action fired by finishInBc() runs Candidate.Submit(), which sends it
    // through the Default email scenario. Sending here as well would double it up.

    res.status(201).json({ message, candidate: saved });
  } catch (err) {
    next(err);
  }
}

async function listCandidates(req, res, next) {
  try {
    res.json({ value: await Candidate.list() });
  } catch (err) {
    next(err);
  }
}

module.exports = { createCandidate, listCandidates };
