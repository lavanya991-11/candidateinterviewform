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
}
