/// <summary>
/// The highest educational qualification of a candidate.
/// </summary>
enum 70123 "Candidate Qualification"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Diploma)
    {
        Caption = 'Diploma';
    }
    value(2; Graduate)
    {
        Caption = 'Graduate';
    }
    value(3; "Post Graduate")
    {
        Caption = 'Post Graduate';
    }
    value(4; Other)
    {
        Caption = 'Other';
    }
}
