/// <summary>
/// The section of the job application that a file was uploaded for.
/// </summary>
enum 70125 "Candidate Attachment Type"
{
    Extensible = true;

    value(0; Other)
    {
        Caption = 'Other';
    }
    value(1; Education)
    {
        Caption = 'Graduation Certificate / Mark Sheet';
    }
    value(2; Registration)
    {
        Caption = 'Registration Certificate';
    }
    value(3; Experience)
    {
        Caption = 'Employment Experience Certificate';
    }
}
