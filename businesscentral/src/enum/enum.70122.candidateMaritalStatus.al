/// <summary>
/// The marital status of a candidate.
/// </summary>
enum 70122 "Candidate Marital Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Single)
    {
        Caption = 'Single';
    }
    value(2; Married)
    {
        Caption = 'Married';
    }
    value(3; "Single Mother")
    {
        Caption = 'Single Mother';
    }
    value(4; Separated)
    {
        Caption = 'Separated';
    }
    value(5; Divorced)
    {
        Caption = 'Divorced';
    }
    value(6; "Widow or Widower")
    {
        Caption = 'Widow / Widower';
    }
}
