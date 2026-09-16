/// <summary>
/// Whether a job application is still a draft or has been submitted.
/// </summary>
enum 70126 "Candidate Application Status"
{
    Extensible = true;

    value(0; Draft)
    {
        Caption = 'Draft';
    }
    value(1; Submitted)
    {
        Caption = 'Submitted';
    }
    // HR has sent the candidate a registration link that has not been used yet. The
    // member is named without a space because OData publishes the name, not the caption.
    value(2; Invited)
    {
        Caption = 'Registration Sent';
    }
}
