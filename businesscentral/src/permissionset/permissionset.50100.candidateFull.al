/// <summary>
/// Grants full access to the candidate job application objects.
/// </summary>
permissionset 70110 "Candidate - Full"
{
    Caption = 'Candidate - Full Access';
    Assignable = true;
    Permissions =
        tabledata "Candidate" = RIMD,
        tabledata "Candidate Cue" = RIMD,
        tabledata "Candidate Employment History" = RIMD,
        tabledata "Candidate Reference" = RIMD,
        tabledata "Candidate Attachment" = RIMD,
        table "Candidate" = X,
        table "Candidate Cue" = X,
        table "Candidate Employment History" = X,
        table "Candidate Reference" = X,
        table "Candidate Attachment" = X,
        page "Candidate List" = X,
        page "Candidate Card" = X,
        page "Candidate API" = X,
        page "Candidate Empl. History Part" = X,
        page "Candidate References Part" = X,
        page "Candidate Attachments Part" = X,
        page "Candidate Empl. Hist. API" = X,
        page "Candidate Reference API" = X,
        page "Candidate Attachment API" = X,
        page "Candidate Role Center" = X,
        page "Candidate Activities" = X,
        page "Candidate Headline" = X,
        codeunit "Candidate Ack. Email" = X;
}
