const path = require('path');
const multer = require('multer');

// Mirrors what table 70123 "Candidate Attachment" accepts in Business Central, so a
// file is refused here rather than after it has crossed the wire twice.
const MAX_FILE_BYTES = 10 * 1024 * 1024;
const MAX_FILES = 20;
const ALLOWED = {
  'application/pdf': 'pdf',
  'image/jpeg': 'jpg',
  'image/png': 'png',
};

// A browser does not read the file to work out its type. On Windows it looks the
// extension up in the registry, and a missing "Content Type" value under .jpg or .png
// leaves the type blank or generic - the file is a perfectly good photo, but it arrives
// as application/octet-stream and would be turned away. Where the declared type says
// nothing, the extension decides instead, and the file carries the resolved type from
// here on: the photo travels to Business Central inside a data URI, and each attachment
// is written to its stream with a content type, so an octet-stream would follow it in.
const EXTENSION_TYPES = {
  '.pdf': 'application/pdf',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
};

// Older aliases that some browsers still send for the same two image formats.
const TYPE_ALIASES = {
  'image/jpg': 'image/jpeg',
  'image/pjpeg': 'image/jpeg',
  'image/x-png': 'image/png',
};

// A type that identifies nothing. Anything else is taken at its word and, if it is not
// a type we accept, refused - an extension does not override a type the browser is sure of.
const VAGUE_TYPES = ['', 'application/octet-stream', 'binary/octet-stream'];

function resolveMimeType(file) {
  const declared = (file.mimetype || '').toLowerCase().split(';')[0].trim();
  const canonical = TYPE_ALIASES[declared] || declared;
  if (!VAGUE_TYPES.includes(canonical)) return canonical;
  return EXTENSION_TYPES[path.extname(file.originalname || '').toLowerCase()] || canonical;
}

// Each dropzone posts under its own field name, which is also the Candidate Attachment
// Type enum member the file is filed under in BC.
const FIELDS = ['Education', 'Registration', 'Experience', 'Photo'];

// The candidate photo is one file, unlike the other sections which accept a batch.
const MAX_COUNTS = { Photo: 1 };

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: MAX_FILE_BYTES, files: MAX_FILES },
  fileFilter(req, file, cb) {
    const mimetype = resolveMimeType(file);
    if (!ALLOWED[mimetype]) {
      cb(new multer.MulterError('LIMIT_UNEXPECTED_FILE', file.fieldname));
      return;
    }
    // multer hands the same object on to req.files, so the resolved type is what
    // everything downstream sees.
    file.mimetype = mimetype;
    cb(null, true);
  },
});

const acceptAttachments = upload.fields(
  FIELDS.map((name) => ({ name, maxCount: MAX_COUNTS[name] || MAX_FILES })),
);

// The form posts as multipart so the files travel with the application in one request.
// The application itself rides along as a JSON string, which is unpacked here so that
// validateCandidate and everything downstream keep seeing a plain body.
function unpackApplication(req, res, next) {
  if (!req.is('multipart/form-data')) {
    next();
    return;
  }

  try {
    req.body = JSON.parse(req.body.payload || '{}');
  } catch {
    res.status(400).json({
      error: 'The application could not be read.',
      code: 'VALIDATION_FAILED',
      details: ['payload is not valid JSON'],
    });
    return;
  }

  // Flatten the per-dropzone groups into one list, each file tagged with the section
  // it came from so BC files it under the right attachment type.
  req.attachments = FIELDS.flatMap((attachmentType) => (
    (req.files?.[attachmentType] || []).map((file) => ({ ...file, attachmentType }))
  ));

  next();
}

function uploadErrorHandler(err, req, res, next) {
  if (!(err instanceof multer.MulterError)) {
    next(err);
    return;
  }

  const message = {
    LIMIT_FILE_SIZE: 'Each file must be 10 MB or smaller.',
    LIMIT_UNEXPECTED_FILE: 'Only PDF, JPG and PNG files can be attached.',
    LIMIT_FILE_COUNT: `You can attach at most ${MAX_FILES} files.`,
  }[err.code] || 'The attached files could not be read.';

  res.status(400).json({ error: message, code: 'UPLOAD_REJECTED' });
}

module.exports = {
  acceptAttachments, unpackApplication, uploadErrorHandler, resolveMimeType, FIELDS, MAX_FILE_BYTES,
};
