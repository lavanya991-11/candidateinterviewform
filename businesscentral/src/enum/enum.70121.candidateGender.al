/// <summary>
/// The gender of a candidate.
/// </summary>
enum 70121 "Candidate Gender"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Male)
    {
        Caption = 'Male';
    }
    value(2; Female)
    {
        Caption = 'Female';
    }
    value(3; Other)
    {
        Caption = 'Other';
    }
}
